-- index scan�� ���
-- rowid �˻�
select employee_id, rowid
from employees
order by 1;
-- rowid�� ������ ã��
select *
from employees
where rowid = 'AAAEAbAAEAAAADOAAC'