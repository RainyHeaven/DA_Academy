-- 권한: 특정한 SQL문을 수행할 수 있는 권리
--시스템 권한 확인
----내게 부여된 권한 확인(user_sys_privs + role_sys_privs)
select *from session_privs;

---- DBA로부터 직접 받은 권한확인
select * from user_sys_privs;

----내가 받은 role확인
select * from session_roles;

----내 role에 부여된 권한 확인
select * from role_sys_privs;

--object권한 확인
----내가 받은 객체권한과 내가 부여한 객체권한에 대한 정보 확인
select * from user_tab_privs;

----내 role에 부여된 객체 권한 확인
select * from role_tab_privs;

show user;

-- 내가 가지고 있는 테이블 목록
select * from user_tables;
