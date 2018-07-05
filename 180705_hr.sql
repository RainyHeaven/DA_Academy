-- [����2] ��ü ����� ��� �޿��� ��� �ϴ� ���α׷� ���弼��.  ���α׷� ������ ���� �Ŀ��� ��ü ����� ��հ��� �̿��ؼ� ��ü ����� ��� �޿� ���� ���� �޴� ����� ���� select ������ �ۼ��ϼ���.
var b_deptavg number

begin
  select avg(salary) into :b_deptavg from employees;
  dbms_output.put_line('��ü ����� ��� �޿�: ' || round(:b_deptavg));
end;
/

select * from employees where salary > :b_deptavg;

/*[����3] ��� ��ȣ�� �Է°����� �޾Ƽ� �׻���� ���, �̸�, �޿� ������ ����ϴ� ���α׷��� �ۼ��ϼ���.
<ȭ�� ���>
���=> �����ȣ: 100, ����̸�: King, ����޿�: 24000*/

var b_empid number
exec :b_empid := 100

declare
  v_lname employees.last_name%type;
  v_sal employees.salary%type;

begin
  select last_name, salary into v_lname, v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('���=> �����ȣ: ' || :b_empid || ', ����̸�: ' || v_lname || ', ����޿�: ' || v_sal);

end;
/

/*[����4] ��� ��ȣ�� �Է°����� �޾Ƽ� �Ի���, �޿� ������ ����ϴ� ���α׷��� �ۼ��ϼ���.
<ȭ�� ���>
hire date is : 2003�� 6�� 17��
Salary is : ��24,000.00 */

-- employee_id Ȯ�� : 100��
select employee_id from employees
where hire_date = to_date('20030617', 'yyyymmdd')
and salary = 24000;

var b_empid number
exec :b_empid := 100

declare
  v_hdate employees.hire_date%type;
  v_sal employees.salary%type;

begin
  select hire_date, salary into v_hdate, v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('Hire date is : ' || to_char(v_hdate, 'YYYY"��" fmMM"��" DD"��"'));
  dbms_output.put_line('Salary is : ' || ltrim(to_char(v_sal, 'l999g999d00'))); -- to_char�� l ������ ���� ������ ���� ltrim���� ������
end;
/

/*<����5> �μ����̺� �ű� �μ��� �Է��ϴ� ���α׷��� �ۼ��Ϸ��� �մϴ�.
�μ� �̸��� �Է°����� �ް� �μ��ڵ�� ������ �μ� �ڵ忡 10�� �����ؼ� �μ��ڵ带
�ְ� �����ڹ�ȣ, �μ� ��ġ�� null������ �Է��ϴ� ���α׷��� �ۼ��ϼ���.
ȭ����� ó�� ����ϼ���.(dept ���̺��� �������� ���α׷��� ���弼��) 

<ȭ�����>
�ű� �μ� ��ȣ�� 280, �μ� �̸� It �Դϴ�. */

drop table dept purge;
create table dept as select * from departments;

alter table dept add constraint dept_dept_id_pk primary key(department_id);

var b_dname varchar2(10)
exec :b_dname := 'It'

declare
  new_deptid departments.department_id%type;

begin
  select max(department_id)+10 into new_deptid from dept;
  insert into dept(department_id, department_name)
  values(new_deptid, :b_dname);
  dbms_output.put_line('�ű� �μ� ��ȣ�� ' || new_deptid || ', �μ� �̸� ' || :b_dname || '�Դϴ�.');

end;
/

select * from dept;

rollback;




<<outer>>
declare 
  v_name varchar2(20) := 'ȫ�浿';
  v_date date := to_date('2018-01-01', 'yyyy-mm-dd');

begin
  dbms_output.put_line('�л� �̸��� ' || v_name);
  dbms_output.put_line('������ ��¥�� ' || to_char(v_date, 'yyyymmdd'));
  
  declare
    v_name varchar2(20) := '����ȣ';
    v_date date := to_date('2017-01-10', 'yyyy-mm-dd');
  begin
    outer.v_name := '�����';
    dbms_output.put_line('�л� �̸��� ' || v_name);
    dbms_output.put_line('������ ��¥�� ' || to_char(v_date, 'yyyymmdd'));
    dbms_output.put_line('�л� �̸��� ' || outer.v_name);
    dbms_output.put_line('������ ��¥�� ' || to_char(outer.v_date, 'yyyymmdd'));
  end;

end;
/



declare
  v_name2 varchar2(20);
  v_date2 date := to_date('2017-01-10', 'yyyy-mm-dd');

begin
  v_name2 := upper('james'); -- ���ν�����
  dbms_output.put_line('�л� �̸��� ' || v_name2);
  dbms_output.put_line('������ ��¥�� ' || to_char(v_date2, 'yyyymmdd'));
  
end;
/

-- ���ν��������� ����� �� ���� �Լ�
-- decode **case�� ����
-- avg, sum, max, min, count, stddev, variance


/*�Ͻ��� Ŀ��
select ... into... : �ݵ�� 1�� row�� fetch�ؾ� �Ѵ�. 
    0��: no data found
    2���̻�: too_many_rows -> ����� Ŀ���� ����Ͽ� �ذ� ����
DML(insert, update, delete, merge) */
declare
  v_lname varchar2(20);
  v_fname varchar2(20);
  v_sal number;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal -- fetch��
  from employees where employee_id = 300;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

declare
  v_lname varchar2(20); -- �ϵ��ڵ� ���
  v_fname varchar2(20);
  v_sal number;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal -- fetch��
  from employees where department_id = 20;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

declare
  v_lname employees.last_name%type; -- ����Ʈ�ڵ� ���
  v_fname v_lname%type; -- ������ type�� ����
  v_sal employees.salary%type;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal 
  from employees where employee_id = 100;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

var b_id number
exec :b_id := 100

declare
  v_lname employees.last_name%type;
  v_fname v_lname%type; 
  v_sal employees.salary%type;

begin
  select last_name, first_name, salary
  into v_lname, v_fname, v_sal 
  from employees where employee_id = :b_id;
  dbms_output.put_line(v_lname || ' ' || v_fname || ' ' || v_sal);

end;
/

drop table test purge;

create table test(id number, name varchar2(20), day date);

desc test

insert into test(id, name, day) 
values(1, 'ȫ�浿', to_date('2018-01-01', 'yyyy-mm-dd'));

select * from test;

rollback;

-- ���α׷� �ȿ��� dml���� ����� Ʈ�������� ������, �������� �����ؾ� �Ѵ�. Ʈ�������� �״�� �����Ǹ� lock�� �ɷ� ������ ������ ���� ���� ����
begin
  insert into test(id, name, day) 
  values(1, 'ȫ�浿', to_date('2018-01-01', 'yyyy-mm-dd'));

end;
/
rollback;
select * from test;

var b_id number
var b_name varchar2(20)
var b_day varchar2(30)

exec :b_id := 1
exec :b_name := 'ȫ�浿'
exec :b_day := '20180101'

print b_id b_name b_day

begin
  insert into test(id, name, day)
  values(:b_id, :b_name, to_date(:b_day, 'yyyymmdd'));
  
end;
/

exec :b_id := 2
exec :b_name := '���'
exec :b_day := '19860125'

select * from test;

commit;

-- insert ��������
begin 
  insert into test(id, name, day)
  select employee_id, last_name, hire_date from employees;
  dbms_output.put_line(sql%rowcount || '���� row�� �����Ǿ����ϴ�');

end;
/

select * from test;

rollback;

begin
  update test set name = '����ȣ'
  where id = 1;
  
end;
/
var b_id number
var b_name varchar2(20)
exec :b_id := 1
exec :b_name := '����ȣ'

begin
  update test set name = :b_name
  where id = :b_id;
  dbms_output.put_line(sql%rowcount || '���� row�� �����Ǿ����ϴ�'); -- bind ������ ���� ������ �� ���� ����
end;
/

select * from test;

rollback;

drop table emp purge;

create table emp as select * from employees;

begin
  delete from emp where department_id = 20;
  dbms_output.put_line(sql%rowcount|| '���� �����Ǿ����ϴ�');
  
  update emp
  set salary = salary * 1.1
  where department_id = 30;
  dbms_output.put_line(sql%rowcount|| '���� �����Ǿ����ϴ�'); -- �ٷ� �� dml���� �Ǽ��� ����

end;
/

rollback;

begin
  update emp
  set salary = salary * 1.1
  where employee_id = 00;
  
  if sql%found then 
    dbms_output.put_line('���� �Ǿ����ϴ�');
  else
    dbms_output.put_line('�������� �ʾҽ��ϴ�');
  end if;
  rollback;

end;
/

begin
  delete from emp where department_id = 10;
  
  update emp
  set salary = salary * 1.1
  where employee_id = 00;
  
  if sql%notfound then 
    dbms_output.put_line('�������� �ʾҽ��ϴ�');
  else
    dbms_output.put_line('�����Ǿ����ϴ�');
  end if;
  rollback;

end;
/


declare
  v_lname employees.last_name%type;
  v_sal employees.salary%type;

-- �ǹ̾��� if ����: else�� �۵� ���� �����߻�
begin
  select last_name, salary into v_lname, v_sal from employees where employee_id = 00;
  if sql%found then 
    dbms_output.put_line('���=> �����ȣ: ' || :b_empid || ', ����̸�: ' || v_lname || ', ����޿�: ' || v_sal);
  else
    dbms_output.put_line('����� �����ϴ�.');
  end if;

end;
/
