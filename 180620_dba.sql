select * 
from v$sql -- shared pool 안의 library cache, dba만 확인 가능
where sql_text like 'select * from emp%'
and sql_text not like '%v$sql%';

alter system flush shared_pool; -- shared_pool을 초기화 시키는 명령어. 버그가 있을 수 있어 3번 실행 필요

select *
from v$sql_plan
where sql_id = '0t028xxgcphg0';

-- 실행계획을 좀 더 보기편하게 하는 패키지 dbms_xplan
select * from table(dbms_xplan.display_cursor('0t028xxgcphg0'));
--실행계획은 가장 깊은 depth부터 확인

select * from dba_segments where segment_name = 'EMP';

-- 한번에 올라가는 block의 수
show parameter db_file_multiblock_read_count

-- 한번에 읽는 block의 수 설정 (자신의 세션에만 적용)
alter session set db_file_multiblock_read_count = 128;