-- 딕셔너리 테이블 뷰: 간접 액세스를 위한 뷰
select * from dba_users;

-- 실제 테이블
select * from user$;

select * from dba_data_files;

-- 정렬을 위한 임시 공간
select * from dba_temp_files;

select * from dba_objects where owner = 'HR';

select * from dict;

-- 유저생성
-- default tablespace 설정을 하지 않을 시 system으로 설정됨
create user ora10
identified by oracle;

select * from dba_users where username = 'ORA10';

alter user ora10 default tablespace users;

select * from dba_ts_quotas;

-- 테이블 용량 부여
alter user ora10 quota 1m on users;

-- 무제한 용량 부여
alter user ora10 quota unlimited on users;

-- 패스워드 변경
alter user ora10 identified by ora10;

-- 권한 부여
grant create session to ora10;
grant create table to ora10;

-- 권한 확인
select * from dba_sys_privs where grantee = 'ORA10';

alter user ora10 account lock;
select * from dba_users where username = 'ORA10';
alter user ora10 account unlock;

create table emp(id number(4), name varchar2(10), day date default sysdate) tablespace users;