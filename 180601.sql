-- 문제 42 모든 사원의 last_name, department_id, department_name을 표시하기 위한 query 를 작성합니다.
--오라클
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

--ANSI표준
select e.last_name, e.department_id, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id;

-- 문제 43 부서 80에 속하는 last_name, job_id, department_name, city를 표시하기 위한 query 를 작성합니다.
--오라클
select e.last_name, e.job_id, d.department_name, l.city
from employees e, departments d, locations l
where e.department_id = 80 and e.department_id = d.department_id and d.location_id = l.location_id;

--ANSI표준
select e.last_name, e.job_id, d.department_name, l.city
from employees e join departments d
on e.department_id = d.department_id 
join locations l
on d.location_id = l.location_id
where e.department_id = 80;

--문제 44 commission_pct 에 null이 아닌 모든 사원의 last_name, department_name, location_id, city를 표시하기 위한 query 를 작성합니다.
--오라클
select e.last_name, d.department_name, d.location_id, l.city
from employees e, departments d, locations l
where e.commission_pct is not null and e.department_id = d.department_id(+) and d.location_id = l.location_id(+);

--ANSI표준
select e.last_name, d.department_name, d.location_id, l.city
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
where e.commission_pct is not null;

--문제 45 last_name에 a(소문자)가 포함된 모든 사원의 last_name, department_name 을 표시하기 위한 query 를 작성합니다.
--오라클
select e.last_name, d.department_name
from employees e, departments d
where e.last_name like '%a%' and e.department_id = d.department_id(+);

--ANSI표준
select e.last_name, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id
where e.last_name like '%a%';

select e.last_name, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id
where instr(e.last_name, 'a') >=1;

-- 문제 46 locations 테이블에 있는 city컬럼에  Toronto도시에서 근무하는 모든 사원의 last_name, job_id, department_id, department_name 을 표시하기 위한 query 를 작성합니다.
--오라클
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where l.city = 'Toronto' and e.department_id = d.department_id and d.location_id = l.location_id;

--ANSI표준
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where l.city = 'Toronto';
desc employees

-- 문제 47 2006년도에 입사한 사원들의 부서이름별로 급여의 총액, 평균을 출력하세요.
--오라클
select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e, departments d
where extract(year from e.hire_date) = 2006 and e.department_id = d.department_id
-- extract로 뽑아내면 인덱스 스캔이 아닌 풀 스캔이 됨
group by d.department_name;

--ANSI표준
select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e join departments d
on e.department_id = d.department_id
where to_char(e.hire_date, 'yyyy') = '2006' 
-- to_char로 뽑아내면 인덱스 스캔이 아닌 풀 스캔이 됨
group by d.department_name;

select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e join departments d
on e.department_id = d.department_id
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
group by d.department_name;

-- 문제 48 2006년도에 입사한 사원들의 도시이름별로 급여의 총액, 평균을 출력하세요.
--오라클
select l.city, sum(e.salary), avg(e.salary)
from employees e, departments d, locations l
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
and e.department_id = d.department_id
and d.location_id = l.location_id
group by l.city;

--ANSI표준
select l.city, sum(e.salary), avg(e.salary)
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
group by l.city;

-- 문제49 2007년도에 입사한 사원들의 도시이름별로 급여의 총액, 평균을 출력하세요. 단 부서 배치를 받지 않는 사람들의 급여의 총액, 평균도 구하세요.
--오라클
select l.city, sum(e.salary), avg(e.salary)
from employees e, departments d, locations l
where e.hire_date >= to_date('20070101', 'yyyymmdd') and e.hire_date < to_date('20080101', 'yyyymmdd')
and e.department_id = d.department_id(+)
and d.location_id = l.location_id(+)
group by l.city;

--ANSI표준
select l.city, sum(e.salary), avg(e.salary)
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
where e.hire_date >= to_date('20070101', 'yyyymmdd') and e.hire_date < to_date('20080101', 'yyyymmdd')
group by l.city;

-- 문제 50 사원들의 사번, 급여, 급여등급, 부서이름을 출력하세요. 부서배치를 받지 않는 사원은 제외시켜주세요.
--오라클
select e.employee_id, e.salary, j.grade_level, d.department_name
from employees e, departments d, job_grades j
where e.department_id = d.department_id and e.salary between j.lowest_sal and j.highest_sal;

--ANSI표준
select e.employee_id, e.salary, j.grade_level, d.department_name
from employees e join departments d
on e.department_id = d.department_id
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;

-- 문제 51 사원들의 사번, 급여, 급여등급, 부서이름, 근무 도시 정보를 출력하세요. 부서배치를 받지 않는 사원도 포함시켜주세요.
--오라클
select e.employee_id, e.salary, j.grade_level, d.department_name, l.city
from employees e, departments d, job_grades j, locations l
where e.department_id = d.department_id(+)
and e.salary between j.lowest_sal and j.highest_sal
and d.location_id = l.location_id(+);

--ANSI표준
select e.employee_id, e.salary, j.grade_level, d.department_name, l.city
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;

-- 문제 52 사원들의 last_name,salary,grade_level, department_name을 출력하는데 last_name에 a문자가 2개 이상 포함되어 있는 사원들을 출력하세요.
--오라클
select e.last_name, e.salary, j.grade_level, d.department_name
from employees e, job_grades j, departments d
where instr(e.last_name, 'a', 1, 2) >= 2 and e.department_id = d.department_id(+) and e.salary between j.lowest_sal and j.highest_sal;

--ANSI표준
select e.last_name, e.salary, j.grade_level, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal
where instr(e.last_name, 'a', 1, 2) >= 2;


-- 1. equi join / outer join
select e.last_name, e.department_id, 
       d.department_id, d.department_name, d.location_id, 
       l.location_id, l.city
from employees e, departments d, locations l
where e.department_id = d.department_id(+) and d.location_id = l.location_id(+)
order by 2, 3;

-- 2. non equi join
select e.last_name, e.salary, j.grade_level
from employees e, job_grades j
where e.salary between j.lowest_sal and j.highest_sal;

-- 3. self join / outer join
select w.employee_id, w.last_name, m.employee_id, m.last_name
from employees w, employees m
where w.manager_id = m.employee_id(+);

-- cartesian product
select last_name, department_name
from employees, departments;

select last_name, department_name
from employees cross join departments;

select e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id;

--natural join
select last_name, department_name
from employees natural join departments;

desc employees
desc departments

select department_name, city
from departments natural join locations;

-- join using 절
select e.last_name, department_id, d.department_name
from employees e join departments d
using(department_id)
where department_id in (20, 30);

-- join on 절
select e.last_name, d.department_name, l.city
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where d.department_id in (10, 20);

select e.last_name, e.salary, j.grade_level
from employees e join job_grades j
on e.salary between j.lowest_sal and j.highest_sal
where e.department_id = 30
and e.salary >= 3000;

select w.employee_id, w.last_name, m.employee_id, m.last_name
from employees w join employees m
on w.manager_id = m.employee_id;

-- left outer join, right outer join, full outer join
select e.last_name, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id;

select e.last_name, d.department_name
from employees e right outer join departments d
on e.department_id = d.department_id;

select e.last_name, d.department_name
from employees e full outer join departments d
on e.department_id = d.department_id;

select e.last_name, d.department_name, l.city
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id;