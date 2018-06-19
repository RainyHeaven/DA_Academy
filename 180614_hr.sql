-- 다중테이블 인서트
-- 하나의 테이블에서 여러 테이블로 자료를 입력하는 방법

-- insert all
-- values절에는 from 쪽 컬럼이름 지정(select절에서 별칭을 썼을 시 values절에도 별칭 사용)
drop table sal_history purge;
drop table mgr_history purge;
 
create table sal_history
as select employee_id, hire_date, salary
from employees
where 1=2;
desc sal_history
 
create table mgr_history
as select employee_id, manager_id, salary
from employees
where 1=2;
desc mgr_history

insert all 
into sal_history(employee_id, hire_date, salary)
values(employee_id, hire_date, salary)
into mgr_history(employee_id, manager_id, salary)
values(employee_id, manager_id, salary)
select employee_id, hire_date, manager_id, salary
from employees;

-- 조건 insert all
create table emp_history
as select employee_id, hire_date, salary
from employees
where 1=2;

create table emp_sal
as select employee_id, commission_pct, salary
from employees
where 1=2;

insert all
when hire < to_date('2005-01-01', 'yyyy-mm-dd') then
into emp_history(employee_id, hire_date, salary)
values(id, hire, sal)
when comm is not null then
into emp_sal(employee_id, commission_pct, salary)
values(id, comm, sal)
select employee_id as id, hire_date as hire, salary as sal, commission_pct as comm
from employees;

-- 조건 first insert
create table sal_low
as select employee_id, last_name, salary
from employees
where 1=2;

create table sal_high
as select employee_id, last_name, salary
from employees
where 1=2;

create table sal_mid
as select employee_id, last_name, salary
from employees
where 1=2;

insert first
when salary < 5000 then
into sal_low(employee_id, last_name, salary)
values(employee_id, last_name, salary)
when salary between 5000 and 10000 then
into sal_mid(employee_id, last_name, salary)
values(employee_id, last_name, salary)
else
into sal_high(employee_id, last_name, salary)
values(employee_id, last_name, salary)
select employee_id, last_name, salary
from employees;
