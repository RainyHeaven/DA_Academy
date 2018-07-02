-- [����128] �Ʒ� SQL���� �м��غ�����.
select *
FROM employees e
where exists (select 'x' 	from departments d WHERE department_id = e.department_id	and location_id = 1500);
/*
-----------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                   |      1 |        |     45 |00:00:00.01 |   11 |          |       |          |
|   1 |  NESTED LOOPS                  |                   |      1 |        |     45 |00:00:00.01 |   11 |          |       |          |
|   2 |   NESTED LOOPS                 |                   |      1 |     10 |     45 |00:00:00.01 |    6 |          |       |          |
|   3 |    SORT UNIQUE                 |                   |      1 |      1 |      1 |00:00:00.01 |    2 |     2048 |  2048 | 2048  (0)|
|   4 |     TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |    2 |          |       |          |
|*  5 |      INDEX RANGE SCAN          | DEPT_LOCATION_IX  |      1 |      1 |      1 |00:00:00.01 |    1 |          |       |          |
|*  6 |    INDEX RANGE SCAN            | EMP_DEPARTMENT_IX |      1 |     10 |     45 |00:00:00.01 |    4 |          |       |          |
|   7 |   TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |     45 |     10 |     45 |00:00:00.01 |    5 |          |       |          |
-----------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   5 - access("LOCATION_ID"=1500)
   6 - access("DEPARTMENT_ID"="E"."DEPARTMENT_ID")
*/

-- 3: SORT UNIQUE �߻�: driven���� 1���������� Ȯ������ ���� ��Ȳ
-- 6,7: batch i/o �۵�

-- join���� �����
SELECT /*+ leading(d) use_nl(e)*/e.*
FROM employees e, departments d
WHERE d.department_id = e.department_id	AND d.location_id = 1500;
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

   4 - access("D"."LOCATION_ID"=1500)
   5 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
*/

SELECT /*+ leading(d) use_hash(e)*/e.*
FROM employees e, departments d
WHERE d.department_id = e.department_id	AND d.location_id = 1500;
/*
--------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
--------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                  |      1 |        |     45 |00:00:00.01 |      11 |       |       |          |
|*  1 |  HASH JOIN                   |                  |      1 |     10 |     45 |00:00:00.01 |      11 |  1517K|  1517K|  386K (0)|
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS      |      1 |      1 |      1 |00:00:00.01 |    2 |          |       |          |
|*  3 |    INDEX RANGE SCAN          | DEPT_LOCATION_IX |      1 |      1 |      1 |00:00:00.01 |    1 |          |       |          |
|   4 |   TABLE ACCESS FULL          | EMPLOYEES        |      1 |    107 |    107 |00:00:00.01 |    9 |          |       |          |
--------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
   3 - access("D"."LOCATION_ID"=1500)
*/
SELECT /*+ leading(d) use_merge(e)*/e.*
FROM employees e, departments d
WHERE d.department_id = e.department_id	AND d.location_id = 1500;
/*
---------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name             | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                  |      1 |        |     45 |00:00:00.01 |    8 |          |       |          |
|   1 |  MERGE JOIN                   |                  |      1 |     10 |     45 |00:00:00.01 |    8 |          |       |          |
|   2 |   SORT JOIN                   |                  |      1 |      1 |      1 |00:00:00.01 |    2 |  2048 |  2048 | 2048  (0)|
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS      |      1 |      1 |      1 |00:00:00.01 |    2 |          |       |          |
|*  4 |     INDEX RANGE SCAN          | DEPT_LOCATION_IX |      1 |      1 |      1 |00:00:00.01 |    1 |          |       |          |
|*  5 |   SORT JOIN                   |                  |      1 |    107 |     45 |00:00:00.01 |    6 | 22528 | 22528 |20480  (0)|
|   6 |    TABLE ACCESS FULL          | EMPLOYEES        |      1 |    107 |    107 |00:00:00.01 |    6 |          |       |          |
---------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("D"."LOCATION_ID"=1500)
   5 - access("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
       filter("D"."DEPARTMENT_ID"="E"."DEPARTMENT_ID")
*/

-- [����129] SQL���� Ʃ���ϼ���.
select department_name, (select sum(salary)	from employees	where department_id = d.department_id) sumsal,	(select avg(salary)	from employees	WHERE department_id = d.department_id) avgsal
FROM departments d;
/*
------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |      1 |        |     27 |00:00:00.01 |    8 |
|   1 |  SORT AGGREGATE              |                   |     27 |      1 |     27 |00:00:00.01 |   14 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |     27 |     10 |    106 |00:00:00.01 |   14 |
|*  3 |    INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |    4 |
|   4 |  SORT AGGREGATE              |                   |     27 |      1 |     27 |00:00:00.01 |   14 |
|   5 |   TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |     27 |     10 |    106 |00:00:00.01 |   14 |
|*  6 |    INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |    4 |
|   7 |  TABLE ACCESS FULL           | DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |    8 |
------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("DEPARTMENT_ID"=:B1)
   6 - access("DEPARTMENT_ID"=:B1)
*/


-- ��Į�󼭺������� 2�� �־� ���� ���̺� ������ ����

-- ��Į�󼭺����� Ȱ��
SELECT department_name, substr(sal, 1, 10) sum_sal, substr(sal, 11) avg_sal
FROM (SELECT department_name, (SELECT lpad(sum(salary), 10)||lpad(avg(salary), 10) FROM employees WHERE department_id = d.department_id) sal FROM departments d)
where sal is not null;
/*
------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                   |      1 |        |     11 |00:00:00.01 |   20 |
|   1 |  SORT AGGREGATE              |                   |     27 |      1 |     27 |00:00:00.01 |   13 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |     27 |     10 |    106 |00:00:00.01 |   13 |
|*  3 |    INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |    3 |
|*  4 |  VIEW                        |                   |      1 |     27 |     11 |00:00:00.01 |   20 |
|   5 |   TABLE ACCESS FULL          | DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |    7 |
------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("DEPARTMENT_ID"=:B1)
   4 - filter("SAL" IS NOT NULL)
*/

-- join Ȱ��
SELECT /*+ leading(d) use_nl(e)*/d.department_name, e.sumsal, e.avgsal
FROM departments d, (SELECT department_id, sum(salary) AS sumsal, avg(salary) AS avgsal FROM employees GROUP BY department_id) e
where e.department_id(+) = d.department_id;
/*
----------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
----------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      1 |        |     27 |00:00:00.01 |   18 |          |       |          |
|   1 |  HASH GROUP BY                |                   |      1 |    106 |     27 |00:00:00.01 |   18 |      806K|   806K| 1347K (0)|
|   2 |   NESTED LOOPS OUTER          |                   |      1 |    106 |    122 |00:00:00.01 |   18 |          |       |          |
|   3 |    TABLE ACCESS FULL          | DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |    6 |          |       |          |
|   4 |    TABLE ACCESS BY INDEX ROWID| EMPLOYEES         |     27 |      4 |    106 |00:00:00.01 |   12 |          |       |          |
|*  5 |     INDEX RANGE SCAN          | EMP_DEPARTMENT_IX |     27 |     10 |    106 |00:00:00.01 |    3 |          |       |          |
----------------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   5 - access("DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

SELECT /*+ leading(d) use_merge(e)*/d.department_name, e.sumsal, e.avgsal
FROM departments d, (SELECT department_id, sum(salary) AS sumsal, avg(salary) AS avgsal FROM employees GROUP BY department_id) e
where e.department_id(+) = d.department_id;
/*
---------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
---------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |             |      1 |        |     27 |00:00:00.01 |      12 |       |       |          |
|   1 |  MERGE JOIN OUTER            |             |      1 |     27 |     27 |00:00:00.01 |      12 |       |       |          |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   3 |    INDEX FULL SCAN           | DEPT_ID_PK  |      1 |     27 |     27 |00:00:00.01 |       3 |       |       |          |
|*  4 |   SORT JOIN                  |             |     27 |     11 |     11 |00:00:00.01 |       6 |  2048 |  2048 | 2048  (0)|
|   5 |    VIEW                      |             |      1 |     11 |     12 |00:00:00.01 |       6 |       |       |          |
|   6 |     HASH GROUP BY            |             |      1 |     11 |     12 |00:00:00.01 |       6 |   894K|   894K| 1718K (0)|
|   7 |      TABLE ACCESS FULL       | EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
---------------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/

SELECT /*+ leading(d) use_hash(e)*/d.department_name, e.sumsal, e.avgsal
FROM departments d, (SELECT department_id, sum(salary) AS sumsal, avg(salary) AS avgsal FROM employees GROUP BY department_id) e
where e.department_id(+) = d.department_id;
/*
-------------------------------------------------------------------------------------------------------------------------
| Id  | Operation            | Name        | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |             |      1 |        |     27 |00:00:00.01 |      12 |       |       |          |
|*  1 |  HASH JOIN OUTER     |             |      1 |     27 |     27 |00:00:00.01 |      12 |  1079K|  1079K| 1280K (0)|
|   2 |   TABLE ACCESS FULL  | DEPARTMENTS |      1 |     27 |     27 |00:00:00.01 |       6 |       |       |          |
|   3 |   VIEW               |             |      1 |     11 |     12 |00:00:00.01 |       6 |       |       |          |
|   4 |    HASH GROUP BY     |             |      1 |     11 |     12 |00:00:00.01 |       6 |   894K|   894K| 1732K (0)|
|   5 |     TABLE ACCESS FULL| EMPLOYEES   |      1 |    107 |    107 |00:00:00.01 |       6 |       |       |          |
-------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
*/






-- bitmap index
-- ex) create bitmap index �����̺�_����.indx on �����̺�(����);

select * from user_ind_columns where table_name = 'EMPLOYEES';
SELECT * FROM user_indexes WHERE table_name = 'EMPLOYEES';

-- b*tree index�� bitmap index�� conversion
select /*+ index_combine(e emp_emp_id_pk emp_job_ix) */ employee_id, job_id
from employees e
where employee_id <= 120
AND job_id = 'PU_CLERK';

SELECT /*+ index_combine(e emp_emp_id_pk emp_sal_idx) */ employee_id, salary
FROM employees e
WHERE employee_id = 100
and salary = 10000;

-- filter���: ������������ ������ row���� ���������� �ݺ������ϸ鼭 ���ǿ� �´� �����͸� ã�� ���
select * 
FROM employees
where department_id in (select /*+ no_unnest */ department_id from departments where location_id = 1500);

select * 
FROM employees e
WHERE exists (SELECT /*+ no_unnest */ 'x' FROM departments WHERE location_id = 1500 and department_id = e.department_id);

-- join���
select * 
FROM employees
where department_id in (select /*+ unnest */ department_id from departments where location_id = 1500);

SELECT e.*
FROM employees e, departments d
WHERE e.department_id = d.department_id
and d.location_id= 1500;

-- hash unique / sort unique <- �߰ߵ� �� Ʃ�� ���
-- 1�� �������� Ȯ���� �� ���� ���������� driving table�� �ȴٸ� ���� sort(hash) unique�� ���������ν� 1���������� ���� �� join ����
SELECT /*+ leading(e) user_nl(d) */ *
FROM departments d
where department_id in (select /*+ unnest */ department_id from employees e);

/*
-----------------------------------------------------------------------------------------------------------------------------
| Id  | Operation          | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                   |      1 |        |     11 |00:00:00.01 |       8 |    |  |          |
|*  1 |  HASH JOIN         |                   |      1 |     11 |     11 |00:00:00.01 |       8 |  1517K|  1517K| 1077K (0)|
|   2 |   SORT UNIQUE      |                   |      1 |    107 |     11 |00:00:00.01 |       1 |  2048 |  2048 | 2048  (0)|
|   3 |    INDEX FULL SCAN | EMP_DEPARTMENT_IX |      1 |    107 |    106 |00:00:00.01 |       1 |    |  |          |
|   4 |   TABLE ACCESS FULL| DEPARTMENTS       |      1 |     27 |     27 |00:00:00.01 |       7 |    |  |          |
-----------------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("DEPARTMENT_ID"="DEPARTMENT_ID")
*/

-- semi join
select *
FROM departments
WHERE department_id IN (SELECT department_id FROM employees);


select *
FROM departments
WHERE department_id IN (SELECT /*+ nl_sj*/ department_id FROM employees);

select *
FROM departments
WHERE department_id IN (SELECT /*+ hash_sj*/ department_id FROM employees);

select *
FROM departments
WHERE department_id IN (SELECT /*+ merge_sj*/ department_id FROM employees);


SELECT *
FROM departments
WHERE department_id NOT IN (SELECT /*+ no_unnest */ department_id FROM employees where department_id is not null);

SELECT *
FROM departments d
WHERE NOT EXISTS (SELECT /*+ no_unnest */ 'x' FROM employees WHERE department_id = d.department_id);

-- anti join: join�� ���� �������� �ʴ� row�� ã�´�
SELECT *
FROM departments d
WHERE NOT EXISTS (SELECT 'x' FROM employees WHERE department_id = d.department_id);

SELECT *
FROM departments d
where not exists (select /*+ nl_aj */ 'x' from employees where department_id = d.department_id);

SELECT *
FROM departments d
WHERE NOT EXISTS (SELECT /*+ hash_aj */ 'x' FROM employees WHERE department_id = d.department_id);

SELECT *
FROM departments d
where not exists (select /*+ merge_aj */ 'x' from employees where department_id = d.department_id);

SELECT e.*, d.*
FROM employees e, departments d
WHERE e.department_id = d.department_id
and exists (select 'x' from locations where location_id = d.location_id and city = 'London');

-- pushing subquery
-- �����ȹ�� �մܰ迡�� ������ �������� ���͸��� ���� ó���Ͽ� ���� ����ܰ�� �Ѿ�� row���� ���̴� ���
-- unnest ���� �ʴ� ���������� ó�������� �����ϴ� ���
-- no push
SELECT e.*, d.*
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND EXISTS (SELECT /*+ no_unnest no_push_subq */'x' FROM locations WHERE location_id = d.location_id AND city = 'London');
-- push
SELECT e.*, d.*
FROM employees e, departments d
WHERE e.department_id = d.department_id
and exists (select /*+ no_unnest push_subq */'x' from locations where location_id = d.location_id and city = 'London');

SELECT e.*, d.*
FROM employees e, departments d
WHERE e.department_id = d.department_id
and exists (select 'x' from locations where location_id = d.location_id and city = 'London');


SELECT /*+ leading(l, d, e) use_nl(d) use_nl(e) */e.*, d.*
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
and l.city = 'London';
