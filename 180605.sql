-- ���� 65 last_name�� Davies ������� �ʰ� �Ի��� ��� �߿� �޿��� Davies ����� �޿� ���Ϸ� �ް� �ִ� ������� ������ּ���.
--��������
select *
from employees
where salary <= (select salary from employees where last_name = 'Davies')
and hire_date > (select hire_date from employees where last_name = 'Davies');

--����Ŭ
select e.*
from employees e, employees d
where e.salary <= d.salary
and e.hire_date > d.hire_date
and d.last_name = 'Davies';

--ANSIǥ��
select e.*
from employees e join employees d
on e.salary <= d.salary
and e.hire_date > d.hire_date
where d.last_name = 'Davies';

-- ���� 66 �ڽ��� �μ� ��� �޿����� �� ���� �޿��� �޴� ������� ������ ������ּ���
select *
from employees o
where o.salary > (select avg(salary) from employees where department_id = o.department_id);

-- ���� 67 �ι� �̻� job_id�� �ٲ� ��� ������ּ���.
select j.*
from job_history j
where 2 <= (select count(employee_id) from job_history where employee_id = j.employee_id)
order by j.employee_id;

-- ���� 68 ������ ����� ���ؼ� ������ּ���
select *
from employees e
where employee_id in (select distinct manager_id from employees where manager_id is not null);

select *
from employees o
where exists (select 'x'--���� ������ ���� ���� �ǹ̾��� ǥ�� 'x'
              from employees
              where manager_id = o.employee_id);
              
-- ���� 69 �����ڰ� �ƴ� ����� ���ؼ� ������ּ���
select *
from employees e
where employee_id not in (select distinct manager_id from employees where manager_id is not null);

select *
from employees o
where not exists (select 'x'
              from employees
              where manager_id = o.employee_id);

-- ���� 70 ����� ���� �μ� ������ ������ּ���
select *
from departments
where department_id not in (select department_id from employees where department_id is not null);

select *
from departments d
where not exists (select 'x' from employees where department_id = d.department_id);

-- ���� 71 �ڽ��� �μ��ȿ��� �ڽź��� �ʰ� �Ի��ϰ� �ڽź��� �޿��� ���̹޴� ����� �ִ� ������� ã���ּ���
select *
from employees e
where exists (select 'x' from employees where department_id = e.department_id and salary > e.salary and hire_date > e.hire_date)
and e.department_id = 30;

