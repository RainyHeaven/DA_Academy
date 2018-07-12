--[문제32] 사원테이블에 부서코드를 입력값으로 받아서 그 사원들의 employee_id, last_name, salary, job_id를 출력하는 프로그램을 생성하세요. 단   부서코드중에 50,80, null 값이 입력되면 full table scan 그외 부서 코드값이 입력 입력되면 index range scan으로 실행계획을 분리하세요.
var b_id number
execute :b_id := 50
execute :b_id := 10
execute :b_id := null

-- 건수확인(분포도 확인)
select department_id, count(*) from emp group by department_id order by department_id;
/*
10	1
20	2
30	6
40	1
50	45
60	5
70	1
80	34
90	3
100	6
110	2
null 1
*/
-- 인덱스 확인 & 생성
select * from user_indexes where table_name = 'EMP';
create index emp_deptid_idx on emp(department_id);

declare
  type emp_rec_type is record(empid emp.employee_id%type, lname emp.last_name%type, sal emp.salary%type, jobid emp.job_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_tab emp_tab_type;

begin 
  if :b_id in (50, 80) then
    select /*+ full(emp) parallel(emp, 2)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id = :b_id;
    dbms_output.put_line(:b_id || '번 부서 사원의 정보입니다.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('사원ID: ' || v_tab(i).empid || ' 이름: ' || v_tab(i).lname || ' 급여: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' 직책: ' || v_tab(i).jobid);
    end loop;
  elsif :b_id is null then
    select /*+ full(emp)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id is null;
    dbms_output.put_line('부서가 없는 사원의 정보입니다.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('사원ID: ' || v_tab(i).empid || ' 이름: ' || v_tab(i).lname || ' 급여: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' 직책: ' || v_tab(i).jobid);
    end loop;
  else 
    select /*+ index_rs(emp emp_empid_pk)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id = :b_id;
    dbms_output.put_line(:b_id || '번 부서 사원의 정보입니다.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('사원ID: ' || v_tab(i).empid || ' 이름: ' || v_tab(i).lname || ' 급여: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' 직책: ' || v_tab(i).jobid);
    end loop;  
  end if;

end;
/

/*[문제33] 사원 번호를 입력 값으로 받아서 사원의 번호, 이름, 부서이름 정보를 출력하는 프로그램을 작성합니다.
단 100번 사원이 입력값으로 들어오면 예외사항이 발생하도록 해야 합니다.
또한 없는 사원번호 값이 들어오면 예외사항 처리을 만들어 주세요.
<화면 결과>
SQL> var b_id number
SQL> execute :b_id := 200
Result=> 사원번호 : 200, 사원이름 : Whalen, 부서이름 : Administration
SQL> execute :b_id := 100
100 사원은 조회할수 없습니다.
SQL> execute :b_id := 300
300 사원은 존재하지 않습니다. */

var b_id number
exec :b_id := 300

declare
  type emp_rec is record(lname emp.last_name%type, dname departments.department_name%type);
  v_rec emp_rec;
  vip exception;
  
begin
  if :b_id = 100 then
    raise vip;
  else
    select e.last_name, d.department_name into v_rec from employees e, departments d where e.department_id = d.department_id and e.employee_id = :b_id;
    dbms_output.put_line('Result=> 사원번호 : ' || :b_id || ', 사원이름 : ' || v_rec.lname || ', 부서이름 : ' || v_rec.dname);
  end if;

exception
  when vip then
    dbms_output.put_line(:b_id || ' 사원은 조회할 수 없습니다.');
  
  when no_data_found then
    dbms_output.put_line(:b_id || ' 사원은 존재하지 않습니다.');

end;
/






/*암시적 커서에서 실행되는 select문 : 반드시 1개 row만 fetch해야 한다
select * from emplopyees where employee_id = 입력변수 
*/
var b_id number;
exec :b_id := 300;

declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

end;
/

/*exception
- 실행중에 발생한 PL/SQL 오류
- oracle에 의해 암시적으로 발생
- 프로그램에 의해 명시적으로 발생
*/
declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' 사원은 존재하지 않습니다.');
    
end;
/

exec :b_id := 20;
declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where department_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

end;
/

declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where department_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' 사원은 존재하지 않습니다.');
    
  when too_many_rows then
    dbms_output.put_line('부서에 여러명의 사원이 있습니다. 명시적 커서를 사용하세요.');
    
end;
/

-- ORA - 01403(단일행 select 데이터를 리턴하지 않았을 때, 없는 배열 요소를 참조하려고 할 때)
declare
  v_rec employees%rowtype;
begin  
  begin
    select * into v_rec from employees where employee_id = 300;
  
  exception
    when no_data_found then
      dbms_output.put_line('사원이 존재하지 않습니다.');
  end;
  -- exception처리와 상관없이 공통적으로 처리해야 할 작업은 문제가 될 부분을 서브블락으로 분리하고 그 밖에서 실행하여 해결 가능
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name); 
    
end;
/
select salary from employees where department_id = 20;

-- 프로그램이 exception으로 종료되면 그 안의 transaction은 rollback됨
declare
  v_rec employees%rowtype;

begin
  update employees set salary = salary * 1.1 where department_id = 20;
  
  select * into v_rec from employees where department_id= 20;
  
  dbms_output.put_line(v_rec.last_name);

end;
/

declare
  v_rec employees%rowtype;

begin
  update employees set salary = salary * 1.1 where department_id = 20; 
  select * into v_rec from employees where department_id= 20;
  dbms_output.put_line(v_rec.last_name);

exception
  when too_many_rows then
    dbms_output.put_line('여러건의 row를 fetch할 수 없다');
  
  when others then
    dbms_output.put_line('꿈을 꾸자');
    dbms_output.put_line(sqlcode); -- 현재 발생한 오류 코드
    dbms_output.put_line(sqlerrm); -- 현재 발생한 오류 코드 + 메세지

end;
/

select salary from employees where department_id = 20;
rollback;


declare

begin
  delete from departments where department_id = 20;

exception
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
    
end;
/

declare
  pk_error exception; -- exception 이름 선
  pragma exception_init(pk_error, -2292); -- 선언한 exception과 오류번호를 붙임

begin
  delete from departments where department_id = 20;

exception
  when pk_error then
    dbms_output.put_line('이 값을 참조하는 row들이 있습니다.');
    
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
end;
/
-- exception 유발
declare
  e_invalid exception;
  
begin
  update employees set salary = salary * 1.1 where employee_id = 300;
  if sql%notfound then
    raise e_invalid; -- raise exception명 : 해당 exception을 발생시킴
  end if;

exception
  when e_invalid then
    --dbms_output.put_line('수정된 데이터가 없습니다');
    null; 
  
end;
/

-- 비정상 종료 유발 
begin
  update employees set salary = salary * 1.1 where employee_id = 300;
  if sql%notfound then
    raise_application_error(-20000, '수정된 데이터가 없습니다'); -- 오류번호는 -20000 ~ -20999번 사이에서 선언해야 함.
  end if;
  
end;
/

declare 
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = 300;

exception
  when no_data_found then
    raise_application_error(-20000, '조회 데이터가 없습니다', true); -- 기존 에러를 내가 원하는 에러 메시지로 출력, true 옵션을 사용시 기존 에러코드도 표기

end;
/