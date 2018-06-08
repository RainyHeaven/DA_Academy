-- ���� 83  job_id��  ST_CLERK �� �������� �ʴ� �μ��� ���� department_id�� ������ּ���.
SELECT department_id
FROM departments
WHERE department_id NOT IN (SELECT DISTINCT department_id FROM employees WHERE job_id = 'ST_CLERK');

-- ���� ����/������ ���θ� ã�� ���ؼ��� correlated subquery�� ����ϴ� ���� �����ϴ�
SELECT department_id
FROM departments d
WHERE NOT EXISTS (SELECT 'x' FROM employees WHERE department_id = d.department_id AND job_id = 'ST_CLERK');
  
-- job_id�� ST_CLERK�� ����� ���� �μ�
SELECT DISTINCT department_id
FROM employees
WHERE job_id = 'ST_CLERK';

-- ���� 84 �μ��� �������� �ʴ� ������ ����Ʈ�� �ʿ��մϴ�. �ش� ������ country_id, country_name�� ������ּ���.
-- in / not in ���
-- �μ��� �ִ� ������� ���̺�
select distinct country_id
from locations
where location_id in (select location_id from departments);

-- ��ü ���� ���̺��� �μ��� �ִ� ������� ������ ���̺�
select country_id, country_name
from countries
where country_id not in (select distinct country_id from locations l where location_id in (select location_id from departments));

-- exists / not exists ���
--�μ��� �ִ� ������� ���̺�
select distinct country_id
from locations l
where exists (select 'x' from departments where location_id = l.location_id);

-- ��ü ���� ���̺��� �μ��� �ִ� ������� ������ ���̺�
select country_id, country_name
from countries o
where not exists (select 'x' from locations l where exists (select 'x' from departments where location_id = l.location_id) and l.country_id = o.country_id);

-- ���տ����� ��� / sort�� �ϰԵǰ� ������ ���̺��� ������ ����ϰ� ��
select country_id, country_name
from countries
minus
select l.country_id, c.country_name
from departments d, locations l, countries c
where l.country_id = c.country_id
and d.locations_id = l.location_id

--not exists ��� / join�� �� Ȱ������ / 1�� -> m�� ��
select country_id, country_name
from countries c
where not exists (select 'x' from locations l, departments d where d.location_id = l.location_id and l.country_id = c.country_id);

-- ���� 85 ������� employee_id, last_name, department_name�� ����ϴµ� �ҼӺμ��� ���� ����� ����Ͻð�, �Ҽӻ���� ���� �μ��� ����ϼ���. ANSIǥ�� ����, ����Ŭ ���� �������� ���弼��.
--����Ŭ
--department_id = null�� ����
select e.employee_id, e.last_name, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
union all
--employee_id = null�� ����
select e.employee_id, e.last_name, d.department_name
from employees e, departments d
where e.department_id(+) = d.department_id
and e.department_id is null;


--ANSIǥ��
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

-- ���� 86 1,2,3,4�� �Ѳ����� ������ּ���.
-- 1. department_id, job_id, manager_id �������� �Ѿ� �޿��� ���
-- 2. department_id, job_id �������� �Ѿױ޿����
-- 3. department_id �������� �Ѿױ޿� ���
-- 4. ��ü �Ѿ� �޿��� ���

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


-- 1. department_id, job_id, manager_id �������� �Ѿ� �޿��� ���
select department_id, job_id, manager_id, sum(salary)
from employees
group by department_id, job_id, manager_id;

-- 2. department_id, job_id �������� �Ѿױ޿����
select department_id, job_id, null, sum(salary)
from employees
group by department_id, job_id;

-- 3. department_id �������� �Ѿױ޿� ���
select department_id, null, null, sum(salary)
from employees
group by department_id;

-- 4. ��ü �Ѿ� �޿��� ���
select null, null, null, sum(salary)
from employees;

--roll up������
-- group by ������ ������ �� ����Ʈ�� �����ʿ��� �������� �� �÷��� �ٿ����� �׷�ȭ
select department_id, job_id, manager_id, sum(salary)
from employees
group by rollup (department_id, job_id, manager_id);

--cube ������
-- group by ���� ������ ������ ��� �׷�ȭ
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

-- ���� 87 1, 2 �Ѳ����� ������ּ���
-- 1. department_id, manager_id ���� �޿� �� ��
-- 2. department_id, job_id ���� �޿� �� ��
select department_id, manager_id, null, sum(salary)
from employees
group by department_id, manager_id
union all
select department_id, null, job_id, sum(salary)
from employees
group by department_id, job_id;

-- 1. department_id, manager_id ���� �޿� �� ��
select department_id, manager_id, sum(salary)
from employees
group by department_id, manager_id;

-- 2. department_id, job_id ���� �޿� �� ��
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id;

--grouping sets ������
select department_id, job_id, manager_id, sum(salary)
from employees
group by grouping sets ((department_id, manager_id), (department_id, job_id), ());

-- ���� 88  �⵵���� �Ի��� �ο���, ��ü �ο����� ������ּ���
SELECT 
       max(decode(year,'2001',cn)) "2001",
       max(decode(year,'2002',cn)) "2002",
       max(decode(year,'2003',cn)) "2003",
       max(decode(year,'2004',cn)) "2004",   
       max(decode(year,'2005',cn)) "2005",
       max(decode(year,'2006',cn)) "2006",
       max(decode(year,'2007',cn)) "2007",
       max(decode(year,'2008',cn)) "2008",
       sum(cn) "���ο���"
FROM (
              SELECT to_char(hire_date, 'yyyy') year, count(*) cn
              FROM employees
              GROUP BY(to_char(hire_date, 'yyyy')));

-- rollup Ȱ��              
SELECT 
       max(decode(year,'2001',cn)) "2001",
       max(decode(year,'2002',cn)) "2002",
       max(decode(year,'2003',cn)) "2003",
       max(decode(year,'2004',cn)) "2004",   
       max(decode(year,'2005',cn)) "2005",
       max(decode(year,'2006',cn)) "2006",
       max(decode(year,'2007',cn)) "2007",
       max(decode(year,'2008',cn)) "2008",
       max(decode(year,null,cn)) "���ο���"
FROM (
              SELECT to_char(hire_date, 'yyyy') year, count(*) cn
              FROM employees
              GROUP BY rollup(to_char(hire_date, 'yyyy')));

-- ���� 89 �޺� �Ի��� �ο���, ���ο����� ������ּ���.
SELECT 
       max(decode(hire_month,01,cn)) "1��",
       max(decode(hire_month,02,cn)) "2��",
       max(decode(hire_month,03,cn)) "3��",
       max(decode(hire_month,04,cn)) "4��",
       max(decode(hire_month,05,cn)) "5��",
       max(decode(hire_month,06,cn)) "6��",
       max(decode(hire_month,07,cn)) "7��",
       max(decode(hire_month,08,cn)) "8��",
       max(decode(hire_month,09,cn)) "9��",
       max(decode(hire_month,10,cn)) "10��",
       max(decode(hire_month,11,cn)) "11��",
       max(decode(hire_month,12,cn)) "12��",
       sum(cn) "���ο���"
FROM (
              SELECT to_char(hire_date, 'mm') hire_month, count(*) cn
              FROM employees
              GROUP BY(to_char(hire_date, 'mm')));              
              
 -- rollup Ȱ��   
 SELECT 
       max(decode(hire_month,01,cn)) "1��",
       max(decode(hire_month,02,cn)) "2��",
       max(decode(hire_month,03,cn)) "3��",
       max(decode(hire_month,04,cn)) "4��",
       max(decode(hire_month,05,cn)) "5��",
       max(decode(hire_month,06,cn)) "6��",
       max(decode(hire_month,07,cn)) "7��",
       max(decode(hire_month,08,cn)) "8��",
       max(decode(hire_month,09,cn)) "9��",
       max(decode(hire_month,10,cn)) "10��",
       max(decode(hire_month,11,cn)) "11��",
       max(decode(hire_month,12,cn)) "12��",
       max(decode(hire_month,null,cn)) "���ο���"
FROM (SELECT to_char(hire_date, 'mm') hire_month, count(*) cn
      FROM employees
      GROUP BY rollup(to_char(hire_date, 'mm')));   
      
-- to_char(hire_date, 'month')�� ���� 1�ڸ� �� �ڿ��� ���� 1ĭ�� �ִ�      
 SELECT 
       max(decode(hire_month,'1�� ',cn)) "1��",
       max(decode(hire_month,'2�� ',cn)) "2��",
       max(decode(hire_month,'3�� ',cn)) "3��",
       max(decode(hire_month,'4�� ',cn)) "4��",
       max(decode(hire_month,'5�� ',cn)) "5��",
       max(decode(hire_month,'6�� ',cn)) "6��",
       max(decode(hire_month,'7�� ',cn)) "7��",
       max(decode(hire_month,'8�� ',cn)) "8��",
       max(decode(hire_month,'9�� ',cn)) "9��",
       max(decode(hire_month,'10��',cn)) "10��",
       max(decode(hire_month,'11��',cn)) "11��",
       max(decode(hire_month,'12��',cn)) "12��",
       max(decode(hire_month,null,cn)) "���ο���"
FROM (SELECT to_char(hire_date, 'month') hire_month, count(*) cn
      FROM employees
      GROUP BY rollup(to_char(hire_date, 'month')));         
      
SELECT to_char(hire_date, 'month') hire_month, count(*) cn
FROM employees
GROUP BY rollup(to_char(hire_date, 'month'));
      


-- �����˻�
-- �ʼ���: start with / connect by
-- �ߺ��Ǵ� ���� �ִ� Ű�� ������ �� ����� ��ȣ�ϰ� ���� �� �����Ƿ� ������ ����� �ƴ�

-- top down ���
select employee_id, last_name, manager_id
from employees
start with employee_id = 101
connect by prior employee_id = manager_id; --����� prior: �����ܰ�

-- bottom up ���
select employee_id, last_name, manager_id
from employees
start with department_id = 20
connect by employee_id = prior manager_id;

-- level�Լ�: ������ ǥ��
-- order siblings by: ������ ������ ä�� ����
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
start with employee_id   = 100
connect by prior employee_id = manager_id
order siblings by last_name;

-- where������ ���ѽ� �� ������ ���� �ȳ���
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
where employee_id != 101
start with employee_id = 100
connect by prior employee_id = manager_id
order siblings by last_name;

-- connect by ������ ���ѽ� �� ���� �ܰ���� �����Ͽ� ���ѵ�
select level, lpad(' ', 2*level - 2, ' ') || last_name
from employees
start with employee_id = 100
connect by prior employee_id = manager_id
and employee_id != 101
order siblings by last_name;
