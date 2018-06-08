-- 문제 83  job_id가  ST_CLERK 을 포함하지 않는 부서에 대한 department_id를 출력해주세요.
SELECT department_id
FROM departments
WHERE department_id NOT IN (SELECT DISTINCT department_id FROM employees WHERE job_id = 'ST_CLERK');

-- 값의 존재/비존재 여부를 찾기 위해서는 correlated subquery를 사용하는 것이 적합하다
SELECT department_id
FROM departments d
WHERE NOT EXISTS (SELECT 'x' FROM employees WHERE department_id = d.department_id AND job_id = 'ST_CLERK');
  
-- job_id가 ST_CLERK인 사원을 가진 부서
SELECT DISTINCT department_id
FROM employees
WHERE job_id = 'ST_CLERK';

-- 문제 84 부서가 소재하지 않는 국가의 리스트가 필요합니다. 해당 국가의 country_id, country_name을 출력해주세요.
-- in / not in 사용
-- 부서가 있는 나라들의 테이블
select distinct country_id
from locations
where location_id in (select location_id from departments);

-- 전체 나라 테이블에서 부서가 있는 나라들을 제외한 테이블
select country_id, country_name
from countries
where country_id not in (select distinct country_id from locations l where location_id in (select location_id from departments));

-- exists / not exists 사용
--부서가 있는 나라들의 테이블
select distinct country_id
from locations l
where exists (select 'x' from departments where location_id = l.location_id);

-- 전체 나라 테이블에서 부서가 있는 나라들을 제외한 테이블
select country_id, country_name
from countries o
where not exists (select 'x' from locations l where exists (select 'x' from departments where location_id = l.location_id) and l.country_id = o.country_id);

-- 집합연산자 사용 / sort를 하게되고 동일한 테이블을 여러번 사용하게 됨
select country_id, country_name
from countries
minus
select l.country_id, c.country_name
from departments d, locations l, countries c
where l.country_id = c.country_id
and d.locations_id = l.location_id

--not exists 사용 / join을 잘 활용하자 / 1족 -> m족 비교
select country_id, country_name
from countries c
where not exists (select 'x' from locations l, departments d where d.location_id = l.location_id and l.country_id = c.country_id);

-- 문제 85 사원들의 employee_id, last_name, department_name을 출력하는데 소속부서가 없는 사원도 출력하시고, 소속사원이 없는 부서도 출력하세요. ANSI표준 조인, 오라클 전용 조인으로 만드세요.
--오라클
--department_id = null을 포함
select e.employee_id, e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
union all
--employee_id = null을 포함
select e.employee_id, e.last_name, d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id
and e.department_id is null;


--ANSI표준
select e.employee_id, e.last_name, d.department_name
from employees e full outer join departments d
on e.department_id = d.department_id;

-- union all & not exists
select e.employee_id, e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
union all
select null, null, d.department_name
from departments d
where not exists (select 'x' from employees e where e.department_id = d.department_id); 

-- 문제 86 1,2,3,4를 한꺼번에 출력해주세요.
-- 1. department_id, job_id, manager_id 기준으로 총액 급여를 출력
-- 2. department_id, job_id 기준으로 총액급여출력
-- 3. department_id 기준으로 총액급여 출력
-- 4. 전체 총액 급여를 출력

select department_id, job_id, manager_id, sum(salary) Total
from employees
group by department_id, job_id, manager_id
union all
select department_id, job_id, null, sum(salary)
from employees
group by department_id, job_id
union all
select department_id, null, null, sum(salary)
from employees
group by department_id
union all
select null, null, null, sum(salary)
from employees
order by 1, 2, 3, 4;


-- 1. department_id, job_id, manager_id 기준으로 총액 급여를 출력
select department_id, job_id, manager_id, sum(salary)
from employees
group by department_id, job_id, manager_id;

-- 2. department_id, job_id 기준으로 총액급여출력
select department_id, job_id, null, sum(salary)
from employees
group by department_id, job_id;

-- 3. department_id 기준으로 총액급여 출력
select department_id, null, null, sum(salary)
from employees
group by department_id;

-- 4. 전체 총액 급여를 출력
select null, null, null, sum(salary)
from employees;

--roll up연산자
-- group by 절에서 지정한 열 리스트를 오른쪽에서 왼쪽으로 한 컬럼씩 줄여가며 그룹화
select department_id, job_id, manager_id, sum(salary)
from employees
group by rollup (department_id, job_id, manager_id);

--cube 연산자
-- group by 절에 지정된 가능한 모든 그룹화
select department_id, job_id, manager_id, sum(salary)
from employees
group by cube (department_id, job_id, manager_id);

group by rollup(a, b, c)
sum(sal) = {a, b, c}
sum(sal) = {a, b}
sum(sal) = {a}
sum(sal) = {}

group by cube(a, b, c)
sum(sal) = {a, b, c}
sum(sal) = {a, b}
sum(sal) = {a, c}
sum(sal) = {b, c}
sum(sal) = {a}
sum(sal) = {b}
sum(sal) = {c}
sum(sal) = {}

-- 문제 87 1, 2 한꺼본에 출력해주세요
-- 1. department_id, manager_id 기준 급여 총 합
-- 2. department_id, job_id 기준 급여 총 합
select department_id, manager_id, null, sum(salary)
from employees
group by department_id, manager_id
union all
select department_id, null, job_id, sum(salary)
from employees
group by department_id, job_id;

-- 1. department_id, manager_id 기준 급여 총 합
select department_id, manager_id, sum(salary)
from employees
group by department_id, manager_id;

-- 2. department_id, job_id 기준 급여 총 합
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id;

--grouping sets 연산자
select department_id, job_id, manager_id, sum(salary)
from employees
group by grouping sets ((department_id, manager_id), (department_id, job_id), ());

-- 문제 88  년도별로 입사한 인원수, 전체 인원수를 출력해주세요
SELECT 
       max(decode(year,'2001',cn)) "2001",
       max(decode(year,'2002',cn)) "2002",
       max(decode(year,'2003',cn)) "2003",
       max(decode(year,'2004',cn)) "2004",   
       max(decode(year,'2005',cn)) "2005",
       max(decode(year,'2006',cn)) "2006",
       max(decode(year,'2007',cn)) "2007",
       max(decode(year,'2008',cn)) "2008",
       sum(cn) "총인원수"
FROM (
              SELECT to_char(hire_date, 'yyyy') year, count(*) cn
              FROM employees
              GROUP BY(to_char(hire_date, 'yyyy')));

-- rollup 활용              
SELECT 
       max(decode(year,'2001',cn)) "2001",
       max(decode(year,'2002',cn)) "2002",
       max(decode(year,'2003',cn)) "2003",
       max(decode(year,'2004',cn)) "2004",   
       max(decode(year,'2005',cn)) "2005",
       max(decode(year,'2006',cn)) "2006",
       max(decode(year,'2007',cn)) "2007",
       max(decode(year,'2008',cn)) "2008",
       max(decode(year,null,cn)) "총인원수"
FROM (
              SELECT to_char(hire_date, 'yyyy') year, count(*) cn
              FROM employees
              GROUP BY rollup(to_char(hire_date, 'yyyy')));

-- 문제 89 달별 입사한 인원수, 총인원수를 출력해주세요.
SELECT 
       max(decode(hire_month,01,cn)) "1월",
       max(decode(hire_month,02,cn)) "2월",
       max(decode(hire_month,03,cn)) "3월",
       max(decode(hire_month,04,cn)) "4월",
       max(decode(hire_month,05,cn)) "5월",
       max(decode(hire_month,06,cn)) "6월",
       max(decode(hire_month,07,cn)) "7월",
       max(decode(hire_month,08,cn)) "8월",
       max(decode(hire_month,09,cn)) "9월",
       max(decode(hire_month,10,cn)) "10월",
       max(decode(hire_month,11,cn)) "11월",
       max(decode(hire_month,12,cn)) "12월",
       sum(cn) "총인원수"
FROM (
              SELECT to_char(hire_date, 'mm') hire_month, count(*) cn
              FROM employees
              GROUP BY(to_char(hire_date, 'mm')));              
              
 -- rollup 활용   
 SELECT 
       max(decode(hire_month,01,cn)) "1월",
       max(decode(hire_month,02,cn)) "2월",
       max(decode(hire_month,03,cn)) "3월",
       max(decode(hire_month,04,cn)) "4월",
       max(decode(hire_month,05,cn)) "5월",
       max(decode(hire_month,06,cn)) "6월",
       max(decode(hire_month,07,cn)) "7월",
       max(decode(hire_month,08,cn)) "8월",
       max(decode(hire_month,09,cn)) "9월",
       max(decode(hire_month,10,cn)) "10월",
       max(decode(hire_month,11,cn)) "11월",
       max(decode(hire_month,12,cn)) "12월",
       max(decode(hire_month,null,cn)) "총인원수"
FROM (SELECT to_char(hire_date, 'mm') hire_month, count(*) cn
      FROM employees
      GROUP BY rollup(to_char(hire_date, 'mm')));   
      
-- to_char(hire_date, 'month')로 나온 1자리 월 뒤에는 공백 1칸이 있다      
 SELECT 
       max(decode(hire_month,'1월 ',cn)) "1월",
       max(decode(hire_month,'2월 ',cn)) "2월",
       max(decode(hire_month,'3월 ',cn)) "3월",
       max(decode(hire_month,'4월 ',cn)) "4월",
       max(decode(hire_month,'5월 ',cn)) "5월",
       max(decode(hire_month,'6월 ',cn)) "6월",
       max(decode(hire_month,'7월 ',cn)) "7월",
       max(decode(hire_month,'8월 ',cn)) "8월",
       max(decode(hire_month,'9월 ',cn)) "9월",
       max(decode(hire_month,'10월',cn)) "10월",
       max(decode(hire_month,'11월',cn)) "11월",
       max(decode(hire_month,'12월',cn)) "12월",
       max(decode(hire_month,null,cn)) "총인원수"
FROM (SELECT to_char(hire_date, 'month') hire_month, count(*) cn
      FROM employees
      GROUP BY rollup(to_char(hire_date, 'month')));         
      
SELECT to_char(hire_date, 'month') hire_month, count(*) cn
FROM employees
GROUP BY rollup(to_char(hire_date, 'month'));
      


-- 계층검색
-- 필수절: start with / connect by
-- 중복되는 값이 있는 키로 시작할 시 결과가 모호하게 나올 수 있으므로 적절한 방법이 아님

-- top down 방식
select employee_id, last_name, manager_id
from employees
start with employee_id = 101
connect by prior employee_id = manager_id; --연결고리 prior: 이전단계

-- bottom up 방식
select employee_id, last_name, manager_id
from employees
start with department_id = 20
connect by employee_id = prior manager_id;

-- level함수: 계층을 표현
-- order siblings by: 계층을 유지한 채로 정렬
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
start with employee_id   = 100
connect by prior employee_id = manager_id
order siblings by last_name;

-- where절에서 제한시 그 제한한 값만 안나옴
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
where employee_id != 101
start with employee_id = 100
connect by prior employee_id = manager_id
order siblings by last_name;

-- connect by 절에서 제한시 그 이하 단계까지 포함하여 제한됨
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
start with employee_id = 100
connect by prior employee_id = manager_id
and employee_id != 101
order siblings by last_name;
