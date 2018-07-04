/*[����130] 20�� �μ� ������� �޿��� ���� �հ踦 �Ʒ��� ���� ����ϼ���.
<ȭ�����>
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

-- �����Լ� over (): group by�� order by�� ���ÿ� �� �� �ִ� �Լ�
-- COUNT(), MAX(), MIN(), SUM(), AVG(), RANK(), ROW_NUMBER() ��� ���� �����Լ��� �м��Լ��� �Բ� ���
SELECT employee_id, salary, department_id, sum(salary) OVER (ORDER BY employee_id) AS TOTAL
FROM employees
where department_id = 20;

SELECT employee_id, salary, department_id, sum(salary) OVER () AS TOTAL
FROM employees
where department_id = 20;

select employee_id, salary, department_id, avg(salary) over () as TOTAL
from employees
where department_id = 20;

-- over(partition by �׷��): �׷������ ����
SELECT employee_id, salary, department_id, sum(salary) OVER (PARTITION BY department_id) AS DEPT_TOTAL
from employees;

SELECT employee_id, salary, department_id, sum(salary) OVER(PARTITION BY department_id) AS DEPT_TOTAL, sum(salary) OVER(PARTITION BY department_id ORDER BY employee_id) as TOTAL
from employees;

-- [����131] ������̺��� �޿��� ���� ���� 2����� �����ȣ, �޿��� ��� ���ּ���.
select employee_id, salary
FROM (SELECT employee_id, salary FROM employees ORDER BY 2 DESC)
WHERE ROWNUM <= 2;
--where�� ���� ���ư��� ������ �����Ľ� ���ϴ� ���� ���� ���Ҽ� ����
--���ϱ����� �ε�ȣ�� >,<���� >=,<=�� �̿��ϴ°� ȿ����
--���ϱ޿���� �����Ҽ�����>�м��Լ��� Ǯ�������

-- rank(): �ߺ������� ������ŭ �ǳʶٰ� ������ ���� / dense_rank(): �ߺ����� ������� ������ ���� ����
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
-- rows between unbounded preceding and current row: ó������ ���� ����� ����, default
-- rows between unbounded preceding and unbounded following: ó������ ������ ����

-- [����132] �μ����� �޿��� ������ ���ϼ���.
SELECT rank() OVER(ORDER BY dept_sal desc), department_id, dept_sal
FROM (SELECT department_id, sum(salary) AS dept_sal FROM employees GROUP BY department_id);

SELECT department_id, salary, rank() OVER(PARTITION BY department_id ORDER BY salary DESC) rank1, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) rank2
from employees;

-- [����133] �ڽ��� �μ� ��ձ޿� ���� ���� �޴� ������� ���,�̸�,�޿�,�μ��̸��� ����ϼ���.
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


/*[����134] SQL�� ���� ��ȹ�� Ȯ�� �� �� Ʃ���ϼ���.
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

-- ���� ������ Ȯ��
select distinct job_id, count(*) over(partition by job_id) from employees;
select distinct department_id, count(*) over(partition by department_id) from employees;

-- lnnvl(department_id = 20) : department_id <> 20 or department_id is null
select * from employees where department_id = 20
union all
select * from employees where job_id = 'IT_PROG' and lnnvl(department_id = 20);

-- ���� �������� ���� concat�� ����ؾ� �� ���� �ִ� (�ߺ����� ���� ��)
-- use_concat: or ������ union all�� ����
select /*+ use_concat */ *
from employees
where job_id = 'IT_PROG'
or department_id = 20;

-- use_concat�� �ݴ� / or concatenation �� ����
select /*+ no_expand */ *
from employees
where job_id = 'IT_PROG'
or department_id = 20;

-- [����135] job_id�� AD_PRES�� ������ ����߿� ���� ū �޿����� �O���ּ���. �� decode�Լ��� �̿��ϼ���.
select max(decode(job_id, 'AD_PRES', null, salary))
from employees;

-- decode �Լ��� 3��° ���� 4��° ���� Ÿ�Կ� ������ ��(3��° ���� char�� 4��° ���� charȭ ��)
-- ���� char�� ���� ū ������ 9�� �νĵǾ� �ִ밪 9600 ���
select max(decode(job_id, 'AD_PRES', to_number(null), salary)) -- null�� ����Ÿ������
from employees;

select max(case when job_id = 'AD_PRES' then null else salary end)
from employees;
