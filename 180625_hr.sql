-- [문제113] emp 테이블의 통계 수집을 한 후 전체 row의 수, 사용한 block수, 한 행의 평균 byte 값을 확인 해주세요.
drop table emp  purge;

create table emp as
select rownum emp_id, last_name, first_name, job_id, hire_date, salary, commission_pct, email, department_id
from employees, (select rownum emp_id from dual connect by level < = 100) -- 100개의 emp_id 생성
order by dbms_random.value;  -- 데이터를 랜덤한 순서로 입력

-- 통계정보 수집
exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);

-- 통계정보 확인
select num_rows, blocks, avg_row_len from user_tables where table_name = 'EMP';

-- 통계정보가 없을때 확인하는 방법
select bytes, blocks, extents from user_segments where segment_name = 'EMP';
select extent_id, bytes, blocks from user_extents where segment_name = 'EMP';


/* [문제114] hr 유저는 sql문을 수행 한 후 실제 수행한 실행계획 처리한 블록의 수를 확인하기위해서 
dbms_xplan.display_cursor 사용하려고 할때 필요한 권한은 작성해 주세요. */

grant select on v_$session to hr;
grant select on v_$sql to hr;
grant select on v_$sql_plan to hr;
grant select on v_$sql_plan_statistics to hr;
grant select on v_$sql_plan_statistics_all to hr;


-- [문제115]이 쿼리문장을 튜닝하기 전과 튜닝한 후를  비교해주세요.
select * from emp where emp_id = 100; 

-- 튜닝전
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
  
-- 튜닝
-- index생성
alter table emp add constraint emp_id_pk primary key(emp_id);

-- index확인
select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic 
where ix.index_name = ic.index_name and ix.table_name = 'EMP';
  
-- 결과 확인
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

-- [문제116] 이 쿼리문장을 튜닝하기 전과 튜닝한 후를  비교해주세요.
sql> select count(*) from emp where last_name = 'King';

-- 튜닝 전
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
   
-- 튜닝
create index emp_last_idx on emp(last_name);

-- index 확인
select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic
where ix.index_name = ic.index_name and ix.table_name = 'EMP';

-- 결과 확인
-- *group 관련 함수가 사용될 시 sort aggregate operation이 등장(실제 sort가 된 것이 아님, sort작동시 메모리 사용량이 표기됨)
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
   
-- [문제117] 이 쿼리문장을 튜닝하기 전과 튜닝한 후를  비교해주세요.
select count(*) from emp where last_name = 'King' and first_name = 'Steven';

-- 튜닝 전
select /*+ gather_plan_statistics */ count(*) from emp where last_name = 'King' and first_name = 'Steven';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- 결과
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
   
-- 튜닝
create index emp_last_first_idx on emp(last_name, first_name);

-- 결과 확인
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
   
-- [문제118] emp 테이블에 있는 데이터 중에 2001년도 입사한 사원들의 인원수를 조회하는 쿼리문장을 만드시고 성능이 나도록 구성하세요.
-- 쿼리문
select /*+ gather_plan_statistics */ count(*) from emp where to_char(hire_date, 'yyyy') = 2001;
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- 결과확인
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
   
-- 튜닝
create index emp_hire_idx on emp(hire_date);
   
-- 확인
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
   
 -- 튜닝
 select /*+ gather_plan_statistics */ count(*) from emp where hire_date between to_date('20010101', 'yyyymmdd') and to_date('20011231 23:59:59', 'yyyymmdd hh24:mi:ss');
   
 -- 확인
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

/* [문제119] emp 테이블에 있는 데이터 중에 2003년도 입사한 사원들 중에 
10번 부서 인원수를 조회하는 쿼리문장을 만드시고 성능이 나도록 구성하세요. */
-- 쿼리문장
select /*+ gather_plan_statistics */ count(*) from emp where department_id = 10 and to_char(hire_date, 'yyyy') = 2003;

-- 확인
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

-- 튜닝
create index emp_dept_hire_idx on emp(department_id, hire_date);
select /*+ gather_plan_statistics */ count(*) from emp where department_id = 10 and hire_date between to_date('20030101', 'yyyymmdd') and to_date('20031231', 'yyyymmdd');

-- 확인
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
 
-- [문제120] 아래 쿼리문장을 문제118번에서 만든 인덱스를 사용할때와  문제119번에 만든 인덱스를 사용할때를 비교하세요.
select count(*) from emp where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- 118번 인덱스 사용
select /*+ index(e emp_hire_idx) gather_plan_statistics */count(*) from emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- 확인
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

-- 119번 인덱스 사용
select /*+ index(e emp_dept_hire_idx) gather_plan_statistics */count(*) from emp e where hire_date >= to_date('2001-01-01','yyyy-mm-dd') and hire_date < to_date('2002-01-01','yyyy-mm-dd');

-- 확인
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

-- [문제121] 쿼리문장을 확인하시고 튜닝하세요.
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

-- 튜닝
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




-- 함수기반 인덱스
-- 데이터 품질이 좋지 않을때 사용 ex) 대소문자 구분이 안되어 있을때
select /*+ gather_plan_statistics */ count(*) from emp where lower(last_name) = 'king';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- 함수기반 인덱스 생성
create index emp_lower_name_idx on emp(lower(last_name));

-- 인덱스에 걸린 함수 확인
select * from user_ind_expressions;

select * from user_indexes;
select * from user_ind_columns;

-- clustering factor를 개선하기 위해서는 CTAS를 사용한다
create table c_table as select * from all_objects order by object_id;

create index c_obj_idx on c_table(object_id);

create index c_obj_name_idx on c_table(object_name);

exec dbms_stats.gather_table_stats('hr', 'c_table');

select num_rows, blocks from user_tables where table_name = 'C_TABLE';

select index_name, leaf_blocks, clustering_factor from user_indexes where table_name = 'C_TABLE';

-- c_obj_idx 인덱스를 모두 탄 결과의 buffer값이 해당 인덱스의 clustering factor값과 동일하다
select /*+ gather_plan_statistics index(c c_obj_idx) */ count(*) from c_table c where object_id >= 0 and object_name >= ' ';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- c_obj_name_idx 인덱스를 모두 탄 결과의 buffer값이 해당 인덱스의 clustering factor값과 동일하다
select /*+ gather_plan_statistics index(c c_obj_name_idx) */ count(*) from c_table c where object_id >= 0 and object_name >= ' ';
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

create table n_table as select * from all_objects order by object_name;

create index n_obj_idx on n_table(object_id);
create index n_obj_name_idx on n_table(object_name);

select index_name, leaf_blocks, clustering_factor from user_indexes where table_name = 'N_TABLE';