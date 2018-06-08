-- 문제 72 사원수가 3명 미만인 부서번호, 부서이름, 인원수를 출력해주세요
select d.department_id, d.department_name, m.peoples
from departments d, (select department_id, count(employee_id) peoples from employees where department_id is not null group by department_id having count(employee_id) < 3) m
where d.department_id = m.department_id
order by d.department_id;

select d.department_id, d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, d.department_name
having count(*) < 3
order by d.department_id;

--inline view를 통해 join의 양을 줄일 수 있다

-- 문제 73번 2005년, 2006년, 2007년, 2008년에 입사한 사원의 수 출력하세요.
select count(*) as TOTAL, count(decode(extract(year from hire_date), 2005, 1)) as "2005", count(decode(extract(year from hire_date), 2006, 1)) as "2006", count(decode(extract(year from hire_date), 2007, 1)) as "2007", count(decode(extract(year from hire_date), 2008, 1)) as "2008"
from employees;

select to_char(hire_date, 'yyyy'), count(*) from employees group by to_char(hire_date, 'yyyy');

select 
       decode(hire_year, '2001', people) as "2001",
       decode(hire_year, '2002', people) as "2002",
       decode(hire_year, '2003', people) as "2003",
       decode(hire_year, '2004', people) as "2004",
       decode(hire_year, '2005', people) as "2005",
       decode(hire_year, '2006', people) as "2006",
       decode(hire_year, '2007', people) as "2007",
       decode(hire_year, '2008', people) as "2008"
from (select to_char(hire_date, 'yyyy') hire_year, count(*) people from employees group by to_char(hire_date, 'yyyy'));

SELECT 
       max(decode(year,'2001',cn)) "2001",
       max(decode(year,'2002',cn)) "2002",
       max(decode(year,'2003',cn)) "2003",
       max(decode(year,'2004',cn)) "2004",   
       max(decode(year,'2005',cn)) "2005",
       max(decode(year,'2006',cn)) "2006",
       max(decode(year,'2007',cn)) "2007",
       max(decode(year,'2008',cn)) "2008"       
FROM (
              SELECT to_char(hire_date, 'yyyy') year, count(*) cn
              FROM employees
              GROUP BY(to_char(hire_date, 'yyyy')));
                
-- 문제 74 평균 급여가 가장 높은 부서의 부서 번호와 최고, 최저, 평균 급여를 출력하세요.
select department_id, max(salary), min(salary), avg(salary) as average
from employees
group by department_id
having avg(salary) = (select max(avg(salary)) from employees group by department_id);

-- 부서별 최고, 최저, 평균급여 테이블
select department_id, max(salary), min(salary), avg(salary) as average
from employees
group by department_id;

-- 최고 평균급여 테이블
select max(avg(salary)) from employees group by department_id;


-- 문제 75 사원 수가 가장 많은 부서이름, 도시, 인원수를 출력해주세요.
select d.department_name, l.city, e.cn
from (select department_id, count(*) cn from employees group by department_id having count(*) 
      = (select max(count(*)) from employees group by department_id)) e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id;      

-- 문제 76 사원 채용 수가 가장 많은 요일을 출력해주세요.
select to_char(hire_date, 'day'), count(*)
from employees
group by to_char(hire_date, 'day')
having count(*) = (select max(count(*)) from employees group by to_char(hire_date, 'day'));

-- 문제 77 사원 채용 수가 가장 많은 요일에 입사한 사원들의 last_name, 요일을 출력해주세요.
select last_name, to_char(hire_date, 'day')
from employees
where to_char(hire_date, 'day') in (select to_char(hire_date, 'day') from employees group by to_char(hire_date, 'day')
having count(*) = (select max(count(*)) from employees group by to_char(hire_date, 'day')));

-- 문제 78 부서별로 인원수를 출력주세요.
select 
       max(decode(department_id, '10', cn)) as "10",
       max(decode(department_id, '20', cn)) as "20",
       max(decode(department_id, '30', cn)) as "30",
       max(decode(department_id, '40', cn)) as "40",
       max(decode(department_id, '50', cn)) as "50",
       max(decode(department_id, '60', cn)) as "60",
       max(decode(department_id, '70', cn)) as "70",
       max(decode(department_id, '80', cn)) as "80",
       max(decode(department_id, '90', cn)) as "90",
       max(decode(department_id, '100', cn)) as "100",
       max(decode(department_id, '110', cn)) as "110",
       max(decode(department_id, null, cn)) as "부서가 없는 사원"
from (select department_id, count(*) cn from employees group by department_id);

-- 문제 79 부서 번호와 급여가 커미션을 받는 사원의 부서 번호 및 급여와 일치하는 모든  사원의 last_name, department_id, salary 를 표시하는 query 를 작성하세요.
select last_name, department_id, salary
from employees
where (department_id, salary) in (select department_id, salary from employees where commission_pct is not null);

--커미션을 받는 사원 테이블
select department_id, salary from employees where commission_pct is not null;

-- 문제 80 급여와 커미션이 location_id가 1700 에 있는 사원의 급여 및 커미션과 일치하는 사원의 last_name, department_name, salary를 출력해주세요.
select e.last_name, d.department_name, e.salary
from employees e join departments d
on e.department_id = d.department_id
where (salary, nvl(e.commission_pct, 0)) in (select e.salary, nvl(e.commission_pct, 0) from employees e, departments d where e.department_id = d.department_id and d.location_id = 1700);

-- location_id = 1700인 사원들의 급여와 커미션
select e.salary, nvl(e.commission_pct, 0) 
from employees e, departments d 
where e.department_id = d.department_id and d.location_id = 1700;

-- 문제 81 select department_id, department_name from departments where location_id = 1700
select last_name, hire_date, salary, commission_pct
from employees
where (salary, nvl(commission_pct, 0)) = (select salary, nvl(commission_pct, 0) from employees where last_name = 'Johnson')
and last_name not like 'Johnson';

-- Johnson의 급여와 커미션
select salary, commission_pct from employees where last_name = 'Johnson';

-- 문제 82 부서의 총 급여가 전체 부서의 평균 급여보다 많은 부서의 이름과 총 급여를 표시하도록 query를 작성하세요.
--null 부서 미포함
select d.department_name, sum(e.salary)
from employees e join departments d
on e.department_id = d.department_id
group by d.department_name
having sum(e.salary) > (select avg(dep_sum) from (select department_id, sum(salary) dep_sum from employees where department_id is not null group by department_id));

--null 부서 포함
select d.department_name, sum(e.salary)
from employees e join departments d
on e.department_id = d.department_id
group by d.department_name
having sum(salary) > (select avg(dep_sum) from (select department_id, sum(salary) dep_sum from employees group by department_id));

--null 부서 포함(선생님 답)
select d.department_name, e.average
from (select department_id, sum(salary) average from employees group by department_id having sum(salary) > (select avg(average) from (select sum(salary) average from employees group by department_id))) e, departments d
where e.department_id = d.department_id;

-- 전체 부서의 총급여 평균
select avg(dep_sum)
from (select department_id, sum(salary) dep_sum from employees where department_id is not null group by department_id);

-- 각 부서별 총급여
select department_id, sum(salary)
from employees
where department_id is not null
group by department_id;

--with: 재사용이 가능한 가상테이블 생성
with
dept_cost as (select d.department_name, sum(e.salary) as sumsal  from employees e, departments d where e.department_id = d.department_id(+) group by d.department_name), 
avg_cost as (select sum(sumsal) / count(*) as deptavg from dept_cost)
select *
from dept_cost
where sumsal > (select deptavg from avg_cost);


--with 재사용이 가능한 가상 테이블 생성

with
dept_cost as (select d.department_name, sum(e.salary) as sumsal from employees e, departments d where e.department_id = d.department_id(+) group by d.department_name), 
avg_cost as (select sum(sumsal) / count(*) as deptavg from dept_cost)
select *
from dept_cost
where sumsal > (select deptavg from avg_cost);

--multiple-column subquery (다중열 서브쿼리)
-- 재사용이 가능한 가상 테이블 생성
-- 복합 query문 안에서 동일한 select 문을 두번 이상 반복할 경우에 query block을 만들어서 사용하면 성능이 향상된다

--다중열 서브쿼리는 쌍비교 방식
select *
from employees
where (manager_id, department_id) in (select manager_id, department_id from employees where first_name = 'John')
order by employee_id;

--여러행 서브쿼리는 비쌍비교 방식
select *
from employees
where manager_id in (select manager_id from employees where first_name = 'John')
and department_id in (select department_id from employees where first_name = 'John')
order by employee_id;

-- 집합연산자
--합집합, 교집합, 차집합
--컬럼 수, 데이터 타입을 일치시켜야 한다
--sort를 발생시킨다
-- 원하는 정렬을 위해선 가장 마지막에 order by를 사용해야 한다
-- 이때 컬럼명은 제일 첫 쿼리문장의 컬럼명을 사용해야 한다
-- 성능 이슈가 있으므로 집합연산자는 되도록 사용하지 않는 것이 좋다

--합집합 union(중복을 제거한 합집합)
select employee_id, job_id
from employees
union
select employee_id, job_id
from job_history;

--union all (중복을 포함한 합집합)
-- sort를 발생시키지 않는다
-- union all과 not exists를 활용하여 union과 같은결과를 얻을 수 있다
select employee_id, job_id
from employees e
where not exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id)
union all
select employee_id, job_id
from job_history;

-- 교집합 intersect
select employee_id, job_id
from employees
intersect
select employee_id, job_id
from job_history;

--exists를 활용하여 intersect와 같은 결과를 얻을 수 있다
select employee_id, job_id
from employees e
where exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id);

-- 차집합 minus
select employee_id, job_id
from employees
minus
select employee_id, job_id
from job_history;

-- not exists를 활용하여 minus와 같은 결과를 얻을 수 있다
select employee_id, job_id
from employees e
where not exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id);
