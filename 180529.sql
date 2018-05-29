-- 문제22 employees(사원)테이블에 있는 last_name의 세번째 문자가 'a' 또는 'e'가 포함된 모든 사원의 last_name을 조회하세요.
select last_name
from employees
where substr(last_name, 3, 1) in ('a', 'e');

select last_name
from employees
where last_name like '__a%' or last_name like '__e%';

select last_name
from employees
where instr(last_name, 'a', 3, 1) = 3 or instr(last_name, 'e', 3, 1) = 3;

-- 스타트지점을 바꾸는 것은 작동 안하는 경우가 있음
select last_name
from employees
where instr(last_name, 'a') = 3 
or instr(last_name, 'a', 1, 2) = 3
or instr(last_name, 'a', 1, 3) = 3
or instr(last_name, 'e') = 3 
or instr(last_name, 'e', 1, 2) = 3
or instr(last_name, 'e', 1, 3) = 3;

-- 문제23 employees(사원)테이블에 있는  80번 부서(department_id) 사원중에 commission_pct 값이 0.2 이고 job_id는 SA_MAN인 사원의 employee_id, last_name, salary를 조회하세요.
select employee_id, last_name, salary
from employees
where department_id = 80 and commission_pct = 0.2 and job_id = 'SA_MAN';

-- 문제24 사원의 employees(사원)테이블에 있는 last_name,hire_date 및 근무 6 개월 후 첫번째 월요일에 해당하는 급여 협상 날짜를 표시합니다.
-- 열 레이블을 REVIEW 로 지정합니다. 날짜는 "월요일, the Second of 4, 2007"과 유사한 형식으로 나타나도록 지정합니다.
select last_name, hire_date, to_char(next_day(add_months(hire_date, 6), '월요일'), 'day, "the" ddspth "of" dd, yyyy') as REVIEW
from employees;

-- 문제25 employees(사원) 테이블에서  일요일에 입사한 사원의 정보를 조회하세요.
select *
from employees
where to_char(hire_date, 'day') = '일요일';

select *
from employees
where to_char(hire_date, 'd') = '1';

-- 문제26 짝수달에 입사한 사원의 정보를 조회하세요.
select *
from employees
where mod(to_number(to_char(hire_date, 'fmmm')), 2) = 0;

-- 문제27 2006년도에 홀수 달에 입사한 사원의 employee_id, last_name, hire_date를 조회하세요.
select employee_id, last_name, hire_date
from employees
where hire_date  between to_date('20050101', 'yyyymmdd') and to_date('20051231', 'yyyymmdd') and mod(to_number(to_char(hire_date, 'fmmm')), 2) = 1;

-- 형변환 함수
desc employees

select *
from employees
where department_id = '10';

select *
from employees
where hire_date = '2001/01/01';

select last_name || salary
from employees;

-- 서버시간
select sysdate
from dual;

select to_char(sysdate, 'yyyy year mm month mon dd day dy')
from dual;

select to_char(sysdate, 'ddd dd d q"분기"')
from dual;

-- fm: 앞단위0 제거 am or pm: 시간의 오전/오후 표기
select to_char(sysdate, 'fmhh:mi:ss.sssss pm')
from dual;

--sp: 날짜를 글자로 표기 th: 서수로 표기
select to_char(sysdate, 'ddspth')
from dual;

-- 월요일을 제일 앞으로 정렬하기 위한 방법
select to_char(hire_date, 'day')
from employees
order by to_char(hire_date-1, 'd');

-- bc: 서기 scc: 세기 ww: 몇주차인지
select to_char(sysdate, 'bc scc yyyy ww w')
from dual;

-- g: 천단위 구분자 d: 소수점 구분자 l: 지역통화부호
select to_char(salary, '$999,999,999.00'), to_char(salary, '999.00'),
       to_char(salary, 'l999g999d00')
from employees;

-- 세션 정보 확인
select * from nls_session_parameters;

-- 세션의 지역, 언어 정보 수정. 이번 세션에만 적용됨.
ALTER SESSION SET NLS_TERRITORY=KOREA;
ALTER SESSION SET NLS_LANGUAGE =KOREAN;

ALTER SESSION SET NLS_TERRITORY = GERMANY;
ALTER SESSION SET NLS_LANGUAGE= GERMAN;

ALTER SESSION SET NLS_LANGUAGE =JAPANESE;
ALTER SESSION SET NLS_TERRITORY=JAPAN;

ALTER SESSION SET NLS_LANGUAGE =FRENCH;
ALTER SESSION SET NLS_TERRITORY=FRANCE;

ALTER SESSION SET NLS_TERRITORY=AMERICA;
ALTER SESSION SET NLS_LANGUAGE =AMERICAN;

ALTER SESSION SET NLS_TERRITORY=china;
ALTER SESSION SET NLS_LANGUAGE = 'simplified chinese';

select employee_id, 
      to_char(salary,'l999g999d00'),
      to_char(hire_date, 'YYYY-MONTH-DD DAY')
from employees;

select sysdate from dual;
alter session set nls_date_format='yyyymmdd';

select *
from employees
where hire_date > '20020101';

-- sysdate, systimestamp: 서버의 시간 current_date, current_timestamp, localtimestamp : 세션(클라이언트)의 시간
select sysdate, systimestamp, current_date, current_timestamp, localtimestamp
from dual;

alter session set time_zone = '+09:00';

select to_char(sysdate, 'yyyymmdd hh24:mi:ss.sssss'), systimestamp, 
to_char(current_date, 'yyyymmdd hh24:mi:ss.sssss'), current_timestamp, localtimestamp
from dual;

select sysdate + to_yminterval('01-00') from dual;

select sysdate + to_dsinterval('100 00:00:00') from dual;

select to_char(sysdate, 'yyyy') 
from dual;

select localtimestamp
from dual;
alter session set time_zone = 'Asia/Seoul';
select extract(year from sysdate) from dual;
select extract(month from sysdate) from dual;
select extract(day from sysdate) from dual;
select extract(hour from localtimestamp) from dual;
select extract(minute from localtimestamp) from dual;
select extract(second from localtimestamp) from dual;
select extract(timezone_hour from systimestamp) from dual;
select extract(timezone_minute from systimestamp) from dual;
select extract(timezone_region from current_timestamp) from dual;
select extract(timezone_abbr from current_timestamp) from dual;

select * from v$timezone_names;

select last_name, salary, commission_pct, 
(salary * 12) + (salary * 12 * commission_pct) as "1",
(salary * 12) + (salary * 12 * nvl(commission_pct, 0)) as "2"
from employees;

-- nvl 내의 인자들의 타입은 일치해야 함
select employee_id, nvl(to_char(commission_pct), 'no comm')
from employees;

select employee_id, 
nvl2(commission_pct, '(salary * 12) + (salary * 12 * commission_pct)', 'salary * 12'),
coalesce((salary * 12) + (salary * 12 * commission_pct), salary * 12, salary)
from employees;

select employee_id, nullif(length(last_name), length(first_name))
from employees;

select *
from employees
where commission_pct is null;

select *
from employees
where commission_pct is not null;