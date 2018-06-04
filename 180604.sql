-- 문제 53 141번 사원의 job_id와 동일한 job_id를 가진 사원들 중에 141번 사원의 급여보다 더 많이 받는 사원을 출력해주세요
select *
from employees
where job_id = (select job_id
                from employees
                where employee_id = 141)
and salary > (select salary
                from employees
                where employee_id = 141);
                
-- 문제 54 최소월급을 받은 사원들의 정보를 출력해주세요.
select *
from employees
where salary = (select min(salary)
                from employees);

-- 문제 55 평균 급여가 가장 낮은 job_id를 찾아 주세요.
select job_id
from employees
group by job_id
having avg(salary) = (select min(avg(salary))
                      from employees
                      group by job_id);
                      
-- 문제 56 부서별로 최소 급여자들을 출력해주세요.
select *
from employees
where salary in (select min(salary) from employees group by department_id)
order by department_id;

-- 문제 57 last_name 에 문자 "u"가 포함된 사원과 같은 부서에 근무하는 모든 사원의 employee_id, last_name 을 출력하세요.
select employee_id, last_name
from employees
where department_id in (select distinct department_id from employees where last_name like '%u%');

-- 문제 58 부서 위치(location_id) ID 가 1700 인 모든 사원의 last_name, department_id, job_id 를 출력하세요.(조인, 서브쿼리)
--오라클
select e.last_name, e.department_id, e.job_id
from employees e, departments d
where e.department_id = d.department_id
and d.location_id = 1700;

--ANSI표준
select e.last_name, e.department_id, e.job_id
from employees e join departments d
on e.department_id = d.department_id
where d.location_id = 1700;

--서브쿼리
select last_name, department_id, job_id
from employees
where department_id in (select department_id from departments where location_id = 1700);

-- 문제 59 King 에게 보고하는 모든 사원의 last_name 및 salary 출력하세요.(조인, 서브쿼리)
--오라클
select e.last_name, e.salary
from employees e, employees m
where e.manager_id = m.employee_id
and m.last_name = 'King';

--ANSI표준
select e.last_name, e.salary
from employees e join employees m
on e.manager_id = m.employee_id
where m.last_name = 'King';

--서브쿼리
select last_name, salary
from employees
where manager_id in (select distinct employee_id from employees where last_name = 'King');

-- 문제 60 부서 이름(department_name) 이 Executive 부서의 모든 사원에 대한 department_id, last_name, job_id  출력하세요.
--오라클
select e.department_id, e.last_name, e.job_id
from employees e, departments d
where e.department_id = d.department_id
and d.department_name = 'Executive';

--ANSI표준
select e.department_id, e.last_name, e.job_id
from employees e join departments d
on e.department_id = d.department_id
where d.department_name = 'Executive';

--서브쿼리
select department_id, last_name, job_id
from employees
where department_id = (select department_id from departments where department_name = 'Executive');

-- 문제 61 60부서에 소속된 모든 사원의 급여(salary)보다 높은(max) 급여를 받는 모든 사원 출력하세요.
select *
from employees
where salary > all (select salary from employees where department_id = 60);

select *
from employees
where salary > (select max(salary) from employees where department_id = 60);

-- 문제 62 전체 평균 급여보다 많은 급여를 받고 last_name에 "u"가 포함된 사원이 있는 부서에서 근무하는 모든 사원의 employee_id, last_name, salary 출력하세요
select employee_id, last_name, salary
from employees
where salary > (select avg(salary) from employees)
and department_id in (select distinct department_id from employees where last_name like '%u%');

-- 문제 63 관리자 사원들의 정보를 출력해주세요 
select *
from employees
where employee_id in (select distinct manager_id from employees);

-- 문제 64 관리자가 아닌 사원들의 정보를 출력해 주세요
-- 서브쿼리에 null 값이 있을 경우 not in 연산자를 사용할 수 없음 
select *
from employees
where employee_id not in (select distinct manager_id from employees where manager_id is not null);

select *
from employees
where employee_id != all (select distinct manager_id from employees where manager_id is not null);




-- 단일행 서브쿼리 / 중첩 서브쿼리 nested subquery
select *
from employees
where salary > (select salary
                from employees
                where job_id = 'IT_PROG');
                
select *
from employees
where job_id = (select job_id
                from employees
                where employee_id = 141);
                
select *
from employees
where salary > any(select salary
                from employees
                where last_name = 'King');
                
-- > any / 최소값보다 큰
select *
from employees
where salary > any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary > (select min(salary)
                from employees
                where job_id = 'IT_PROG');

-- < any / 최대값보다 작은              
select *
from employees
where salary < any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary < (select max(salary)
                from employees
                where job_id = 'IT_PROG');
                
-- = any == in
select *
from employees
where salary = any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary in (select salary
                from employees
                where job_id = 'IT_PROG');                

-- > all / 최대값보다 큰                    
select *
from employees
where salary > all (select salary
                    from employees
                    where job_id = 'IT_PROG');

select *
from employees
where salary > (select max(salary)
                from employees
                where job_id = 'IT_PROG');
                
-- < all / 최소값보다 작은
select *
from employees
where salary < all (select salary
                    from employees
                    where job_id = 'IT_PROG');

select *
from employees
where salary < (select min(salary)
                from employees
                where job_id = 'IT_PROG');                


                