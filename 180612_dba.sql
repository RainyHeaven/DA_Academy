-- ��ųʸ� ���̺� ��: ���� �׼����� ���� ��
select * from dba_users;

-- ���� ���̺�
select * from user$;

select * from dba_data_files;

-- ������ ���� �ӽ� ����
select * from dba_temp_files;

select * from dba_objects where owner = 'HR';

select * from dict;

-- ��������
-- default tablespace ������ ���� ���� �� system���� ������
create user ora10
identified by oracle;

select * from dba_users where username = 'ORA10';

alter user ora10 default tablespace users;

select * from dba_ts_quotas;

-- ���̺� �뷮 �ο�
alter user ora10 quota 1m on users;

-- ������ �뷮 �ο�
alter user ora10 quota unlimited on users;

-- �н����� ����
alter user ora10 identified by ora10;

-- ���� �ο�
grant create session to ora10;
grant create table to ora10;

-- ���� Ȯ��
select * from dba_sys_privs where grantee = 'ORA10';

alter user ora10 account lock;
select * from dba_users where username = 'ORA10';
alter user ora10 account unlock;

create table emp(id number(4), name varchar2(10), day date default sysdate) tablespace users;