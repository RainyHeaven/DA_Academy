--������ ���丮 ����
create directory data_dir as 'C:\Users\stu\git\DA_Academy\data\';

--���丮 ������ �ο�
grant read, write on directory data_dir to hr;

--ȸ��
revoke read, write on directory data_dir from hr;