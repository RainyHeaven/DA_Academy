create table empxt
(id number, name varchar2(30), hire_date date, sal number, dept_id number)
organization external
(type oracle_loader --type 설정 환경구성
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

-- external table 확인
select * from user_external_tables;

select * from user_external_locations;

--내가 사용할 수 있는 디렉토리 확인(디렉토리는 dba만 만들 수 있음)
select * from all_directories;

-- spool
-- 쿼리문장을 미리 작성하여 실행시킬 수 있는 기능 (커맨드라인 작업환경에서 필요)

-- 메모장에서 환경설정과 select문장을 작성하여 sql파일로 저장
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

-- 커맨드라인에서 파일 실행 시 지정한 파일로 저장됨
@C:\Users\stu\git\DA_Academy\data\emp.sql

set pagesize 0 -- 중간중간의 컬럼 생략
set linesize 200
set echo off -- sql문장은 스풀에서 제외
set termout off -- 화면에 결과물 출력 생략
set trimspool on -- 라인 뒤에 공백줄을 만들지 않음
set feedback off -- 셀렉문에 대한 피드백(시스템) 메시지 생략
spool c:\data\emp_sal.dat

select employee_id ||','|| last_name ||','||
	hire_date ||','||salary ||','||
	department_id
from employees
order by 1;
spool off
