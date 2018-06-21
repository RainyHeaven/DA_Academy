-- [����109] emp ���̺��� ������ �� ��������� Ȯ�� ���� �������� �ϼ���.
drop table emp purge;
create table emp
as select * from employees;

-- ������� Ȯ��
select *
from user_tables
where table_name = 'EMP';

-- ������� ���� no_invalidate �� invalidation�� ������� �ʰڴٴ� �ɼ�
exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);


-- [����110] select���� �����ȹ�� Ȯ�� �� �� filter�� access�� �ذ��� �ּ���.
select * from emp where employee_id = 100;

-- �����ȹ�� plan_table�� ����
explain plan for select * from emp where employee_id = 100;

-- dbms_stats�� Ȱ���Ͽ� �����ȹ�� �������� Ȯ��
select * from table(dbms_xplan.display(null, null, 'typical'));

-- employee_id�� index�� �ɾ�����
-- PK�����
alter table emp add constraint emp_id_pk primary key(employee_id);
-- ����
alter table emp drop constraint emp_id_pk;

-- unique index�����
create unique index emp_id_unq_idx on emp(employee_id);
-- ����
drop index emp_id_unq_idx;


-- [����111] select���� �����ȹ�� Ȯ�� �� �� filter�� access�� �ذ��� �ּ���.
select * from emp where department_id = 10;

-- �����ȹ�� ���̺� ����
explain plan for select * from emp where department_id = 10;

-- �����ȹ�� Ȯ��
select * from table(dbms_xplan.display(null, null, 'typical'));

-- �ߺ����� null���� �־� PK�� �Ұ�
-- index �����
create index emp_dpid_idx on emp(department_id);

select * from user_ind_columns where table_name = 'EMP';


-- [����112] select���� �����ȹ�� Ȯ�� �� �� filter�� access�� �ذ��� �ּ���.
select * from emp where last_name = 'King' and first_name = 'Steven';

-- �����ȹ ���̺� ����
explain plan for select * from emp where last_name = 'King' and first_name = 'Steven';

-- xplan ���� Ȯ��
select * from table(dbms_xplan.display(null, null, 'typical'));

-- composite index ����
create index emp_lname_fname_idx on emp(last_name, first_name);




select * from user_tables;

select * from user_ind_columns where table_name = 'EMP';