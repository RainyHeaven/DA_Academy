-- ����: Ư���� SQL���� ������ �� �ִ� �Ǹ�
--�ý��� ���� Ȯ��
----���� �ο��� ���� Ȯ��(user_sys_privs + role_sys_privs)
select *from session_privs;

---- DBA�κ��� ���� ���� ����Ȯ��
select * from user_sys_privs;

----���� ���� roleȮ��
select * from session_roles;

----�� role�� �ο��� ���� Ȯ��
select * from role_sys_privs;

--object���� Ȯ��
----���� ���� ��ü���Ѱ� ���� �ο��� ��ü���ѿ� ���� ���� Ȯ��
select * from user_tab_privs;

----�� role�� �ο��� ��ü ���� Ȯ��
select * from role_tab_privs;

show user;

-- ���� ������ �ִ� ���̺� ���
select * from user_tables;
