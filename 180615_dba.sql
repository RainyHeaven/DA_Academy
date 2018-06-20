--External Table

-- 물리적 주소 입력
create directory new_data_dir as 'C:\Users\stu\git\DA_Academy\data';

-- 디렉토리 확인
select * from dba_directories;

--권한부여
grant read, write on directory data_dir to hr;

-- 디렉토리 삭제
drop directory new_data_dir;
