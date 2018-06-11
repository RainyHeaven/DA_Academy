--dba 
select * from session_privs;
----시스템권한을 어떤 유저에게 부여했는지
select * from dba_sys_privs;
----객체권한을 어떤 유저에게 부여했는지
select * from dba_tab_privs;
----db의 role에 대한 정보
select * from dba_roles;
----role을 어떤 유저에게 부여했는지
select * from dba_role_privs;

----db에 생성되어 있는 유저 정보 확인
select * from dba_users;

---- tablespace 정보를 확인
select * from dba_tablespaces;

---- 물리적인 저장공간 정보 확인
select * from dba_data_files;

--유저 생성
create user olap
identified by oracle
default tablespace users -- 쿼터값을 주지 않으면 테이블스페이스 사용 X
temporary tablespace temp
quota 10m on users; --테이블스페이스를 사용하기 위한 권리 부여

-- 유저 수정
alter user olap
identified by oracle
default tablespace users
temporary tablespace temp
quota 10m on users;

select * from dba_users;
--테이블 스페이스 확인
select * from dba_ts_quotas;

--권한부여
grant create session to olap;
grant create table to olap;

--부여한 권한 확인
select * from dba_sys_privs where grantee = 'OLAP';

--권한 회수
revoke create session from olap;

-- 접속 확인
select * from v$session where username = 'OLAP';

-- session kill
alter system kill session '48, 413' immediate;
alter system kill session '67, 247' immediate;

-- 유저 삭제
drop user olap cascade;

