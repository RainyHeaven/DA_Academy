-- index scan의 방식
-- rowid 검색
select employee_id, rowid
from employees
order by 1;
-- rowid로 데이터 찾기
select *
from employees
where rowid = 'AAAEAbAAEAAAADOAAC'