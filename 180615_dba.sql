--External Table

-- ������ �ּ� �Է�
create directory new_data_dir as 'C:\Users\stu\git\DA_Academy\data';

-- ���丮 Ȯ��
select * from dba_directories;

--���Ѻο�
grant read, write on directory data_dir to hr;

-- ���丮 ����
drop directory new_data_dir;
