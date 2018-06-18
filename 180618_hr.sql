-- 문제 100 EMPLOYEES 테이블을 복제 EMP_COPY 이름으로 복제하세요.
create table emp_copy
as select * from hr.employees;
-- CTAS로 복제시 not null 제약조건만 복제된다.

--문제 101 EMP_COPY테이블에 employee_id에 emp_copy_id_pk 이름으로 primary key 제약조건을 추가하세요. 
alter table emp_copy
add constraints emp_id_pk primary key(employee_id);
	
--문제 102 EMP_COPY 테이블에 department_name varchar2(30) 컬럼을 추가하세요.
alter table emp_copy
add department_name varchar2(30);

--문제 103 DEPARTMENTS 테이블에 있는 department_name을 기준으로 EMP_COPY 테이블에 department_name에 값을 수정하세요.
--단 UPDATE문을 이용해서 해결한 후 수정된 정보를 확인하고 ROLLBACK 하세요.
update emp_copy e
set department_name = (select department_name from departments where department_id = e.department_id);

select department_id, department_name from emp_copy;	

rollback;

select department_id, department_name from emp_copy;	

--문제 104 DEPARTMENTS 테이블에 있는 department_name을 기준으로 EMP_COPY 테이블에 department_name에 값을 수정하세요.
--단 MERGE문을 이용해서 해결한 후  수정된 정보를 영구히 저장하세요.
merge into emp_copy e
using (select department_id, department_name from departments) d
on (e.department_id = d.department_id)
when matched then
update set e.department_name = d.department_name;

select department_id, department_name from emp_copy;

commit;

--문제 105 EMP_COPY 테이블에 department_name에 값을 NULL 값으로 수정하세요. 
--단 MERGE문을 이용해서 해결한 후 ROLLBACK 하세요.
merge into emp_copy e
using (select department_id from departments) d
on (e.department_id = d.department_id)
when matched then
update set e.department_name = null;

select department_name from emp_copy;

rollback;

select department_name from emp_copy;

-- 문제 106 사원들의 급여가 5000 미만일 경우 employee_id, salary 정보를 SPECIAL_SAL 테이블에 입력하고 
--아니면 employee_id, hire_date, salary정보를 SAL_HISTORY 테이블에 입력하고 
--또는  employee_id, manager_id, salary 정보를  MGR_HISTORY 테이블에 입력한다.

create table special_sal
(employee_id number,
 salary number)
 tablespace users;
  
create table sal_history
(employee_id number,
 hire_date date,
 salary number);
  
create table mgr_history
(employee_id number,
 manager_id number,
 salary number);
 
insert all
when sal < 5000 then
into special_sal(employee_id, salary) values (empid, sal)
else
into sal_history(employee_id, hire_date, salary) values (empid, hiredate, sal)
into mgr_history(employee_id, manager_id, salary) values (empid, mgrid, sal)
select employee_id as empid, salary as sal, hire_date as hiredate, manager_id as mgrid from employees;
 
select * from special_sal;
select * from sal_history;
select * from mgr_history;

--다른 답
insert first
when sal < 5000 then
into special_sal(employee_id, salary) values (empid, sal)
else
into sal_history(employee_id, hire_date, salary) values(empid, hiredate, sal)
into mgr_history(employee_id, manager_id, salary) values(empid, mgrid, sal)
select employee_id as empid, salary as sal, hire_date as hiredate, manager_id as mgrid from employees;

--문제 107 emp.csv 파일의 데이터를 분석하려고 한다. external table를 생성하세요.
--권한 확인
select * from user_tab_privs where table_name = 'DATA_DIR';
select * from all_directories where directory_name = 'DATA_DIR';

-- external table은 dml사용 불가(읽기 전용) / index 없음
create table empxt
(id number,
 name varchar2(30),
 hire_date date,
 job_id varchar2(20),
 department_id number)
 organization external
 (type oracle_loader
  default directory data_dir
  access parameters
   (records delimited by newline -- 한행의 끝은 문서의 끝이 아니라 새로운 줄이 있음.
    badfile 'empxt.bad'
    logfile 'empxt.log'
    fields terminated by ',' -- 필드 구분자
    missing field values are null -- 빈 값을 대체하여 null 입력
     (id, name, hire_date char date_format date mask "YYYYMMDD", job_id, department_id))
  location('emp.csv'))
reject limit unlimited; --오류 허용 / 거의 필수적

-- 주석이 달려있으면 실행 시 오류 발생
create table empxt
(id number,
 name varchar2(30),
 hire_date date,
 job_id varchar2(20),
 department_id number)
 organization external
 (type oracle_loader
  default directory data_dir
  access parameters
   (records delimited by newline
    badfile 'empxt.bad'
    logfile 'empxt.log'
    fields terminated by ','
    missing field values are null
     (id, name, hire_date char date_format date mask "YYYYMMDD", job_id, department_id))
  location('emp.csv'))
reject limit unlimited;

select * from empxt;

-- 문제 108 부서이름별 총액급여, 평균급여, 최고급여, 최저급여를 출력하는 query문을 작성한 후, dept_sal_vw view를 생성하세요.
create or replace view dept_sal_vw
as select d.department_name, sum(e.salary) as sumsal, avg(e.salary) as avgsal, max(e.salary) as maxsal, min(e.salary) as minsal from employees e join departments d on e.department_id = d.department_id group by d.department_name;

create or replace view dept_sal_vw
as select d.department_name, e.sumsal, e.avgsal, e.maxsal, e.minsal from departments d join (select department_id, sum(salary) as sumsal, avg(salary) as avgsal, max(salary) as maxsal, min(salary) as minsal from employees group by department_id) e on d.department_id = e.department_id;

select * from dept_sal_vw;





--view
-- 하나 이상의 테이블에 있는 데이터를 논리적으로 처리하는 오브젝트
-- select 문만 가지고 있다

create table dept_20
as select * from employees where department_id = 20;

create table dept_30
as select * from employees where department_id = 30;

create view dept_v20
as select * from employees where department_id = 20;

create view dept_v30
as select * from employees where department_id = 30;

select * from dept_v20;
select * from dept_v30;

create view emp_vw
as select employee_id, last_name, department_id
from employees;

select * from emp_vw;

--권한부여
grant select on hr.emp_vw to ora10;

--view확인
select * from user_views where view_name = 'EMP_VW';

--object확인
select * from user_objects where object_name = 'EMP_VW';

--view는 수정이 불가 -> drop 후 create해야함
-- 이 과정을 해주는 것이 or replace (존재할 시 drop후 create)
create or replace view emp_vw
as select employee_id, last_name || first_name as name from employees; --컬럼의 이름이 될 수 없는 컬럼이 있을 시 별칭을 정해주어야 함

select * from emp_vw;

drop table emp_new purge;

--단순 view
create table emp_new
as select employee_id, last_name, salary, department_id
from employees
where department_id = 20;

select * from emp_new;

drop view emp_vw;

create view emp_vw
as select * from emp_new;

desc emp_vw;

--단순 view는 dml을 통해 원본 데이터 변경 가능
update emp_vw
set department_id = 200;

select * from emp_vw;
select * from emp_new;
rollback;

delete from emp_vw;

select * from emp_vw;
select * from emp_new;
rollback;

insert into emp_vw(employee_id, last_name, salary, department_id)
values(1, 'james', 1000, 10);

select * from emp_vw;
select * from emp_new;
-- view는 참고하는 테이블의 제약조건도 그대로 가져옴
desc emp_vw;

insert into emp_vw(employee_id, last_name, salary, department_id)
values(2, null, 2000, 20);

rollback;

create or replace view emp_vw
as select employee_id, salary * 12 as sal, department_id
from emp_new;

-- view가 참조하지 않는 컬럼은 update 불가능
update emp_vw
set last_name = 'james';

-- not null제약조건이 있는 컬럼에 null을 넣게되면 insert 불가능
insert into emp_vw(employee_id, salary, department_id)
values(3, 2000, 10);

-- 표현식의 일부인 컬럼값은 수정이 불가능하다
create or replace view emp_vw
as select employee_id, salary * 12 as sal, department_id
from emp_new;

--view를 만들 때 check 제약 조건을 걸 수 있다
--where절이 check 제약조건의 조건식이 된다
create or replace view empvu20
as select *
from employees
where department_id = 20
with check option constraint empvu20_ck;

select * from empvu20;

select * from user_constraints where table_name = 'EMPVU20';

update empvu20
set department_id = 30
where employee_id = 201;

rollback;

--읽기 전용 뷰 생성
create or replace view empvu20
as select *
from employees
where department_id = 20
with read only;

delete empvu20;
update empvu20
set department_id = 30;

--복합뷰
-- 그룹함수, group by, join 문이 들어있는 뷰
-- DML을 사용 할 수 없다( 단 pl/sql trigger를 만들면 가능)


select * from session_privs;

--sequence: 자동 일련번호를 생성하는 오브젝트, create sequence 시스템 권한 필요
create table emp_seq
(id number,
 name varchar2(20),
 day timestamp default systimestamp);
 
 create sequence emp_id_seq
 increment by 1 -- default 1
 start with 1 -- default 1
 maxvalue 50 -- default 10**27
 minvalue 1 -- default -10**26
 cache 20
 nocycle; -- cycle or nocycle
 
 --cache값이 있기 때문에 last_number로는 현재 값 확인 불가능
 select * from user_sequences where sequence_name = 'EMP_ID_SEQ';
 
 -- 내부 값을 바꿔서 캐시값이 사라질 시 last_number 확인 가능
 alter sequence emp_id_seq
 maxvalue 100;
 
 
 insert into emp_seq(id, name, day)
 values(emp_id_seq.nextval, user, default);
 
 select * from emp_seq;
 
 -- 현재 몇번까지 썼는지 확인
 select emp_id_seq.currval from dual;
 
 -- sequence는 롤백되지 않음
 rollback;
 
 