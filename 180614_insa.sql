-- 문제 95  insa 유저는 테이블논리적설계.pdf에 ERD(Entity Relationship Diagram)을 확인 한후 table instance chart를  보면서 테이블을 구성하세요.

create table dept
(dept_id number(3) constraint dept_id_pk primary key,
 dept_name varchar2(50) constraint dept_nn not null 
                        constraint dept_uk unique,
 mgr number(5));
 
 create table emp
 (id number(5) constraint emp_id_pk primary key,
  name varchar2(50) constraint emp_name_nn not null,
  hire_date date constraint emp_date_nn not null,
  sal number(8, 2) constraint emp_sal_ck check(sal > 100),
  mgr number(5),
  dept_id number(3),
  constraint emp_dept_id_fk foreign key(dept_id) references dept(dept_id),
  constraint emp_mgr_fk foreign key(mgr) references emp(id));
  
  desc emp;
  desc dept;
  
  select * from user_constraints where table_name = 'DEPT';
  
  alter table emp modify dept_id constraint emp_dept_id_nn not null;
  
  -- 지금부터 들어오는 새로운 데이터만 제약조건 체크
  --validate: 이관되는 데이터 체크 / novalidate: 새롭게 들어오는 데이터부터 체크
  alter table emp modify dept_id constraint emp_dept_id_nn not null enable novalidate;
  
  --novalidate 확인
select *
from user_constraints
where table_name = 'EMP';
  
--제약조건 비활성화
--disable novalidate: 대용량 데이터를 이관 할 때 속도저하를 방지하기 위해 비활성화(disable의 default)
--disable validate: 대상 테이블 DML 불허, 읽기 전용 성격의 테이블
--제약조건 활성화
--enable novalidate: 기존 값 검증하지 않음
--enable validate: 기존값 검증(enable의 default)

drop table test purge;
create table test(id number constraint test_id_nn not null disable novalidate);
  
select * 
from user_constraints
where table_name = 'TEST';

-- null임에도 insert가 가능
insert into test(id)
values(null);

rollback;

alter table test
modify id constraint test_id_nn not null disable validate;

drop table test purge;
create table test
(id number,
 name char(10),
 sal number);
 insert into test(id, name, sal) values(1, 'a', 1000);
 insert into test(id, name, sal) values(2, 'b', 100);
 insert into test(id, name, sal) values(1, 'a', 2000);
 commit;
 
 select * from test;
 
 -- enable validate가 기본 값이어서 primary key의 조건과 오류 발생
 alter table test add constraint test_id_pk primary key(id);
 
 -- primary key는 enable novalidate가 불가
 alter table test add constraint test_id_pk primary key(id)
 enable novalidate;
 
 --disable 기본값 disable novalidate
 alter table test add constraint test_id_pk primary key(id) disable;
 select * from user_constraints where table_name = 'TEST';
 
  --윈도우즈의 환경값에 등록되어있는 정보를 가져옴
  --제약조건 활성화에 문제되는 데이터들을 위한 exceptions 테이블 생성
 @%ORACLE_HOME%\rdbms\admin\utlexpt1
 
 select * from tab;
 
 desc exceptions;
 
 --exceptions into 테이블명: 위반되는 컬럼은 지정된 테이블에 넣음
 alter table test enable constraint test_id_pk
 exceptions into exceptions;
 
 select * from exceptions;
 
 --rowid로 오류 확인 후 수정
 select * from test where rowid = 'AAAE/mAAEAAAAIFAAA';
 
 update test
 set id = 3
 where rowid = 'AAAE/mAAEAAAAIFAAA';
 
 alter table test add constraint test_sal_ck check(sal > 1000)
 enable novalidate;
 
 insert into test(id, name, sal)
 values(4, 'c', 500);
 
 -- primary key와 unique 제약조건은 만들 때 부터 disable로 해야함(이후 enable novalidate 불가능)
 -- not null, foreign key, check 제약조건은 enable novalidate 가능
 
 alter table test enable constraint test_sal_ck
 exceptions into exceptions;
 
 alter table test add constraint test_sal_ck check(sal > 1000) enable novalidate;
 
 delete from exceptions;
 
 commit;
 
 alter table test enable constraint test_sal_ck exceptions into exceptions;
 
 select * from exceptions;
 
 update test
 set sal = null
 where rowid in ('AAAE/mAAEAAAAIFAAA', 'AAAE/mAAEAAAAIFAAB');
 
 select * from test;
 
 commit;
 
 delete from exceptions;
 
 commit;
 
 alter table test enable constraint test_sal_ck exceptions into exceptions;
 
 select * from exceptions;