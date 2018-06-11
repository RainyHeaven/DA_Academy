select * from user_users;

-- 테이블 생성
create table test(id number);
select * from user_tables;
create table test1(id number) tablespace users;

-- 테이블 삭제
drop table test purge;
drop table test1 purge;

create table emp (id number(4), name varchar2(20), day date) tablespace users;

select * from emp;

-- 새로운 row 삽입
desc emp --데이터 타입 확인 후 생성

insert into emp(id, name, day)
values(1, '홍길동', to_date('2018-06-11', 'yyyy-mm-dd'));

insert into emp(id, name, day)
values(2, '박찬호', sysdate);

--data에 null을 넣는 방법
insert into emp(id, name, day)
values(3, '박지성', null);

insert into emp(id, name)
values(4, '차두리');

insert into emp
values(5, '손흥민', sysdate);

--되돌리기
rollback;

--저장
commit;

create table emp_new(id number(4), name varchar2(20), day date)
tablespace users;

select * from emp;
select * from emp_new;

-- 테이블 복제
-- 데이터를 복제하여 삽입
insert into emp_new(id, name, day)
select * from emp;

drop table emp_new purge;

-- 그대로 복제하여 테이블 생성
create table emp_new
as select * from emp;

-- 테이블의 구조만 복제하여 새로운 테이블 생성
create table emp_new
as select * from emp where 1=2;

commit;
rollback;