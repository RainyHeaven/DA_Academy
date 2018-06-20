/* [문제96] hr.departments 테이블의 department_id, department_name, manager_id 데이터를 
insa 유저의 dept 테이블로 insert 한후 영구히 저장하세요. */
drop table dept purge;
select * from user_constraints where table_name = 'DEPT';

alter table dept
drop primary key cascade;

create table dept
as select department_id, department_name, manager_id from hr.departments;

select * from dept;

commit;

/* [문제97] hr.employees 테이블의 employee_id, last_name, hire_date, salary, manager_id, 
department_id 데이터를 insa 유저의 emp 테이블로 insert 한후 영구히 저장하세요. */
select * from emp;
desc emp;
drop table emp purge;

create table emp
as select employee_id, last_name, hire_date, salary, manager_id, department_id from hr.employees where 1=2;

select * from user_tab_privs;

insert all
into emp(employee_id, last_name, hire_date, salary, manager_id, department_id) values(employee_id, last_name, hire_date, salary, manager_id, department_id)
select * from hr.employees;

rollback;

insert into emp(employee_id, last_name, hire_date, salary, manager_id, department_id)
select employee_id, last_name, hire_date, salary, manager_id, department_id
from hr.employees;

commit;

/* [문제98] insa유저의 dept 테이블의 부서정보 중에 소속사원이 없는 부서정보를 삭제한 후 영구히 저장하세요. */
delete from dept d
where not exists(select 'x' from emp where department_id = d.department_id);

commit;

/* [문제99] 사원들 중에 근무연수가 15년 이상 이면서 급여는 10000이상 급여를 받는 사원들은 emp_1테이블에 
사번, 이름, 입사일, 근무연수,  급여 정보를 입력하고 근무연수가 15년 이상이면서 급여는 10000미만 급여를 
받는 사원들은 emp_2테이블에 사번, 이름, 입사일, 근무연수, 급여 정보를 입력하세요. */
create table emp_1
(employee_id number,
 last_name varchar2(20) constraint emp1_name_nn not null,
 hire_date date,
 work_year number,
 salary number constraint emp1_salary_nn not null,
 constraint emp1_id_pk primary key(employee_id))
tablespace users;
desc emp_1

create table emp_2
as select * from emp_1 where 1=2;
desc emp_2;

insert first
when work_year >= 15 and salary >= 10000 then
into emp_1(employee_id, last_name, hire_date, work_year, salary) values(employee_id, last_name, hire_date, work_year, salary)
when work_year >= 15 and salary < 10000 then
into emp_2(employee_id, last_name, hire_date, work_year, salary) values(employee_id, last_name, hire_date, work_year, salary)
select employee_id, last_name, hire_date, (months_between(sysdate, hire_date)/ 12) as work_year, salary from employees;

select * from emp_1;능
select * from emp_2;

--Merge
-- 일치하는 키 값은 update, delete를 수행하고 없는 키 값은 insert 하는 기능

create table oltp_emp
as select employee_id, last_name, salary, department_id
from hr.employees;

create table dw_emp
as select employee_id, last_name, salary, department_id
from hr.employees
where department_id = 20;

select * from dw_emp;

alter table oltp_emp add flag char(1);

update oltp_emp
set flag = 'd'
where employee_id = 202;

update oltp_emp
set salary = 20000
where employee_id = 201;

commit;

select * from oltp_emp where department_id = 20;

merge into dw_emp d -- 타겟 테이블
using oltp_emp o -- 소스테이블
on (d.employee_id = o.employee_id) -- on절은 조인조건
when matched then 
update set d.last_name = o.last_name, d.salary = o.salary * 1.1, d.department_id = o.department_id
delete where o.flag = 'd'
when not matched then
insert(d.employee_id, d.last_name, d.salary, d.department_id)
values(o.employee_id, o.last_name, o.salary, o.department_id);

select * from dw_emp where employee_id in (201, 202);
