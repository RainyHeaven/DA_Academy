-- ���� 53 141�� ����� job_id�� ������ job_id�� ���� ����� �߿� 141�� ����� �޿����� �� ���� �޴� ����� ������ּ���
select *
from employees
where job_id = (select job_id
                from employees
                where employee_id = 141)
and salary > (select salary
                from employees
                where employee_id = 141);
                
-- ���� 54 �ּҿ����� ���� ������� ������ ������ּ���.
select *
from employees
where salary = (select min(salary)
                from employees);

-- ���� 55 ��� �޿��� ���� ���� job_id�� ã�� �ּ���.
select job_id
from employees
group by job_id
having avg(salary) = (select min(avg(salary))
                      from employees
                      group by job_id);
                      
-- ���� 56 �μ����� �ּ� �޿��ڵ��� ������ּ���.
select *
from employees
where salary in (select min(salary) from employees group by department_id)
order by department_id;

-- ���� 57 last_name �� ���� "u"�� ���Ե� ����� ���� �μ��� �ٹ��ϴ� ��� ����� employee_id, last_name �� ����ϼ���.
select employee_id, last_name
from employees
where department_id in (select distinct department_id from employees where last_name like '%u%');

-- ���� 58 �μ� ��ġ(location_id) ID �� 1700 �� ��� ����� last_name, department_id, job_id �� ����ϼ���.(����, ��������)
--����Ŭ
select e.last_name, e.department_id, e.job_id
from employees e, departments d
where e.department_id = d.department_id
and d.location_id = 1700;

--ANSIǥ��
select e.last_name, e.department_id, e.job_id
from employees e join departments d
on e.department_id = d.department_id
where d.location_id = 1700;

--��������
select last_name, department_id, job_id
from employees
where department_id in (select department_id from departments where location_id = 1700);

-- ���� 59 King ���� �����ϴ� ��� ����� last_name �� salary ����ϼ���.(����, ��������)
--����Ŭ
select e.last_name, e.salary
from employees e, employees m
where e.manager_id = m.employee_id
and m.last_name = 'King';

--ANSIǥ��
select e.last_name, e.salary
from employees e join employees m
on e.manager_id = m.employee_id
where m.last_name = 'King';

--��������
select last_name, salary
from employees
where manager_id in (select distinct employee_id from employees where last_name = 'King');

-- ���� 60 �μ� �̸�(department_name) �� Executive �μ��� ��� ����� ���� department_id, last_name, job_id  ����ϼ���.
--����Ŭ
select e.department_id, e.last_name, e.job_id
from employees e, departments d
where e.department_id = d.department_id
and d.department_name = 'Executive';

--ANSIǥ��
select e.department_id, e.last_name, e.job_id
from employees e join departments d
on e.department_id = d.department_id
where d.department_name = 'Executive';

--��������
select department_id, last_name, job_id
from employees
where department_id = (select department_id from departments where department_name = 'Executive');

-- ���� 61 60�μ��� �Ҽӵ� ��� ����� �޿�(salary)���� ����(max) �޿��� �޴� ��� ��� ����ϼ���.
select *
from employees
where salary > all (select salary from employees where department_id = 60);

select *
from employees
where salary > (select max(salary) from employees where department_id = 60);

-- ���� 62 ��ü ��� �޿����� ���� �޿��� �ް� last_name�� "u"�� ���Ե� ����� �ִ� �μ����� �ٹ��ϴ� ��� ����� employee_id, last_name, salary ����ϼ���
select employee_id, last_name, salary
from employees
where salary > (select avg(salary) from employees)
and department_id in (select distinct department_id from employees where last_name like '%u%');

-- ���� 63 ������ ������� ������ ������ּ��� 
select *
from employees
where employee_id in (select distinct manager_id from employees);

-- ���� 64 �����ڰ� �ƴ� ������� ������ ����� �ּ���
-- ���������� null ���� ���� ��� not in �����ڸ� ����� �� ���� 
select *
from employees
where employee_id not in (select distinct manager_id from employees where manager_id is not null);

select *
from employees
where employee_id != all (select distinct manager_id from employees where manager_id is not null);




-- ������ �������� / ��ø �������� nested subquery
select *
from employees
where salary > (select salary
                from employees
                where job_id = 'IT_PROG');
                
select *
from employees
where job_id = (select job_id
                from employees
                where employee_id = 141);
                
select *
from employees
where salary > any(select salary
                from employees
                where last_name = 'King');
                
-- > any / �ּҰ����� ū
select *
from employees
where salary > any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary > (select min(salary)
                from employees
                where job_id = 'IT_PROG');

-- < any / �ִ밪���� ����              
select *
from employees
where salary < any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary < (select max(salary)
                from employees
                where job_id = 'IT_PROG');
                
-- = any == in
select *
from employees
where salary = any (select salary
                    from employees
                    where job_id = 'IT_PROG');
                    
select *
from employees
where salary in (select salary
                from employees
                where job_id = 'IT_PROG');                

-- > all / �ִ밪���� ū                    
select *
from employees
where salary > all (select salary
                    from employees
                    where job_id = 'IT_PROG');

select *
from employees
where salary > (select max(salary)
                from employees
                where job_id = 'IT_PROG');
                
-- < all / �ּҰ����� ����
select *
from employees
where salary < all (select salary
                    from employees
                    where job_id = 'IT_PROG');

select *
from employees
where salary < (select min(salary)
                from employees
                where job_id = 'IT_PROG');                


                