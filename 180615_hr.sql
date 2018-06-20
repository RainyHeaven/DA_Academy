create table empxt
(id number, name varchar2(30), hire_date date, sal number, dept_id number)
organization external
(type oracle_loader --type ���� ȯ�汸��
 default directory data_dir
 access parameters
 (records delimited by newline
  badfile 'empxt.log'
  logfile 'empxt.log'
  fields terminated by ''
  missing field values are null
  (id, name, hire_date char date_format date mask 'yy/mm/dd', sal, dept_id)
  )
 location('emp1.csv')
 )
reject limit unlimited;

-- external table Ȯ��
select * from user_external_tables;

select * from user_external_locations;

--���� ����� �� �ִ� ���丮 Ȯ��(���丮�� dba�� ���� �� ����)
select * from all_directories;

-- spool
-- ���������� �̸� �ۼ��Ͽ� �����ų �� �ִ� ��� (Ŀ�ǵ���� �۾�ȯ�濡�� �ʿ�)

-- �޸��忡�� ȯ�漳���� select������ �ۼ��Ͽ� sql���Ϸ� ����
set pagesize 0
set linesize 200
set echo off
set termout off
set trimspool on
set feedback off
spool c:\data\emp_sal.dat

select employee_id ||','|| last_name ||','||
	hire_date ||','||salary ||','||
	department_id
from employees
order by 1;
spool off

-- Ŀ�ǵ���ο��� ���� ���� �� ������ ���Ϸ� �����
@C:\Users\stu\git\DA_Academy\data\emp.sql

set pagesize 0 -- �߰��߰��� �÷� ����
set linesize 200
set echo off -- sql������ ��Ǯ���� ����
set termout off -- ȭ�鿡 ����� ��� ����
set trimspool on -- ���� �ڿ� �������� ������ ����
set feedback off -- �������� ���� �ǵ��(�ý���) �޽��� ����
spool c:\data\emp_sal.dat

select employee_id ||','|| last_name ||','||
	hire_date ||','||salary ||','||
	department_id
from employees
order by 1;
spool off
