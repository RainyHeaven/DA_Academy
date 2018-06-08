-- ���� 72 ������� 3�� �̸��� �μ���ȣ, �μ��̸�, �ο����� ������ּ���
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

--inline view�� ���� join�� ���� ���� �� �ִ�

-- ���� 73�� 2005��, 2006��, 2007��, 2008�⿡ �Ի��� ����� �� ����ϼ���.
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
                
-- ���� 74 ��� �޿��� ���� ���� �μ��� �μ� ��ȣ�� �ְ�, ����, ��� �޿��� ����ϼ���.
select department_id, max(salary), min(salary), avg(salary) as average
from employees
group by department_id
having avg(salary) = (select max(avg(salary)) from employees group by department_id);

-- �μ��� �ְ�, ����, ��ձ޿� ���̺�
select department_id, max(salary), min(salary), avg(salary) as average
from employees
group by department_id;

-- �ְ� ��ձ޿� ���̺�
select max(avg(salary)) from employees group by department_id;


-- ���� 75 ��� ���� ���� ���� �μ��̸�, ����, �ο����� ������ּ���.
select d.department_name, l.city, e.cn
from (select department_id, count(*) cn from employees group by department_id having count(*) 
      = (select max(count(*)) from employees group by department_id)) e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id;      

-- ���� 76 ��� ä�� ���� ���� ���� ������ ������ּ���.
select to_char(hire_date, 'day'), count(*)
from employees
group by to_char(hire_date, 'day')
having count(*) = (select max(count(*)) from employees group by to_char(hire_date, 'day'));

-- ���� 77 ��� ä�� ���� ���� ���� ���Ͽ� �Ի��� ������� last_name, ������ ������ּ���.
select last_name, to_char(hire_date, 'day')
from employees
where to_char(hire_date, 'day') in (select to_char(hire_date, 'day') from employees group by to_char(hire_date, 'day')
having count(*) = (select max(count(*)) from employees group by to_char(hire_date, 'day')));

-- ���� 78 �μ����� �ο����� ����ּ���.
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
       max(decode(department_id, null, cn)) as "�μ��� ���� ���"
from (select department_id, count(*) cn from employees group by department_id);

-- ���� 79 �μ� ��ȣ�� �޿��� Ŀ�̼��� �޴� ����� �μ� ��ȣ �� �޿��� ��ġ�ϴ� ���  ����� last_name, department_id, salary �� ǥ���ϴ� query �� �ۼ��ϼ���.
select last_name, department_id, salary
from employees
where (department_id, salary) in (select department_id, salary from employees where commission_pct is not null);

--Ŀ�̼��� �޴� ��� ���̺�
select department_id, salary from employees where commission_pct is not null;

-- ���� 80 �޿��� Ŀ�̼��� location_id�� 1700 �� �ִ� ����� �޿� �� Ŀ�̼ǰ� ��ġ�ϴ� ����� last_name, department_name, salary�� ������ּ���.
select e.last_name, d.department_name, e.salary
from employees e join departments d
on e.department_id = d.department_id
where (salary, nvl(e.commission_pct, 0)) in (select e.salary, nvl(e.commission_pct, 0) from employees e, departments d where e.department_id = d.department_id and d.location_id = 1700);

-- location_id = 1700�� ������� �޿��� Ŀ�̼�
select e.salary, nvl(e.commission_pct, 0) 
from employees e, departments d 
where e.department_id = d.department_id and d.location_id = 1700;

-- ���� 81 select department_id, department_name from departments where location_id = 1700
select last_name, hire_date, salary, commission_pct
from employees
where (salary, nvl(commission_pct, 0)) = (select salary, nvl(commission_pct, 0) from employees where last_name = 'Johnson')
and last_name not like 'Johnson';

-- Johnson�� �޿��� Ŀ�̼�
select salary, commission_pct from employees where last_name = 'Johnson';

-- ���� 82 �μ��� �� �޿��� ��ü �μ��� ��� �޿����� ���� �μ��� �̸��� �� �޿��� ǥ���ϵ��� query�� �ۼ��ϼ���.
--null �μ� ������
select d.department_name, sum(e.salary)
from employees e join departments d
on e.department_id = d.department_id
group by d.department_name
having sum(e.salary) > (select avg(dep_sum) from (select department_id, sum(salary) dep_sum from employees where department_id is not null group by department_id));

--null �μ� ����
select d.department_name, sum(e.salary)
from employees e join departments d
on e.department_id = d.department_id
group by d.department_name
having sum(salary) > (select avg(dep_sum) from (select department_id, sum(salary) dep_sum from employees group by department_id));

--null �μ� ����(������ ��)
select d.department_name, e.average
from (select department_id, sum(salary) average from employees group by department_id having sum(salary) > (select avg(average) from (select sum(salary) average from employees group by department_id))) e, departments d
where e.department_id = d.department_id;

-- ��ü �μ��� �ѱ޿� ���
select avg(dep_sum)
from (select department_id, sum(salary) dep_sum from employees where department_id is not null group by department_id);

-- �� �μ��� �ѱ޿�
select department_id, sum(salary)
from employees
where department_id is not null
group by department_id;

--with: ������ ������ �������̺� ����
with
dept_cost as (select d.department_name, sum(e.salary) as sumsal  from employees e, departments d where e.department_id = d.department_id(+) group by d.department_name), 
avg_cost as (select sum(sumsal) / count(*) as deptavg from dept_cost)
select *
from dept_cost
where sumsal > (select deptavg from avg_cost);


--with ������ ������ ���� ���̺� ����

with
dept_cost as (select d.department_name, sum(e.salary) as sumsal from employees e, departments d where e.department_id = d.department_id(+) group by d.department_name), 
avg_cost as (select sum(sumsal) / count(*) as deptavg from dept_cost)
select *
from dept_cost
where sumsal > (select deptavg from avg_cost);

--multiple-column subquery (���߿� ��������)
-- ������ ������ ���� ���̺� ����
-- ���� query�� �ȿ��� ������ select ���� �ι� �̻� �ݺ��� ��쿡 query block�� ���� ����ϸ� ������ ���ȴ�

--���߿� ���������� �ֺ� ���
select *
from employees
where (manager_id, department_id) in (select manager_id, department_id from employees where first_name = 'John')
order by employee_id;

--������ ���������� ��ֺ� ���
select *
from employees
where manager_id in (select manager_id from employees where first_name = 'John')
and department_id in (select department_id from employees where first_name = 'John')
order by employee_id;

-- ���տ�����
--������, ������, ������
--�÷� ��, ������ Ÿ���� ��ġ���Ѿ� �Ѵ�
--sort�� �߻���Ų��
-- ���ϴ� ������ ���ؼ� ���� �������� order by�� ����ؾ� �Ѵ�
-- �̶� �÷����� ���� ù ���������� �÷����� ����ؾ� �Ѵ�
-- ���� �̽��� �����Ƿ� ���տ����ڴ� �ǵ��� ������� �ʴ� ���� ����

--������ union(�ߺ��� ������ ������)
select employee_id, job_id
from employees
union
select employee_id, job_id
from job_history;

--union all (�ߺ��� ������ ������)
-- sort�� �߻���Ű�� �ʴ´�
-- union all�� not exists�� Ȱ���Ͽ� union�� ��������� ���� �� �ִ�
select employee_id, job_id
from employees e
where not exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id)
union all
select employee_id, job_id
from job_history;

-- ������ intersect
select employee_id, job_id
from employees
intersect
select employee_id, job_id
from job_history;

--exists�� Ȱ���Ͽ� intersect�� ���� ����� ���� �� �ִ�
select employee_id, job_id
from employees e
where exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id);

-- ������ minus
select employee_id, job_id
from employees
minus
select employee_id, job_id
from job_history;

-- not exists�� Ȱ���Ͽ� minus�� ���� ����� ���� �� �ִ�
select employee_id, job_id
from employees e
where not exists (select 'x' from job_history where employee_id = e.employee_id and job_id = e.job_id);
