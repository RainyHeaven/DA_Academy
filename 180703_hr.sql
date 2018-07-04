/*[문제130] 20번 부서 사원들의 급여의 누적 합계를 아래와 같이 출력하세요.
<화면출력>
EMPLOYEE_ID     SALARY DEPARTMENT_ID      TOTAL
----------- ---------- ------------- ----------
        201      13000            20      13000
        202       6000            20      19000
*/
SELECT e.employee_id, e.salary, e.department_id, sum(t.salary) AS TOTAL
FROM employees e, employees t
WHERE e.department_id = 20 
AND  t.department_id = 20
AND e.employee_id >= t.employee_id
GROUP BY e.employee_id, e.salary, e.department_id
order by 1;

-- 누적함수 over (): group by와 order by를 동시에 할 수 있는 함수
-- COUNT(), MAX(), MIN(), SUM(), AVG(), RANK(), ROW_NUMBER() 등과 같은 집계함수나 분석함수와 함께 사용
SELECT employee_id, salary, department_id, sum(salary) OVER (ORDER BY employee_id) AS TOTAL
FROM employees
where department_id = 20;

SELECT employee_id, salary, department_id, sum(salary) OVER () AS TOTAL
FROM employees
where department_id = 20;

select employee_id, salary, department_id, avg(salary) over () as TOTAL
from employees
where department_id = 20;

-- over(partition by 그룹명): 그룹명으로 묶임
SELECT employee_id, salary, department_id, sum(salary) OVER (PARTITION BY department_id) AS DEPT_TOTAL
from employees;

SELECT employee_id, salary, department_id, sum(salary) OVER(PARTITION BY department_id) AS DEPT_TOTAL, sum(salary) OVER(PARTITION BY department_id ORDER BY employee_id) as TOTAL
from employees;

-- [문제131] 사원테이블에서 급여를 많이 받은 2등까지 사원번호, 급여를 출력 해주세요.
select employee_id, salary
FROM (SELECT employee_id, salary FROM employees ORDER BY 2 DESC)
WHERE ROWNUM <= 2;
--where절 부터 돌아가기 때문에 미정렬시 원하는 값을 얻지 못할수 있음
--구하기위해 부등호는 >,<보다 >=,<=를 이용하는게 효과적
--동일급여사람 누락할수있음>분석함수로 풀어줘야함

-- rank(): 중복순위는 갯수만큼 건너뛰고 순위를 리턴 / dense_rank(): 중복순위 상관없이 순차적 순위 리턴
SELECT employee_id, salary, rank() OVER(ORDER BY salary DESC), DENSE_RANK() OVER(ORDER BY salary DESC)
from employees;

SELECT rank, employee_id, salary
FROM (SELECT DENSE_RANK() OVER(ORDER BY salary DESC) AS rank, employee_id, salary FROM employees)
where rank <= 2;

SELECT department_id, salary, rank() OVER(PARTITION BY department_id ORDER BY salary DESC) as rank1,
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank2
from employees;

SELECT employee_id, salary, 
sum(salary) OVER(ORDER BY employee_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_1,
sum(salary) OVER(ORDER BY employee_id) sum_2,
sum(salary) OVER(ORDER BY employee_id ROWS BETWEEN UNBOUNDED PRECEDING AND unbounded FOLLOWING) sum_3
FROM employees;
-- rows between unbounded preceding and current row: 처음부터 현재 행까지 정렬, default
-- rows between unbounded preceding and unbounded following: 처음부터 끝까지 정렬

-- [문제132] 부서별로 급여의 순위를 구하세요.
SELECT rank() OVER(ORDER BY dept_sal desc), department_id, dept_sal
FROM (SELECT department_id, sum(salary) AS dept_sal FROM employees GROUP BY department_id);

SELECT department_id, salary, rank() OVER(PARTITION BY department_id ORDER BY salary DESC) rank1, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) rank2
from employees;

-- [문제133] 자신의 부서 평균급여 보다 많이 받는 사원들의 사번,이름,급여,부서이름을 출력하세요.
select e.employee_id, e.last_name, e.department_id, d.department_name
from (select employee_id, last_name, department_id, salary, avg(salary) over(partition by department_id) as avg_sal from employees) e, departments d
where e.department_id = d.department_id
and e.salary > e.avg_sal;

select e.employee_id,e.last_name,e.salary,d.department_name
from employees e,departments d
where e.department_id=d.department_id
and e.salary > (select avg(salary) from employees where department_id=e.department_id);

select employee_id,last_name, salary,department_name
from(select e.employee_id,e.last_name,e. salary,d.department_name, case when e.salary>avg(e.salary) over (partition by e.department_id) then 'good' end VM_COL_5 from employees e,departments d where e.department_id=d.department_id)
where vm_col_5 is not null;


/*[문제134] SQL문 실행 계획을 확인 한 후 튜닝하세요.
select *
from employees
where job_id = 'IT_PROG'
or department_id = 20;

-----------------------------------------------------------------------------------------
| Id  | Operation         | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |           |      1 |        |      7 |00:00:00.01 |       7 |
|*  1 |  TABLE ACCESS FULL| EMPLOYEES |      1 |      7 |      7 |00:00:00.01 |       7 |
-----------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(("JOB_ID"='IT_PROG' OR "DEPARTMENT_ID"=20))
*/

-- 값의 분포도 확인
select distinct job_id, count(*) over(partition by job_id) from employees;
select distinct department_id, count(*) over(partition by department_id) from employees;

-- lnnvl(department_id = 20) : department_id <> 20 or department_id is null
select * from employees where department_id = 20
union all
select * from employees where job_id = 'IT_PROG' and lnnvl(department_id = 20);

-- 값의 분포도에 따라 concat을 사용해야 할 때가 있다 (중복값이 많을 때)
-- use_concat: or 구분을 union all로 변경
select /*+ use_concat */ *
from employees
where job_id = 'IT_PROG'
or department_id = 20;

-- use_concat과 반대 / or concatenation 을 막음
select /*+ no_expand */ *
from employees
where job_id = 'IT_PROG'
or department_id = 20;

-- [문제135] job_id가 AD_PRES를 제외한 사원중에 가장 큰 급여값을 찿아주세요. 단 decode함수를 이용하세요.
select max(decode(job_id, 'AD_PRES', null, salary))
from employees;

-- decode 함수의 3번째 값이 4번째 값의 타입에 영향을 줌(3번째 값이 char면 4번째 값도 char화 됨)
-- 따라서 char중 가장 큰 숫자인 9로 인식되어 최대값 9600 출력
select max(decode(job_id, 'AD_PRES', to_number(null), salary)) -- null을 숫자타입으로
from employees;

select max(case when job_id = 'AD_PRES' then null else salary end)
from employees;
