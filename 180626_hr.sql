-- 이번 세션에서 세부 실행계획을 항상 확인
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
 
 -- join의 순서를 지정하는 힌트
-- ordered : from 절에 지정된 순서대로 join
select /*+ ordered use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from departments d, employees e
where e.department_id = d.department_id;

-- leading: 순서를 지정하여 join
select /*+ leading(e, d) use_nl(e, d) */ e.last_name, e.salary, e.job_id, d.department_name
from departments d, employees e
where e.department_id = d.department_id;

-- 순서: l,d,e의 순서로 join / 방법: l에서 d는 nl로 d에서 e는 nl로 
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
10.2.0.5 버전
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
-- table prefetch: buffer cache에 올라와 있지 않은 block들을 나중에 한번에 접근하기 위한 기법 / clustering factor가 나쁠 때 효과적
-- disk i/o를 수행하면 비용이 많이 들기 때문에 한번의 i/o call이 필요한 시점에 곧 이어 읽을 가능성이 있는 block들을 data buffer cache에 미리 적재해 두는 기능
-- |   1 |  TABLE ACCESS BY INDEX ROWID  | EMPLOYEES         |      1 |     10 |     34 |00:00:00.01 |   11 |


select /*+ optimizer_features_enable('11.2.0.1.1') leading(d, e) use_nl(e) */ e.*, d.*
from departments d, employees e
where e.department_id = d.department_id
and d.location_id = 2500;

/*
11.2.0.1.1 버전
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
-- batch i/o: inner쪽 index와 join하면서 중간 결과 집합(active set)을 만든 후 inner 테이블과 일괄(batch) 처리한다


-- no batch i/o -> table prefetch형식으로 바뀜
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


