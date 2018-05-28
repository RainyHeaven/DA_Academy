-- 문제6 departments 테이블에 있는 데이터에서 department_name , manager_id 컬럼을 가지고 화면 결과 처럼 출력하는 쿼리문장을 만드세요.

select department_name || 'Department''s Manager Id: ' || manager_id as "Department and Manager"
from departments;

-- 문제7 employees 테이블에 있는 데이터 중에  last_name에 Whalen 이라는 사원의 모든 정보를 출력하세요.
select *
from employees
where last_name = 'Whalen';

-- 문제8 EMPLOYEES 테이블에서 급여가 3000보다 작거나 같은 사원의 last_name, salary 를 출력하세요.
select last_name, salary
from employees
where salary <= 3000;

-- 문제9 EMPLOYEES 테이블에서 salary(급여)값이 10000이상부터 15000이하인 사원들의 모든정보를 출력하세요.
select *
from employees
where salary between 10000 and 15000;

-- 문제10 EMPLOYEES 테이블에서 last_name이 "S"로 시작하는 사원의 last_name, first_name 을 출력하세요.
select last_name, first_name
from employees
where last_name like 'S%';

-- 문제11 last_name의 세번째 문자가 "o"인 모든 사원의 last_name을 출력하세요.
select last_name
from employees
where last_name like '__o%';

-- 문제12 employees 테이블에 있는 데이터 중에 job_id에 SA_ 문자열로 시작되는 사원들의 employee_id, last_name, job_id를 출력하세요.
select employee_id, last_name, job_id 
from employees
where job_id like 'SA@_%' escape '@';

-- 문제13 employees 테이블에 있는 데이터에서 job_id컬럼의 값이  SA로 시작하고  10000 이상의 salary(급여)를 받는 사원들의 모든 정보를 출력하세요.
select *
from employees
where job_id like 'SA%' and salary >= 10000;

-- 문제14 employees 테이블에서  job_id 컬럼의 값이  SA로 시작하거나 10000 이상의 salary(급여)를 받는 사원들의 모든 정보를 출력하세요.
select *
from employees
where job_id like 'SA%' or salary >= 10000;

-- 문제15 employees 테이블에서  job_id컬럼의 값이  IT_PROG, ST_CLERK , SA_REP가 아닌 모든 사원의 last_name, job_id를  출력해주세요.
select last_name, job_id
from employees
where job_id not in ('IT_PROG','ST_CLERK', 'SA_REP');

-- 문제16 employees 테이블에 있는 데이터에서 job_id컬럼의 값이  SA로 시작하고  10000 이상의 salary(급여)를 받고 2005년도에 입사한(hire_date) 모든 사원들의 정보를 출력하세요.
select *
from employees
where job_id like 'SA%' and salary >= 10000 and hire_date between to_date('2005.01.01', 'yyyy.mm.dd') and to_date('2005.12.31', 'yyyy.mm.dd');

-- 문제17 employees 테이블에서 job_id 컬럼의 값이 SA_REP 또는 AD_PRES 사원들 중에 급여가 10000 초가 한 사원들의 모든 정보를 출력하세요.
select *
from employees
where job_id in ('SA_REP', 'AD_PRES') and salary > 10000;

select last_name, salary
from employees
order by salary desc;

select department_id, salary
from employees
order by department_id asc, salary desc;

-- 문제18 employees 테이블에 last_name 컬럼의 값 중에  "J" 또는 "A" 또는 "M"으로 시작하는 사원들의 last_name(첫번째 문자는대문자, 나머지는 모두 소문자)과 last_name의 길이를 표시하는 query 를 작성합니다.
-- 사원들의 last_name을 기준으로 결과를 오름차순 정렬해 주세요. 
select initcap(last_name), length(last_name)
from employees
where last_name like 'J%' or last_name like 'A%' or last_name like 'M%'
order by last_name;

select initcap(last_name), length(last_name)
from employees
where instr(last_name, 'J') = 1 or instr(last_name, 'A') = 1 or instr(last_name, 'M') = 1
order by last_name;

select initcap(last_name), length(last_name)
from employees
where substr(last_name, 1, 1) in ('J', 'M', 'A')
order by last_name;

-- 문제19 employees테이블에서 department_id(부서코드)가 50번 사원들 중에 last_name에 두번째 위치에 "a"글자가 있는 사원들을 조회하세요. 
select *
from employees
where department_id = 50 and last_name like '_a%';

select *
from employees
where department_id = 50 and substr(last_name, 2, 1) = 'a';

select *
from employees
where department_id = 50 and instr(last_name, 'a', 2, 1) = 2;

-- 문제20 사원의 last_name,hire_date 및 근무 6 개월 후 월요일에 해당하는 날짜를 조회하세요. 열별칭은 REVIEW 로 지정합니다. 
select last_name, hire_date, next_day(add_months(hire_date, 6), '월요일') as REVIEW
from employees;

-- 문제21 15년 이상 근무한 사원들의 employee_id(사원번호), hire_date(입사일), 근무개월수를 조회하세요.
select employee_id, hire_date, months_between(sysdate, hire_date) as work_months
from employees
where months_between(sysdate, hire_date) >= (15*12);

-- 정렬 기준은 컬럼명 그대로 혹은 열 별칭으로도 쓸 수 있다
select last_name, department_id, salary * 12 as ann_sal
from employees
order by salary * 12;

select last_name, department_id, salary * 12 as "ann_sal"
from employees
order by "ann_sal";

-- 정렬 기준은 select 절에서의 위치로도 정할 수 있다
select last_name, department_id, salary * 12 as "ann_sal"
from employees
order by 2 asc, 3 desc, 1 asc;

-- 문자 함수
select lower(last_name), upper(last_name), initcap(last_name)
from employees;

select *
from employees
where lower(last_name) = 'king';

select last_name || first_name, concat(last_name, first_name)
from employees;

select last_name, length(last_name), substr(last_name, 1, 3), substr(last_name, -2, 2)
from employees;

select salary, lpad(salary, 10, '-'), rpad(salary, 10, '*')
from employees;

select instr('abbcabbc', 'c'), instr('abbcabbc', 'c', 1, 1)
from dual; -- dual: 가상테이블(더미테이블)

select last_name, instr(last_name, 'i')
from employees;

-- 함수는 병렬연산을 하기 때문에 like 연산자 보다 instr 함수가 성능이 좋다
select last_name
from employees
where last_name like '%i%';

select last_name
from employees
where instr(last_name, 'i') > 0;

select trim('A' from 'AbABBCAA'), ltrim('AABBC', 'A'), rtrim('BBCA', 'A')
from dual;

select replace('100-001', '0', '9')
from dual;

-- 숫자함수
select round(45.926, 0), round(45.926, 1), round(45.926, 2), round(55.926, -2)
from dual;

select trunc(45.926, 0), trunc(45.926, 1), trunc(45.926, 2), trunc(55.926, -2)
from dual;

select mod(13, 2)
from dual;

select ceil(45.0), ceil(45.12), ceil(45.926)
from dual;

-- 날짜함수
select sysdate, sysdate + 7, sysdate - 2
from dual;

select employee_id, sysdate - hire_date
from employees;

select months_between(sysdate, hire_date)
from employees;

select months_between(to_date('2018.05.24', 'yyyy.mm.dd'), to_date('2018.11.22', 'yyyy.mm.dd'))
from dual;

select add_months(sysdate, 6)
from dual;

select next_day(sysdate, '금요일'), last_day(sysdate)
from dual;

select round(sysdate, 'month'), round(sysdate, 'year')
from dual;

select trunc(sysdate, 'month'), trunc(sysdate, 'year')
from dual;