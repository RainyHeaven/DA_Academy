-- 문제 28 아래 화면의 결과 처럼 사원의  last_name,  salary, salary 값을 1000당 별표를 하나를 출력하는  query문을 작성하세요. 
select last_name, salary, lpad('*', trunc(salary/1000), '*') as "STAR"
from employees
order by salary desc;

-- 문제 29 아래 화면결과 처럼 출력하세요.
select '현재 서버의 날짜 시간 : ' || to_char(sysdate, 'yyyymmdd hh:mi:ss am') as "현재날짜시간"
from dual;

-- 문제 30 아래 화면결과 처럼 출력하세요
select '서버의 시간을 기준으로 하루 전 : ' || to_char(sysdate-1, 'yyyymmdd hh24:mi:ss') as "하루전"
from dual;

-- 문제 31 아래 화면결과 처럼 출력하세요
select '서버의 시간을 기준으로 1시간 전 : ' || to_char(sysdate-1/24, 'yyyymmdd hh24:mi:ss') as "1시간전"
from dual;

select '서버의 시간을 기준으로 1시간 전 : ' || to_char(sysdate-to_dsinterval('0 01:00:00'), 'yyyymmdd hh24:mi:ss') as "1시간전"
from dual;

-- 문제 32 아래 화면결과 처럼 출력하세요
select '서버의 시간을 기준으로 5분 전 : ' || to_char(sysdate-to_dsinterval('0 00:05:00'), 'yyyymmdd hh24:mi:ss') as "5분전"
from dual;

select '서버의 시간을 기준으로 5분 전 : ' || to_char(sysdate-5/(24*60), 'yyyymmdd hh24:mi:ss') as "5분전"
from dual;

-- 문제 33 아래 화면결과 처럼 출력하세요
select '서버의 시간을 기준으로 10초 전 : ' || to_char(sysdate-to_dsinterval('0 00:00:10'), 'yyyymmdd hh24:mi:ss') as "10초전"
from dual;

select '서버의 시간을 기준으로 10초 전 : ' || to_char(sysdate-10/(24*60*60), 'yyyymmdd hh24:mi:ss') as "10초전"
from dual;

-- 문제 34 JOB_ID 열의 값을 기준으로 모든 사원의 등급(GRADE)을 표시하는 query 를 작성하세요.
select job_id, decode(job_id, 'AD_PRES', 'A', 'ST_MAN', 'B', 'IT_PROG', 'C', 'SA_REP', 'D', 'ST_CLERK', 'E', 'Z') as "GRADE"
from employees;

-- 문제 35 사원테이블에  연봉을 계산 하는 쿼리문을 작성하세요 
-- 단 commission_pct 값이 null 아니면 (salary*12) + (salary*12*commission_pct) 이값이 수행되고
-- null 이면 salary * 12 가 수행합니다. 수행 결과는 화면처럼 만드세요.
-- (nvl, nvl2,  coalesce, case, decode 함수를 사용하여 각각으로 수행해서 보고서 작성해 주세요)
select last_name, salary, commission_pct, decode(commission_pct, null, salary * 12, (salary * 12) + (salary * 12 * commission_pct)) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, (salary * 12) + (salary * 12 * nvl(commission_pct, 0)) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, nvl2(commission_pct, (salary * 12) + (salary * 12 * commission_pct), salary * 12) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, coalesce((salary * 12) + (salary * 12 * commission_pct), salary * 12) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, case when commission_pct is null then salary * 12 else (salary * 12) + (salary * 12 * commission_pct) end as "ANN_SAL"
from employees;

-- 문제36 모든 사원의 최고급여, 최저급여, 합계 및 평균 급여를 찾습니다. 
-- 열 레이블을 각각 Maximum, Minimum, Sum 및 Average 로 지정합니다. 
-- 결과를 소수점은 반올림해서 정수값으로 출력하세요.
select max(salary) as "Maximum", min(salary) as "Minimum", sum(salary) as "Sum", round(avg(salary), 0) as "Average"
from employees;

-- 문제 37 2008년도에 입사한 사원들의 job_id별 인원수를 구하고 인원수가 많은 순으로 출력하세요. 
select job_id, count(*)
from employees
where to_char(hire_date, 'yyyy') = '2008'
group by job_id
order by 2 desc;


-- 하루의 시작
select to_date('20180530 00:00:00.00000', 'yyyymmdd hh24:mi:ss.sssss')
from dual;

-- 하루의 끝
select to_date('20180530 23:59:59.86399', 'yyyymmdd hh24:mi:ss.sssss')
from dual;

select to_timestamp('20180530 11:16:00', 'yyyymmdd hh24:mi:ss')
from dual;

-- timestamp는 s로 자리수 나타내면 안됨. ff로 써야함
select to_timestamp('20180530 11:16:00.0', 'yyyymmdd hh24:mi:ss.s')
from dual;

select to_timestamp('20180530 11:16:00.123', 'yyyymmdd hh24:mi:ss.ff')
from dual;

-- 하루의 시작 / 0을 9개 넣음
select to_timestamp('20180530 11:16:00.000000000', 'yyyymmdd hh24:mi:ss.ff')
from dual;

-- 하루의 끝 / 9를 9개 넣음
select to_timestamp('20180530 11:16:00.999999999', 'yyyymmdd hh24:mi:ss.ff')
from dual;

select to_char(systimestamp, 'ss.ff')
from dual;

-- 2자리로 뽑아내기
select to_char(systimestamp, 'ss.ff2')
from dual;

-- 9자리로 뽑아내기
select to_char(systimestamp, 'ss.ff9')
from dual;

-- 세기가 없이 연도 뒷자리만 넣을 경우 rr 타입과 yy타입은 결과가 다름
select to_date('95-10-27', 'rr-mm-dd')
from dual;

select to_date('95-10-27', 'yy-mm-dd')
from dual;

-- yy타입은 현재 시점 기준으로 연도를 계산해버림
select to_char(to_date('95-10-27', 'rr-mm-dd'), 'yyyy') -- 1995
from dual; 

select to_char(to_date('95-10-27', 'yy-mm-dd'), 'yyyy') -- 2095
from dual;

-- rr타입 찾는 표
--                          지정된 연도
--                            0~49                50~99
--현재연도  0~49     반환 날짜는 현재 세기를 반영     반환 날짜는 이전 세기를 반영
--         50~99    반환 날짜는 이후 세기를 반영     반환 날짜는 현재 세기를 반영

--현재 연도     데이터 입력 날짜(지정 연도)        rr      yy
--1994년       95-10-27                      1995년   1995년
--1994년       17-10-27                      2017년   1917년
--2001년       17-10-27                      2017년   2017년
--2048년       52-10-27                      1952년   2052년
--2051년       47-10-27                      2147년   2047년

-- rr, yy타입 둘다 문제가 있다
-- rr타입: 표를 통해 지정해준다
-- yy타입: 현재 연도의 세기를 통해 지정연도에 반영해준다
-- 날짜 데이터를 입력할 때 무조건 연도 네자리 입력
-- 실무에선 rr은 절대 쓰지 않는다

-- if 조건 평가 then
--          참값 1;
-- else if 조건 평가 then
--          참값 2;
-- else if 조건 평가 then
--          참값 3;
-- else
--          기본값1;
-- end if;

-- SQL에서 if절 사용 불가. 함수 제공
-- 조건부 표현식(함수)
-- decode(함수), case(표현식, 함수)
-- if 기준값 = 비교값 then
--            참값
-- end if;

-- decode(기준값, 비교값, 참값)
-- decode 함수는 무조건 기준값과 비교값의 '=' 동일성만 비교 가능(비교연산자 무조건 =만 사용 가능)

-- ex) job_id 별로 다른 급여를 보여주고 싶다
-- ex) job_id가 'IT_PROG'이면 급여를 10% 인상하고, 'ST_CLEAR'와 'SA_REP'는 20%를 인상한다. 
select last_name, job_id, salary, 
       decode(job_id, 'IT_PROG', salary * 1.1, 'ST_CLEAR', salary * 1.2, 'SA_REP', salary * 1.2, salary)
from employees;

-- case 기준값, 비교값, 참값
-- 출력결과에 식 대신 "별칭" 설정해줘도 됨
select last_name, job_id, salary,
       case job_id
            when 'IT_PROG' then salary * 1.1
            when 'ST_CLEAR' then salary * 1.2
            when 'SA_REP' then salary * 1.2
            else salary
       end "별칭"
from employees;

-- 기준값을 when절에 넣어줘도 되고, case와 when 사이에 넣어도 상관 없음
select last_name, salary,
       case
            when salary < 5000 then 'low'
            when salary < 10000 then 'medium' -- between연산자 쓸 필요 없이 이미 앞의 조건을 넘어서 온것이기 때문에 5000 이상임
            when salary < 20000 then 'good'
            else 'excellent'
       end "별칭"
from employees;

-- 여기까지가 단일행 함수
-- 단일행 함수: 문자함수, 숫자함수, 날짜함수, 형변환 함수, null관련 함수, 조건표현식 함수

-- 그룹함수: max, min, count, 평균, 분산, 표준편차
-- max: 최대값, 타입에 영향을 받지 않는다
-- min: 최소값, 타입에 영향을 받지 않는다

select max(salary), min(salary)
from employees;

select max(hire_date), min(hire_date)
from employees;

select max(last_name), min(last_name) 
from employees;

-- 행을 제안해서 그룹화 함수를 사용할 수 있다
select max(salary), min(salary), max(hire_date), min(hire_date), max(last_name), min(last_name)
from employees
where department_id = 50;

-- count: 행 수
select count(*)
from employees;

select count(commission_pct)
from employees;

select count(distinct department_id)
from employees;

select sum(salary)
from employees;

select sum(salary)
from employees
where department_id = 50;

select avg(salary)
from employees;

select avg(commission_pct)
from employees;

select avg(nvl(commission_pct, 0))
from employees;

select variance(salary)
from employees;

select stddev(salary)
from employees;

select department_id, avg(salary)
from employees
group by department_id;

select department_id, job_id, avg(salary)
from employees
group by department_id, job_id;

-- where절은 행을 제한하는 절 / 오류가 남
select department_id, sum(salary)
from employees
where sum(salary) > 10000
group by department_id;

select department_id, sum(salary)
from employees
group by department_id
having sum(salary) > 10000;

-- 그룹함수를 2번 중첩하면 개별 컬럼을 쓰지 못함 -> 어느그룹의 max값인지 알 수 없음
select max(avg(salary))
from employees
group by department_id;