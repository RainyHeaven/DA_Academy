/* index scan
1. index unique scan
2. index range scan
3. inlist iterator - in / or 연산자 일때 
4. index skip scan - 9i 버전부터 등장
5. index full scan */
-- 하나의 테이블에 4개 이상의 index는 권고하지 않음 -> 너무 많은 index는 실행계획 생성등에 부적합

-- 테이블에 걸린 인덱스 확인
select * from user_ind_columns where table_name = 'EMP';


-- 테이블에 포함된 컬럼의 제약조건 확인
select * from user_constraints where table_name = 'EMP';
select * from user_cons_columns where table_name = 'EMP';

-- 인덱스 생성
create index emp_last_first_idx on emp(last_name, first_name);
create index emp_dept_idx on emp(department_id);

-- 실행계획 저장
explain plan for select * from emp where last_name = 'King' and first_name = 'Steven';
explain plan for select * from emp where department_id = 10;

-- 실행계획에 힌트 넣기
-- full scan
explain plan for select /*+ full(e)*/* from emp e where employee_id = 100;
-- 지정한 index사용
explain plan for select /*+ index(e emp_dept_id_idx)*/ * from emp e where department_id = 10;
-- 지정한 index로 range scan
explain plan for select /*+ index_rs(e emp_dept_id_idx)*/ * from emp e where department_id = 10;
-- skip scanning이 비효율 적인 상황일 때는 개별 index로 유도
explain plan for select /*+ index(e emp_first_idx)*/* from emp e where first_name = 'Steven';
-- 지정한 index로 skip scanning
explain plan for select /*+ index_ss(e emp_last_first_idx)*/* from emp e where first_name = 'Steven';
-- 지정한 index로 fast full scan
explain plan for select /*+ index_ffs(e emp_id_pk) */ count(*) from emp e; -- not null 조건이 걸린 index를 통해 count: 읽는 block을 줄여 I/O 최소화
-- 지정된 index로 descending하게 정렬
select /*+ index_desc(e emp_id_pk) */ employee_id from emp e;


-- index가 있어도 원하는 컬럼의 양이 많다면 full scan으로 유도하는 것이 효율적이다
explain plan for select * from emp e where department_id = 50;
explain plan for select /*+ full(e)*/* from emp e where department_id = 50;

-- 실행계획 확인
select * from table(dbms_xplan.display(null, null, 'typical'));

-- random I/O: 특정 row를 찾기 위해 블럭에 접근할 때 발생
-- serial I/O:  block 내에서 연속된 row에 접근할 때 발생

-- primary key 추가
alter table emp add constraint emp_id_pk primary key(employee_id);

select department_id, count(*)
from emp
group by department_id;

-- 원하는 컬럼의 중복도 체크 distinctive column check
select count(distinct department_id) from emp;

explain plan for select last_name, first_name from emp;

explain plan for select employee_id from emp;

-- count(*): null 포함 / count(컬럼): null 생략
explain plan for select count(*) from emp e; -- pk 또는 not null 조건이 걸린 index를 통해 count: 읽는 block을 줄여 I/O 최소화

-- parallel_index: index병렬처리, (multiblock i/o를 유발하는 )fast full scan과 같이 쓴다 
explain plan for 
select /*+ index_ffs(e emp_id_pk) 
           parallel_index(e, emp_id_pk, 2) */ 
           count(*) 
from emp e;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- index range scan descending / index는 sort된 결과를 가지고 있으므로 따로 정렬이 발생하지 않음
explain plan for
select *
from emp 
where employee_id > 0
order by employee_id desc;

-- 현재는 사용하지 않는 방식(max찾기)
select /*+ index_asc(e emp_id_pk) */ employee_id
from emp e
where rownum <= 1;

-- INDEX FULL SCAN (MIN/MAX)를 위해서 MIN/MAX 값에만 접근한다
-- min, max가 함께 있을 경우 index full scan이 된다
explain plan for select max(employee_id), min(employee_id) from emp;
explain plan for select max(employee_id) from emp union all select min(employee_id) from emp;

-- 수행한 select 문의 실행계획에 대한 통계정보 수집
select /*+ gather_plan_statistics */ *
from emp
where employee_id = 100;

-- 수집한 통계정보 확인
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
-- E-Rows: 예측한 row의 수
-- A-Rows: 실제 row의 수
-- buffers: 메모리에서 찾은 block의 수(아래에서 부터 누적된 수)

select /*+ gather_plan_statistics */ *
from emp
where department_id = 50;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- clustering factor: row의 밀집도를 표현하는 factor / 하나의 row에서 다음 row가 다른 block에 있을 때 1씩 늘어남

select /*+ gather_plan_statistics full(e) */ *
from emp e
where department_id = 50;