-- [문제2] 전체 사원의 평균 급여를 출력 하는 프로그램 만드세요.  프로그램 수행이 끝난 후에도 전체 사원의 평균값을 이용해서 전체 사원의 평균 급여 보다 많이 받는 사원의 정보 select 문장을 작성하세요.
var b_deptavg number

begin
  select avg(salary) into :b_deptavg from employees;
  dbms_output.put_line('전체 사원의 평균 급여: ' || round(:b_deptavg));
end;
/

select * from employees where salary > :b_deptavg;

/*[문제3] 사원 번호를 입력값으로 받아서 그사원의 사번, 이름, 급여 정보를 출력하는 프로그램을 작성하세요.
<화면 결과>
결과=> 사원번호: 100, 사원이름: King, 사원급여: 24000*/

var b_empid number
exec :b_empid := 100

declare
  v_lname employees.last_name%type;
  v_sal employees.salary%type;

begin
  select last_name, salary into v_lname, v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('결과=> 사원번호: ' || :b_empid || ', 사원이름: ' || v_lname || ', 사원급여: ' || v_sal);

end;
/

/*[문제4] 사원 번호를 입력값으로 받아서 입사일, 급여 정보를 출력하는 프로그램을 작성하세요.
<화면 결과>
hire date is : 2003년 6월 17일
Salary is : ￦24,000.00 */

-- employee_id 확인 : 100번
select employee_id from employees
where hire_date = to_date('20030617', 'yyyymmdd')
and salary = 24000;

var b_empid number
exec :b_empid := 100

declare
  v_hdate employees.hire_date%type;
  v_sal employees.salary%type;

begin
  select hire_date, salary into v_hdate, v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('Hire date is : ' || to_char(v_hdate, 'YYYY"년" fmMM"월" DD"일"'));
  dbms_output.put_line('Salary is : ' || ltrim(to_char(v_sal, 'l999g999d00'))); -- to_char의 l 때문에 왼쪽 공백이 생겨 ltrim으로 지워줌
end;
/

/*<문제5> 부서테이블에 신규 부서를 입력하는 프로그램을 작성하려고 합니다.
부서 이름만 입력값으로 받고 부서코드는 마지막 부서 코드에 10을 증가해서 부서코드를
넣고 관리자번호, 부서 위치는 null값으로 입력하는 프로그램을 작성하세요.
화면출력 처럼 출력하세요.(dept 테이블을 생성한후 프로그램을 만드세요) 

<화면출력>
신규 부서 번호는 280, 부서 이름 It 입니다. */

drop table dept purge;
create table dept as select * from departments;

alter table dept add constraint dept_dept_id_pk primary key(department_id);

var b_dname varchar2(10)
exec :b_dname := 'It'

declare
  new_deptid departments.department_id%type;

begin
  select max(department_id)+10 into new_deptid from dept;
  insert into dept(department_id, department_name)
  values(new_deptid, :b_dname);
  dbms_output.put_line('신규 부서 번호는 ' || new_deptid || ', 부서 이름 ' || :b_dname || '입니다.');

end;
/

select * from dept;

rollback;




<<outer>>
declare 
  v_name varchar2(20) := '홍길동';
  v_date date := to_date('2018-01-01', 'yyyy-mm-dd');

begin
  dbms_output.put_line('학생 이름은 ' || v_name);
  dbms_output.put_line('수강한 날짜는 ' || to_char(v_date, 'yyyymmdd'));
  
  declare
    v_name varchar2(20) := '박찬호';
    v_date date := to_date('2017-01-10', 'yyyy-mm-dd');
  begin
    outer.v_name := '손흥민';
    dbms_output.put_line('학생 이름은 ' || v_name);
    dbms_output.put_line('수강한 날짜는 ' || to_char(v_date, 'yyyymmdd'));
    dbms_output.put_line('학생 이름은 ' || outer.v_name);
    dbms_output.put_line('수강한 날짜는 ' || to_char(outer.v_date, 'yyyymmdd'));
  end;

end;
/



declare
  v_name2 varchar2(20);
  v_date2 date := to_date('2017-01-10', 'yyyy-mm-dd');

begin
  v_name2 := upper('james'); -- 프로시저문
  dbms_output.put_line('학생 이름은 ' || v_name2);
  dbms_output.put_line('수강한 날짜는 ' || to_char(v_date2, 'yyyymmdd'));
  
end;
/

-- 프로시저문에서 사용할 수 없는 함수
-- decode **case는 가능
-- avg, sum, max, min, count, stddev, variance


/*암시적 커서
select ... into... : 반드시 1개 row만 fetch해야 한다. 
    0개: no data found
    2개이상: too_many_rows -> 명시적 커서를 사용하여 해결 가능
DML(insert, update, delete, merge) */
declare
  v_lname varchar2(20);
  v_fname varchar2(20);
  v_sal number;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal -- fetch절
  from employees where employee_id = 300;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

declare
  v_lname varchar2(20); -- 하드코딩 방식
  v_fname varchar2(20);
  v_sal number;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal -- fetch절
  from employees where department_id = 20;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

declare
  v_lname employees.last_name%type; -- 소프트코딩 방식
  v_fname v_lname%type; -- 변수의 type도 가능
  v_sal employees.salary%type;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal 
  from employees where employee_id = 100;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

var b_id number
exec :b_id := 100

declare
  v_lname employees.last_name%type;
  v_fname v_lname%type; 
  v_sal employees.salary%type;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal 
  from employees where employee_id = :b_id;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

drop table test purge;

create table test(id number, name varchar2(20), day date);

desc test

insert into test(id, name, day) 
values(1, '홍길동', to_date('2018-01-01', 'yyyy-mm-dd'));

select * from test;

rollback;

-- 프로그램 안에서 dml문을 수행시 트랜젝션을 끝낼지, 유지할지 결정해야 한다. 트랜젝션이 그대로 유지되면 lock이 걸려 업무에 문제가 생길 수도 있음
begin
  insert into test(id, name, day) 
  values(1, '홍길동', to_date('2018-01-01', 'yyyy-mm-dd'));

end;
/
rollback;
select * from test;

var b_id number
var b_name varchar2(20)
var b_day varchar2(30)

exec :b_id := 1
exec :b_name := '홍길동'
exec :b_day := '20180101'

print b_id b_name b_day

begin
  insert into test(id, name, day)
  values(:b_id, :b_name, to_date(:b_day, 'yyyymmdd'));
  
end;
/

exec :b_id := 2
exec :b_name := '고목'
exec :b_day := '19860125'

select * from test;

commit;

-- insert 서브쿼리
begin 
  insert into test(id, name, day)
  select employee_id, last_name, hire_date from employees;
  dbms_output.put_line(sql%rowcount || '개의 row가 수정되었습니다');

end;
/

select * from test;

rollback;

begin
  update test set name = '박찬호'
  where id = 1;
  
end;
/
var b_id number
var b_name varchar2(20)
exec :b_id := 1
exec :b_name := '박찬호'

begin
  update test set name = :b_name
  where id = :b_id;
  dbms_output.put_line(sql%rowcount || '개의 row가 수정되었습니다'); -- bind 변수를 통해 수정된 건 수를 리턴
end;
/

select * from test;

rollback;

drop table emp purge;

create table emp as select * from employees;

begin
  delete from emp where department_id = 20;
  dbms_output.put_line(sql%rowcount|| '행이 수정되었습니다');
  
  update emp
  set salary = salary * 1.1
  where department_id = 30;
  dbms_output.put_line(sql%rowcount|| '행이 수정되었습니다'); -- 바로 전 dml문의 건수만 리턴

end;
/

rollback;

begin
  update emp
  set salary = salary * 1.1
  where employee_id = 00;
  
  if sql%found then 
    dbms_output.put_line('수정 되었습니다');
  else
    dbms_output.put_line('수정되지 않았습니다');
  end if;
  rollback;

end;
/

begin
  delete from emp where department_id = 10;
  
  update emp
  set salary = salary * 1.1
  where employee_id = 00;
  
  if sql%notfound then 
    dbms_output.put_line('수정되지 않았습니다');
  else
    dbms_output.put_line('수정되었습니다');
  end if;
  rollback;

end;
/


declare
  v_lname employees.last_name%type;
  v_sal employees.salary%type;

-- 의미없는 if 구문: else문 작동 없이 오류발생
begin
  select last_name, salary into v_lname, v_sal from employees where employee_id = 00;
  if sql%found then 
    dbms_output.put_line('결과=> 사원번호: ' || :b_empid || ', 사원이름: ' || v_lname || ', 사원급여: ' || v_sal);
  else
    dbms_output.put_line('사원이 없습니다.');
  end if;

end;
/
