drop table emp purge;
create table emp as select * from employees;

drop table dept purge;
create table dept as select * from departments;

create table loc as select * from locations;

-- [문제122] 테이블 통계 수집을 하시고 컬럼 정보를 확인 하세요.
-- 통계정보 수집
exec dbms_stats.gather_table_stats('hr', 'emp');
exec dbms_stats.gather_table_stats('hr', 'dept');
exec dbms_stats.gather_table_stats('hr', 'loc');

-- 통계정보 확인
select table_name, num_rows, blocks, avg_row_len, last_analyzed from user_tables where table_name in('EMP','DEPT','LOC');

/*
TABLE_NAME                                                     NUM_ROWS     BLOCKS AVG_ROW_LEN LAST_ANA
------------------------------------------------------------ ---------- ---------- ----------- --------
DEPT                                                                 27          4          21 18/06/27
EMP                                                                 107          5          69 18/06/27
loc                                                                  23          4          49 18/06/27
*/


-- [문제123] SQL문장의 실행계획을 확인 한 후 nested loop join 으로 튜닝하세요.
-- 실행계획 확인
alter session set statistics_level = all;

select e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and e.employee_id = 100;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
-------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |      |      1 |        |      1 |00:00:00.01 |       7 |       |       |          |
|*  1 |  HASH JOIN            |      |      1 |      1 |      1 |00:00:00.01 |       7 |   927K|   927K| 1271K (0)|
|   2 |   MERGE JOIN CARTESIAN|      |      1 |     23 |     23 |00:00:00.01 |       5 |       |       |          |
|*  3 |    TABLE ACCESS FULL  | EMP  |      1 |      1 |      1 |00:00:00.01 |       3 |       |       |          |
|   4 |    BUFFER SORT        |      |      1 |     23 |     23 |00:00:00.01 |       2 |  2048 |  2048 | 2048  (0)|
|   5 |     TABLE ACCESS FULL | LOC  |      1 |     23 |     23 |00:00:00.01 |       2 |       |       |          |
|   6 |   TABLE ACCESS FULL   | DEPT |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
-------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID" AND "D"."LOCATION_ID"="L"."LOCATION_ID")
   3 - filter("E"."EMPLOYEE_ID"=100)
*/

select * from user_indexes where table_name in ('EMP', 'DEPT', 'LOC');

-- 문제확인: employee_id가 filter로 풀림 / table full scan
-- 튜닝: e.employee_id, d.department_id, l.location_id에 pk를 걸고 emp를 outer로 nl join
alter table emp add constraint emp_id_pk primary key(employee_id);
alter table dept add constraint dept_deptid_pk primary key(department_id);
alter table loc add constraint loc_locid_pk primary key(location_id);

-- 제약조건 확인
select a.constraint_name, b.column_name, a.constraint_type, a.search_condition, a.r_constraint_name, a.index_name
from user_constraints a, user_cons_columns b
where a.constraint_name = b.constraint_name
and a.table_name = 'EMP';

-- 인덱스 확인
select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic 
where ix.index_name = ic.index_name and ix.table_name = 'EMP';

select /*+ leading(e, d, l) use_nl(d) use_nl(l) */ e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and e.employee_id = 100;

-- 확인
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
----------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                |      1 |        |      1 |00:00:00.01 |       6 |
|   1 |  NESTED LOOPS                 |                |      1 |      1 |      1 |00:00:00.01 |       6 |
|   2 |   NESTED LOOPS                |                |      1 |      1 |      1 |00:00:00.01 |       4 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP            |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  4 |     INDEX UNIQUE SCAN         | EMP_ID_PK      |      1 |      1 |      1 |00:00:00.01 |       1 |
|   5 |    TABLE ACCESS BY INDEX ROWID| DEPT           |      1 |     27 |      1 |00:00:00.01 |       2 |
|*  6 |     INDEX UNIQUE SCAN         | DEPT_DEPTID_PK |      1 |      1 |      1 |00:00:00.01 |       1 |
|   7 |   TABLE ACCESS BY INDEX ROWID | LOC            |      1 |     23 |      1 |00:00:00.01 |       2 |
|*  8 |    INDEX UNIQUE SCAN          | LOC_LOCID_PK   |      1 |      1 |      1 |00:00:00.01 |       1 |
----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E"."EMPLOYEE_ID"=100)
   6 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   8 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
  */
  
-- [문제124] SQL문장의 실행계획을 확인 한 후 NESTED LOOP JOIN으로 튜닝하세요.

-- 실행계획 확인
select e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'; 

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

/*
-----------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |      1 |        |     18 |00:00:00.01 |       7 |       |       |          |
|*  1 |  HASH JOIN                    |              |      1 |     15 |     18 |00:00:00.01 |       7 |   972K|   972K| 1241K (0)|
|   2 |   MERGE JOIN                  |              |      1 |      4 |     21 |00:00:00.01 |       4 |       |       |          |
|*  3 |    TABLE ACCESS BY INDEX ROWID| LOC          |      1 |      1 |      1 |00:00:00.01 |       2 |       |       |          |
|   4 |     INDEX FULL SCAN           | LOC_LOCID_PK |      1 |     23 |     23 |00:00:00.01 |       1 |       |       |          |
|*  5 |    SORT JOIN                  |              |      1 |     27 |     21 |00:00:00.01 |       2 |  2048 |  2048 | 2048  (0)|
|   6 |     TABLE ACCESS FULL         | DEPT         |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
|   7 |   TABLE ACCESS FULL           | EMP          |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   3 - filter("L"."CITY"='Seattle')
   5 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
*/

-- 문제확인: l.city이 filter로 풀림
-- 튜닝: l.city, d.location_id, e.department_id 에 index를 걸고 loc를 outer로 nl join
create unique index loc_city_idx on loc(city);
create index dept_locid_idx on dept(location_id);
create index emp_deptid_idx on emp(department_id);

select /*+ leading(l, d, e) use_nl(d) use_nl(e) */ e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'; 

-- 확인
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                |      1 |        |     18 |00:00:00.01 |      10 |
|   1 |  NESTED LOOPS                  |                |      1 |        |     18 |00:00:00.01 |      10 |
|   2 |   NESTED LOOPS                 |                |      1 |     15 |     18 |00:00:00.01 |       7 |
|   3 |    NESTED LOOPS                |                |      1 |      4 |     21 |00:00:00.01 |       4 |
|   4 |     TABLE ACCESS BY INDEX ROWID| LOC            |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  5 |      INDEX UNIQUE SCAN         | LOC_CITY_IDX   |      1 |      1 |      1 |00:00:00.01 |       1 |
|   6 |     TABLE ACCESS BY INDEX ROWID| DEPT           |      1 |      4 |     21 |00:00:00.01 |       2 |
|*  7 |      INDEX RANGE SCAN          | DEPT_LOCID_IDX |      1 |      4 |     21 |00:00:00.01 |       1 |
|*  8 |    INDEX RANGE SCAN            | EMP_DEPTID_IDX |     21 |     10 |     18 |00:00:00.01 |       3 |
|   9 |   TABLE ACCESS BY INDEX ROWID  | EMP            |     18 |      4 |     18 |00:00:00.01 |       3 |
-----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("L"."CITY"='Seattle')
   7 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   8 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- [문제125] SQL문장의 실행계획을 확인 한 후 튜닝하세요.
-- 실행계획 확인
select  e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
and e.job_id = 'AD_VP';  

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                |      1 |        |      2 |00:00:00.01 |      10 |
|   1 |  NESTED LOOPS                  |                |      1 |        |      2 |00:00:00.01 |      10 |
|   2 |   NESTED LOOPS                 |                |      1 |      1 |     18 |00:00:00.01 |       7 |
|   3 |    NESTED LOOPS                |                |      1 |      4 |     21 |00:00:00.01 |       4 |
|   4 |     TABLE ACCESS BY INDEX ROWID| LOC            |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  5 |      INDEX UNIQUE SCAN         | LOC_CITY_IDX   |      1 |      1 |      1 |00:00:00.01 |       1 |
|   6 |     TABLE ACCESS BY INDEX ROWID| DEPT           |      1 |      4 |     21 |00:00:00.01 |       2 |
|*  7 |      INDEX RANGE SCAN          | DEPT_LOCID_IDX |      1 |      4 |     21 |00:00:00.01 |       1 |
|*  8 |    INDEX RANGE SCAN            | EMP_DEPTID_IDX |     21 |     10 |     18 |00:00:00.01 |       3 |
|*  9 |   TABLE ACCESS BY INDEX ROWID  | EMP            |     18 |      1 |      2 |00:00:00.01 |       3 |
-----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("L"."CITY"='Seattle')
   7 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   8 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   9 - filter("E"."JOB_ID"='AD_VP')
*/

-- 문제확인: e.job_id가 filter로 풀림
-- 건수확인
select count(*) from emp e, dept d where e.department_id = d.department_id and job_id = 'AD_VP'; -- 2건
select count(*) from loc l, dept d where d.location_id = l.location_id and l.city = 'Seattle'; -- 21건

-- e.job_id = 'AD_VP' 먼저 처리
create index emp_jobid_idx on emp(job_id);
alter table dept add constraint dept_deptid_pk primary key(department_id);
create index loc_id_city_idx on loc(location_id, city);

select ix.index_name, ix.uniqueness, ic.column_name from user_indexes ix, user_ind_columns ic 
where ix.index_name = ic.index_name and ix.table_name = 'LOC';

select  /*+ leading(e, d, l) use_nl(d) use_nl(l) */e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
and e.job_id = 'AD_VP';  

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                 |      1 |        |      2 |00:00:00.01 |       8 |
|   1 |  NESTED LOOPS                 |                 |      1 |      1 |      2 |00:00:00.01 |       8 |
|   2 |   NESTED LOOPS                |                 |      1 |      6 |      2 |00:00:00.01 |       6 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP             |      1 |      6 |      2 |00:00:00.01 |       2 |
|*  4 |     INDEX RANGE SCAN          | EMP_JOBID_IDX   |      1 |      6 |      2 |00:00:00.01 |       1 |
|   5 |    TABLE ACCESS BY INDEX ROWID| DEPT            |      2 |      1 |      2 |00:00:00.01 |       4 |
|*  6 |     INDEX UNIQUE SCAN         | DEPT_DEPTID_PK  |      2 |      1 |      2 |00:00:00.01 |       2 |
|*  7 |   INDEX RANGE SCAN            | LOC_ID_CITY_IDX |      2 |      1 |      2 |00:00:00.01 |       2 |
-----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E"."JOB_ID"='AD_VP')
   6 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   7 - access("D"."LOCATION_ID"="L"."LOCATION_ID" AND "L"."CITY"='Seattle')
*/


-- 사용 index 지정
select  /*+ leading(e, d, l) use_nl(d) use_nl_with_index(l loc_locid_pk) */e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
and e.job_id = 'AD_VP';  

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));


-- l.city = 'Seattle' 먼저 처리
create index emp_dept_jobid_idx on emp(department_id, job_id);

select  /*+ leading(l, d, e) use_nl(d) use_nl(e) */e.last_name, e.job_id, d.department_name, l.city
from emp e, dept d, loc l
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
and e.job_id = 'AD_VP';  

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
---------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name               | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                    |      1 |        |      2 |00:00:00.01 |       8 |
|   1 |  NESTED LOOPS                  |                    |      1 |        |      2 |00:00:00.01 |       8 |
|   2 |   NESTED LOOPS                 |                    |      1 |      1 |      2 |00:00:00.01 |       7 |
|   3 |    NESTED LOOPS                |                    |      1 |      4 |     21 |00:00:00.01 |       4 |
|   4 |     TABLE ACCESS BY INDEX ROWID| LOC                |      1 |      1 |      1 |00:00:00.01 |       2 |
|*  5 |      INDEX UNIQUE SCAN         | LOC_CITY_IDX       |      1 |      1 |      1 |00:00:00.01 |       1 |
|   6 |     TABLE ACCESS BY INDEX ROWID| DEPT               |      1 |      4 |     21 |00:00:00.01 |       2 |
|*  7 |      INDEX RANGE SCAN          | DEPT_LOCID_IDX     |      1 |      4 |     21 |00:00:00.01 |       1 |
|*  8 |    INDEX RANGE SCAN            | EMP_DEPT_JOBID_IDX |     21 |      5 |      2 |00:00:00.01 |       3 |
|   9 |   TABLE ACCESS BY INDEX ROWID  | EMP                |      2 |      1 |      2 |00:00:00.01 |       1 |
---------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("L"."CITY"='Seattle')
   7 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   8 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID" and "E"."JOB_ID"='AD_VP')
  */







-- sort merge join
select e.last_name, e.salary, d.department_name
from emp e, dept d
where e.department_id = d.department_id;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

/*
------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                |      1 |        |    106 |00:00:00.01 |      15 |       |       |          |
|   1 |  MERGE JOIN                  |                |      1 |    106 |    106 |00:00:00.01 |      15 |       |       |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT           |      1 |     27 |     27 |00:00:00.01 |      12 |       |       |          |
|   3 |    INDEX FULL SCAN           | DEPT_DEPTID_PK |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|*  4 |   SORT JOIN                  |                |     27 |    107 |    106 |00:00:00.01 |       3 | 15360 | 15360 |14336  (0)|
|   5 |    TABLE ACCESS FULL         | EMP            |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
------------------------------------------------------------------------------------------------------------------------------------


Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- 아래의 두 query를 merge
select last_name, salary, department_id
from emp
order by department_id;

select department_id, department_name
from dept
order by department_id;

-- first(driving) table을 바꾼경우 - buffer는 줄고 memory 사용량은 늘어남
select /*+ leading(e, d) use_merge(d) */ e.last_name, e.salary, d.department_name
from emp e, dept d
where e.department_id = d.department_id;
/*
-----------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |      |      1 |        |    106 |00:00:00.01 |       5 |       |       |          |
|   1 |  MERGE JOIN         |      |      1 |    106 |    106 |00:00:00.01 |       5 |       |       |          |
|   2 |   SORT JOIN         |      |      1 |    107 |    107 |00:00:00.01 |       3 | 15360 | 15360 |14336  (0)|
|   3 |    TABLE ACCESS FULL| EMP  |      1 |    107 |    107 |00:00:00.01 |       3 |       |       |          |
|*  4 |   SORT JOIN         |      |    107 |     27 |    106 |00:00:00.01 |       2 |  2048 |  2048 | 2048  (0)|
|   5 |    TABLE ACCESS FULL| DEPT |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
-----------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

select * from user_indexes where table_name = 'EMP';
create index emp_deptid_idx on emp(department_id);
       
select /*+ leading(e, d) use_merge(d) index(e emp_deptid_idx)  */ e.last_name, e.salary, d.department_name
from emp e, dept d
where e.department_id = d.department_id;
/*
------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                |      1 |        |    106 |00:00:00.01 |      25 |       |       |          |
|   1 |  MERGE JOIN                  |                |      1 |    106 |    106 |00:00:00.01 |      25 |       |       |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP            |      1 |    107 |    106 |00:00:00.01 |      23 |       |       |          |
|   3 |    INDEX FULL SCAN           | EMP_DEPTID_IDX |      1 |    106 |    106 |00:00:00.01 |       8 |       |       |          |
|*  4 |   SORT JOIN                  |                |    106 |     27 |    106 |00:00:00.01 |       2 |  2048 |  2048 | 2048  (0)|
|   5 |    TABLE ACCESS FULL         | DEPT           |      1 |     27 |     27 |00:00:00.01 |       2 |       |       |          |
------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

drop table emp_copy;

-- 대용량 테스트 테이블 생성
create table emp_copy
as select rownum emp_id, last_name, first_name, job_id, hire_date, salary, commission_pct, email, department_id
from employees, (select rownum emp_id from dual connect by level <= 100)
order by dbms_random.value;

-- 통계 수집
exec dbms_stats.gather_table_stats('hr', 'emp_copy');

-- 인덱스 생성
create index emp_copy_dept_idx on emp_copy(department_id);

select /*+ leading(d, e) use_merge(e) */ e.last_name, e.salary, d.department_name
from emp_copy e, dept d
where e.department_id = d.department_id;
/*
------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                |      1 |        |  10600 |00:00:00.01 |     108 |       |       |          |
|   1 |  MERGE JOIN                  |                |      1 |  10600 |  10600 |00:00:00.01 |     108 |       |       |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT           |      1 |     27 |     27 |00:00:00.01 |      24 |       |       |          |
|   3 |    INDEX FULL SCAN           | DEPT_DEPTID_PK |      1 |     27 |     27 |00:00:00.01 |      12 |       |       |          |
|*  4 |   SORT JOIN                  |                |     27 |  10700 |  10600 |00:00:00.01 |      84 |   407K|   407K|  361K (0)|
|   5 |    TABLE ACCESS FULL         | EMP_COPY       |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |       |          |
------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

select /*+ leading(e, d) use_merge(d) */ e.last_name, e.salary, d.department_name
from emp_copy e, dept d
where e.department_id = d.department_id;
/*
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name     | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |          |      1 |        |  10600 |00:00:00.02 |      86 |       |    |     |
|   1 |  MERGE JOIN         |          |      1 |  10600 |  10600 |00:00:00.02 |      86 |       |    |     |
|   2 |   SORT JOIN         |          |      1 |  10700 |  10601 |00:00:00.01 |      84 |   407K|   407K|  361K (0)|
|   3 |    TABLE ACCESS FULL| EMP_COPY |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |    |     |
|*  4 |   SORT JOIN         |          |  10601 |     27 |  10600 |00:00:00.01 |       2 |  2048 |  2048 | 2048  (0)|
|   5 |    TABLE ACCESS FULL| DEPT     |      1 |     27 |     27 |00:00:00.01 |       2 |       |    |     |
---------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")   
*/

