--논리적인 디렉토리 생성
create directory data_dir as 'C:\Users\stu\git\DA_Academy\data\';

--디렉토리 사용권한 부여
grant read, write on directory data_dir to hr;

--회수
revoke read, write on directory data_dir from hr;