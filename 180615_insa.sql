/* [����96] hr.departments ���̺��� department_id, department_name, manager_id �����͸� 
insa ������ dept ���̺�� insert ���� ������ �����ϼ���. */
drop table dept purge;
select * from user_constraints where table_name = 'DEPT';

alter table dept
drop primary key cascade;

create table dept
as select department_id, department_name, manager_id from hr.departments;

select * from dept;

commit;

/* [����97] hr.employees ���̺��� employee_id, last_name, hire_date, salary, manager_id, 
department_id �����͸� insa ������ emp ���̺�� insert ���� ������ �����ϼ���. */
select * from emp;
desc emp;
drop table emp purge;

create table emp
as select employee_id, last_name, hire_date, salary, manager_id, department_id from hr.employees where 1=2;

select * from user_tab_privs;

insert all
into emp(employee_id, last_name, hire_date, salary, manager_id, department_id) values(employee_id, last_name, hire_date, salary, manager_id, department_id)
select * from hr.employees;

rollback;

insert into emp(employee_id, last_name, hire_date, salary, manager_id, department_id)
select employee_id, last_name, hire_date, salary, manager_id, department_id
from hr.employees;

commit;

/* [����98] insa������ dept ���̺��� �μ����� �߿� �Ҽӻ���� ���� �μ������� ������ �� ������ �����ϼ���. */
delete from dept d
where not exists(select 'x' from emp where department_id = d.department_id);

commit;

/* [����99] ����� �߿� �ٹ������� 15�� �̻� �̸鼭 �޿��� 10000�̻� �޿��� �޴� ������� emp_1���̺� 
���, �̸�, �Ի���, �ٹ�����,  �޿� ������ �Է��ϰ� �ٹ������� 15�� �̻��̸鼭 �޿��� 10000�̸� �޿��� 
�޴� ������� emp_2���̺� ���, �̸�, �Ի���, �ٹ�����, �޿� ������ �Է��ϼ���. */
create table emp_1
(employee_id number,
 last_name varchar2(20) constraint emp1_name_nn not null,
 hire_date date,
 work_year number,
 salary number constraint emp1_salary_nn not null,
 constraint emp1_id_pk primary key(employee_id))
tablespace users;
desc emp_1

create table emp_2
as select * from emp_1 where 1=2;
desc emp_2;

insert first
when work_year >= 15 and salary >= 10000 then
into emp_1(employee_id, last_name, hire_date, work_year, salary) values(employee_id, last_name, hire_date, work_year, salary)
when work_year >= 15 and salary < 10000 then
into emp_2(employee_id, last_name, hire_date, work_year, salary) values(employee_id, last_name, hire_date, work_year, salary)
select employee_id, last_name, hire_date, (months_between(sysdate, hire_date)/ 12) as work_year, salary from employees;

select * from emp_1;��
select * from emp_2;

--Merge
-- ��ġ�ϴ� Ű ���� update, delete�� �����ϰ� ���� Ű ���� insert �ϴ� ���

create table oltp_emp
as select employee_id, last_name, salary, department_id
from hr.employees;

create table dw_emp
as select employee_id, last_name, salary, department_id
from hr.employees
where department_id = 20;

select * from dw_emp;

alter table oltp_emp add flag char(1);

update oltp_emp
set flag = 'd'
where employee_id = 202;

update oltp_emp
set salary = 20000
where employee_id = 201;

commit;

select * from oltp_emp where department_id = 20;

merge into dw_emp d -- Ÿ�� ���̺�
using oltp_emp o -- �ҽ����̺�
on (d.employee_id = o.employee_id) -- on���� ��������
when matched then 
update set d.last_name = o.last_name, d.salary = o.salary * 1.1, d.department_id = o.department_id
delete where o.flag = 'd'
when not matched then
insert(d.employee_id, d.last_name, d.salary, d.department_id)
values(o.employee_id, o.last_name, o.salary, o.department_id);

select * from dw_emp where employee_id in (201, 202);
