-- 문제 38 job_id별로 총액급여를 구합니다. 단 CLERK글자가 있는 job_id는 제외하고 총액급여는 13000가 넘는 정보를 출력하면서 총액 급여를 기준으로 내림차순 정렬하세요.
select job_id, sum(salary) as "payroll"
from employees
where job_id not like '%CLERK%'
group by job_id
having  sum(salary) > 13000
order by 2 desc;

-- 문제 39 입사한 년도별로 급여의 총액을 출력하세요.
select to_char(hire_date, 'yyyy'), sum(salary)
from employees
group by to_char(hire_date, 'yyyy');

select extract(year from hire_date), sum(salary)
from employees
group by extract(year from hire_date);

-- 문제 40 입사한 달별 인원수를 출력해주세요.
select to_char(hire_date, 'mm'), count(*)
from employees
group by to_char(hire_date, 'mm')
order by 1;

-- 문제 41 사원의 총 수와 2005년, 2006년, 2007년, 2008년에 입사한 사원의 수 출력하세요.
-- 결과값에 1이 아닌 0이나 문자를 넣어도 무방(행 수를 세기 때문에)
select count(*) as TOTAL, count(decode(extract(year from hire_date), 2005, 1)) as "2005", count(decode(extract(year from hire_date), 2006, 1)) as "2006", count(decode(extract(year from hire_date), 2007, 1)) as "2007", count(decode(extract(year from hire_date), 2008, 1)) as "2008"
from employees;

-- 결과값에 1이 들어가야 합계가 계산됨
select count(*) as TOTAL, sum(case to_char(hire_date, 'yyyy') when '2005' then 1 end) as "2005", sum(case to_char(hire_date, 'yyyy') when '2006' then 1 end) as "2006", sum(case to_char(hire_date, 'yyyy') when '2007' then 1 end) as "2007", sum(case to_char(hire_date, 'yyyy') when '2008' then 1 end) as "2008"

-- having절에 들어갈 내용을 where절에 넣으면 안된다
select department_id, sum(salary)
from employees
where department_id in (10, 20) -- where은 행을 제한하는 함수
group by department_id;

-- full scan이 됨
select department_id, sum(salary)
from employees
having department_id in (10, 20) --having은 결과를 제한하는 함수 / 순서에 큰 영향을 받지 않음
group by department_id;

desc employees
desc departments

-- join
-- 아래 경우는 join을 사용하지 않아 cartesian product 발생
select last_name, department_name
from employees, departments;

-- equi join: 일치하는 key값을 통해 조인
select last_name, department_name
from employees e, departments d
where e.department_id = d.department_id;

desc locations

select * 
from locations;

select e.last_name, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id;

select *
from locations;

-- 조인조건술어: e.department_id = d.department_id
-- 비조인조건술어: e.department_id = 10
select last_name, department_name
from employees e, departments d
where e.department_id = d.department_id and e.department_id = 10;

select last_name, department_name
from employees e, departments d
where e.department_id = 10 and d.department_id = 10;

-- self join: 자신의 테이블을 join
select w.employee_id, w.last_name, m.employee_id, m.last_name
from employees w, employees m
where w.manager_id = m.employee_id;

-- outer join(+): 키 값이 일치되지 않는 데이터를 뽑기위한 방법
select e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
union
select e.last_name, d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

select e.last_name, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id(+) and d.location_id = l.location_id(+);

CREATE TABLE job_grades
( grade_level varchar2(3),
  lowest_sal  number,
  highest_sal number);

INSERT INTO job_grades VALUES ('A',1000,2999);
INSERT INTO job_grades VALUES ('B',3000,5999);
INSERT INTO job_grades VALUES ('C',6000,9999);
INSERT INTO job_grades VALUES ('D',10000,14999);
INSERT INTO job_grades VALUES ('E',15000,24999);
INSERT INTO job_grades VALUES ('F',25000,40000);
commit;

select *
from job_grades;

select last_name, salary
from employees;

-- non equi join
select e.last_name, e.salary, j.grade_level
from employees e, job_grades j
where e.salary between j.lowest_sal and j.highest_sal;