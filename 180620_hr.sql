drop table emp purge;

create table emp
as select * from employees;

select * from emp where employee_id = 100;

--자신의 테이블에 대한 통계정보 확인
select num_rows, blocks, avg_row_len
from user_tables
where table_name = 'EMP';

select * from user_tab_privs;

exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);

drop table emp purge;

select * from emp where employee_id = 100;

create index emp_id_idx
on emp(employee_id);

-- 플랜테이블 확인
select *
from all_synonyms
where synonym_name = 'PLAN_TABLE';

explain plan for select * from emp where employee_id = 100;

-- 실행계획 확인
select * from plan_table;

-- 실행계획 확인 (dbms_xplan을 활용하여 보기 좋게 확인)
-- 인수값으로 넣는 id값들을 알 수 없으므로 null을 넣어 마지막으로 plan_table에 담긴 값을 사용
select * from table(dbms_xplan.display(null, null, 'typical'));

select * from table(dbms_xplan.display(null, null, 'basic'));

drop index emp_id_idx;

-- 한번에 읽는 block의 수 설정 (자신의 세션에만 적용)
alter session set db_file_multiblock_read_count = 128;

-- 풀 스캔을 하도록 하는 힌트 /*+full(테이블명or별칭)*/
select /*+full(e)*/* from emp e;

-- parallel(): 프로세서를 여러개 띄워서 찾는 방법
-- data buffer cache를 통하지 않고 바로 cursor로 direct read
select /*+full(e) parallel(e,2)*/employee_id, last_name from emp e;

select rowid, employee_id from emp;

select * from emp where rowid = 'AAAFADAAEAAAAHLAAE';

-- index unique scan
-- 컬럼에 유니크 인덱스가 구성되어 있고
-- 비교연산자로 = 가 사용될 때

--인덱스가 걸려있는 컬럼 확인
select * from user_ind_columns where table_name = 'EMP';

alter table emp add constraint emp_id_new_pk primary key(employee_id);

-- 인덱스 정보 확인
select * from user_indexes where table_name = 'EMP';

explain plan for select * from emp where employee_id <= 100;

-- full table scan
explain plan for select * from emp where employee_id >= 100;

-- index range scan
explain plan for select employee_id, last_name from emp where employee_id >= 100;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- index range scan
-- index leaf block 에서 필요한 범위만 스캔하는 방식
create index emp_dept_idx
on emp(department_id);

select * from user_ind_columns where table_name = 'EMP';
select * from user_indexes where table_name = 'EMP';


explain plan for select * from emp where department_id = 10;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- inlist iterator
-- index에 root, branch, leaf가 반복될 때 
explain plan for 
select * from emp where employee_id in (100, 200);

select * from table(dbms_xplan.display(null, null, 'typical'));

-- in, or 연산자는 set operator와 동일함
select * from emp where employee_id = 100
union all
select * from emp where employee_id = 200;

-- 원하는 값들 사이에 다른 값들이 없다면 between연산자를 사용하는 것이 좋음 
-- index range scan이 됨
explain plan for
select *
from emp
where employee_id between 100 and 102;

