--���� 90 ���ο� user�� �����ϼ���
-- �����̸�: insa default tablespace : users temporary tablespace : temp 	users tablespace ��뷮 : 1m

create user insa
identified by oracle
default tablespace users
temporary tablespace temp
quota 1m on users;

select * from dba_sys_privs where grantee = 'insa';

-- ���� 91 insa�������� create session, create table �ý��� ������ �ο����ּ���
grant create session, create table to insa;

-- ���� 92 insa ������ ����� �� �ִ� users tablespace quota ���� unlimited�� �����ϼ���
alter user insa
quota unlimited on users;

select * from dba_ts_quotas;
select * from user_ts_quotas;

-- ���� 93 hr������ ������ employees ���̺��� select ��ü ������ insa�������� �ο��� �ּ���
grant select on hr.employees to insa;

--ȸ��
revoke select on hr.employees from insa;

-- ���� 94 hr������ ������ departments ���̺��� select ��ü ������ insa�������� �ο����ּ���
<<<<<<< HEAD
grant select on hr.departments to insa;
=======
grant select on hr.departments to insa;
>>>>>>> 6337a0f3f6536bffb695d3f98e9b0425f803ca87
