-- ���� 28 �Ʒ� ȭ���� ��� ó�� �����  last_name,  salary, salary ���� 1000�� ��ǥ�� �ϳ��� ����ϴ�  query���� �ۼ��ϼ���. 
select last_name, salary, lpad('*', trunc(salary/1000), '*') as "STAR"
from employees
order by salary desc;

-- ���� 29 �Ʒ� ȭ���� ó�� ����ϼ���.
select '���� ������ ��¥ �ð� : ' || to_char(sysdate, 'yyyymmdd hh:mi:ss am') as "���糯¥�ð�"
from dual;

-- ���� 30 �Ʒ� ȭ���� ó�� ����ϼ���
select '������ �ð��� �������� �Ϸ� �� : ' || to_char(sysdate-1, 'yyyymmdd hh24:mi:ss') as "�Ϸ���"
from dual;

-- ���� 31 �Ʒ� ȭ���� ó�� ����ϼ���
select '������ �ð��� �������� 1�ð� �� : ' || to_char(sysdate-1/24, 'yyyymmdd hh24:mi:ss') as "1�ð���"
from dual;

select '������ �ð��� �������� 1�ð� �� : ' || to_char(sysdate-to_dsinterval('0 01:00:00'), 'yyyymmdd hh24:mi:ss') as "1�ð���"
from dual;

-- ���� 32 �Ʒ� ȭ���� ó�� ����ϼ���
select '������ �ð��� �������� 5�� �� : ' || to_char(sysdate-to_dsinterval('0 00:05:00'), 'yyyymmdd hh24:mi:ss') as "5����"
from dual;

select '������ �ð��� �������� 5�� �� : ' || to_char(sysdate-5/(24*60), 'yyyymmdd hh24:mi:ss') as "5����"
from dual;

-- ���� 33 �Ʒ� ȭ���� ó�� ����ϼ���
select '������ �ð��� �������� 10�� �� : ' || to_char(sysdate-to_dsinterval('0 00:00:10'), 'yyyymmdd hh24:mi:ss') as "10����"
from dual;

select '������ �ð��� �������� 10�� �� : ' || to_char(sysdate-10/(24*60*60), 'yyyymmdd hh24:mi:ss') as "10����"
from dual;

-- ���� 34 JOB_ID ���� ���� �������� ��� ����� ���(GRADE)�� ǥ���ϴ� query �� �ۼ��ϼ���.
select job_id, decode(job_id, 'AD_PRES', 'A', 'ST_MAN', 'B', 'IT_PROG', 'C', 'SA_REP', 'D', 'ST_CLERK', 'E', 'Z') as "GRADE"
from employees;

-- ���� 35 ������̺�  ������ ��� �ϴ� �������� �ۼ��ϼ��� 
-- �� commission_pct ���� null �ƴϸ� (salary*12) + (salary*12*commission_pct) �̰��� ����ǰ�
-- null �̸� salary * 12 �� �����մϴ�. ���� ����� ȭ��ó�� ���弼��.
-- (nvl, nvl2,  coalesce, case, decode �Լ��� ����Ͽ� �������� �����ؼ� ���� �ۼ��� �ּ���)
select last_name, salary, commission_pct, decode(commission_pct, null, salary * 12, (salary * 12) + (salary * 12 * commission_pct)) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, (salary * 12) + (salary * 12 * nvl(commission_pct, 0)) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, nvl2(commission_pct, (salary * 12) + (salary * 12 * commission_pct), salary * 12) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, coalesce((salary * 12) + (salary * 12 * commission_pct), salary * 12) as "ANN_SAL"
from employees;

select last_name, salary, commission_pct, case when commission_pct is null then salary * 12 else (salary * 12) + (salary * 12 * commission_pct) end as "ANN_SAL"
from employees;

-- ����36 ��� ����� �ְ�޿�, �����޿�, �հ� �� ��� �޿��� ã���ϴ�. 
-- �� ���̺��� ���� Maximum, Minimum, Sum �� Average �� �����մϴ�. 
-- ����� �Ҽ����� �ݿø��ؼ� ���������� ����ϼ���.
select max(salary) as "Maximum", min(salary) as "Minimum", sum(salary) as "Sum", round(avg(salary), 0) as "Average"
from employees;

-- ���� 37 2008�⵵�� �Ի��� ������� job_id�� �ο����� ���ϰ� �ο����� ���� ������ ����ϼ���. 
select job_id, count(*)
from employees
where to_char(hire_date, 'yyyy') = '2008'
group by job_id
order by 2 desc;


-- �Ϸ��� ����
select to_date('20180530 00:00:00.00000', 'yyyymmdd hh24:mi:ss.sssss')
from dual;

-- �Ϸ��� ��
select to_date('20180530 23:59:59.86399', 'yyyymmdd hh24:mi:ss.sssss')
from dual;

select to_timestamp('20180530 11:16:00', 'yyyymmdd hh24:mi:ss')
from dual;

-- timestamp�� s�� �ڸ��� ��Ÿ���� �ȵ�. ff�� �����
select to_timestamp('20180530 11:16:00.0', 'yyyymmdd hh24:mi:ss.s')
from dual;

select to_timestamp('20180530 11:16:00.123', 'yyyymmdd hh24:mi:ss.ff')
from dual;

-- �Ϸ��� ���� / 0�� 9�� ����
select to_timestamp('20180530 11:16:00.000000000', 'yyyymmdd hh24:mi:ss.ff')
from dual;

-- �Ϸ��� �� / 9�� 9�� ����
select to_timestamp('20180530 11:16:00.999999999', 'yyyymmdd hh24:mi:ss.ff')
from dual;

select to_char(systimestamp, 'ss.ff')
from dual;

-- 2�ڸ��� �̾Ƴ���
select to_char(systimestamp, 'ss.ff2')
from dual;

-- 9�ڸ��� �̾Ƴ���
select to_char(systimestamp, 'ss.ff9')
from dual;

-- ���Ⱑ ���� ���� ���ڸ��� ���� ��� rr Ÿ�԰� yyŸ���� ����� �ٸ�
select to_date('95-10-27', 'rr-mm-dd')
from dual;

select to_date('95-10-27', 'yy-mm-dd')
from dual;

-- yyŸ���� ���� ���� �������� ������ ����ع���
select to_char(to_date('95-10-27', 'rr-mm-dd'), 'yyyy') -- 1995
from dual; 

select to_char(to_date('95-10-27', 'yy-mm-dd'), 'yyyy') -- 2095
from dual;

-- rrŸ�� ã�� ǥ
--                          ������ ����
--                            0~49                50~99
--���翬��  0~49     ��ȯ ��¥�� ���� ���⸦ �ݿ�     ��ȯ ��¥�� ���� ���⸦ �ݿ�
--         50~99    ��ȯ ��¥�� ���� ���⸦ �ݿ�     ��ȯ ��¥�� ���� ���⸦ �ݿ�

--���� ����     ������ �Է� ��¥(���� ����)        rr      yy
--1994��       95-10-27                      1995��   1995��
--1994��       17-10-27                      2017��   1917��
--2001��       17-10-27                      2017��   2017��
--2048��       52-10-27                      1952��   2052��
--2051��       47-10-27                      2147��   2047��

-- rr, yyŸ�� �Ѵ� ������ �ִ�
-- rrŸ��: ǥ�� ���� �������ش�
-- yyŸ��: ���� ������ ���⸦ ���� ���������� �ݿ����ش�
-- ��¥ �����͸� �Է��� �� ������ ���� ���ڸ� �Է�
-- �ǹ����� rr�� ���� ���� �ʴ´�

-- if ���� �� then
--          ���� 1;
-- else if ���� �� then
--          ���� 2;
-- else if ���� �� then
--          ���� 3;
-- else
--          �⺻��1;
-- end if;

-- SQL���� if�� ��� �Ұ�. �Լ� ����
-- ���Ǻ� ǥ����(�Լ�)
-- decode(�Լ�), case(ǥ����, �Լ�)
-- if ���ذ� = �񱳰� then
--            ����
-- end if;

-- decode(���ذ�, �񱳰�, ����)
-- decode �Լ��� ������ ���ذ��� �񱳰��� '=' ���ϼ��� �� ����(�񱳿����� ������ =�� ��� ����)

-- ex) job_id ���� �ٸ� �޿��� �����ְ� �ʹ�
-- ex) job_id�� 'IT_PROG'�̸� �޿��� 10% �λ��ϰ�, 'ST_CLEAR'�� 'SA_REP'�� 20%�� �λ��Ѵ�. 
select last_name, job_id, salary, 
       decode(job_id, 'IT_PROG', salary * 1.1, 'ST_CLEAR', salary * 1.2, 'SA_REP', salary * 1.2, salary)
from employees;

-- case ���ذ�, �񱳰�, ����
-- ��°���� �� ��� "��Ī" �������൵ ��
select last_name, job_id, salary,
       case job_id
            when 'IT_PROG' then salary * 1.1
            when 'ST_CLEAR' then salary * 1.2
            when 'SA_REP' then salary * 1.2
            else salary
       end "��Ī"
from employees;

-- ���ذ��� when���� �־��൵ �ǰ�, case�� when ���̿� �־ ��� ����
select last_name, salary,
       case
            when salary < 5000 then 'low'
            when salary < 10000 then 'medium' -- between������ �� �ʿ� ���� �̹� ���� ������ �Ѿ �°��̱� ������ 5000 �̻���
            when salary < 20000 then 'good'
            else 'excellent'
       end "��Ī"
from employees;

-- ��������� ������ �Լ�
-- ������ �Լ�: �����Լ�, �����Լ�, ��¥�Լ�, ����ȯ �Լ�, null���� �Լ�, ����ǥ���� �Լ�

-- �׷��Լ�: max, min, count, ���, �л�, ǥ������
-- max: �ִ밪, Ÿ�Կ� ������ ���� �ʴ´�
-- min: �ּҰ�, Ÿ�Կ� ������ ���� �ʴ´�

select max(salary), min(salary)
from employees;

select max(hire_date), min(hire_date)
from employees;

select max(last_name), min(last_name) 
from employees;

-- ���� �����ؼ� �׷�ȭ �Լ��� ����� �� �ִ�
select max(salary), min(salary), max(hire_date), min(hire_date), max(last_name), min(last_name)
from employees
where department_id = 50;

-- count: �� ��
select count(*)
from employees;

select count(commission_pct)
from employees;

select count(distinct department_id)
from employees;

select sum(salary)
from employees;

select sum(salary)
from employees
where department_id = 50;

select avg(salary)
from employees;

select avg(commission_pct)
from employees;

select avg(nvl(commission_pct, 0))
from employees;

select variance(salary)
from employees;

select stddev(salary)
from employees;

select department_id, avg(salary)
from employees
group by department_id;

select department_id, job_id, avg(salary)
from employees
group by department_id, job_id;

-- where���� ���� �����ϴ� �� / ������ ��
select department_id, sum(salary)
from employees
where sum(salary) > 10000
group by department_id;

select department_id, sum(salary)
from employees
group by department_id
having sum(salary) > 10000;

-- �׷��Լ��� 2�� ��ø�ϸ� ���� �÷��� ���� ���� -> ����׷��� max������ �� �� ����
select max(avg(salary))
from employees
group by department_id;