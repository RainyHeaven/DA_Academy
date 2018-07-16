/*[문제37] 사원번호를 입력 값으로 받아서 그 사원의 이름, 급여, 부서 이름을 출력하는 query_emp 프로시저 생성하세요.
단 100번 사원이 입력 값으로 들어오면 프로그램은 아무런 작업하지 않고 종료 될 수 있어야 합니다. 
또한 사원이 없을 경우 예외 사항 처리해주세요.

SQL> execute query_emp(100)
PL/SQL procedure successfully completed.

SQL> execute query_emp(101)
사원 이름: Kochhar 사원 급여: 17000 사원 부서 이름: Executive
PL/SQL procedure successfully completed.

SQL> execute query_emp(300)
300 존재하지 않는 사원입니다.
pl/sql procedure successfully completed. */
exec query_emp(100);
show error;
-- exception으로 100번 사원 제외
create or replace procedure query_emp(p_empid in number)
is
  e_vip exception;
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    raise e_vip;
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('사원 이름: ' || v_emp_rec.lname || ' 사원 급여: ' || v_emp_rec.sal || ' 사원 부서 이름: ' || v_emp_rec.dname);
  end if;

exception
  when e_vip then
    null;
    
  when no_data_found then
    dbms_output.put_line(p_empid || ' 존재하지 않는 사원입니다.');

end query_emp; -- 메인블럭 종료
/
-- if문으로 100번 사원제외
create or replace procedure query_emp1(p_empid in number)
is
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    null;
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('사원 이름: ' || v_emp_rec.lname || ' 사원 급여: ' || v_emp_rec.sal || ' 사원 부서 이름: ' || v_emp_rec.dname);
  end if;

exception 
  when no_data_found then
    dbms_output.put_line(p_empid || ' 존재하지 않는 사원입니다.');

end query_emp1;
/

-- return문 *프로시저의 return문은 함수의 return과 다르다
create or replace procedure query_emp1(p_empid in number)
is
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    return; -- return문을 만나면 프로그램 바로 종료.
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('사원 이름: ' || v_emp_rec.lname || ' 사원 급여: ' || v_emp_rec.sal || ' 사원 부서 이름: ' || v_emp_rec.dname);
  end if;

exception 
  when no_data_found then
    dbms_output.put_line(p_empid || ' 존재하지 않는 사원입니다.');

end query_emp1;
/

/*[문제38] 사원번호를 입력값으로 받아서 그 사원의 근무개월수를 출력하고 근무개월수가
180개월 이상이면 급여를 20% 인상한 급여로 수정, 
179개월 보다 작거나 같고 150개월 보다 크거나 같으면  10%인상한 급여로 수정,
150개월 미만인 근무자는 아무 작업을 수행하지 않는 프로그램을 작성하세요.
테스트가 끝나면 rollback 합니다.

begin
  sal_update_proc(100);
  rollback;
end;
/

100 사원은 근무개월수가 166 입니다. 이전 급여는 24000 수정된 급여는 26400 입니다.

begin
  sal_update_proc(103);
  rollback;
end;
/

103 사원은 근무개월수가 136 입니다. 150 개월 미만입니다.9000 급여는 수정 안됩니다. */
-- 테스트
begin
  sal_update_proc(104);
  rollback;
end;
/

create or replace procedure sal_update_proc(p_id in number)
is
  v_wmonth number;
  v_sal emp.salary%type;
  v_nsal v_sal%type;

begin
  select trunc(months_between(sysdate, hire_date)), salary into v_wmonth, v_sal from emp where employee_id = p_id;
  if v_wmonth >= 180 then
    update emp set salary = salary * 1.2 where employee_id = p_id returning salary into v_nsal;
  elsif v_wmonth between 150 and 179 then
    update emp set salary = salary * 1.1 where employee_id = p_id returning salary into v_nsal;
  else
    dbms_output.put_line(p_id||' 사원은 근무개월수가 '||v_wmonth||' 입니다. 150 개월 미만입니다. 급여는 '||v_sal||' 에서 수정되지 않습니다.');
    return;
  end if;
  dbms_output.put_line(p_id||' 사원은 근무개월수가 '||v_wmonth||' 입니다. 이전 급여는 '||v_sal||' 수정된 급여는 '||v_nsal||' 입니다.');

exception
  when no_data_found then
    dbms_output.put_line('없는 사원 번호입니다.');
  
end sal_update_proc;
/

-- rowid scan으로 튜닝
create or replace procedure sal_update_proc(p_id in number)
is
  v_wmonth number;
  v_sal emp.salary%type;
  v_nsal v_sal%type;
  v_rowid rowid;
  v_pct number;

begin
  select rowid, trunc(months_between(sysdate, hire_date)), salary into v_rowid, v_wmonth, v_sal from emp where employee_id = p_id;
  if v_wmonth >= 180 thend
    v_pct := 1.2;
  elsif v_wmonth between 150 and 179 then
    v_pct := 1.1;
  else
    dbms_output.put_line(p_id||' 사원은 근무개월수가 '||v_wmonth||' 입니다. 150 개월 미만입니다. 급여는 '||v_sal||' 에서 수정되지 않습니다.');
    return;
  end if;
  update emp set salary = salary * v_pct where rowid = v_rowid returning salary into v_nsal;
  dbms_output.put_line(p_id||' 사원은 근무개월수가 '||v_wmonth||' 입니다. 이전 급여는 '||v_sal||' 수정된 급여는 '||v_nsal||' 입니다.');

exception
  when no_data_found then
    dbms_output.put_line('없는 사원 번호입니다.');
    
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
  
end sal_update_proc;
/

/*[문제39] 급여에 3.3%를 계산하는 tax 함수를 생성하세요.
SQL> SELECT employee_id, last_name, salary, tax(salary) FROM employees;
EMPLOYEE_ID LAST_NAME                SALARY TAX(SALARY)
----------- -------------------- ---------- -----------
        100 King                    35138.4   1159.5672
        101 Kochhar                   22627     746.691
        102 de haan                 24889.7    821.3601
        103 Hunold                     9000         297 */
        
create or replace function tax(sal number)
return number
is

begin
  return sal * 0.033;

exception
  when no_data_found then
    return 0;
    
end tax;
/

select employee_id, last_name, salary, tax(salary) from employees;

drop function tax;

/*[문제40] 급여를 계산하는 get_annual_comp 함수를 생성하세요.
SQL> SELECT employee_id,
     (salary*12) + (commission_pct*salary*12) ann_sal,
     get_annual_comp(salary,commission_pct) ann_sal2
     FROM employees;
EMPLOYEE_ID    ANN_SAL   ANN_SAL2  
----------- ---------- ---------- 
        100                288000    
        101                204000     
        102                204000    
        103                108000     */
create or replace function get_annual_comp(sal number, comm_pct number)
return number
is

begin
  return nvl((sal * 12),0) + nvl((sal * 12 * comm_pct), 0);

end get_annual_comp;
/

select employee_id, (salary*12) + (commission_pct*salary*12) ann_sal, get_annual_comp(salary,commission_pct) ann_sal2 from employees;

/* 문제 41: 문제 40번을 nvl함수를 쓰지 않고 해결하세요 */
create or replace function get_annual_comp(sal number, comm_pct number)
return number
is

begin
  if sal is not null and comm_pct is not null then
    return (sal * 12) + (sal * 12 * comm_pct);
  elsif sal is not null and comm_pct is null then
    return (sal * 12);
  else
    return 0;
  end if;
    
end get_annual_comp;
/








create or replace procedure sp_comm(p_id in employees.employee_id%type, p_name out employees.last_name%type, p_sal out employees.salary%type, p_comm in out employees.commission_pct%type)
is 
  v_comm employees.commission_pct%type;

begin
  select last_name, salary, nvl(commission_pct, 0) into p_name, p_sal, v_comm from employees where employee_id = p_id;
  p_comm := p_comm + v_comm;
  
exception
  when no_data_found then
    raise_application_error(-20000, sqlerrm);
    
  when others then
    raise_application_error(-20001, sqlerrm);

end sp_comm;
/

show error;

desc sp_comm;

select text from user_source where name = 'SP_COMM';

var g_name varchar2(30);
var g_sal number;
var g_comm number;
var g_id number;

exec :g_comm := 0.1;
exec :g_id := 145;
print g_name g_sal g_comm;

exec sp_comm(:g_id, :g_name, :g_sal, :g_comm);

print g_name g_sal g_comm;

create table sawon(id number, name varchar2(30), day date, deptno number);

create or replace procedure sawon_in_proc(p_id in number, p_name in varchar2, p_day in date default sysdate, p_deptno in number default 0)
is
begin 
  insert into sawon(id, name, day, deptno) values(p_id, p_name, p_day, p_deptno);

end sawon_in_proc;
/

desc sawon_in_proc;

exec sawon_in_proc(1, '홍길동', to_date('20180101', 'YYYYMMDD'), 10); -- 위치지정방식
exec sawon_in_proc(p_id => 2, p_name => '박찬호', p_deptno => 20); -- 이름지정방식
exec sawon_in_proc(3, '손흥민', p_day => to_date('20170101', 'YYYYMMDD')); -- 조합방식
exec sawon_in_proc(p_id => 4, '제임스', p_day => to_date('20170101', 'YYYYMMDD')); -- 오류: 이름지정방식 뒤에는 모두 이름지정방식으로 표현해야함

select * from sawon;

drop table emp purge;
drop table dept purge;

create table emp as select * from employees;
create table dept as select * from departments;

alter table emp add constraint empid_pk primary key(employee_id);
alter table dept add constraint deptid_pk primary key(department_id);
alter table dept add constraint dept_mgr_id_fk foreign key(manager_id) references emp(employee_id);

select * from user_constraints where table_name in ('EMP', 'DEPT');
select * from user_cons_columns where table_name in ('EMP', 'DEPT');

create or replace procedure add_dept(p_name in varchar2, p_mgr in number, p_loc number)
is
  v_max number;
  
begin
  select max(department_id) into v_max from dept;
  insert into dept(department_id, department_name, manager_id, location_id) values(v_max + 10, p_name, p_mgr, p_loc);

end add_dept;
/

-- 1.fk 오류 발생 // 전체 rollback 발생
begin 
  add_dept('경영지원', 100, 1800);
  add_dept('데이터분석', 99, 1800);
  add_dept('자금관리', 101, 1500);
  
end;
/

select * from dept;

-- 2. exception처리: 1번째 데이터는 입력 나머지는 입력 안됨
begin 
  add_dept('경영지원', 100, 1800);
  add_dept('데이터분석', 99, 1800);
  add_dept('자금관리', 101, 1500);

exception
  when others then
    dbms_output.put_line(sqlerrm);
  
end;
/

-- 3.프로시저 내부에 exception처리, 오류난 프로시저 이외에 모두 입력
create or replace procedure add_dept(p_name in varchar2, p_mgr in number, p_loc number)
is
  v_max number;
  
begin
  select max(department_id) into v_max from dept;
  insert into dept(department_id, department_name, manager_id, location_id) values(v_max + 10, p_name, p_mgr, p_loc);

exception
  when others then
    dbms_output.put_line('error : '||p_name);
    dbms_output.put_line(sqlerrm);

end add_dept;
/

begin 
  add_dept('경영지원', 100, 1800);
  add_dept('데이터분석', 99, 1800);
  add_dept('자금관리', 101, 1500);
  
end;
/

select * from dept;
drop procedure add_dept;


-- 함수 function
create or replace function get_sal(p_id in number)
return number --리턴하는 값의 타입, 사이즈 명시 X
is 
  v_sal number := 0;

begin
  select salary into v_sal from employees where employee_id =p_id;
  return v_sal;

exception
  when no_data_found then
    return v_sal;

end get_sal;
/

exec dbms_output.put_line(get_sal(100)); -- 표현식의 일부로 호출

declare 
  v_sal number;

begin
  v_sal := get_sal(100); -- 표현식의 일부로 호출
  dbms_output.put_line(v_sal);

end;
/

select employee_id, get_sal(employee_id) from employees; -- 표현식의 일부로 호출


begin
  get_sal(100); -- 바로 호출 불가
end;
/

