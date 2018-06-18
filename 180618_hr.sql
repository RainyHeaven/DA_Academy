-- ���� 100 EMPLOYEES ���̺��� ���� EMP_COPY �̸����� �����ϼ���.
create table emp_copy
as select * from hr.employees;
-- CTAS�� ������ not null �������Ǹ� �����ȴ�.

--���� 101 EMP_COPY���̺� employee_id�� emp_copy_id_pk �̸����� primary key ���������� �߰��ϼ���. 
alter table emp_copy
add constraints emp_id_pk primary key(employee_id);
	
--���� 102 EMP_COPY ���̺� department_name varchar2(30) �÷��� �߰��ϼ���.
alter table emp_copy
add department_name varchar2(30);

--���� 103 DEPARTMENTS ���̺� �ִ� department_name�� �������� EMP_COPY ���̺� department_name�� ���� �����ϼ���.
--�� UPDATE���� �̿��ؼ� �ذ��� �� ������ ������ Ȯ���ϰ� ROLLBACK �ϼ���.
update emp_copy e
set department_name = (select department_name from departments where department_id = e.department_id);

select department_id, department_name from emp_copy;	

rollback;

select department_id, department_name from emp_copy;	

--���� 104 DEPARTMENTS ���̺� �ִ� department_name�� �������� EMP_COPY ���̺� department_name�� ���� �����ϼ���.
--�� MERGE���� �̿��ؼ� �ذ��� ��  ������ ������ ������ �����ϼ���.
merge into emp_copy e
using (select department_id, department_name from departments) d
on (e.department_id = d.department_id)
when matched then
update set e.department_name = d.department_name;

select department_id, department_name from emp_copy;

commit;

--���� 105 EMP_COPY ���̺� department_name�� ���� NULL ������ �����ϼ���. 
--�� MERGE���� �̿��ؼ� �ذ��� �� ROLLBACK �ϼ���.
merge into emp_copy e
using (select department_id from departments) d
on (e.department_id = d.department_id)
when matched then
update set e.department_name = null;

select department_name from emp_copy;

rollback;

select department_name from emp_copy;

-- ���� 106 ������� �޿��� 5000 �̸��� ��� employee_id, salary ������ SPECIAL_SAL ���̺� �Է��ϰ� 
--�ƴϸ� employee_id, hire_date, salary������ SAL_HISTORY ���̺� �Է��ϰ� 
--�Ǵ�  employee_id, manager_id, salary ������  MGR_HISTORY ���̺� �Է��Ѵ�.

create table special_sal
(employee_id number,
 salary number)
 tablespace users;
  
create table sal_history
(employee_id number,
 hire_date date,
 salary number);
  
create table mgr_history
(employee_id number,
 manager_id number,
 salary number);
 
insert all
when sal < 5000 then
into special_sal(employee_id, salary) values (empid, sal)
else
into sal_history(employee_id, hire_date, salary) values (empid, hiredate, sal)
into mgr_history(employee_id, manager_id, salary) values (empid, mgrid, sal)
select employee_id as empid, salary as sal, hire_date as hiredate, manager_id as mgrid from employees;
 
select * from special_sal;
select * from sal_history;
select * from mgr_history;

--�ٸ� ��
insert first
when sal < 5000 then
into special_sal(employee_id, salary) values (empid, sal)
else
into sal_history(employee_id, hire_date, salary) values(empid, hiredate, sal)
into mgr_history(employee_id, manager_id, salary) values(empid, mgrid, sal)
select employee_id as empid, salary as sal, hire_date as hiredate, manager_id as mgrid from employees;

--���� 107 emp.csv ������ �����͸� �м��Ϸ��� �Ѵ�. external table�� �����ϼ���.
--���� Ȯ��
select * from user_tab_privs where table_name = 'DATA_DIR';
select * from all_directories where directory_name = 'DATA_DIR';

-- external table�� dml��� �Ұ�(�б� ����) / index ����
create table empxt
(id number,
 name varchar2(30),
 hire_date date,
 job_id varchar2(20),
 department_id number)
 organization external
 (type oracle_loader
  default directory data_dir
  access parameters
   (records delimited by newline -- ������ ���� ������ ���� �ƴ϶� ���ο� ���� ����.
    badfile 'empxt.bad'
    logfile 'empxt.log'
    fields terminated by ',' -- �ʵ� ������
    missing field values are null -- �� ���� ��ü�Ͽ� null �Է�
     (id, name, hire_date char date_format date mask "YYYYMMDD", job_id, department_id))
  location('emp.csv'))
reject limit unlimited; --���� ��� / ���� �ʼ���

-- �ּ��� �޷������� ���� �� ���� �߻�
create table empxt
(id number,
 name varchar2(30),
 hire_date date,
 job_id varchar2(20),
 department_id number)
 organization external
 (type oracle_loader
  default directory data_dir
  access parameters
   (records delimited by newline
    badfile 'empxt.bad'
    logfile 'empxt.log'
    fields terminated by ','
    missing field values are null
     (id, name, hire_date char date_format date mask "YYYYMMDD", job_id, department_id))
  location('emp.csv'))
reject limit unlimited;

select * from empxt;

-- ���� 108 �μ��̸��� �Ѿױ޿�, ��ձ޿�, �ְ�޿�, �����޿��� ����ϴ� query���� �ۼ��� ��, dept_sal_vw view�� �����ϼ���.
create or replace view dept_sal_vw
as select d.department_name, sum(e.salary) as sumsal, avg(e.salary) as avgsal, max(e.salary) as maxsal, min(e.salary) as minsal from employees e join departments d on e.department_id = d.department_id group by d.department_name;

create or replace view dept_sal_vw
as select d.department_name, e.sumsal, e.avgsal, e.maxsal, e.minsal from departments d join (select department_id, sum(salary) as sumsal, avg(salary) as avgsal, max(salary) as maxsal, min(salary) as minsal from employees group by department_id) e on d.department_id = e.department_id;

select * from dept_sal_vw;





--view
-- �ϳ� �̻��� ���̺� �ִ� �����͸� �������� ó���ϴ� ������Ʈ
-- select ���� ������ �ִ�

create table dept_20
as select * from employees where department_id = 20;

create table dept_30
as select * from employees where department_id = 30;

create view dept_v20
as select * from employees where department_id = 20;

create view dept_v30
as select * from employees where department_id = 30;

select * from dept_v20;
select * from dept_v30;

create view emp_vw
as select employee_id, last_name, department_id
from employees;

select * from emp_vw;

--���Ѻο�
grant select on hr.emp_vw to ora10;

--viewȮ��
select * from user_views where view_name = 'EMP_VW';

--objectȮ��
select * from user_objects where object_name = 'EMP_VW';

--view�� ������ �Ұ� -> drop �� create�ؾ���
-- �� ������ ���ִ� ���� or replace (������ �� drop�� create)
create or replace view emp_vw
as select employee_id, last_name || first_name as name from employees; --�÷��� �̸��� �� �� ���� �÷��� ���� �� ��Ī�� �����־�� ��

select * from emp_vw;

drop table emp_new purge;

--�ܼ� view
create table emp_new
as select employee_id, last_name, salary, department_id
from employees
where department_id = 20;

select * from emp_new;

drop view emp_vw;

create view emp_vw
as select * from emp_new;

desc emp_vw;

--�ܼ� view�� dml�� ���� ���� ������ ���� ����
update emp_vw
set department_id = 200;

select * from emp_vw;
select * from emp_new;
rollback;

delete from emp_vw;

select * from emp_vw;
select * from emp_new;
rollback;

insert into emp_vw(employee_id, last_name, salary, department_id)
values(1, 'james', 1000, 10);

select * from emp_vw;
select * from emp_new;
-- view�� �����ϴ� ���̺��� �������ǵ� �״�� ������
desc emp_vw;

insert into emp_vw(employee_id, last_name, salary, department_id)
values(2, null, 2000, 20);

rollback;

create or replace view emp_vw
as select employee_id, salary * 12 as sal, department_id
from emp_new;

-- view�� �������� �ʴ� �÷��� update �Ұ���
update emp_vw
set last_name = 'james';

-- not null���������� �ִ� �÷��� null�� �ְԵǸ� insert �Ұ���
insert into emp_vw(employee_id, salary, department_id)
values(3, 2000, 10);

-- ǥ������ �Ϻ��� �÷����� ������ �Ұ����ϴ�
create or replace view emp_vw
as select employee_id, salary * 12 as sal, department_id
from emp_new;

--view�� ���� �� check ���� ������ �� �� �ִ�
--where���� check ���������� ���ǽ��� �ȴ�
create or replace view empvu20
as select *
from employees
where department_id = 20
with check option constraint empvu20_ck;

select * from empvu20;

select * from user_constraints where table_name = 'EMPVU20';

update empvu20
set department_id = 30
where employee_id = 201;

rollback;

--�б� ���� �� ����
create or replace view empvu20
as select *
from employees
where department_id = 20
with read only;

delete empvu20;
update empvu20
set department_id = 30;

--���պ�
-- �׷��Լ�, group by, join ���� ����ִ� ��
-- DML�� ��� �� �� ����( �� pl/sql trigger�� ����� ����)


select * from session_privs;

--sequence: �ڵ� �Ϸù�ȣ�� �����ϴ� ������Ʈ, create sequence �ý��� ���� �ʿ�
create table emp_seq
(id number,
 name varchar2(20),
 day timestamp default systimestamp);
 
 create sequence emp_id_seq
 increment by 1 -- default 1
 start with 1 -- default 1
 maxvalue 50 -- default 10**27
 minvalue 1 -- default -10**26
 cache 20
 nocycle; -- cycle or nocycle
 
 --cache���� �ֱ� ������ last_number�δ� ���� �� Ȯ�� �Ұ���
 select * from user_sequences where sequence_name = 'EMP_ID_SEQ';
 
 -- ���� ���� �ٲ㼭 ĳ�ð��� ����� �� last_number Ȯ�� ����
 alter sequence emp_id_seq
 maxvalue 100;
 
 
 insert into emp_seq(id, name, day)
 values(emp_id_seq.nextval, user, default);
 
 select * from emp_seq;
 
 -- ���� ������� ����� Ȯ��
 select emp_id_seq.currval from dual;
 
 -- sequence�� �ѹ���� ����
 rollback;
 
 