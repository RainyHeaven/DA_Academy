-- [문제127] SQL문장의 실행계획을 nested loop join, sort merge join, hash join 방법으로 비교하세요.

select e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id; 

--기본 실행계획
/*
--------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                  |      1 |        |    106 |00:00:00.03 |   31 |        21 |       |       |          |
|*  1 |  HASH JOIN                      |                  |      1 |    106 |    106 |00:00:00.03 |   31 |        21 |   792K|   792K| 1274K (0)|
|*  2 |   HASH JOIN                     |                  |      1 |     27 |     27 |00:00:00.02 |   18 |        15 |   799K|   799K|  549K (0)|
|   3 |    NESTED LOOPS                 |                  |      1 |     27 |     27 |00:00:00.02 |   12 |         9 |       |       |          |
|   4 |     MERGE JOIN                  |                  |      1 |     27 |     27 |00:00:00.02 |    8 |         8 |       |       |          |
|   5 |      TABLE ACCESS BY INDEX ROWID| DEPARTMENTS      |      1 |     27 |     27 |00:00:00.01 |    2 |         2 |       |       |          |
|   6 |       INDEX FULL SCAN           | DEPT_LOCATION_IX |      1 |     27 |     27 |00:00:00.01 |    1 |         1 |       |       |          |
|*  7 |      SORT JOIN                  |                  |     27 |     23 |     27 |00:00:00.01 |    6 |         6 |  2048 |  2048 | 2048  (0)|
|   8 |       TABLE ACCESS FULL         | LOCATIONS        |      1 |     23 |     23 |00:00:00.01 |    6 |         6 |       |       |          |
|*  9 |     INDEX UNIQUE SCAN           | COUNTRY_C_ID_PK  |     27 |      1 |     27 |00:00:00.01 |    4 |         1 |       |       |          |
|  10 |    TABLE ACCESS FULL            | REGIONS          |      1 |      4 |      4 |00:00:00.01 |    6 |         6 |       |       |          |
|  11 |   TABLE ACCESS FULL             | EMPLOYEES        |      1 |    107 |    107 |00:00:00.01 |   13 |         6 |       |       |          |
--------------------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("R"."REGION_ID"="C"."REGION_ID")
   7 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
   9 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
*/


-- nested loop join 순서: employees - departments - locations - countries - regions
select /*+ leading (e, d, l, c, r) use_nl(d) use_nl(l) use_nl(c) use_nl(r) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;

-- 결과
/*
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                        | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |                 |      1 |        |    106 |00:00:00.02 |  371 |         3 |
|   1 |  NESTED LOOPS                    |                 |      1 |        |    106 |00:00:00.02 |  371 |         3 |
|   2 |   NESTED LOOPS                   |                 |      1 |    106 |    106 |00:00:00.02 |  265 |         3 |
|   3 |    NESTED LOOPS                  |                 |      1 |    106 |    106 |00:00:00.01 |  255 |         2 |
|   4 |     NESTED LOOPS                 |                 |      1 |    106 |    106 |00:00:00.01 |  245 |         2 |
|   5 |      NESTED LOOPS                |                 |      1 |    106 |    106 |00:00:00.01 |  129 |         1 |
|   6 |       TABLE ACCESS FULL          | EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |   13 |         0 |
|   7 |       TABLE ACCESS BY INDEX ROWID| DEPARTMENTS     |    107 |      1 |    106 |00:00:00.01 |  116 |         1 |
|*  8 |        INDEX UNIQUE SCAN         | DEPT_ID_PK      |    107 |      1 |    106 |00:00:00.01 |   10 |         1 |
|   9 |      TABLE ACCESS BY INDEX ROWID | LOCATIONS       |    106 |      1 |    106 |00:00:00.01 |  116 |         1 |
|* 10 |       INDEX UNIQUE SCAN          | LOC_ID_PK       |    106 |      1 |    106 |00:00:00.01 |   10 |         1 |
|* 11 |     INDEX UNIQUE SCAN            | COUNTRY_C_ID_PK |    106 |      1 |    106 |00:00:00.01 |   10 |         0 |
|* 12 |    INDEX UNIQUE SCAN             | REG_ID_PK       |    106 |      1 |    106 |00:00:00.01 |   10 |         1 |
|  13 |   TABLE ACCESS BY INDEX ROWID    | REGIONS         |    106 |      1 |    106 |00:00:00.01 |  106 |         0 |
-----------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
   8 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
  10 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
  11 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
  12 - access("R"."REGION_ID"="C"."REGION_ID")
*/

-- nested loop join 순서: regions - countries - locations - departments - employees
select /*+ leading (r, c, l, d, e) use_nl(c) use_nl(l) use_nl(d) use_nl(e) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;

-- 결과
/*
------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                   |      1 |        |    106 |00:00:00.01 |      82 |      3 |
|   1 |  NESTED LOOPS                   |                   |      1 |        |    106 |00:00:00.01 |      82 |      3 |
|   2 |   NESTED LOOPS                  |                   |      1 |    106 |    106 |00:00:00.01 |      68 |      3 |
|   3 |    NESTED LOOPS                 |                   |      1 |     27 |     27 |00:00:00.01 |      54 |      2 |
|   4 |     NESTED LOOPS                |                   |      1 |     23 |     23 |00:00:00.01 |      37 |      2 |
|   5 |      NESTED LOOPS               |                   |      1 |     25 |     25 |00:00:00.01 |      23 |      1 |
|   6 |       TABLE ACCESS FULL         | REGIONS           |      1 |      4 |      4 |00:00:00.01 |       8 |      0 |
|*  7 |       INDEX FAST FULL SCAN      | COUNTRY_C_ID_PK   |      4 |      6 |     25 |00:00:00.01 |      15 |      1 |
|   8 |      TABLE ACCESS BY INDEX ROWID| LOCATIONS         |     25 |      1 |     23 |00:00:00.01 |      14 |      1 |
|*  9 |       INDEX RANGE SCAN          | LOC_COUNTRY_IX    |     25 |      2 |     23 |00:00:00.01 |       9 |      1 |
|  10 |     TABLE ACCESS BY INDEX ROWID | DEPARTMENTS       |     23 |      1 |     27 |00:00:00.01 |      17 |      0 |
|* 11 |      INDEX RANGE SCAN           | DEPT_LOCATION_IX  |     23 |      4 |     27 |00:00:00.01 |      11 |      0 |
|* 12 |    INDEX RANGE SCAN             | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |      14 |      1 |
|  13 |   TABLE ACCESS BY INDEX ROWID   | EMPLOYEES         |    106 |      4 |    106 |00:00:00.01 |      14 |      0 |
------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   7 - filter("R"."REGION_ID"="C"."REGION_ID")
   9 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
  11 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
  12 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- sort merge join 순서: employees - departments - locations - countries - regions
select /*+ leading (e, d, l, c, r) use_merge(d) use_merge(l) use_merge(c) use_merge(r) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;

/*
-------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                 | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT          |                 |      1 |        |    106 |00:00:00.02 |      25 |      5 |       |       |          |
|   1 |  MERGE JOIN               |                 |      1 |    106 |    106 |00:00:00.02 |      25 |      5 |       |       |          |
|   2 |   SORT JOIN               |                 |      1 |    106 |    106 |00:00:00.02 |      19 |      5 | 20480 | 20480 |18432  (0)|
|   3 |    MERGE JOIN             |                 |      1 |    106 |    106 |00:00:00.01 |      19 |      5 |       |       |          |
|   4 |     SORT JOIN             |                 |      1 |    106 |    106 |00:00:00.01 |      18 |      5 | 15360 | 15360 |14336  (0)|
|   5 |      MERGE JOIN           |                 |      1 |    106 |    106 |00:00:00.01 |      18 |      5 |       |       |          |
|   6 |       SORT JOIN           |                 |      1 |    106 |    106 |00:00:00.01 |      12 |      5 | 13312 | 13312 |12288  (0)|
|   7 |        MERGE JOIN         |                 |      1 |    106 |    106 |00:00:00.01 |      12 |      5 |       |       |          |
|   8 |         SORT JOIN         |                 |      1 |    107 |    107 |00:00:00.01 |       6 |      0 | 18432 | 18432 |16384  (0)|
|   9 |          TABLE ACCESS FULL| EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |       6 |      0 |       |       |          |
|* 10 |         SORT JOIN         |                 |    107 |     27 |    106 |00:00:00.01 |       6 |      5 |  2048 |  2048 | 2048  (0)|
|  11 |          TABLE ACCESS FULL| DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |      5 |       |       |          |
|* 12 |       SORT JOIN           |                 |    106 |     23 |    106 |00:00:00.01 |       6 |      0 |  2048 |  2048 | 2048  (0)|
|  13 |        TABLE ACCESS FULL  | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |       6 |      0 |       |       |          |
|* 14 |     SORT JOIN             |                 |    106 |     25 |    106 |00:00:00.01 |       1 |      0 |  2048 |  2048 | 2048  (0)|
|  15 |      INDEX FULL SCAN      | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |      0 |       |       |          |
|* 16 |   SORT JOIN               |                 |    106 |      4 |    106 |00:00:00.01 |       6 |      0 |  2048 |  2048 | 2048  (0)|
|  17 |    TABLE ACCESS FULL      | REGIONS         |      1 |      4 |      4 |00:00:00.01 |       6 |      0 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

  10 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
  12 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
  14 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
       filter("L"."COUNTRY_ID"="C"."COUNTRY_ID")
  16 - access("R"."REGION_ID"="C"."REGION_ID")
       filter("R"."REGION_ID"="C"."REGION_ID")
*/


-- sort merge join 순서: regions - countries - locations - departments - employees
select /*+ leading (r, c, l, d, e) use_merge(c) use_merge(l) use_merge(d) use_merge(e) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;

/*
-------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                 |      1 |        |    106 |00:00:00.01 |      21 |       |       |          |
|   1 |  MERGE JOIN                        |                 |      1 |    106 |    106 |00:00:00.01 |      21 |       |       |          |
|   2 |   SORT JOIN                        |                 |      1 |     27 |     27 |00:00:00.01 |      15 |  4096 |  4096 | 4096  (0)|
|   3 |    MERGE JOIN                      |                 |      1 |     27 |     27 |00:00:00.01 |      15 |       |       |          |
|   4 |     SORT JOIN                      |                 |      1 |     23 |     19 |00:00:00.01 |       9 |  4096 |  4096 | 4096  (0)|
|   5 |      MERGE JOIN                    |                 |      1 |     23 |     23 |00:00:00.01 |       9 |       |       |          |
|   6 |       SORT JOIN                    |                 |      1 |     25 |     24 |00:00:00.01 |       3 |  2048 |  2048 | 2048  (0)|
|   7 |        MERGE JOIN                  |                 |      1 |     25 |     25 |00:00:00.01 |       3 |       |       |          |
|   8 |         TABLE ACCESS BY INDEX ROWID| REGIONS         |      1 |      4 |      4 |00:00:00.01 |       2 |       |       |          |
|   9 |          INDEX FULL SCAN           | REG_ID_PK       |      1 |      4 |      4 |00:00:00.01 |       1 |       |       |          |
|* 10 |         SORT JOIN                  |                 |      4 |     25 |     25 |00:00:00.01 |       1 |  2048 |  2048 | 2048  (0)|
|  11 |          INDEX FULL SCAN           | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |       |       |          |
|* 12 |       SORT JOIN                    |                 |     24 |     23 |     23 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|  13 |        TABLE ACCESS FULL           | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |       6 |       |       |          |
|* 14 |     SORT JOIN                      |                 |     19 |     27 |     27 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|  15 |      TABLE ACCESS FULL             | DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|* 16 |   SORT JOIN                        |                 |     27 |    107 |    106 |00:00:00.01 |       6 | 18432 | 18432 |16384  (0)|
|  17 |    TABLE ACCESS FULL               | EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

  10 - access("R"."REGION_ID"="C"."REGION_ID")
       filter("R"."REGION_ID"="C"."REGION_ID")
  12 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
       filter("L"."COUNTRY_ID"="C"."COUNTRY_ID")
  14 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
       filter("D"."LOCATION_ID"="L"."LOCATION_ID")
  16 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- hash join 순서: employees - departments - locations - countries - regions
select /*+ leading (e, d, l, c, r) use_hash(d) use_hash(l) use_hash(c) use_hash(r) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;
/*
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |                 |      1 |        |    106 |00:00:00.01 |      30 |    |          |          |
|*  1 |  HASH JOIN            |                 |      1 |    106 |    106 |00:00:00.01 |      30 |  1079K|  1079K|  735K (0)|
|   2 |   TABLE ACCESS FULL   | REGIONS         |      1 |      4 |      4 |00:00:00.01 |       6 |    |          |          |
|*  3 |   HASH JOIN           |                 |      1 |    106 |    106 |00:00:00.01 |      24 |  1079K|  1079K| 1241K (0)|
|   4 |    INDEX FULL SCAN    | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |    |          |          |
|*  5 |    HASH JOIN          |                 |      1 |    106 |    106 |00:00:00.01 |      23 |   889K|   889K|  643K (0)|
|*  6 |     HASH JOIN         |                 |      1 |    106 |    106 |00:00:00.01 |      12 |   940K|   940K|  906K (0)|
|   7 |      TABLE ACCESS FULL| EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |       6 |    |          |          |
|   8 |      TABLE ACCESS FULL| DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |    |          |          |
|   9 |     TABLE ACCESS FULL | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |      11 |    |          |          |
------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("R"."REGION_ID"="C"."REGION_ID")
   3 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
   5 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   6 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- hash join 순서: regions - countries - locations - departments - employees
select /*+ leading (r, c, l, d, e) use_hash(c) use_hash(l) use_hash(d) use_hash(e) */e.employee_id, e.last_name, e.salary, e.job_id, d.department_name, l.city, l.street_address, c.country_name, r.region_name
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and r.region_id = c.region_id;
/*
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |                 |      1 |        |    106 |00:00:00.01 |      32 |    |          |          |
|*  1 |  HASH JOIN            |                 |      1 |    106 |    106 |00:00:00.01 |      32 |   792K|   792K| 1252K (0)|
|*  2 |   HASH JOIN           |                 |      1 |     27 |     27 |00:00:00.01 |      19 |   832K|   832K| 1159K (0)|
|*  3 |    HASH JOIN          |                 |      1 |     23 |     23 |00:00:00.01 |      13 |   981K|   981K| 1255K (0)|
|*  4 |     HASH JOIN         |                 |      1 |     25 |     25 |00:00:00.01 |       7 |  1096K|  1096K|  741K (0)|
|   5 |      TABLE ACCESS FULL| REGIONS         |      1 |      4 |      4 |00:00:00.01 |       6 |    |          |          |
|   6 |      INDEX FULL SCAN  | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |    |          |          |
|   7 |     TABLE ACCESS FULL | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |       6 |    |          |          |
|   8 |    TABLE ACCESS FULL  | DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |    |          |          |
|   9 |   TABLE ACCESS FULL   | EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |      13 |    |          |          |
------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   3 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
   4 - access("R"."REGION_ID"="C"."REGION_ID")
*/

-- arraysize 1000
-- hash join 순서: employees - departments - locations - countries - regions
/*
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |                 |      1 |        |    106 |00:00:00.01 |      26 |    |          |          |
|*  1 |  HASH JOIN            |                 |      1 |    106 |    106 |00:00:00.01 |      26 |  1079K|  1079K|  742K (0)|
|   2 |   TABLE ACCESS FULL   | REGIONS         |      1 |      4 |      4 |00:00:00.01 |       6 |    |          |          |
|*  3 |   HASH JOIN           |                 |      1 |    106 |    106 |00:00:00.01 |      20 |  1079K|  1079K| 1253K (0)|
|   4 |    INDEX FULL SCAN    | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |    |          |          |
|*  5 |    HASH JOIN          |                 |      1 |    106 |    106 |00:00:00.01 |      19 |   889K|   889K|  651K (0)|
|*  6 |     HASH JOIN         |                 |      1 |    106 |    106 |00:00:00.01 |      12 |   940K|   940K|  901K (0)|
|   7 |      TABLE ACCESS FULL| EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |       6 |    |          |          |
|   8 |      TABLE ACCESS FULL| DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |    |          |          |
|   9 |     TABLE ACCESS FULL | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |       7 |    |          |          |
------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("R"."REGION_ID"="C"."REGION_ID")
   3 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
   5 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   6 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

-- hash join 순서: regions - countries - locations - departments - employees
/*
------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation             | Name            | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |                 |      1 |        |    106 |00:00:00.01 |      26 |    |          |          |
|*  1 |  HASH JOIN            |                 |      1 |    106 |    106 |00:00:00.01 |      26 |   792K|   792K| 1294K (0)|
|*  2 |   HASH JOIN           |                 |      1 |     27 |     27 |00:00:00.01 |      19 |   832K|   832K| 1156K (0)|
|*  3 |    HASH JOIN          |                 |      1 |     23 |     23 |00:00:00.01 |      13 |   981K|   981K| 1254K (0)|
|*  4 |     HASH JOIN         |                 |      1 |     25 |     25 |00:00:00.01 |       7 |  1096K|  1096K|  770K (0)|
|   5 |      TABLE ACCESS FULL| REGIONS         |      1 |      4 |      4 |00:00:00.01 |       6 |    |          |          |
|   6 |      INDEX FULL SCAN  | COUNTRY_C_ID_PK |      1 |     25 |     25 |00:00:00.01 |       1 |    |          |          |
|   7 |     TABLE ACCESS FULL | LOCATIONS       |      1 |     23 |     23 |00:00:00.01 |       6 |    |          |          |
|   8 |    TABLE ACCESS FULL  | DEPARTMENTS     |      1 |     27 |     27 |00:00:00.01 |       6 |    |          |          |
|   9 |   TABLE ACCESS FULL   | EMPLOYEES       |      1 |    107 |    107 |00:00:00.01 |       7 |    |          |          |
------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
   2 - access("D"."LOCATION_ID"="L"."LOCATION_ID")
   3 - access("L"."COUNTRY_ID"="C"."COUNTRY_ID")
   4 - access("R"."REGION_ID"="C"."REGION_ID")
*/




-- IOT: index organized table
-- NON_IOT
create table emp_non_iot
as select rownum emp_id, last_name, first_name, job_id, hire_date, salary, commission_pct, email, department_id
from employees, (select rownum emp_id from dual connect by level <= 10000)
order by dbms_random.value;

exec dbms_stats.gather_table_stats('hr', 'emp_non_iot');

select num_rows, blocks from user_tables where table_name = 'EMP_NON_IOT';  

alter table emp_non_iot add constraint emp_non_iot_pk primary key(emp_id);

select index_name, blevel, leaf_blocks, clustering_factor
from user_indexes
where table_name = 'EMP_NON_IOT';

-- IOT
create table emp_iot
(emp_id, last_name, first_name, job_id, hire_date, salary, commission_pct, email, department_id, 
constraint emp_iot_pk primary key(emp_id))
organization index
as select * from emp_non_iot;

exec dbms_stats.gather_table_stats('hr', 'emp_iot');

select num_rows, blocks from user_tables where table_name = 'EMP_IOT';  

select index_name, blevel, leaf_blocks, clustering_factor
from user_indexes
where table_name = 'EMP_IOT';

-- 인덱스 확인
select ix.table_name, ix.index_type, ix.index_name, ix.uniqueness, ic.column_name
from user_indexes ix, user_ind_columns ic
where ix.index_name = ic.index_name;

-- index join
select /*+ index_join(e emp_emp_id_pk emp_job_ix)*/ employee_id, job_id
from employees e
where employee_id < 150
and job_id = 'ST_CLERK';

-- join하지 않는 서브쿼리: no_unnest 힌트 활용
select *
from employees
where department_id in (select /*+ no_unnest*/ department_id from departments);

select * 
from employees e
where exists (select /*+ no_unnest*/ 'x' from departments where department_id = e.department_id);


select e.*
from employees e, departments d
where e.department_id = d.department_id;

create table emp_test
as select * from employees;

create table dept_test
as select * from departments;

select e.*
from emp_test e, dept_test d
where e.department_id = d.department_id;

select distinct department_id from employees;

select e.employee_id, e.department_id, d.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
order by 2, 3;

-- 스칼라 서브쿼리: cache를 활용하여 i/o를 줄임 & outer join과 같은 효과가 있음
select employee_id, department_id, (select department_name from departments where department_id = e.department_id)
from employees e;

-- unnest: 동일한 결과를 보장한다면 조인문으로 변환하는 방식
-- 조인으로 변환하면 다양한 액세스 경로, 조인 방법을 결정할 수 있기 때문에 변환한다

select *
from departments d
where exists (select 'x' from employees where department_id = d.department_id);

select d.*
from employees e, departments d
where e.department_id = d.department_id;

select * 
from employees e
where exists (select /*+ unnest */ 'x' from departments where department_id = e.department_id);

select *
from employees
where department_id in (select department_id from departments where location_id = 1500);
/*
-------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      1 |        |     45 |00:00:00.01 |   12 |
|   1 |  NESTED LOOPS                 |                   |      1 |        |     45 |00:00:00.01 |   12 |
|   2 |   NESTED LOOPS                |                   |      1 |     10 |     45 |00:00:00.01 |    7 |
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |    3 |
|*  4 |     INDEX RANGE SCAN          | DEPT_LOCATION_IX  |      1 |      1 |      1 |00:00:00.01 |    2 |
|*  5 |    INDEX RANGE SCAN           | EMP_DEPARTMENT_IX |      1 |     10 |     45 |00:00:00.01 |    4 |
|   6 |   TABLE ACCESS BY INDEX ROWID | EMPLOYEES         |     45 |     10 |     45 |00:00:00.01 |    5 |
-------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("LOCATION_ID"=1500)
   5 - access("DEPARTMENT_ID"="DEPARTMENT_ID")
*/

-- 위의 서브쿼리와 동일한 결과를 얻는 join
select e.*
from employees e, departments d
where e.department_id = d.department_id
and d.location_id = 1500;

select *
from employees
where department_id in (select /*+ no_unnest */department_id from departments where location_id = 1500);
/*
------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |             |      1 |        |     45 |00:00:00.01 |      31 |
|*  1 |  FILTER                      |             |      1 |        |     45 |00:00:00.01 |      31 |
|   2 |   TABLE ACCESS FULL          | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       9 |
|*  3 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS |     12 |      1 |      1 |00:00:00.01 |      22 |
|*  4 |    INDEX UNIQUE SCAN         | DEPT_ID_PK  |     12 |      1 |     11 |00:00:00.01 |      11 |
------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter( IS NOT NULL)
   3 - filter("LOCATION_ID"=1500)
   4 - access("DEPARTMENT_ID"=:B1)
*/
-- 위의 서브쿼리와 동일한 결과를 얻는 filter방식
select * 
from employees e
where exists (select /*+ no_unnest */ 'x' from departments where department_id = e.department_id and location_id = 1500);

/*서브쿼리를 조인으로 바꿀때 발생하는 문제
departments 테이블이 기준 집합이므로 그 결과 집합은 departments 테이블의 총 건수를 넘지 않아야 한다
만약에 조인문장으로 변환한다면 m쪽 집합인 employees 테이블 결과집합으로 만들어지기 때문에 잘못된 결과가 나온다. */

select * 
from departments d
where exists (select  'x' from employees where department_id = d.department_id);

select d.*
from (select distinct department_id from employees) e, departments d
where e.department_id = d.department_id;

select distinct d.*
from employees e, departments d
where d.department_id = e.department_id;