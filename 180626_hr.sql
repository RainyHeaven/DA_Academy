-- �̹� ���ǿ��� ���� �����ȹ�� �׻� Ȯ��
alter session set statistics_level = all;

-- nested loop join
select /*+ use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and e.department_id = 10;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

 select e.*, d.*
 from employees e, departments d
 where d.department_id = 20 
 and e.department_id = 20;
 
 -- join�� ������ �����ϴ� ��Ʈ
-- ordered : from ���� ������ ������� join
select /*+ ordered use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from departments d, employees e
where e.department_id = d.department_id;

-- leading: ������ �����Ͽ� join
select /*+ leading(e, d) use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from departments d, employees e
where e.department_id = d.department_id;

-- ����: l,d,e�� ������ join / ���: l���� d�� nl�� d���� e�� nl�� 
select /*+ leading(l, d, e) use_nl(d) use_nl(e)  */ e.*, d.*, l.*
from departments d, employees e, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

select /*+ optimizer_features_enable('10.2.0.5') leading(d, e) use_nl(e) */ e.*, d.*
from departments d, employees e
where e.department_id = d.department_id
and d.location_id = 2500;
/*
10.2.0.5 ����
-------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      0 |        |      0 |00:00:00.01 |    0 |
|   1 |  TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |      1 |     10 |     34 |00:00:00.01 |   11 |
|   2 |   NESTED LOOPS                |                   |      1 |     10 |     36 |00:00:00.01 |    7 |
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |    3 |
|*  4 |     INDEX RANGE SCAN          | DEPT_LOCATION_IX  |      1 |      1 |      1 |00:00:00.01 |    2 |
|*  5 |    index range scan           | emp_department_ix |      1 |     10 |     34 |00:00:00.01 |    4 |
-------------------------------------------------------------------------------------------------------------
*/
-- table prefetch: buffer cache�� �ö�� ���� ���� block���� ���߿� �ѹ��� �����ϱ� ���� ��� / clustering factor�� ���� �� ȿ����
-- disk i/o�� �����ϸ� ����� ���� ��� ������ �ѹ��� i/o call�� �ʿ��� ������ �� �̾� ���� ���ɼ��� �ִ� block���� data buffer cache�� �̸� ������ �δ� ���
-- |   1 |  TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |      1 |     10 |     34 |00:00:00.01 |   11 |


select /*+ optimizer_features_enable('11.2.0.1.1') leading(d, e) use_nl(e) */ e.*, d.*
from departments d, employees e
where e.department_id = d.department_id
and d.location_id = 2500;

/*
11.2.0.1.1 ����
-------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      1 |        |     34 |00:00:00.01 |   11 |
|   1 |  NESTED LOOPS                 |                   |      1 |        |     34 |00:00:00.01 |   11 |
|   2 |   NESTED LOOPS                |                   |      1 |     10 |     34 |00:00:00.01 |    7 |
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |    3 |
|*  4 |     INDEX RANGE SCAN          | DEPT_LOCATION_IX  |      1 |      1 |      1 |00:00:00.01 |    2 |
|*  5 |    INDEX RANGE SCAN           | EMP_DEPARTMENT_IX |      1 |     10 |     34 |00:00:00.01 |    4 |
|   6 |   TABLE ACCESS BY INDEX ROWID | EMPLOYEES         |     34 |     10 |     34 |00:00:00.01 |    4 |
-------------------------------------------------------------------------------------------------------------
*/
-- batch i/o: inner�� index�� join�ϸ鼭 �߰� ��� ����(active set)�� ���� �� inner ���̺�� �ϰ�(batch) ó���Ѵ�


-- no batch i/o -> table prefetch�������� �ٲ�
select /*+ leading(d, e) use_nl(e) no_nlj_batching(e) */ e.*, d.*
from departments d, employees e
where e.department_id = d.department_id
and d.location_id = 2500;

/*
-------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |      0 |        |      0 |00:00:00.01 |    0 |
|   1 |  TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |      1 |     10 |     34 |00:00:00.01 |   11 |
|   2 |   NESTED LOOPS                |                   |      1 |     10 |     36 |00:00:00.01 |    7 |
|   3 |    TABLE ACCESS BY INDEX ROWID| DEPARTMENTS       |      1 |      1 |      1 |00:00:00.01 |    3 |
|*  4 |     INDEX RANGE SCAN          | DEPT_LOCATION_IX  |      1 |      1 |      1 |00:00:00.01 |    2 |
|*  5 |    INDEX RANGE SCAN           | EMP_DEPARTMENT_IX |      1 |     10 |     34 |00:00:00.01 |    4 |
-------------------------------------------------------------------------------------------------------------
*/

 
 select /*+ use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and e.last_name = 'King';


