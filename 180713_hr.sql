/*[����34] ����� �߿� job_id�� 'SA_REP' ������� �̸�, �μ� �̸��� ����ϰ� �μ� ��ġ�� ���� �ʴ�
����鿡 ���ؼ��� "�μ� ��ġ�� �� �޾ҽ��ϴ�." ����ؾ� �մϴ�.
���� ����Ҷ� ī���� ���� ������ּ���.(������ �̿����� ������)
1 ����̸� : Tucker, �μ��̸� : Sales
2 ����̸� : Bernstein, �μ��̸� : Sales
3 ����̸� : Hall, �μ��̸� : Sales
4 ����̸� : Olsen, �μ��̸� : Sales
5 ����̸� : Cambrault, �μ��̸� : Sales
6 ����̸� : Tuvault, �μ��̸� : Sales
7 ����̸� : King, �μ��̸� : Sales
8 ����̸� : Sully, �μ��̸� : Sales
9 ����̸� : McEwen, �μ��̸� : Sales
10 ����̸� : Smith, �μ��̸� : Sales
11 ����̸� : Doran, �μ��̸� : Sales
12 ����̸� : Sewall, �μ��̸� : Sales
13 ����̸� : Vishney, �μ��̸� : Sales
14 ����̸� : Greene, �μ��̸� : Sales
15 ����̸� : Marvins, �μ��̸� : Sales
16 ����̸� : Lee, �μ��̸� : Sales
17 ����̸� : Ande, �μ��̸� : Sales
18 ����̸� : Banda, �μ��̸� : Sales
19 ����̸� : Ozer, �μ��̸� : Sales
20 ����̸� : Bloom, �μ��̸� : Sales
21 ����̸� : Fox, �μ��̸� : Sales
22 ����̸� : Smith, �μ��̸� : Sales
23 ����̸� : Bates, �μ��̸� : Sales
24 ����̸� : Kumar, �μ��̸� : Sales
25 ����̸� : Abel, �μ��̸� : Sales
26 ����̸� : Hutton, �μ��̸� : Sales
27 ����̸� : Taylor, �μ��̸� : Sales
28 ����̸� : Livingston, �μ��̸� : Sales
29 ����̸� : grant, �μ��̸� : �μ� ��ġ�� �� �޾ҽ��ϴ�.
30 ����̸� : Johnson, �μ��̸� : Sales */

declare
  type emp_rec_type is record(lname emp.last_name%type, deptid emp.department_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  v_deptname departments.department_name%type;
  
begin
  select last_name, department_id bulk collect into v_emp_tab from emp where job_id = 'SA_REP';
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is null then
      dbms_output.put_line( i || ' ����̸� : ' ||v_emp_tab(i).lname || ', �μ��̸�: �μ� ��ġ�� �� �޾ҽ��ϴ�.');
    else
      select department_name into v_deptname from departments where department_id = v_emp_tab(i).deptid;
      dbms_output.put_line( i || ' ����̸� : ' ||v_emp_tab(i).lname || ', �μ��̸�: ' || v_deptname);
    end if;
  end loop;

end;
/

-- departments ���̺� �����ϴ� Ƚ���� �ٿ����� -> **��Į�� ��������**�� ����
declare
  type emp_rec_type is record(lname emp.last_name%type, deptid emp.department_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  type deptid_tab_type is table of departments.department_name%type index by pls_integer;
  v_deptid_tab deptid_tab_type;
  
begin
  select last_name, department_id bulk collect into v_emp_tab from emp where job_id = 'SA_REP';
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is not null then
      v_deptid_tab(v_emp_tab(i).deptid) := null;
    end if;
  end loop;
  
  for i in v_deptid_tab.first..v_deptid_tab.last loop
    select department_name into v_deptid_tab(i) from departments where department_id = i;
  end loop;
  
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is null then
      dbms_output.put_line( i || ' ����̸� : ' ||v_emp_tab(i).lname || ', �μ��̸�: �μ� ��ġ�� �� �޾ҽ��ϴ�.');
    else
      dbms_output.put_line( i || ' ����̸� : ' ||v_emp_tab(i).lname || ', �μ��̸�: ' || v_deptid_tab(v_emp_tab(i).deptid));
    end if;
  end loop;
  
end;
/

/**������ ���**/
DECLARE
 cursor emp_cursor is
	SELECT last_name, department_id FROM employees WHERE job_id = 'SA_REP';
 v_dept_name departments.department_name%type;
 v_c number := 1;
BEGIN
	FOR c_rec IN emp_cursor LOOP
		begin
			SELECT department_name INTO v_dept_name FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : '||v_dept_name);
			v_c := v_c+1;

    EXCEPTION
      when no_data_found then 
      dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : �μ� ��ġ�� �� �޾ҽ��ϴ�.');
       v_c := v_c + 1;
    END;
  END LOOP;

END;
/

DECLARE
  v_dept_name departments.department_name%type;
  v_c number := 1;

BEGIN
	FOR c_rec IN (SELECT last_name, department_id FROM  employees WHERE job_id = 'SA_REP') LOOP
    begin
      SELECT department_name INTO v_dept_name	FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      when no_data_found then 
        dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : �μ���ġ�� �� �޾ҽ��ϴ�.');
        v_c := v_c + 1;
    end;
  END LOOP;

END;
/

declare
  cursor emp_cursor is select last_name, department_id from employees	where job_id = 'SA_REP';
  c_rec emp_cursor%rowtype;
  v_dept_name departments.department_name%type;
  v_c number := 1;

BEGIN
  open emp_cursor;
  LOOP
    FETCH emp_cursor INTO c_rec;
    EXIT WHEN emp_cursor%NOTFOUND;
  	begin
			SELECT department_name INTO v_dept_name FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      WHEN no_data_found THEN 
        dbms_output.put_line(v_c||  ' ����̸� : '||c_rec.last_name ||', �μ��̸� : �μ� ��ġ�� �� �޾ҽ��ϴ�.');
		    v_c := v_c + 1;
    END;     
	END LOOP;
  CLOSE emp_cursor;

END;
/

DECLARE
 CURSOR emp_cursor IS	SELECT last_name, department_id FROM  employees	WHERE job_id = 'SA_REP';
 TYPE emp_tab_type IS TABLE OF emp_cursor%rowtype;
 v_tab emp_tab_type;
 v_dept_name departments.department_name%type;
 v_c number := 1;

BEGIN
 OPEN emp_cursor;
 FETCH emp_cursor BULK COLLECT INTO v_tab;
  FOR i IN v_tab.first..v_tab.last LOOP
		begin
      SELECT department_name INTO v_dept_name	FROM departments WHERE department_id = v_tab(i).department_id;
      dbms_output.put_line(v_c||  ' ����̸� : '||v_tab(i).last_name ||', �μ��̸� : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      WHEN no_data_found THEN 
        dbms_output.put_line(v_c||  ' ����̸� : '||v_tab(i).last_name ||', �μ��̸� : �μ� ��ġ�� �� �޾ҽ��ϴ�.');
		    v_c := v_c + 1;
    END;
	end loop;
  CLOSE emp_cursor;

END;
/

/*****��Į�� ��������!! Ȱ��: ������ ���� �� �� ĳ�ñ���� ����*****/
DECLARE
 cursor emp_cursor is	select rownum no, e.last_name, 
  nvl((select  department_name from departments where department_id = e.department_id), '�μ� ��ġ�� ���޾ҽ��ϴ�.') dept_name	from employees e	where  e.job_id = 'SA_REP';
 TYPE emp_tab_type IS TABLE OF emp_cursor%rowtype;
 v_tab emp_tab_type;

BEGIN
  open emp_cursor;
  fetch emp_cursor bulk collect into v_tab;
  FOR i IN v_tab.first..v_tab.last LOOP
    dbms_output.put_line(v_tab(i).no||  ' ����̸� : '||v_tab(i).last_name ||', �μ��̸� : '||v_tab(i).dept_name);
  end loop;
  CLOSE emp_cursor;

END;
/


DECLARE
 TYPE emp_rec_type IS RECORD(no number, name varchar2(30), dept_name varchar2(50));
 TYPE emp_tab_type IS TABLE OF emp_rec_type;
 v_tab emp_tab_type;
BEGIN
	select rownum, e.last_name, nvl((select department_name from departments where department_id = e.department_id), '�μ� ��ġ�� ���޾ҽ��ϴ�.') 
  bulk collect into v_tab FROM employees e WHERE  e.job_id = 'SA_REP';
  for i in v_tab.first..v_tab.last loop
  	dbms_output.put_line(v_tab(i).no||  ' ����̸� : '||v_tab(i).name ||', �μ��̸� : '||v_tab(i).dept_name);
  END LOOP;

end;
/

/*[����35] ��ü ��� ���� ���, �̸�, �޿�, �Ի���, �ٹ������� ����մϴ�.
���� �ٹ������� 13�� �̻��̰� �޿��� 10000 �̸��� ������� ���ܻ����� �߻��ϵ��� �� �� 
�޽��� ����ϰ�  ���α׷� ������ �Ϸ�� �Ŀ� �м��Ҽ��ֵ���  years ���̺� ������ �Է��� �ǵ��� ���α׷��� �ۼ��մϴ�. �ٹ������� �Ҽ����� ��������
SQL> create table years(id number, name varchar2(30), sal number, year number);
<ȭ�� ���>
....
201, Hartstein, 13000, 04/02/17, 12
202, Fay, 6000, 05/08/17, 10
203, Mavris, 6500, 02/06/07, 13
��� 203 �ٹ������� 13 ���̰� �޿��� 6500 �Դϴ�.
204, Baer, 10000, 02/06/07, 13
205, Higgins, 12008, 02/06/07, 13
206, Gietz, 8300, 02/06/07, 13
��� 206 �ٹ������� 13 ���̰� �޿��� 8300 �Դϴ�.
....
SQL> select * from years; */
create table years(id number, name varchar2(30), sal number, year number);
select * from years;
truncate table years; --���̺� ������ ��ü ���� & rollback �Ұ���

-- exception ���� ����
declare
  type emp_rec_type is record(id emp.employee_id%type, name emp.last_name%type, sal emp.salary%type, hdate emp.hire_date%type, wyear number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
    
begin
  select employee_id, last_name, salary, hire_date, trunc(months_between(sysdate, hire_date)/12) bulk collect into v_emp_tab from emp;
  for i in v_emp_tab.first..v_emp_tab.last loop
    dbms_output.put_line(v_emp_tab(i).id || ', ' || v_emp_tab(i).name || ', ' || v_emp_tab(i).sal || ', ' || v_emp_tab(i).hdate || ', ' || v_emp_tab(i).wyear);
    if v_emp_tab(i).wyear >= 13 and v_emp_tab(i).sal < 10000 then
      dbms_output.put_line('��� ' || v_emp_tab(i).id || ' �ٹ������� ' || v_emp_tab(i).wyear || ' ���̰� �޿��� ' || v_emp_tab(i).sal || ' �Դϴ�.');
      insert into years values (v_emp_tab(i).id, v_emp_tab(i).name, v_emp_tab(i).sal, v_emp_tab(i).wyear);
    end if;
  end loop;
  
end;
/

-- exception ���ؼ� ����
declare
  type emp_rec_type is record(id emp.employee_id%type, name emp.last_name%type, sal emp.salary%type, hdate emp.hire_date%type, wyear number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  minor exception;
    
begin
  select employee_id, last_name, salary, hire_date, trunc(months_between(sysdate, hire_date)/12) bulk collect into v_emp_tab from emp;
  for i in v_emp_tab.first..v_emp_tab.last loop
    begin
      dbms_output.put_line(v_emp_tab(i).id || ', ' || v_emp_tab(i).name || ', ' || v_emp_tab(i).sal || ', ' || v_emp_tab(i).hdate || ', ' || v_emp_tab(i).wyear);
      if v_emp_tab(i).wyear >= 13 and v_emp_tab(i).sal < 10000 then
        raise minor;
      end if;
    
    exception
      when minor then
        dbms_output.put_line('��� ' || v_emp_tab(i).id || ' �ٹ������� ' || v_emp_tab(i).wyear || ' ���̰� �޿��� ' || v_emp_tab(i).sal || ' �Դϴ�.');
        insert into years values (v_emp_tab(i).id, v_emp_tab(i).name, v_emp_tab(i).sal, v_emp_tab(i).wyear);
    end;
  end loop;
  commit;
end;
/

-- [����36] �����ȣ�� �Է°����� �޾Ƽ� �׻���� �޿��� 10%�λ��ϴ� ���ν����� �����ϼ���. ���ν����̸��� raise_sal�� �����ϼ���.
create or replace procedure raise_sal(id number)
is 
begin
  update emp set salary = salary * 1.1 where employee_id = id;
  if sql%found then 
    dbms_output.put_line(id || '����� �޿��� �����߽��ϴ�.');
  else
    dbms_output.put_line(id || '����� �������� �ʽ��ϴ�.');
  end if;
  
end;
/










var b_id number
exec :b_id := 100


declare
  v_rec  employees%rowtype;

begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' ����� �������� �ʽ��ϴ�');
    
end;
/

--�͸���� ����: ���Ľ��� �ȵ� / ������ �ȵ� / �Է°�, ���ϰ� ó���� ������ �����ϴ� ��ɿ� ������ �� �ۿ� ����

select * from session_privs;
select * from user_tab_privs;
drop procedure emp_proc;

/*procedure: bind���� ��� �Ұ�, declare ��� is & as ���
create �ϸ� �ҽ��ڵ�� �����ϵ� �ҽ��ڵ带 db�� ����
���ν��� ������ �Ű������� ����� ���
-> ���ν��� ������ �Ű����� ���� �Ұ���*/ 
create or replace procedure emp_proc(p_id in number default 100) -- in ��������
is -- as �� ����, ������ ���� ��� ����ؾ� ��
  v_rec  employees%rowtype;

begin
  select * into v_rec from employees where employee_id = p_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(p_id || ' ����� �������� �ʽ��ϴ�');
    
end;
/
-- ���ν��� ����
exec emp_proc(100);
exec emp_proc; --default �� �Էµ�
begin
  emp_proc(100);
end;
/

-- ���ν����� �ҽ��ڵ� Ȯ��
select text from user_source where name = 'EMP_PROC';

-- ���ν��� �������� ���� Ȯ��
show error;

-- ��¿� �Ű�����: ������ out Ÿ��
create or replace procedure emp_proc(p_id in number default 100, p_name out varchar2, p_sal out number) -- in ��������
is -- as �� ����, ������ ���� ��� ����ؾ� ��

begin
  select last_name, salary into p_name, p_sal from employees where employee_id = p_id;
  dbms_output.put_line(p_name || ' ' || p_sal);

exception
  when no_data_found then
    dbms_output.put_line(p_id || ' ����� �������� �ʽ��ϴ�');
    
end;
/

-- ���ν����� �Ű����� Ȯ��
desc emp_proc;

var b_name varchar2(30)
var b_sal number

exec emp_proc(200, :b_name, :b_sal);

print b_name b_sal

select * from employees where salary > :b_sal;

declare
  v_id number := 100;
  v_name varchar2(30);
  v_sal number;

begin
  emp_proc(v_id, v_name, v_sal);
  dbms_output.put_line(v_id || ' ' || v_name || ' ' || v_sal);

end;
/
-- in out ���
create or replace procedure format_phone(p_phone_no in out varchar2)
is 
begin
  p_phone_no := substr(p_phone_no, 1, 3) || '-' || substr(p_phone_no, 4, 4) || '-' || substr(p_phone_no, 8);
end;
/

var b_phone varchar2(30);
exec :b_phone := '01012345678';

exec format_phone(:b_phone);

print b_phone;