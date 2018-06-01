-- ���� 42 ��� ����� last_name, department_id, department_name�� ǥ���ϱ� ���� query �� �ۼ��մϴ�.
--����Ŭ
select e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

--ANSIǥ��
select e.last_name, e.department_id, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id;

-- ���� 43 �μ� 80�� ���ϴ� last_name, job_id, department_name, city�� ǥ���ϱ� ���� query �� �ۼ��մϴ�.
--����Ŭ
select e.last_name, e.job_id, d.department_name, l.city
from employees e, departments d, locations l
where e.department_id = 80 and e.department_id = d.department_id and d.location_id = l.location_id;

--ANSIǥ��
select e.last_name, e.job_id, d.department_name, l.city
from employees e join departments d
on e.department_id = d.department_id 
join locations l
on d.location_id = l.location_id
where e.department_id = 80;

--���� 44 commission_pct �� null�� �ƴ� ��� ����� last_name, department_name, location_id, city�� ǥ���ϱ� ���� query �� �ۼ��մϴ�.
--����Ŭ
select e.last_name, d.department_name, d.location_id, l.city
from employees e, departments d, locations l
where e.commission_pct is not null and e.department_id = d.department_id(+) and d.location_id = l.location_id(+);

--ANSIǥ��
select e.last_name, d.department_name, d.location_id, l.city
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
where e.commission_pct is not null;

--���� 45 last_name�� a(�ҹ���)�� ���Ե� ��� ����� last_name, department_name �� ǥ���ϱ� ���� query �� �ۼ��մϴ�.
--����Ŭ
select e.last_name, d.department_name
from employees e, departments d
where e.last_name like '%a%' and e.department_id = d.department_id(+);

--ANSIǥ��
select e.last_name, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id
where e.last_name like '%a%';

select e.last_name, d.department_name
from employees e left outer join departments d
on e.department_id = d.department_id
where instr(e.last_name, 'a') >=1;

-- ���� 46 locations ���̺� �ִ� city�÷���  Toronto���ÿ��� �ٹ��ϴ� ��� ����� last_name, job_id, department_id, department_name �� ǥ���ϱ� ���� query �� �ۼ��մϴ�.
--����Ŭ
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where l.city = 'Toronto' and e.department_id = d.department_id and d.location_id = l.location_id;

--ANSIǥ��
select e.last_name, e.job_id, e.department_id, d.department_name
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where l.city = 'Toronto';
desc employees

-- ���� 47 2006�⵵�� �Ի��� ������� �μ��̸����� �޿��� �Ѿ�, ����� ����ϼ���.
--����Ŭ
select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e, departments d
where extract(year from e.hire_date) = 2006 and e.department_id = d.department_id
-- extract�� �̾Ƴ��� �ε��� ��ĵ�� �ƴ� Ǯ ��ĵ�� ��
group by d.department_name;

--ANSIǥ��
select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e join departments d
on e.department_id = d.department_id
where to_char(e.hire_date, 'yyyy') = '2006' 
-- to_char�� �̾Ƴ��� �ε��� ��ĵ�� �ƴ� Ǯ ��ĵ�� ��
group by d.department_name;

select d.department_name, sum(e.salary) as "Total", avg(e.salary) as "Average"
from employees e join departments d
on e.department_id = d.department_id
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
group by d.department_name;

-- ���� 48 2006�⵵�� �Ի��� ������� �����̸����� �޿��� �Ѿ�, ����� ����ϼ���.
--����Ŭ
select l.city, sum(e.salary), avg(e.salary)
from employees e, departments d, locations l
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
and e.department_id = d.department_id
and d.location_id = l.location_id
group by l.city;

--ANSIǥ��
select l.city, sum(e.salary), avg(e.salary)
from employees e join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
where e.hire_date >= to_date('20060101', 'yyyymmdd') and e.hire_date < to_date('20070101', 'yyyymmdd')
group by l.city;

-- ����49 2007�⵵�� �Ի��� ������� �����̸����� �޿��� �Ѿ�, ����� ����ϼ���. �� �μ� ��ġ�� ���� �ʴ� ������� �޿��� �Ѿ�, ��յ� ���ϼ���.
--����Ŭ
select l.city, sum(e.salary), avg(e.salary)
from employees e, departments d, locations l
where e.hire_date >= to_date('20070101', 'yyyymmdd') and e.hire_date < to_date('20080101', 'yyyymmdd')
and e.department_id = d.department_id(+)
and d.location_id = l.location_id(+)
group by l.city;

--ANSIǥ��
select l.city, sum(e.salary), avg(e.salary)
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
where e.hire_date >= to_date('20070101', 'yyyymmdd') and e.hire_date < to_date('20080101', 'yyyymmdd')
group by l.city;

-- ���� 50 ������� ���, �޿�, �޿����, �μ��̸��� ����ϼ���. �μ���ġ�� ���� �ʴ� ����� ���ܽ����ּ���.
--����Ŭ
select e.employee_id, e.salary, j.grade_level, d.department_name
from employees e, departments d, job_grades j
where e.department_id = d.department_id and e.salary between j.lowest_sal and j.highest_sal;

--ANSIǥ��
select e.employee_id, e.salary, j.grade_level, d.department_name
from employees e join departments d
on e.department_id = d.department_id
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;

-- ���� 51 ������� ���, �޿�, �޿����, �μ��̸�, �ٹ� ���� ������ ����ϼ���. �μ���ġ�� ���� �ʴ� ����� ���Խ����ּ���.
--����Ŭ
select e.employee_id, e.salary, j.grade_level, d.department_name, l.city
from employees e, departments d, job_grades j, locations l
where e.department_id = d.department_id(+)
and e.salary between j.lowest_sal and j.highest_sal
and d.location_id = l.location_id(+);

--ANSIǥ��
select e.employee_id, e.salary, j.grade_level, d.department_name, l.city
from employees e left outer join departments d
on e.department_id = d.department_id
left outer join locations l
on d.location_id = l.location_id
join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;

-- ���� 52 ������� last_name,salary,grade_level, department_name�� ����ϴµ� last_name�� a���ڰ� 2�� �̻� ���ԵǾ� �ִ� ������� ����ϼ���.
--����Ŭ
select e.last_name, e.salary, j.grade_level, d.department_name
from employees e, job_grades j, departments d
where instr(e.last_name, 'a', 1, 2) >= 2 and e.department_id = d.department_id(+) and e.salary between j.lowest_sal and j.highest_sal;

--ANSIǥ��
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

-- join using ��
select e.last_name, department_id, d.department_name
from employees e join departments d
using(department_id)
where department_id in (20, 30);

-- join on ��
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