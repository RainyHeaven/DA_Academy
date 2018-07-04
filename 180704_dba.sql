ALTER SYSTEM FLUSH SHARED_POOL;

SELECT sql_id, sql_text, parse_calls, executions
FROM v$sql
WHERE sql_text LIKE '%employees%'
AND sql_text NOT LIKE '%v$sql%';
-- parse_calls: parsing 한 횟수 / executions: 실행횟수

SELECT * FROM nls_database_parameters;
/* 
NLS_CHARACTERSET: DB의 characterset, OS의 영향을 받음 / char, varchar2, long, clob
AL32UTF8: unicode, 전세계 출판되는 글자는 모두 입력 가능, 한글은 3 byte
KO16MSWIN949: 한글, 영어, 한자, 일어 입력 가능, 한글은 2 byte 

NLS_NCHAR_CHARACTERSET: national characterset / nchar, nvarchar2, nclob
AL16UTF16: unicode
*/