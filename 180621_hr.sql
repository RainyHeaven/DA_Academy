-- [문제109] emp 테이블을 생성한 후 통계정보를 확인 한후 통계수집을 하세요.
drop table emp purge;
create table emp
as select * from employees;

-- 통계정보 확인
select *
from user_tables
where table_name = 'EMP';

-- 통계정보 수집 no_invalidate 는 invalidation을 즉시하지 않겠다는 옵션
exec dbms_stats.gather_table_stats('hr', 'emp', no_invalidate => False);


-- [문제110] select문의 실행계획을 확인 한 후 filter를 access로 해결해 주세요.
select * from emp where employee_id = 100;

-- 실행계획을 plan_table에 저장
explain plan for select * from emp where employee_id = 100;

-- dbms_stats을 활용하여 실행계획을 보기좋게 확인
select * from table(dbms_xplan.display(null, null, 'typical'));

-- employee_id에 index를 걸어주자
-- PK만들기
alter table emp add constraint emp_id_pk primary key(employee_id);
-- 삭제
alter table emp drop constraint emp_id_pk;

-- unique index만들기
create unique index emp_id_unq_idx on emp(employee_id);
-- 삭제
drop index emp_id_unq_idx;


-- [문제111] select문의 실행계획을 확인 한 후 filter를 access로 해결해 주세요.
select * from emp where department_id = 10;

-- 실행계획을 테이블에 저장
explain plan for select * from emp where department_id = 10;

-- 실행계획을 확인
select * from table(dbms_xplan.display(null, null, 'typical'));

-- 중복값과 null값이 있어 PK는 불가
-- index 만들기
create index emp_dpid_idx on emp(department_id);

select * from user_ind_columns where table_name = 'EMP';


-- [문제112] select문의 실행계획을 확인 한 후 filter를 access로 해결해 주세요.
select * from emp where last_name = 'King' and first_name = 'Steven';

-- 실행계획 테이블에 저장
explain plan for select * from emp where last_name = 'King' and first_name = 'Steven';

-- xplan 으로 확인
select * from table(dbms_xplan.display(null, null, 'typical'));

-- composite index 생성
create index emp_lname_fname_idx on emp(last_name, first_name);




select * from user_tables;

select * from user_ind_columns where table_name = 'EMP';