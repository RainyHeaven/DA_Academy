--dba 
select * from session_privs;
----�ý��۱����� � �������� �ο��ߴ���
select * from dba_sys_privs;
----��ü������ � �������� �ο��ߴ���
select * from dba_tab_privs;
----db�� role�� ���� ����
select * from dba_roles;
----role�� � �������� �ο��ߴ���
select * from dba_role_privs;

----db�� �����Ǿ� �ִ� ���� ���� Ȯ��
select * from dba_users;

---- tablespace ������ Ȯ��
select * from dba_tablespaces;

---- �������� ������� ���� Ȯ��
select * from dba_data_files;

--���� ����
create user olap
identified by oracle
default tablespace users -- ���Ͱ��� ���� ������ ���̺����̽� ��� X
temporary tablespace temp
quota 10m on users; --���̺����̽��� ����ϱ� ���� �Ǹ� �ο�

-- ���� ����
alter user olap
identified by oracle
default tablespace users
temporary tablespace temp
quota 10m on users;

select * from dba_users;
--���̺� �����̽� Ȯ��
select * from dba_ts_quotas;

--���Ѻο�
grant create session to olap;
grant create table to olap;

--�ο��� ���� Ȯ��
select * from dba_sys_privs where grantee = 'OLAP';

--���� ȸ��
revoke create session from olap;

-- ���� Ȯ��
select * from v$session where username = 'OLAP';

-- session kill
alter system kill session '48, 413' immediate;
alter system kill session '67, 247' immediate;

-- ���� ����
drop user olap cascade;

