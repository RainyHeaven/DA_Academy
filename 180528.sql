-- ����6 departments ���̺� �ִ� �����Ϳ��� department_name , manager_id �÷��� ������ ȭ�� ��� ó�� ����ϴ� ���������� ���弼��.

select department_name || 'Department''s Manager Id: ' || manager_id as "Department and Manager"
from departments;

-- ����7 employees ���̺� �ִ� ������ �߿�  last_name�� Whalen �̶�� ����� ��� ������ ����ϼ���.
select *
from employees
where last_name = 'Whalen';

-- ����8 EMPLOYEES ���̺��� �޿��� 3000���� �۰ų� ���� ����� last_name, salary �� ����ϼ���.
select last_name, salary
from employees
where salary <= 3000;

-- ����9 EMPLOYEES ���̺��� salary(�޿�)���� 10000�̻���� 15000������ ������� ��������� ����ϼ���.
select *
from employees
where salary between 10000 and 15000;

-- ����10 EMPLOYEES ���̺��� last_name�� "S"�� �����ϴ� ����� last_name, first_name �� ����ϼ���.
select last_name, first_name
from employees
where last_name like 'S%';

-- ����11 last_name�� ����° ���ڰ� "o"�� ��� ����� last_name�� ����ϼ���.
select last_name
from employees
where last_name like '__o%';

-- ����12 employees ���̺� �ִ� ������ �߿� job_id�� SA_ ���ڿ��� ���۵Ǵ� ������� employee_id, last_name, job_id�� ����ϼ���.
select employee_id, last_name, job_id 
from employees
where job_id like 'SA@_%' escape '@';

-- ����13 employees ���̺� �ִ� �����Ϳ��� job_id�÷��� ����  SA�� �����ϰ�  10000 �̻��� salary(�޿�)�� �޴� ������� ��� ������ ����ϼ���.
select *
from employees
where job_id like 'SA%' and salary >= 10000;

-- ����14 employees ���̺���  job_id �÷��� ����  SA�� �����ϰų� 10000 �̻��� salary(�޿�)�� �޴� ������� ��� ������ ����ϼ���.
select *
from employees
where job_id like 'SA%' or salary >= 10000;

-- ����15 employees ���̺���  job_id�÷��� ����  IT_PROG, ST_CLERK , SA_REP�� �ƴ� ��� ����� last_name, job_id��  ������ּ���.
select last_name, job_id
from employees
where job_id not in ('IT_PROG','ST_CLERK', 'SA_REP');

-- ����16 employees ���̺� �ִ� �����Ϳ��� job_id�÷��� ����  SA�� �����ϰ�  10000 �̻��� salary(�޿�)�� �ް� 2005�⵵�� �Ի���(hire_date) ��� ������� ������ ����ϼ���.
select *
from employees
where job_id like 'SA%' and salary >= 10000 and hire_date between to_date('2005.01.01', 'yyyy.mm.dd') and to_date('2005.12.31', 'yyyy.mm.dd');

-- ����17 employees ���̺��� job_id �÷��� ���� SA_REP �Ǵ� AD_PRES ����� �߿� �޿��� 10000 �ʰ� �� ������� ��� ������ ����ϼ���.
select *
from employees
where job_id in ('SA_REP', 'AD_PRES') and salary > 10000;

select last_name, salary
from employees
order by salary desc;

select department_id, salary
from employees
order by department_id asc, salary desc;

-- ����18 employees ���̺� last_name �÷��� �� �߿�  "J" �Ǵ� "A" �Ǵ� "M"���� �����ϴ� ������� last_name(ù��° ���ڴ´빮��, �������� ��� �ҹ���)�� last_name�� ���̸� ǥ���ϴ� query �� �ۼ��մϴ�.
-- ������� last_name�� �������� ����� �������� ������ �ּ���. 
select initcap(last_name), length(last_name)
from employees
where last_name like 'J%' or last_name like 'A%' or last_name like 'M%'
order by last_name;

select initcap(last_name), length(last_name)
from employees
where instr(last_name, 'J') = 1 or instr(last_name, 'A') = 1 or instr(last_name, 'M') = 1
order by last_name;

select initcap(last_name), length(last_name)
from employees
where substr(last_name, 1, 1) in ('J', 'M', 'A')
order by last_name;

-- ����19 employees���̺��� department_id(�μ��ڵ�)�� 50�� ����� �߿� last_name�� �ι�° ��ġ�� "a"���ڰ� �ִ� ������� ��ȸ�ϼ���. 
select *
from employees
where department_id = 50 and last_name like '_a%';

select *
from employees
where department_id = 50 and substr(last_name, 2, 1) = 'a';

select *
from employees
where department_id = 50 and instr(last_name, 'a', 2, 1) = 2;

-- ����20 ����� last_name,hire_date �� �ٹ� 6 ���� �� �����Ͽ� �ش��ϴ� ��¥�� ��ȸ�ϼ���. ����Ī�� REVIEW �� �����մϴ�. 
select last_name, hire_date, next_day(add_months(hire_date, 6), '������') as REVIEW
from employees;

-- ����21 15�� �̻� �ٹ��� ������� employee_id(�����ȣ), hire_date(�Ի���), �ٹ��������� ��ȸ�ϼ���.
select employee_id, hire_date, months_between(sysdate, hire_date) as work_months
from employees
where months_between(sysdate, hire_date) >= (15*12);

-- ���� ������ �÷��� �״�� Ȥ�� �� ��Ī���ε� �� �� �ִ�
select last_name, department_id, salary * 12 as ann_sal
from employees
order by salary * 12;

select last_name, department_id, salary * 12 as "ann_sal"
from employees
order by "ann_sal";

-- ���� ������ select �������� ��ġ�ε� ���� �� �ִ�
select last_name, department_id, salary * 12 as "ann_sal"
from employees
order by 2 asc, 3 desc, 1 asc;

-- ���� �Լ�
select lower(last_name), upper(last_name), initcap(last_name)
from employees;

select *
from employees
where lower(last_name) = 'king';

select last_name || first_name, concat(last_name, first_name)
from employees;

select last_name, length(last_name), substr(last_name, 1, 3), substr(last_name, -2, 2)
from employees;

select salary, lpad(salary, 10, '-'), rpad(salary, 10, '*')
from employees;

select instr('abbcabbc', 'c'), instr('abbcabbc', 'c', 1, 1)
from dual; -- dual: �������̺�(�������̺�)

select last_name, instr(last_name, 'i')
from employees;

-- �Լ��� ���Ŀ����� �ϱ� ������ like ������ ���� instr �Լ��� ������ ����
select last_name
from employees
where last_name like '%i%';

select last_name
from employees
where instr(last_name, 'i') > 0;

select trim('A' from 'AbABBCAA'), ltrim('AABBC', 'A'), rtrim('BBCA', 'A')
from dual;

select replace('100-001', '0', '9')
from dual;

-- �����Լ�
select round(45.926, 0), round(45.926, 1), round(45.926, 2), round(55.926, -2)
from dual;

select trunc(45.926, 0), trunc(45.926, 1), trunc(45.926, 2), trunc(55.926, -2)
from dual;

select mod(13, 2)
from dual;

select ceil(45.0), ceil(45.12), ceil(45.926)
from dual;

-- ��¥�Լ�
select sysdate, sysdate + 7, sysdate - 2
from dual;

select employee_id, sysdate - hire_date
from employees;

select months_between(sysdate, hire_date)
from employees;

select months_between(to_date('2018.05.24', 'yyyy.mm.dd'), to_date('2018.11.22', 'yyyy.mm.dd'))
from dual;

select add_months(sysdate, 6)
from dual;

select next_day(sysdate, '�ݿ���'), last_day(sysdate)
from dual;

select round(sysdate, 'month'), round(sysdate, 'year')
from dual;

select trunc(sysdate, 'month'), trunc(sysdate, 'year')
from dual;