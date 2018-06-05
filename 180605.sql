-- 문제 65 last_name에 Davies 사원보다 늦게 입사한 사원 중에 급여가 Davies 사원의 급여 이하로 받고 있는 사원들을 출력해주세요.
--서브쿼리
select *
from employees
where salary <= (select salary from employees where last_name = 'Davies')
and hire_date > (select hire_date from employees where last_name = 'Davies');

--오라클
select e.*
from employees e, employees d
where e.salary <= d.salary
and e.hire_date > d.hire_date
and d.last_name = 'Davies';

--ANSI표준
select e.*
from employees e join employees d
on e.salary <= d.salary
and e.hire_date > d.hire_date
where d.last_name = 'Davies';

-- 문제 66 자신의 부서 평균 급여보다 더 많은 급여를 받는 사원들의 정보를 출력해주세요
select *
from employees o
where o.salary > (select avg(salary) from employees where department_id = o.department_id);

-- 문제 67 두번 이상 job_id를 바꾼 사원 출력해주세요.
select j.*
from job_history j
where 2 <= (select count(employee_id) from job_history where employee_id = j.employee_id)
order by j.employee_id;

-- 문제 68 관리자 사원에 대해서 출력해주세요
select *
from employees e
where employee_id in (select distinct manager_id from employees where manager_id is not null);

select *
from employees o
where exists (select 'x'--문법 오류를 막기 위한 의미없는 표현 'x'
              from employees
              where manager_id = o.employee_id);
              
-- 문제 69 관리자가 아닌 사원에 대해서 출력해주세요
select *
from employees e
where employee_id not in (select distinct manager_id from employees where manager_id is not null);

select *
from employees o
where not exists (select 'x'
              from employees
              where manager_id = o.employee_id);

-- 문제 70 사원이 없는 부서 정보만 출력해주세요
select *
from departments
where department_id not in (select department_id from employees where department_id is not null);

select *
from departments d
where not exists (select 'x' from employees where department_id = d.department_id);

-- 문제 71 자신의 부서안에서 자신보다 늦게 입사하고 자신보다 급여를 많이받는 사람이 있는 사람들을 찾아주세요
select *
from employees e
where exists (select 'x' from employees where department_id = e.department_id and salary > e.salary and hire_date > e.hire_date)
and e.department_id = 30;

