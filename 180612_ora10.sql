insert into emp(id, name, day)
values(1, '홍길동', to_date('2018-06-10', 'yyyy-mm-dd'));

commit;
select * from emp;

-- default 값 넣기
-- default입력
insert into emp(id, name, day)
values(2, '박찬호', default);
-- default 값이 있는 컬럼 제외
insert into emp(id, name)
values(3, '박지성');
-- null > default
insert into emp(id, name, day)
values(4, '차두리', null);
-- default 값이 없을때 default 입력시 null
insert into emp(id, name, day)
values(5, default, default);

commit;

--update
update emp
set day = sysdate - 10
where id = 4;

rollback;

select * from emp;

update emp
set name = '손흥민'
where id = 5;
commit;

insert into emp(id, name, day)
values(6, null, null);
commit;

update emp
set name = '나얼', day = default
where id = 6;
select * from emp;
commit;

delete from emp;
select * from emp;
rollback;

delete from emp where id = 6;

select * from emp;

delete from emp where id = 5;

create table emp_new
(id number, name varchar2(20), day date)
tablespace users;

rollback;

select * from hr.employees;
select * from user_tab_privs;

select e.last_name, d.department_name
from hr.employees e, hr.departments d
where  e.department_id = d.department_id;

insert into emp(id, name, day)
select employee_id, last_name, hire_date 
from hr.employees
where department_id = 30;
rollback;
select * from emp;
commit;

create table emp_copy
as select * from hr.employees where 1=2;

select * from emp_copy;

insert into emp_copy
select * from hr.employees;

rollback;

create table dept_copy
as select * from hr.departments;

drop table test1 purge;

create table emp
as select employee_id, last_name, salary, department_id
from hr.employees
where 1=2;

desc emp

-- CTAS(Create Tabe AS)
create table dept
as select * from hr.departments where 1 = 2;

--컬럼추가
alter table emp add job_id varchar2(10);

--컬럼수정
alter table emp modify job_id varchar2(20);

--컬럼삭제
-- 바로삭제 / 삭제되는 동안 테이블 사용 불가
alter table emp drop columns job_id;

-- 사용하지 않는 컬럼으로 지정하고 추후 삭제
alter table emp set unused(salary);
alter table emp drop unused columns;

select * from user_unused_col_tabs;

desc emp
desc dept

insert into emp(employee_id, last_name, department_id)
values(1, 'hong', 10);

insert into emp(employee_id, last_name, department_id)
values(1, 'kim', 10);

insert into emp(employee_id, last_name, department_id)
values(null, 'kim', 10);

--제약조건
--primary key

--제약조건 확인
select * from user_constraints
where table_name = 'EMP';

--제약조건 설정
alter table emp
add constraints emp_id_pk primary key(employee_id);

alter table dept 
add constraint dept_id_pk primary key(department_id);

select * from user_constraints
where table_name = 'DEPT';

--foreign key
alter table emp
add constraint emp_dept_id_fk
foreign key(department_id)
references dept(department_id);

drop table dept purge;
create table dept
as select * from hr.departments;

select *
from user_constraints
where table_name = 'EMP';a

alter table dept
add constraint dept_id_pk primary key(department_id);

select * 
from user_constraints
where table_name = 'DEPT';

--제약조건 삭제
alter table emp drop primary key;
alter table dept drop primary key cascade;

alter table dept drop constraint dept_id_pk cascade;

drop table emp purge;
drop table dept purge;

--테이블 생성시 제약조건 설정
create table emp
(id number, 
 name varchar2(20) constraint emp_name_nn not null, --열 레벨 정의
 sal number,
 dept_id number,
 constraint emp_id_pk primary key(id),
 constraint emp_sal_ck check(sal > 500)), --체크제약조건 / DML문장 수행시 작동
 constraint emp_dept_id_fk foreign key(dept_id) references dept(dept_id);

create table emp
(id number, 
 name varchar2(20) constraint emp_name_nn not null,
 sal number,
 dept_id number constraint emp_dept_id_fk references dept(dept_id), -- fk 열레벨 정의시 foreign key(dept_id)는 생략
 constraint emp_id_pk primary key(id),
 constraint emp_sal_ck check(sal > 500));
 
 
insert into emp(id, name, sal, dept_id)
values(1, '홍길동', null, 10);
 
insert into emp(id, name, sal, dept_id)
values(null, '박찬호', 1000, 10);
 
select * from emp;

rollback;

create table dept
(dept_id number constraint dept_id_pk primary key,
 dept_name varchar2(20) constraint dept_name_uk unique);
 
insert into dept(dept_id, dept_name)
values(10, '총무부');

insert into dept(dept_id, dept_name)
values(20, '데이터분석팀'); 
commit;
rollback;

insert into emp(id, name, sal, dept_id)
values(1, '홍길동', 1000, null);

alter table emp
add constraint emp_dept_id_fk
foreign key(dept_id)
references dept(dept_id);

insert into emp(id, name, sal, dept_id)
values(1, null, 1000, null);

-- not null 제약조건 / 테이블 생성시에는 열레벨 정의만 가능
alter table emp modify name constraint emp_name_nn not null;

-- not null 제약조건
alter table emp modify name null;
alter table emp drop constraint emp_name_nn;
