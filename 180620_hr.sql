drop table emp purge;

create table emp
as select * from employees;

select * from emp where employee_id = 100;

--�ڽ��� ���̺� ���� ������� Ȯ��
select num_rows, blocks, avg_row_len
from user_tables
where table_name = 'EMP';

select * from user_tab_privs;

exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);

drop table emp purge;

select * from emp where employee_id = 100;

create index emp_id_idx
on emp(employee_id);

-- �÷����̺� Ȯ��
select *
from all_synonyms
where synonym_name = 'PLAN_TABLE';

explain plan for select * from emp where employee_id = 100;

-- �����ȹ Ȯ��
select * from plan_table;

-- �����ȹ Ȯ�� (dbms_xplan�� Ȱ���Ͽ� ���� ���� Ȯ��)
-- �μ������� �ִ� id������ �� �� �����Ƿ� null�� �־� ���������� plan_table�� ��� ���� ���
select * from table(dbms_xplan.display(null, null, 'typical'));

select * from table(dbms_xplan.display(null, null, 'basic'));

drop index emp_id_idx;

-- �ѹ��� �д� block�� �� ���� (�ڽ��� ���ǿ��� ����)
alter session set db_file_multiblock_read_count = 128;

-- Ǯ ��ĵ�� �ϵ��� �ϴ� ��Ʈ /*+full(���̺��or��Ī)*/
select /*+full(e)*/* from emp e;

-- parallel(): ���μ����� ������ ����� ã�� ���
-- data buffer cache�� ������ �ʰ� �ٷ� cursor�� direct read
select /*+full(e) parallel(e,2)*/employee_id, last_name from emp e;

select rowid, employee_id from emp;

select * from emp where rowid = 'AAAFADAAEAAAAHLAAE';

-- index unique scan
-- �÷��� ����ũ �ε����� �����Ǿ� �ְ�
-- �񱳿����ڷ� = �� ���� ��

--�ε����� �ɷ��ִ� �÷� Ȯ��
select * from user_ind_columns where table_name = 'EMP';

alter table emp add constraint emp_id_new_pk primary key(employee_id);

-- �ε��� ���� Ȯ��
select * from user_indexes where table_name = 'EMP';

explain plan for select * from emp where employee_id <= 100;

-- full table scan
explain plan for select * from emp where employee_id >= 100;

-- index range scan
explain plan for select employee_id, last_name from emp where employee_id >= 100;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- index range scan
-- index leaf block ���� �ʿ��� ������ ��ĵ�ϴ� ���
create index emp_dept_idx
on emp(department_id);

select * from user_ind_columns where table_name = 'EMP';
select * from user_indexes where table_name = 'EMP';


explain plan for select * from emp where department_id = 10;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- inlist iterator
-- index�� root, branch, leaf�� �ݺ��� �� 
explain plan for 
select * from emp where employee_id in (100, 200);

select * from table(dbms_xplan.display(null, null, 'typical'));

-- in, or �����ڴ� set operator�� ������
select * from emp where employee_id = 100
union all
select * from emp where employee_id = 200;

-- ���ϴ� ���� ���̿� �ٸ� ������ ���ٸ� between�����ڸ� ����ϴ� ���� ���� 
-- index range scan�� ��
explain plan for
select *
from emp
where employee_id between 100 and 102;

