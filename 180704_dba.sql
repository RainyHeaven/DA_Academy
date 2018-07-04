ALTER SYSTEM FLUSH SHARED_POOL;

SELECT sql_id, sql_text, parse_calls, executions
FROM v$sql
WHERE sql_text LIKE '%employees%'
AND sql_text NOT LIKE '%v$sql%';
-- parse_calls: parsing �� Ƚ�� / executions: ����Ƚ��

SELECT * FROM nls_database_parameters;
/* 
NLS_CHARACTERSET: DB�� characterset, OS�� ������ ���� / char, varchar2, long, clob
AL32UTF8: unicode, ������ ���ǵǴ� ���ڴ� ��� �Է� ����, �ѱ��� 3 byte
KO16MSWIN949: �ѱ�, ����, ����, �Ͼ� �Է� ����, �ѱ��� 2 byte 

NLS_NCHAR_CHARACTERSET: national characterset / nchar, nvarchar2, nclob
AL16UTF16: unicode
*/