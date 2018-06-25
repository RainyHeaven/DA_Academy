-- [����113] emp ���̺��� ��� ������ �� �� ��ü row�� ��, ����� block��, �� ���� ��� byte ���� Ȯ�� ���ּ���.
drop table emp  purge;

create table emp as
select rownum emp_id, last_name, first_name, job_id, hire_date, salary, commission_pct, email, department_id
from employees, (select rownum emp_id from dual connect by level < = 100) -- 100���� emp_id ����
order by dbms_random.value;  -- �����͸� ������ ������ �Է�

-- ������� ����
exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);

-- ������� Ȯ��
select num_rows, blocks, avg_row_len from user_tables where table_name = 'EMP';

-- ��������� ������ Ȯ���ϴ� ���
select bytes, blocks, extents from user_segments where segment_name = 'EMP';
select extent_id, bytes, blocks from user_extents where segment_name = 'EMP';


/* [����114] hr ������ sql���� ���� �� �� ���� ������ �����ȹ ó���� ����� ���� Ȯ���ϱ����ؼ� 
dbms_xplan.display_cursor ����Ϸ��� �Ҷ� �ʿ��� ������ �ۼ��� �ּ���. */

grant select on v_$session to hr;
grant select on v_$sql to hr;
grant select on v_$sql_plan to hr;
grant select on v_$sql_plan_statistics to hr;
grant select on v_$sql_plan_statistics_all to hr;


-- [����115]�� ���������� Ʃ���ϱ� ���� Ʃ���� �ĸ�  �����ּ���.
select * from emp where emp_id = 100; 

-- Ʃ����
select /*+ gather_plan_statistics */ * from emp where emp_id = 100;
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  88qdck3u5mvqh, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ * from emp where emp_id = 100
 
Plan hash value: 3956160932
 
------------------------------------------------------------------------------------
| Id  | Operation         | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |      1 |        |      1 |00:00:00.01 |      84 |
|*  1 |  TABLE ACCESS FULL| EMP  |      1 |      1 |      1 |00:00:00.01 |      84 |
------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMP_ID"=100);
  
-- Ʃ��
-- index����
alter table emp add constraint emp_id_pk primary key(emp_id);

-- indexȮ��
select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic 
where ix.index_name = ic.index_name and ix.table_name = 'EMP';
  
-- ��� Ȯ��
select /*+ gather_plan_statistics */ * from emp where emp_id = 100;
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
 
SQL_ID  88qdck3u5mvqh, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ * from emp where emp_id = 100
 
Plan hash value: 1252232671
 
---------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |           |      1 |        |      1 |00:00:00.01 |       3 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP       |      1 |      1 |      1 |00:00:00.01 |       3 |
|*  2 |   INDEX UNIQUE SCAN         | EMP_ID_PK |      1 |      1 |      1 |00:00:00.01 |       2 |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMP_ID"=100);

-- [����116] �� ���������� Ʃ���ϱ� ���� Ʃ���� �ĸ�  �����ּ���.
sql> select count(*) from emp where last_name = 'King';

-- Ʃ�� ��
select /*+ gather_plan_statistics */ count(*) from emp where last_name = 'King';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  86z65hnkrghr2, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where last_name 
= 'King'
 
Plan hash value: 2083865914
 
-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      1 |00:00:00.01 |      84 |
|   1 |  SORT AGGREGATE    |      |      1 |      1 |      1 |00:00:00.01 |      84 |
|*  2 |   TABLE ACCESS FULL| EMP  |      1 |    105 |    200 |00:00:00.01 |      84 |
-------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("LAST_NAME"='King');
   
-- Ʃ��
create index emp_last_idx on emp(last_name);

-- index Ȯ��
select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic
where ix.index_name = ic.index_name and ix.table_name = 'EMP';

-- ��� Ȯ��
-- *group ���� �Լ��� ���� �� sort aggregate operation�� ����(���� sort�� �� ���� �ƴ�, sort�۵��� �޸� ��뷮�� ǥ���)
select /*+ gather_plan_statistics */ count(*) from emp where last_name = 'King';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  86z65hnkrghr2, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where last_name 
= 'King'
 
Plan hash value: 3683339819
 
--------------------------------------------------------------------------------------------
| Id  | Operation         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |      1 |        |      1 |00:00:00.01 |       3 |
|   1 |  SORT AGGREGATE   |              |      1 |      1 |      1 |00:00:00.01 |       3 |
|*  2 |   INDEX RANGE SCAN| EMP_LAST_IDX |      1 |    105 |    200 |00:00:00.01 |       3 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("LAST_NAME"='King');
   
-- [����117] �� ���������� Ʃ���ϱ� ���� Ʃ���� �ĸ�  �����ּ���.
select count(*) from emp where last_name = 'King' and first_name = 'Steven';

-- Ʃ�� ��
select /*+ gather_plan_statistics */ count(*) from emp where last_name = 'King' and first_name = 'Steven';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- ���
SQL_ID  7x1fvprxgs8gj, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where last_name 
= 'King' and first_name = 'Steven'
 
Plan hash value: 2083865914
 
-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      1 |00:00:00.01 |      84 |
|   1 |  SORT AGGREGATE    |      |      1 |      1 |      1 |00:00:00.01 |      84 |
|*  2 |   TABLE ACCESS FULL| EMP  |      1 |      1 |    100 |00:00:00.01 |      84 |
-------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(("LAST_NAME"='King' AND "FIRST_NAME"='Steven'));
   
-- Ʃ��
create index emp_last_first_idx on emp(last_name, first_name);

-- ��� Ȯ��
select /*+ gather_plan_statistics */ count(*) from emp where last_name = 'King' and first_name = 'Steven';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  7x1fvprxgs8gj, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where last_name 
= 'King' and first_name = 'Steven'
 
Plan hash value: 2071372003
 
--------------------------------------------------------------------------------------------------
| Id  | Operation         | Name               | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                    |      1 |        |      1 |00:00:00.01 |       3 |
|   1 |  SORT AGGREGATE   |                    |      1 |      1 |      1 |00:00:00.01 |       3 |
|*  2 |   INDEX RANGE SCAN| EMP_LAST_FIRST_IDX |      1 |    100 |    100 |00:00:00.01 |       3 |
--------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("LAST_NAME"='King' AND "FIRST_NAME"='Steven');
   
-- [����118] emp ���̺� �ִ� ������ �߿� 2001�⵵ �Ի��� ������� �ο����� ��ȸ�ϴ� ���������� ����ð� ������ ������ �����ϼ���.
-- ������
select /*+ gather_plan_statistics */ count(*) from emp where to_char(hire_date, 'yyyy') = 2001;
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- ���Ȯ��
SQL_ID  2w293rjasahha, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where 
to_char(hire_date, 'yyyy') = 2001
 
Plan hash value: 2083865914
 
-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      1 |00:00:00.01 |      84 |
|   1 |  SORT AGGREGATE    |      |      1 |      1 |      1 |00:00:00.01 |      84 |
|*  2 |   TABLE ACCESS FULL| EMP  |      1 |    107 |    100 |00:00:00.01 |      84 |
-------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(TO_NUMBER(TO_CHAR(INTERNAL_FUNCTION("HIRE_DATE"),'yyyy'))=2001);
   
-- Ʃ��
create index emp_hire_idx on emp(hire_date);
   
-- Ȯ��
 select /*+ gather_plan_statistics */ count(*) from emp where to_char(hire_date, 'yyyy') = 2001;
 select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
   
   SQL_ID  2w293rjasahha, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where 
to_char(hire_date, 'yyyy') = 2001
 
Plan hash value: 1197236117
 
------------------------------------------------------------------------------------------------
| Id  | Operation             | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |              |      1 |        |      1 |00:00:00.01 |      34 |
|   1 |  SORT AGGREGATE       |              |      1 |      1 |      1 |00:00:00.01 |      34 |
|*  2 |   INDEX FAST FULL SCAN| EMP_HIRE_IDX |      1 |    107 |    100 |00:00:00.01 |      34 |
------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(TO_NUMBER(TO_CHAR(INTERNAL_FUNCTION("HIRE_DATE"),'yyyy'))=2001);
   
 -- Ʃ��
 select /*+ gather_plan_statistics */ count(*) from emp where hire_date between to_date('20010101', 'yyyymmdd') and to_date('20011231 23:59:59', 'yyyymmdd hh24:mi:ss');
   
 -- Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
SQL_ID  08t760mp3j576, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where hire_date 
between to_date('20010101', 'yyyymmdd') and to_date('20011231 
23:59:59', 'yyyymmdd hh24:mi:ss')
 
Plan hash value: 2664633226
 
--------------------------------------------------------------------------------------------
| Id  | Operation         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |      1 |        |      1 |00:00:00.01 |       2 |
|   1 |  SORT AGGREGATE   |              |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN| EMP_HIRE_IDX |      1 |   1532 |    100 |00:00:00.01 |       2 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("HIRE_DATE">=TO_DATE(' 2001-01-01 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss') AND "HIRE_DATE"<=TO_DATE(' 2001-12-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'));

/* [����119] emp ���̺� �ִ� ������ �߿� 2003�⵵ �Ի��� ����� �߿� 
10�� �μ� �ο����� ��ȸ�ϴ� ���������� ����ð� ������ ������ �����ϼ���. */
-- ��������
select /*+ gather_plan_statistics */ count(*) from emp where department_id = 10 and to_char(hire_date, 'yyyy') = 2003;

-- Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
SQL_ID  c9juby1p74g0w, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where 
department_id = 10 and to_char(hire_date, 'yyyy') = 2003
 
Plan hash value: 2083865914
 
-------------------------------------------------------------------------------------
| Id  | Operation          | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |      1 |        |      1 |00:00:00.01 |      84 |
|   1 |  SORT AGGREGATE    |      |      1 |      1 |      1 |00:00:00.01 |      84 |
|*  2 |   TABLE ACCESS FULL| EMP  |      1 |     10 |    100 |00:00:00.01 |      84 |
-------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(("DEPARTMENT_ID"=10 AND TO_NUMBER(TO_CHAR(INTERNAL_FUNCTION("HI
              RE_DATE"),'yyyy'))=2003));

-- Ʃ��
create index emp_dept_hire_idx on emp(department_id, hire_date);
select /*+ gather_plan_statistics */ count(*) from emp where department_id = 10 and hire_date between to_date('20030101', 'yyyymmdd') and to_date('20031231', 'yyyymmdd');

-- Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  7wcp52bq64qb5, child number 1
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where 
department_id = 10 and hire_date between to_date('20030101', 
'yyyymmdd') and to_date('20031231', 'yyyymmdd')
 
Plan hash value: 2210979594
 
----------------------------------------------------------------------------------------------------------
| Id  | Operation         | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                   |      1 |        |      1 |00:00:00.01 |       2 |      4 |
|   1 |  SORT AGGREGATE   |                   |      1 |      1 |      1 |00:00:00.01 |       2 |      4 |
|*  2 |   INDEX RANGE SCAN| EMP_DEPT_HIRE_IDX |      1 |    152 |    100 |00:00:00.01 |       2 |      4 |
----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("DEPARTMENT_ID"=10 and "HIRE_DATE">=to_date(' 2003-01-01 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss') AND "HIRE_DATE"<=TO_DATE(' 2003-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss'));
 
-- [����120] �Ʒ� ���������� ����118������ ���� �ε����� ����Ҷ���  ����119���� ���� �ε����� ����Ҷ��� ���ϼ���.
select count(*) from emp where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- 118�� �ε��� ���
select /*+ index(e emp_hire_idx) gather_plan_statistics */count(*) from emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
SQL_ID  91cq60xhsbmrm, child number 0
-------------------------------------
select /*+ index(e emp_hire_idx) gather_plan_statistics */count(*) from 
emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and 
hire_date < to_date('2002-01-01','yyyy-mm-dd')
 
Plan hash value: 2664633226
 
--------------------------------------------------------------------------------------------
| Id  | Operation         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |      1 |        |      1 |00:00:00.01 |       2 |
|   1 |  SORT AGGREGATE   |              |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  2 |   INDEX RANGE SCAN| EMP_HIRE_IDX |      1 |   1423 |    100 |00:00:00.01 |       2 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("HIRE_DATE">=TO_DATE(' 2001-01-01 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss') AND "HIRE_DATE"<TO_DATE(' 2002-01-01 00:00:00', 'syyyy-mm-dd 
              hh24:mi:ss'));

-- 119�� �ε��� ���
select /*+ index(e emp_dept_hire_idx) gather_plan_statistics */count(*) from emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
SQL_ID  gnk1h7npttywd, child number 0
-------------------------------------
select /*+ index(e emp_dept_hire_idx) gather_plan_statistics */count(*) 
from emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and 
hire_date < to_date('2002-01-01','yyyy-mm-dd')
 
Plan hash value: 4120062356
 
------------------------------------------------------------------------------------------------
| Id  | Operation        | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |                   |      1 |        |      1 |00:00:00.01 |      10 |
|   1 |  SORT AGGREGATE  |                   |      1 |      1 |      1 |00:00:00.01 |      10 |
|*  2 |   INDEX SKIP SCAN| EMP_DEPT_HIRE_IDX |      1 |   1423 |    100 |00:00:00.01 |      10 |
------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("HIRE_DATE">=TO_DATE(' 2001-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
              AND "HIRE_DATE"<TO_DATE(' 2002-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("HIRE_DATE"<TO_DATE(' 2002-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss') 
              AND "HIRE_DATE">=TO_DATE(' 2001-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss')));

-- [����121] ���������� Ȯ���Ͻð� Ʃ���ϼ���.
select /*+ gather_plan_statistics */ count(*) from emp where substr(last_name,1,2) = 'Ba';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  5nbvsbgw8vr13, child number 1
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where 
substr(last_name,1,2) = 'Ba'
 
Plan hash value: 2621427937
 
------------------------------------------------------------------------------------------------
| Id  | Operation             | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |              |      1 |        |      1 |00:00:00.01 |      32 |
|   1 |  SORT AGGREGATE       |              |      1 |      1 |      1 |00:00:00.01 |      32 |
|*  2 |   INDEX FAST FULL SCAN| EMP_LAST_IDX |      1 |    107 |    400 |00:00:00.01 |      32 |
------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(substr("LAST_NAME",1,2)='Ba');

-- Ʃ��
select /*+ gather_plan_statistics */ count(*) from emp where last_name like 'Ba%';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

SQL_ID  9cczzv7pp4kzx, child number 0
-------------------------------------
select /*+ gather_plan_statistics */ count(*) from emp where last_name 
like 'Ba%'
 
Plan hash value: 3683339819
 
--------------------------------------------------------------------------------------------
| Id  | Operation         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |              |      1 |        |      1 |00:00:00.01 |       3 |
|   1 |  SORT AGGREGATE   |              |      1 |      1 |      1 |00:00:00.01 |       3 |
|*  2 |   INDEX RANGE SCAN| EMP_LAST_IDX |      1 |    107 |    400 |00:00:00.01 |       3 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("LAST_NAME" like 'Ba%')
       filter("LAST_NAME" LIKE 'Ba%');




-- �Լ���� �ε���
-- ������ ǰ���� ���� ������ ��� ex) ��ҹ��� ������ �ȵǾ� ������
select /*+ gather_plan_statistics */ count(*) from emp where lower(last_name) = 'king';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- �Լ���� �ε��� ����
create index emp_lower_name_idx on emp(lower(last_name));

-- �ε����� �ɸ� �Լ� Ȯ��
select * from user_ind_expressions;

select * from user_indexes;
select * from user_ind_columns;

-- clustering factor�� �����ϱ� ���ؼ��� CTAS�� ����Ѵ�
create table c_table as select * from all_objects order by object_id;

create index c_obj_idx on c_table(object_id);

create index c_obj_name_idx on c_table(object_name);

exec dbms_stats.gather_table_stats('hr', 'c_table');

select num_rows, blocks from user_tables where table_name = 'C_TABLE';

select index_name, leaf_blocks, clustering_factor from user_indexes where table_name = 'C_TABLE';

-- c_obj_idx �ε����� ��� ź ����� buffer���� �ش� �ε����� clustering factor���� �����ϴ�
select /*+ gather_plan_statistics index(c c_obj_idx) */ count(*) from c_table c where object_id >= 0 and object_name >= ' ';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- c_obj_name_idx �ε����� ��� ź ����� buffer���� �ش� �ε����� clustering factor���� �����ϴ�
select /*+ gather_plan_statistics index(c c_obj_name_idx) */ count(*) from c_table c where object_id >= 0 and object_name >= ' ';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

create table n_table as select * from all_objects order by object_name;

create index n_obj_idx on n_table(object_id);
create index n_obj_name_idx on n_table(object_name);

select index_name, leaf_blocks, clustering_factor from user_indexes where table_name = 'N_TABLE';