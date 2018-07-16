/*[����37] �����ȣ�� �Է� ������ �޾Ƽ� �� ����� �̸�, �޿�, �μ� �̸��� ����ϴ� query_emp ���ν��� �����ϼ���.
�� 100�� ����� �Է� ������ ������ ���α׷��� �ƹ��� �۾����� �ʰ� ���� �� �� �־�� �մϴ�. 
���� ����� ���� ��� ���� ���� ó�����ּ���.

SQL> execute query_emp(100)
PL/SQL procedure successfully completed.

SQL> execute query_emp(101)
��� �̸�: Kochhar ��� �޿�: 17000 ��� �μ� �̸�: Executive
PL/SQL procedure successfully completed.

SQL> execute query_emp(300)
300 �������� �ʴ� ����Դϴ�.
pl/sql procedure successfully completed. */
exec query_emp(100);
show error;
-- exception���� 100�� ��� ����
create or replace procedure query_emp(p_empid in number)
is
  e_vip exception;
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    raise e_vip;
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('��� �̸�: ' || v_emp_rec.lname || ' ��� �޿�: ' || v_emp_rec.sal || ' ��� �μ� �̸�: ' || v_emp_rec.dname);
  end if;

exception
  when e_vip then
    null;
    
  when no_data_found then
    dbms_output.put_line(p_empid || ' �������� �ʴ� ����Դϴ�.');

end query_emp; -- ���κ� ����
/
-- if������ 100�� �������
create or replace procedure query_emp1(p_empid in number)
is
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    null;
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('��� �̸�: ' || v_emp_rec.lname || ' ��� �޿�: ' || v_emp_rec.sal || ' ��� �μ� �̸�: ' || v_emp_rec.dname);
  end if;

exception 
  when no_data_found then
    dbms_output.put_line(p_empid || ' �������� �ʴ� ����Դϴ�.');

end query_emp1;
/

-- return�� *���ν����� return���� �Լ��� return�� �ٸ���
create or replace procedure query_emp1(p_empid in number)
is
  type emp_rec_type is record(lname employees.last_name%type, sal employees.salary%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  if p_empid = 100 then
    return; -- return���� ������ ���α׷� �ٷ� ����.
  else
    select last_name, salary, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_empid;
    dbms_output.put_line('��� �̸�: ' || v_emp_rec.lname || ' ��� �޿�: ' || v_emp_rec.sal || ' ��� �μ� �̸�: ' || v_emp_rec.dname);
  end if;

exception 
  when no_data_found then
    dbms_output.put_line(p_empid || ' �������� �ʴ� ����Դϴ�.');

end query_emp1;
/

/*[����38] �����ȣ�� �Է°����� �޾Ƽ� �� ����� �ٹ��������� ����ϰ� �ٹ���������
180���� �̻��̸� �޿��� 20% �λ��� �޿��� ����, 
179���� ���� �۰ų� ���� 150���� ���� ũ�ų� ������  10%�λ��� �޿��� ����,
150���� �̸��� �ٹ��ڴ� �ƹ� �۾��� �������� �ʴ� ���α׷��� �ۼ��ϼ���.
�׽�Ʈ�� ������ rollback �մϴ�.

begin
  sal_update_proc(100);
  rollback;
end;
/

100 ����� �ٹ��������� 166 �Դϴ�. ���� �޿��� 24000 ������ �޿��� 26400 �Դϴ�.

begin
  sal_update_proc(103);
  rollback;
end;
/

103 ����� �ٹ��������� 136 �Դϴ�. 150 ���� �̸��Դϴ�.9000 �޿��� ���� �ȵ˴ϴ�. */
-- �׽�Ʈ
begin
  sal_update_proc(104);
  rollback;
end;
/

create or replace procedure sal_update_proc(p_id in number)
is
  v_wmonth number;
  v_sal emp.salary%type;
  v_nsal v_sal%type;

begin
  select trunc(months_between(sysdate, hire_date)), salary into v_wmonth, v_sal from emp where employee_id = p_id;
  if v_wmonth >= 180 then
    update emp set salary = salary * 1.2 where employee_id = p_id returning salary into v_nsal;
  elsif v_wmonth between 150 and 179 then
    update emp set salary = salary * 1.1 where employee_id = p_id returning salary into v_nsal;
  else
    dbms_output.put_line(p_id||' ����� �ٹ��������� '||v_wmonth||' �Դϴ�. 150 ���� �̸��Դϴ�. �޿��� '||v_sal||' ���� �������� �ʽ��ϴ�.');
    return;
  end if;
  dbms_output.put_line(p_id||' ����� �ٹ��������� '||v_wmonth||' �Դϴ�. ���� �޿��� '||v_sal||' ������ �޿��� '||v_nsal||' �Դϴ�.');

exception
  when no_data_found then
    dbms_output.put_line('���� ��� ��ȣ�Դϴ�.');
  
end sal_update_proc;
/

-- rowid scan���� Ʃ��
create or replace procedure sal_update_proc(p_id in number)
is
  v_wmonth number;
  v_sal emp.salary%type;
  v_nsal v_sal%type;
  v_rowid rowid;
  v_pct number;

begin
  select rowid, trunc(months_between(sysdate, hire_date)), salary into v_rowid, v_wmonth, v_sal from emp where employee_id = p_id;
  if v_wmonth >= 180 thend
    v_pct := 1.2;
  elsif v_wmonth between 150 and 179 then
    v_pct := 1.1;
  else
    dbms_output.put_line(p_id||' ����� �ٹ��������� '||v_wmonth||' �Դϴ�. 150 ���� �̸��Դϴ�. �޿��� '||v_sal||' ���� �������� �ʽ��ϴ�.');
    return;
  end if;
  update emp set salary = salary * v_pct where rowid = v_rowid returning salary into v_nsal;
  dbms_output.put_line(p_id||' ����� �ٹ��������� '||v_wmonth||' �Դϴ�. ���� �޿��� '||v_sal||' ������ �޿��� '||v_nsal||' �Դϴ�.');

exception
  when no_data_found then
    dbms_output.put_line('���� ��� ��ȣ�Դϴ�.');
    
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
  
end sal_update_proc;
/

/*[����39] �޿��� 3.3%�� ����ϴ� tax �Լ��� �����ϼ���.
SQL> SELECT employee_id, last_name, salary, tax(salary) FROM employees;
EMPLOYEE_ID LAST_NAME                SALARY TAX(SALARY)
----------- -------------------- ---------- -----------
        100 King                    35138.4   1159.5672
        101 Kochhar                   22627     746.691
        102 de haan                 24889.7    821.3601
        103 Hunold                     9000         297 */
        
create or replace function tax(sal number)
return number
is

begin
  return sal * 0.033;

exception
  when no_data_found then
    return 0;
    
end tax;
/

select employee_id, last_name, salary, tax(salary) from employees;

drop function tax;

/*[����40] �޿��� ����ϴ� get_annual_comp �Լ��� �����ϼ���.
SQL> SELECT employee_id,
     (salary*12) + (commission_pct*salary*12) ann_sal,
     get_annual_comp(salary,commission_pct) ann_sal2
     FROM employees;
EMPLOYEE_ID    ANN_SAL   ANN_SAL2  
----------- ---------- ---------- 
        100                288000    
        101                204000     
        102                204000    
        103                108000     */
create or replace function get_annual_comp(sal number, comm_pct number)
return number
is

begin
  return nvl((sal * 12),0) + nvl((sal * 12 * comm_pct), 0);

end get_annual_comp;
/

select employee_id, (salary*12) + (commission_pct*salary*12) ann_sal, get_annual_comp(salary,commission_pct) ann_sal2 from employees;

/* ���� 41: ���� 40���� nvl�Լ��� ���� �ʰ� �ذ��ϼ��� */
create or replace function get_annual_comp(sal number, comm_pct number)
return number
is

begin
  if sal is not null and comm_pct is not null then
    return (sal * 12) + (sal * 12 * comm_pct);
  elsif sal is not null and comm_pct is null then
    return (sal * 12);
  else
    return 0;
  end if;
    
end get_annual_comp;
/








create or replace procedure sp_comm(p_id in employees.employee_id%type, p_name out employees.last_name%type, p_sal out employees.salary%type, p_comm in out employees.commission_pct%type)
is 
  v_comm employees.commission_pct%type;

begin
  select last_name, salary, nvl(commission_pct, 0) into p_name, p_sal, v_comm from employees where employee_id = p_id;
  p_comm := p_comm + v_comm;
  
exception
  when no_data_found then
    raise_application_error(-20000, sqlerrm);
    
  when others then
    raise_application_error(-20001, sqlerrm);

end sp_comm;
/

show error;

desc sp_comm;

select text from user_source where name = 'SP_COMM';

var g_name varchar2(30);
var g_sal number;
var g_comm number;
var g_id number;

exec :g_comm := 0.1;
exec :g_id := 145;
print g_name g_sal g_comm;

exec sp_comm(:g_id, :g_name, :g_sal, :g_comm);

print g_name g_sal g_comm;

create table sawon(id number, name varchar2(30), day date, deptno number);

create or replace procedure sawon_in_proc(p_id in number, p_name in varchar2, p_day in date default sysdate, p_deptno in number default 0)
is
begin 
  insert into sawon(id, name, day, deptno) values(p_id, p_name, p_day, p_deptno);

end sawon_in_proc;
/

desc sawon_in_proc;

exec sawon_in_proc(1, 'ȫ�浿', to_date('20180101', 'YYYYMMDD'), 10); -- ��ġ�������
exec sawon_in_proc(p_id => 2, p_name => '����ȣ', p_deptno => 20); -- �̸��������
exec sawon_in_proc(3, '�����', p_day => to_date('20170101', 'YYYYMMDD')); -- ���չ��
exec sawon_in_proc(p_id => 4, '���ӽ�', p_day => to_date('20170101', 'YYYYMMDD')); -- ����: �̸�������� �ڿ��� ��� �̸������������ ǥ���ؾ���

select * from sawon;

drop table emp purge;
drop table dept purge;

create table emp as select * from employees;
create table dept as select * from departments;

alter table emp add constraint empid_pk primary key(employee_id);
alter table dept add constraint deptid_pk primary key(department_id);
alter table dept add constraint dept_mgr_id_fk foreign key(manager_id) references emp(employee_id);

select * from user_constraints where table_name in ('EMP', 'DEPT');
select * from user_cons_columns where table_name in ('EMP', 'DEPT');

create or replace procedure add_dept(p_name in varchar2, p_mgr in number, p_loc number)
is
  v_max number;
  
begin
  select max(department_id) into v_max from dept;
  insert into dept(department_id, department_name, manager_id, location_id) values(v_max + 10, p_name, p_mgr, p_loc);

end add_dept;
/

-- 1.fk ���� �߻� // ��ü rollback �߻�
begin 
  add_dept('�濵����', 100, 1800);
  add_dept('�����ͺм�', 99, 1800);
  add_dept('�ڱݰ���', 101, 1500);
  
end;
/

select * from dept;

-- 2. exceptionó��: 1��° �����ʹ� �Է� �������� �Է� �ȵ�
begin 
  add_dept('�濵����', 100, 1800);
  add_dept('�����ͺм�', 99, 1800);
  add_dept('�ڱݰ���', 101, 1500);

exception
  when others then
    dbms_output.put_line(sqlerrm);
  
end;
/

-- 3.���ν��� ���ο� exceptionó��, ������ ���ν��� �̿ܿ� ��� �Է�
create or replace procedure add_dept(p_name in varchar2, p_mgr in number, p_loc number)
is
  v_max number;
  
begin
  select max(department_id) into v_max from dept;
  insert into dept(department_id, department_name, manager_id, location_id) values(v_max + 10, p_name, p_mgr, p_loc);

exception
  when others then
    dbms_output.put_line('error : '||p_name);
    dbms_output.put_line(sqlerrm);

end add_dept;
/

begin 
  add_dept('�濵����', 100, 1800);
  add_dept('�����ͺм�', 99, 1800);
  add_dept('�ڱݰ���', 101, 1500);
  
end;
/

select * from dept;
drop procedure add_dept;


-- �Լ� function
create or replace function get_sal(p_id in number)
return number --�����ϴ� ���� Ÿ��, ������ ��� X
is 
  v_sal number := 0;

begin
  select salary into v_sal from employees where employee_id =p_id;
  return v_sal;

exception
  when no_data_found then
    return v_sal;

end get_sal;
/

exec dbms_output.put_line(get_sal(100)); -- ǥ������ �Ϻη� ȣ��

declare 
  v_sal number;

begin
  v_sal := get_sal(100); -- ǥ������ �Ϻη� ȣ��
  dbms_output.put_line(v_sal);

end;
/

select employee_id, get_sal(employee_id) from employees; -- ǥ������ �Ϻη� ȣ��


begin
  get_sal(100); -- �ٷ� ȣ�� �Ұ�
end;
/

