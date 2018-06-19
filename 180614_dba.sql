--문제 90 새로운 user를 생성하세요
-- 유저이름: insa default tablespace : users temporary tablespace : temp 	users tablespace 사용량 : 1m

create user insa
identified by oracle
default tablespace users
temporary tablespace temp
quota 1m on users;

select * from dba_sys_privs where grantee = 'insa';

-- 문제 91 insa유저에게 create session, create table 시스템 권한을 부여해주세요
grant create session, create table to insa;

-- 문제 92 insa 유저가 사용할 수 있는 users tablespace quota 값을 unlimited로 수정하세요
alter user insa
quota unlimited on users;

select * from dba_ts_quotas;
select * from user_ts_quotas;

-- 문제 93 hr유저가 소유한 employees 테이블의 select 객체 권한을 insa유저에게 부여해 주세요
grant select on hr.employees to insa;

--회수
revoke select on hr.employees from insa;

-- 문제 94 hr유저가 소유한 departments 테이블의 select 객체 권한을 insa유저에게 부여해주세요
grant select on hr.departments to insa;