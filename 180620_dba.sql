select * 
from v$sql -- shared pool ���� library cache, dba�� Ȯ�� ����
where sql_text like 'select * from emp%'
and sql_text not like '%v$sql%';

alter system flush shared_pool; -- shared_pool�� �ʱ�ȭ ��Ű�� ��ɾ�. ���װ� ���� �� �־� 3�� ���� �ʿ�

select *
from v$sql_plan
where sql_id = '0t028xxgcphg0';

-- �����ȹ�� �� �� �������ϰ� �ϴ� ��Ű�� dbms_xplan
select * from table(dbms_xplan.display_cursor('0t028xxgcphg0'));
--�����ȹ�� ���� ���� depth���� Ȯ��

select * from dba_segments where segment_name = 'EMP';

-- �ѹ��� �ö󰡴� block�� ��
show parameter db_file_multiblock_read_count

-- �ѹ��� �д� block�� �� ���� (�ڽ��� ���ǿ��� ����)
alter session set db_file_multiblock_read_count = 128;