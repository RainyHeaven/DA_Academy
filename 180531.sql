-- ���� 38 job_id���� �Ѿױ޿��� ���մϴ�. �� CLERK���ڰ� �ִ� job_id�� �����ϰ� �Ѿױ޿��� 13000�� �Ѵ� ������ ����ϸ鼭 �Ѿ� �޿��� �������� �������� �����ϼ���.
select job_id, sum(salary) as "payroll"
from employees
where job_id not like '%CLERK%'
group by job_id
having  sum(salary) > 13000
order by 2 desc;

-- ���� 39 �Ի��� �⵵���� �޿��� �Ѿ��� ����ϼ���.
select to_char(hire_date, 'yyyy'), sum(salary)
from employees
group by to_char(hire_date, 'yyyy');

select extract(year from hire_date), sum(salary)
from employees
group by extract(year from hire_date);

-- ���� 40 �Ի��� �޺� �ο����� ������ּ���.
select to_char(hire_date, 'mm'), count(*)
from employees
group by to_char(hire_date, 'mm')
order by 1;

-- ���� 41 ����� �� ���� 2005��, 2006��, 2007��, 2008�⿡ �Ի��� ����� �� ����ϼ���.
-- ������� 1�� �ƴ� 0�̳� ���ڸ� �־ ����(�� ���� ���� ������)
select count(*) as TOTAL, count(decode(extract(year from hire_date), 2005, 1)) as "2005", count(decode(extract(year from hire_date), 2006, 1)) as "2006", count(decode(extract(year from hire_date), 2007, 1)) as "2007", count(decode(extract(year from hire_date), 2008, 1)) as "2008"
from employees;

-- ������� 1�� ���� �հ谡 ����
select count(*) as TOTAL, sum(case to_char(hire_date, 'yyyy') when '2005' then 1 end) as "2005", sum(case to_char(hire_date, 'yyyy') when '2006' then 1 end) as "2006", sum(case to_char(hire_date, 'yyyy') when '2007' then 1 end) as "2007", sum(case to_char(hire_date, 'yyyy') when '2008' then 1 end) as "2008"

-- having���� �� ������ where���� ������ �ȵȴ�
select department_id, sum(salary)
from employees
where department_id in (10, 20) -- where�� ���� �����ϴ� �Լ�
group by department_id;

-- full scan�� ��
select department_id, sum(salary)
from employees
having department_id in (10, 20) --having�� ����� �����ϴ� �Լ� / ������ ū ������ ���� ����
group by department_id;

desc employees
desc departments

-- join
-- �Ʒ� ���� join�� ������� �ʾ� cartesian product �߻�
select last_name, department_name
from employees, departments;

-- equi join: ��ġ�ϴ� key���� ���� ����
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

-- �������Ǽ���: e.department_id = d.department_id
-- ���������Ǽ���: e.department_id = 10
select last_name, department_name
from employees e, departments d
where e.department_id = d.department_id and e.department_id = 10;

select last_name, department_name
from employees e, departments d
where e.department_id = 10 and d.department_id = 10;

-- self join: �ڽ��� ���̺��� join
select w.employee_id, w.last_name, m.employee_id, m.last_name
from employees w, employees m
where w.manager_id = m.employee_id;

-- outer join(+): Ű ���� ��ġ���� �ʴ� �����͸� �̱����� ���
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