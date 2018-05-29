-- ����22 employees(���)���̺� �ִ� last_name�� ����° ���ڰ� 'a' �Ǵ� 'e'�� ���Ե� ��� ����� last_name�� ��ȸ�ϼ���.
select last_name
from employees
where substr(last_name, 3, 1) in ('a', 'e');

select last_name
from employees
where last_name like '__a%' or last_name like '__e%';

select last_name
from employees
where instr(last_name, 'a', 3, 1) = 3 or instr(last_name, 'e', 3, 1) = 3;

-- ��ŸƮ������ �ٲٴ� ���� �۵� ���ϴ� ��찡 ����
select last_name
from employees
where instr(last_name, 'a') = 3 
or instr(last_name, 'a', 1, 2) = 3
or instr(last_name, 'a', 1, 3) = 3
or instr(last_name, 'e') = 3 
or instr(last_name, 'e', 1, 2) = 3
or instr(last_name, 'e', 1, 3) = 3;

-- ����23 employees(���)���̺� �ִ�  80�� �μ�(department_id) ����߿� commission_pct ���� 0.2 �̰� job_id�� SA_MAN�� ����� employee_id, last_name, salary�� ��ȸ�ϼ���.
select employee_id, last_name, salary
from employees
where department_id = 80 and commission_pct = 0.2 and job_id = 'SA_MAN';

-- ����24 ����� employees(���)���̺� �ִ� last_name,hire_date �� �ٹ� 6 ���� �� ù��° �����Ͽ� �ش��ϴ� �޿� ���� ��¥�� ǥ���մϴ�.
-- �� ���̺��� REVIEW �� �����մϴ�. ��¥�� "������, the Second of 4, 2007"�� ������ �������� ��Ÿ������ �����մϴ�.
select last_name, hire_date, to_char(next_day(add_months(hire_date, 6), '������'), 'day, "the" ddspth "of" dd, yyyy') as REVIEW
from employees;

-- ����25 employees(���) ���̺���  �Ͽ��Ͽ� �Ի��� ����� ������ ��ȸ�ϼ���.
select *
from employees
where to_char(hire_date, 'day') = '�Ͽ���';

select *
from employees
where to_char(hire_date, 'd') = '1';

-- ����26 ¦���޿� �Ի��� ����� ������ ��ȸ�ϼ���.
select *
from employees
where mod(to_number(to_char(hire_date, 'fmmm')), 2) = 0;

-- ����27 2006�⵵�� Ȧ�� �޿� �Ի��� ����� employee_id, last_name, hire_date�� ��ȸ�ϼ���.
select employee_id, last_name, hire_date
from employees
where hire_date  between to_date('20050101', 'yyyymmdd') and to_date('20051231', 'yyyymmdd') and mod(to_number(to_char(hire_date, 'fmmm')), 2) = 1;

-- ����ȯ �Լ�
desc employees

select *
from employees
where department_id = '10';

select *
from employees
where hire_date = '2001/01/01';

select last_name || salary
from employees;

-- �����ð�
select sysdate
from dual;

select to_char(sysdate, 'yyyy year mm month mon dd day dy')
from dual;

select to_char(sysdate, 'ddd dd d q"�б�"')
from dual;

-- fm: �մ���0 ���� am or pm: �ð��� ����/���� ǥ��
select to_char(sysdate, 'fmhh:mi:ss.sssss pm')
from dual;

--sp: ��¥�� ���ڷ� ǥ�� th: ������ ǥ��
select to_char(sysdate, 'ddspth')
from dual;

-- �������� ���� ������ �����ϱ� ���� ���
select to_char(hire_date, 'day')
from employees
order by to_char(hire_date-1, 'd');

-- bc: ���� scc: ���� ww: ����������
select to_char(sysdate, 'bc scc yyyy ww w')
from dual;

-- g: õ���� ������ d: �Ҽ��� ������ l: ������ȭ��ȣ
select to_char(salary, '$999,999,999.00'), to_char(salary, '999.00'),
       to_char(salary, 'l999g999d00')
from employees;

-- ���� ���� Ȯ��
select * from nls_session_parameters;

-- ������ ����, ��� ���� ����. �̹� ���ǿ��� �����.
ALTER SESSION SET NLS_TERRITORY=KOREA;
ALTER SESSION SET NLS_LANGUAGE =KOREAN;

ALTER SESSION SET NLS_TERRITORY = GERMANY;
ALTER SESSION SET NLS_LANGUAGE= GERMAN;

ALTER SESSION SET NLS_LANGUAGE =JAPANESE;
ALTER SESSION SET NLS_TERRITORY=JAPAN;

ALTER SESSION SET NLS_LANGUAGE =FRENCH;
ALTER SESSION SET NLS_TERRITORY=FRANCE;

ALTER SESSION SET NLS_TERRITORY=AMERICA;
ALTER SESSION SET NLS_LANGUAGE =AMERICAN;

ALTER SESSION SET NLS_TERRITORY=china;
ALTER SESSION SET NLS_LANGUAGE = 'simplified chinese';

select employee_id, 
      to_char(salary,'l999g999d00'),
      to_char(hire_date, 'YYYY-MONTH-DD DAY')
from employees;

select sysdate from dual;
alter session set nls_date_format='yyyymmdd';

select *
from employees
where hire_date > '20020101';

-- sysdate, systimestamp: ������ �ð� current_date, current_timestamp, localtimestamp : ����(Ŭ���̾�Ʈ)�� �ð�
select sysdate, systimestamp, current_date, current_timestamp, localtimestamp
from dual;

alter session set time_zone = '+09:00';

select to_char(sysdate, 'yyyymmdd hh24:mi:ss.sssss'), systimestamp, 
to_char(current_date, 'yyyymmdd hh24:mi:ss.sssss'), current_timestamp, localtimestamp
from dual;

select sysdate + to_yminterval('01-00') from dual;

select sysdate + to_dsinterval('100 00:00:00') from dual;

select to_char(sysdate, 'yyyy') 
from dual;

select localtimestamp
from dual;
alter session set time_zone = 'Asia/Seoul';
select extract(year from sysdate) from dual;
select extract(month from sysdate) from dual;
select extract(day from sysdate) from dual;
select extract(hour from localtimestamp) from dual;
select extract(minute from localtimestamp) from dual;
select extract(second from localtimestamp) from dual;
select extract(timezone_hour from systimestamp) from dual;
select extract(timezone_minute from systimestamp) from dual;
select extract(timezone_region from current_timestamp) from dual;
select extract(timezone_abbr from current_timestamp) from dual;

select * from v$timezone_names;

select last_name, salary, commission_pct, 
(salary * 12) + (salary * 12 * commission_pct) as "1",
(salary * 12) + (salary * 12 * nvl(commission_pct, 0)) as "2"
from employees;

-- nvl ���� ���ڵ��� Ÿ���� ��ġ�ؾ� ��
select employee_id, nvl(to_char(commission_pct), 'no comm')
from employees;

select employee_id, 
nvl2(commission_pct, '(salary * 12) + (salary * 12 * commission_pct)', 'salary * 12'),
coalesce((salary * 12) + (salary * 12 * commission_pct), salary * 12, salary)
from employees;

select employee_id, nullif(length(last_name), length(first_name))
from employees;

select *
from employees
where commission_pct is null;

select *
from employees
where commission_pct is not null;