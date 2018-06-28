-- [문제126] SQL문장의 실행계획을 확인 한 후 sort merge join의 방법으로 튜닝하세요.
alter session set statistics_level = all;

select /*+ leading(l,d,e) use_nl(d) use_nl(e)  */ e.last_name, e.first_name, e.salary, e.job_id, d.department_name, l.city, l.street_address
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id = l.location_id;

-- 실행계획 확인
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
/*
--------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                   |      1 |        |    106 |00:00:00.01 |   54 |
|   1 |  NESTED LOOPS                  |                   |      1 |        |    106 |00:00:00.01 |   54 |
|   2 |   NESTED LOOPS                 |                   |      1 |    106 |    106 |00:00:00.01 |   41 |
|   3 |    NESTED LOOPS                |                   |      1 |     27 |     27 |00:00:00.01 |   27 |
|   4 |     TABLE ACCESS FULL          | LOCATIONS         |      1 |     23 |     23 |00:00:00.01 |   11 |
|   5 |     TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |     23 |      1 |     27 |00:00:00.01 |   16 |
|*  6 |      INDEX RANGE SCAN          | DEPT_LOCATION_IX  |     23 |      4 |     27 |00:00:00.01 |   11 |
|*  7 |    INDEX RANGE SCAN            | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |   14 |
|   8 |   TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |    106 |      4 |    106 |00:00:00.01 |   13 |
--------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   6 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   7 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
*/

-- 튜닝: sort merge join 으로 변경
-- lde순서로
select /*+ leading(l,d,e) use_merge(d) use_merge(e)  */ e.last_name, e.first_name, e.salary, e.job_id, d.department_name, l.city, l.street_address
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id = l.location_id;

-- 실행계획 확인
/*
---------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem |
---------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |             |      1 |        |    106 |00:00:00.02 |      14 |      9 |       |       |
|   1 |  MERGE JOIN                    |             |      1 |    106 |    106 |00:00:00.02 |      14 |      9 |       |       |
|   2 |   SORT JOIN                    |             |      1 |     27 |     27 |00:00:00.01 |       8 |      6 |  4096 |  4096 |
|   3 |    MERGE JOIN                  |             |      1 |     27 |     27 |00:00:00.01 |       8 |      6 |       |       |
|   4 |     TABLE ACCESS BY INDEX ROWID| LOCATIONS   |      1 |     23 |     19 |00:00:00.01 |       2 |      1 |       |       |
|   5 |      INDEX FULL SCAN           | LOC_ID_PK   |      1 |     23 |     19 |00:00:00.01 |       1 |      1 |       |       |
|*  6 |     SORT JOIN                  |             |     19 |     27 |     27 |00:00:00.01 |       6 |      5 |  2048 |  2048 |
|   7 |      TABLE ACCESS FULL         | DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |      5 |       |       |
|*  8 |   SORT JOIN                    |             |     27 |    107 |    106 |00:00:00.01 |       6 |      3 | 18432 | 18432 |
|   9 |    TABLE ACCESS FULL           | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |      3 |       |       |
---------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   6 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
   8 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
       filter("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
*/

-- 4번 단계에서 전체 row가 아닌 19개 row만 사용한 이유: 통계정보를 활용하여 departments의 범위를 벗어나는 row는 제외함
-- |   4 |     TABLE ACCESS BY INDEX ROWID| LOCATIONS   |      1 |     23 |     19 |00:00:00.01 |       2 |      1 |       |       |
select location_id from locations order by location_id;
select distinct l.location_id from locations l, departments d where l.location_id = d.location_id;

select * from user_tab_col_statistics where table_name = 'LOCATIONS';
select * from user_tab_col_statistics where table_name = 'DEPARTMENTS';


A: 4, 5번
select l.location_id, l.city, l.street_address
from locations l
order by l.location_id;

B: 6, 7번
select d.location_id, d.department_name, department_id
from departments d
order by d.location id;

C: 3번
select l.location_id, l.city, l.street_address, d.department_name, d.department_id
from locations l, departments d
where d.location_id = l.location_id;


D: C결과를 정렬, 2번
order by d.department_id;

E: 8, 9번
select e.department_id, e.last_name, e.first_name, e.salary, e.job_id
from employees
order by department_id;

F: D와 E를 merge, 1번

       
-- edl순서로 : 큰 테이블을 first로 두었을때 buffer, memory 모두 증가
select /*+ leading(e, d, l) use_merge(d) use_merge(l)  */ e.last_name, e.first_name, e.salary, e.job_id, d.department_name, l.city, l.street_address
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id = l.location_id;

-- 실행계획 확인
/*
--------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |             |      1 |        |    106 |00:00:00.01 |      18 |       |       |          |
|   1 |  MERGE JOIN           |             |      1 |    106 |    106 |00:00:00.01 |      18 |       |       |          |
|   2 |   SORT JOIN           |             |      1 |    106 |    106 |00:00:00.01 |      12 | 13312 | 13312 |12288  (0)|
|   3 |    MERGE JOIN         |             |      1 |    106 |    106 |00:00:00.01 |      12 |       |       |          |
|   4 |     SORT JOIN         |             |      1 |    107 |    107 |00:00:00.01 |       6 | 18432 | 18432 |16384  (0)|
|   5 |      TABLE ACCESS FULL| EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
|*  6 |     SORT JOIN         |             |    107 |     27 |    106 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   7 |      TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|*  8 |   SORT JOIN           |             |    106 |     23 |    106 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   9 |    TABLE ACCESS FULL  | LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   6 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
       filter("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
   8 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
*/





-- hash join
select /*+ leading(d, e) use_hash(e) */ d.department_name, e.last_name, e.salary, e.job_id
from emp_copy e, departments d
where e.department_id = d.department_id;

-- build table: 1족집합이면서 작은 table이 적
select department_id, department_name
from departments
order by department_id;

-- probe table
select department_id, employee_id, salary합
from employees
order by department_id;

/*+ leading(d, e) use_hash(e)
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |      1 |        |    106 |00:00:00.01 |      19 |       |    |             |
|*  1 |  HASH JOIN         |             |      1 |    106 |    106 |00:00:00.01 |      19 |  1079K|  1079K| 1252K (0)|
|   2 |   TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |    |             |
|   3 |   TABLE ACCESS FULL| EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |      13 |       |    |             |
-----------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")*/
   

/*+ leading(e, d) use_hash(d)
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |      1 |        |    106 |00:00:00.01 |      17 |       |    |             |
|*  1 |  HASH JOIN         |             |      1 |    106 |    106 |00:00:00.01 |      17 |   981K|   981K|  891K (0)|
|   2 |   TABLE ACCESS FULL| EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |    |             |
|   3 |   TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |      11 |       |    |             |
-----------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")*/
   

select /*+ leading(d, e) use_hash(e) */ e.emp_id, d.department_name, e.salary
from emp_copy e, departments d
where e.department_id = d.department_id;
/*
--------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |      1 |        |  10600 |00:00:00.09 |     790 |     82 |       |       |          |
|*  1 |  HASH JOIN         |             |      1 |  10600 |  10600 |00:00:00.09 |     790 |     82 |  1079K|  1079K| 1251K (0)|
|   2 |   TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |      0 |       |       |          |
|   3 |   TABLE ACCESS FULL| EMP_COPY    |      1 |  10700 |  10700 |00:00:00.07 |     784 |     82 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

select /*+ leading(e, d) use_hash(d) */ e.emp_id, d.department_name, e.salary
from emp_copy e, departments d
where e.department_id = d.department_id;
/*
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |             |      1 |        |  10600 |00:00:00.02 |     101 |       |    |             |
|*  1 |  HASH JOIN         |             |      1 |  10600 |  10600 |00:00:00.02 |     101 |  1252K|  1252K| 1599K (0)|
|   2 |   TABLE ACCESS FULL| EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |    |             |
|   3 |   TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |      17 |       |    |             |
-----------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

select num_rows, blocks, avg_row_len from user_tables where table_name = 'EMP_COPY';
select num_rows, blocks, avg_row_len from user_tables where table_name = 'DEPARTMENTS';
select * from emp_copy;

select * from user_extents where segment_name = 'EMP_COPY';
select * from user_extents where segment_name = 'DEPARTMENTS';

select /*+ leading(l, d, e) use_hash(d) use_hash(e) */ e.emp_id, e.salary, d.department_name, l.city, l.street_address
from emp_copy e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;

-- swap_join_inputs: build와 probe의 순서 교체
select /*+ leading(e, d, l) use_hash(d) use_hash(l) swap_join_inputs(l) */ e.emp_id, e.salary, d.department_name, l.city, l.street_address
from emp_copy e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;


select /*+ leading(l, d, e) use_hash(d) use_hash(e) */ e.emp_id,e.salary, d.department_name, l.city, l.street_address 
from emp_copy e,departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id;

/*
emp_copy
  NUM_ROWS     BLOCKS AVG_ROW_LEN
---------- ---------- -----------
     10700         89          50

arraysize = 1
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.06 |    5357 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.06 |    5357 |   865K|   865K| 1281K (0)|
|*  2 |   HASH JOIN         |             |      1 |     27 |     27 |00:00:00.01 |      12 |   909K|   909K| 1132K (0)|
|   3 |    TABLE ACCESS FULL| LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|   4 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL | EMP_COPY    |      1 |  10700 |  10700 |00:00:00.04 |    5345 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("D"."LOCATION_ID"="L"."LOCATION_ID")


arraysize = 125
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.01 |     181 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.01 |     181 |   865K|   865K| 1220K (0)|
|*  2 |   HASH JOIN         |             |      1 |     27 |     27 |00:00:00.01 |      12 |   909K|   909K| 1135K (0)|
|   3 |    TABLE ACCESS FULL| LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|   4 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL | EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |     169 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("D"."LOCATION_ID"="L"."LOCATION_ID")


arraysize = 1000
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.01 |     107 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.01 |     107 |   865K|   865K| 1258K (0)|
|*  2 |   HASH JOIN         |             |      1 |     27 |     27 |00:00:00.01 |      12 |   909K|   909K| 1144K (0)|
|   3 |    TABLE ACCESS FULL| LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|   4 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL | EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |      95 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
*/

select /*+ leading(e, d, l) use_hash(d) use_hash(l) */ e.emp_id,e.salary, d.department_name, l.city, l.street_address 
from emp_copy e,departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id;
/*
DEPARTMENTS
  NUM_ROWS     BLOCKS AVG_ROW_LEN
---------- ---------- -----------
        27          5          21

arraysize = 1
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.02 |     107 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.02 |     107 |   909K|   909K| 1099K (0)|
|   2 |   TABLE ACCESS FULL | LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|*  3 |   HASH JOIN         |             |      1 |  10600 |  10600 |00:00:00.01 |     101 |  1252K|  1252K| 1643K (0)|
|   4 |    TABLE ACCESS FULL| EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |       |          |
|   5 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |      17 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   3 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")


arraysize = 125
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.02 |     106 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.02 |     106 |   909K|   909K| 1125K (0)|
|   2 |   TABLE ACCESS FULL | LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|*  3 |   HASH JOIN         |             |      1 |  10600 |  10600 |00:00:00.01 |     100 |  1252K|  1252K| 1648K (0)|
|   4 |    TABLE ACCESS FULL| EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |       |          |
|   5 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |      16 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   3 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

select /*+ leading(e, d, l) use_hash(d) use_hash(l) no_swap_join_inputs(l) */ e.emp_id,e.salary, d.department_name, l.city, l.street_address 
from emp_copy e,departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id;

/*
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation           | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |             |      1 |        |  10600 |00:00:00.03 |     103 |       |       |          |
|*  1 |  HASH JOIN          |             |      1 |  10600 |  10600 |00:00:00.03 |     103 |  1264K|  1264K| 1396K (0)|
|*  2 |   HASH JOIN         |             |      1 |  10600 |  10600 |00:00:00.02 |      90 |  1252K|  1252K| 1632K (0)|
|   3 |    TABLE ACCESS FULL| EMP_COPY    |      1 |  10700 |  10700 |00:00:00.01 |      84 |       |       |          |
|   4 |    TABLE ACCESS FULL| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   5 |   TABLE ACCESS FULL | LOCATIONS   |      1 |     23 |     23 |00:00:00.01 |      13 |       |       |          |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   2 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- hash join은 full parallel 힌트를 사용하는게 좋음
select /*+ leading(e, d, l) use_hash(d) use_hash(l) full(e) parallel(e, 2) full(d) parallel(d, 2) full(l) parallel(l, 2) */ e.emp_id,e.salary, d.department_name, l.city, l.street_address 
from emp_copy e,departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id;
