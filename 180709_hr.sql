-- [����19] ���� �Է°����� �޾Ƽ� �� �ܿ� ���ؼ��� ����Ͻð� ���࿡ �� �Է°��� ������ ��ü �������� ��µǵ��� �ۼ��ϼ���.
var b_dan number
execute :b_dan := 2
execute :b_dan := null

begin
  if :b_dan is not null then
    dbms_output.put_line('������ ' || :b_dan || '���Դϴ�.');
    for i in 1..9 loop
      dbms_output.put_line(:b_dan || ' * ' || i || ' = ' || :b_dan * i);
    end loop;
  else
    for i in 2..9 loop
    dbms_output.put_line('������ ' || i || '���Դϴ�.');
      for j in 1..9 loop
        dbms_output.put_line(i || ' * ' || j || ' = ' || i * j);
      end loop;
    dbms_output.put_line('');
    end loop;
  end if;
end;
/

/*[����20] ��� ���̺��� employee_id, last_name �� ����ϴ� ���α׷��Դϴ�.
       �����ȣ�� 100�� ���� �ؼ� 5�� ������ ������ ����Ͻð� 120������ �������� ���ּ���.
<ȭ�� ���>
100  King
105  Austin
110  Chen
115  khoo
120  Weiss */

declare
  v_empid number := 100;
  v_lname employees.last_name%type;

begin
  while v_empid <= 120 loop
    select last_name into v_lname from employees where employee_id = v_empid;
    dbms_output.put_line(v_empid || '�� ����� �̸��� ' || v_lname || '�Դϴ�.');
    v_empid := v_empid + 5;
  end loop;

end;
/

/*[����21] ��� ��ȣ�� �Է� ������ �޾Ƽ� �� ����� �޿��� ����ϴ� ���α׷��� �ۼ��մϴ�. 
���� �޿� 1000�� ��(*) �ϳ��� ������ּ���.(�ݺ����� �̿��ϼ���)
<ȭ�����>
employee_id => 200  salary => 4400
star is => ****     */

-- �ݺ��� Ȱ��
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  v_star varchar2(10) := '';
  
begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  
  for i in 1..trunc(v_sal/1000) loop
    v_star := v_star || '*';
  end loop;
  dbms_output.put_line('star is => ' || v_star);
  
end;
/

--substrȰ��
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  v_star varchar2(10) := '**********';

begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  dbms_output.put_line('star is => ' || substr(v_star, 0, trunc(v_sal/1000)));
  
end;
/

-- rpadȰ��
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;

begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  dbms_output.put_line('star is =>' || rpad(' ', trunc(v_sal/1000)+1, '*'));
  
end;
/

-- put Ȱ��
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  
begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  
  for i in 1..trunc(v_sal/1000) loop
    dbms_output.put('*'); -- ��³����� �׾Ƶδ� ���
  end loop;
  dbms_output.new_line; -- ���� ������ ����ϴ� ���
  
end;
/

/* 22�� ����: continue���� ������� �ʰ� ���� ����� �����ϱ�
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    continue when i > 5; --11g���� ����
    v_total := v_total + i;
    dbms_output.put_line('Out of loop total is : ' || v_total);
  end loop;
  
end;
/  */
-- if�� Ȱ��
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    if i <= 5 then
      v_total := v_total + i;
      dbms_output.put_line('Out of loop total is : ' || v_total);
    end if;
  end loop;
  
end;
/
-- sub loop Ȱ��
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    loop
      exit when i > 5
      v_total := v_total + i;
      dbms_output.put_line('Out of loop total is : ' || v_total);
      exit;
    end loop;
  end loop;
  
end;
/

/* ���� 23 continue���� ���� �ʰ� 
declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      continue toploop when i+j > 5; -- continue���� Ȱ��: ���ư� loop���� ������ �� ����
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/  */
-- exit when Ȱ��
declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      exit when i+j > 5;
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/

-- [����24]������ 2���� for loop�� �̿��ؼ� ����ϼ���. �� 2 * 6�� ���� �����ּ���.
-- if Ȱ��
begin
  for i in 1..9 loop
    if i != 6 then
      dbms_output.put_line('2 * ' || i || ' = ' || 2*i);
    end if;
  end loop;

end;
/

-- continue Ȱ��
begin
  for i in 1..9 loop
    continue when i = 6;
    dbms_output.put_line('2 * ' || i || ' = ' || 2*i);
  end loop;

end;
/

/*[����25] �迭 ������ �ִ� 100,101,102,103,104, 200 ������� �ٹ��� �������� ����ϰ� �ٹ��������� 150�����̻� �Ǿ����� �޿�(salary)�� 10% �λ��� �޿��� �����ϴ� ���α׷� �ۼ��ϼ���.
<��� ���>
100�� �ٹ��������� 166 �Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�.
101�� �ٹ��������� 139 �Դϴ�. �޿��� �λ��� �� �����ϴ�.
102�� �ٹ��������� 195 �Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�.
103�� �ٹ��������� 135 �Դϴ�. �޿��� �λ��� �� �����ϴ�.
104�� �ٹ��������� 119 �Դϴ�. �޿��� �λ��� �� �����ϴ�.
200�� �ٹ��������� 163 �Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�. */

declare 
  type empid_type is table of number index by binary_integer;
  v_empid empid_type;
  v_wmonth number;

begin
  v_empid(1) := 100;
  v_empid(2) := 101;
  v_empid(3) := 102;
  v_empid(4) := 103;
  v_empid(5) := 104;
  v_empid(6) := 200;
  for i in v_empid.first..v_empid.last loop
    select trunc(months_between(sysdate, hire_date)) into v_wmonth from emp where employee_id = v_empid(i);
    if v_wmonth >= 150 then
      update emp set salary = salary * 1.1 where employee_id = v_empid(i);
      dbms_output.put_line(v_empid(i) || '�� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�.');
    else
      dbms_output.put_line(v_empid(i) || '�� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� �λ��� �� �����ϴ�.');
    end if;
  end loop;
  rollback;
end;
/

/*[����26] �迭�����ȿ� �ִ� ��� ��ȣ ���� �������� (100,110,200) 
�� ����� last_name, hire_date, department_name ������ �迭������ ��Ƴ��� �� 
ȭ�鿡 ����ϴ� ���α׷��� �ۼ��ϼ���.
<ȭ����>
100 ����� �̸��� King, �Ի��� ��¥�� 2003-06-17, �ٹ� �μ��̸��� Executive �Դϴ�.
110 ����� �̸��� Chen, �Ի��� ��¥�� 2005-09-28, �ٹ� �μ��̸��� Finance �Դϴ�.
200 ����� �̸��� whalen, �Ի��� ��¥�� 2003-09-17, �ٹ� �μ��̸��� administration �Դϴ�. */

declare 
  type rec_type is record(id number, last_name employees.last_name%type, hire_date employees.hire_date%type, department_name departments.department_name%type);
  type tab_type is table of rec_type index by pls_integer;
  v_tab tab_type;
begin
  v_tab(1).id := 100;
  v_tab(2).id := 110;
  v_tab(3).id := 200;
  for i in v_tab.first..v_tab.last loop
    select e.last_name, e.hire_date, d.department_name into v_tab(i).last_name, v_tab(i).hire_date, v_tab(i).department_name from emp e, departments d where e.department_id = d.department_id and employee_id = v_tab(i).id;
    dbms_output.put_line(v_tab(i).id || '����� �̸��� ' || v_tab(i).last_name || ', �Ի��� ��¥�� ' || to_char(v_tab(i).hire_date, 'yyyy-mm-dd') || ', �ٹ� �μ��̸��� ' || v_tab(i).department_name || '�Դϴ�.');
  end loop;

end;
/








-- continue��
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    continue when i > 5; --11g���� ����
    v_total := v_total + i;
    dbms_output.put_line('Out of loop total is : ' || v_total);
  end loop;
  
end;
/

declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      continue toploop when i+j > 5; -- continue���� Ȱ��: ���ư� loop���� ������ �� ����
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/

declare
  v_dept_id departments.department_id%type;
  v_dept_name departments.department_name%type;
  v_mgr_id departments.manager_id%type;
  v_loc_id departments.location_id%type;

begin
  select * into v_dept_id, v_dept_name, v_mgr_id, v_loc_id from departments where department_id = 10;
  dbms_output.put_line('�μ�ID: ' || v_dept_id || ', �μ���: ' || v_dept_name || ', �Ŵ�����: ' || v_mgr_id || ', ����ID: ' || v_loc_id);
  
end;
/

declare
  type dept_record_type is record
  (dept_id departments.department_id%type not null := 10, dept_name varchar2(30), dept_mgr number, dept_loc number, dept_rec departments%rowtype); -- user define type
  v_rec dept_record_type;
  
begin
  select * into v_rec.dept_rec from departments where department_id = v_rec.dept_id;
  dbms_output.put_line(v_rec.dept_rec.department_name);
  
end;
/

declare
  v_rec departments%rowtype;
  
begin
  select * into v_rec from departments where department_id = 10;
  dbms_output.put_line(v_rec.department_id);
  dbms_output.put_line(v_rec.department_name);
  dbms_output.put_line(v_rec.manager_id);
  dbms_output.put_line(v_rec.location_id);
  
end;
/

-- �迭

begin 
  update emp set salary = salary * 1.1 where employee_id = 100;
  update emp set salary = salary * 1.1 where employee_id = 200;
  rollback;

end;
/

declare
  type table_id_type is table of number index by binary_integer;
  v_tab table_id_type;
  
begin
  v_tab(1) := 100;
  v_tab(3) := 200;
  for i in v_tab.first..v_tab.last loop -- �迭.first: ���� ���� index / �迭.last: ���� ū index
    update emp set salary = salary * 1.1 where employee_id = v_tab(i);
  end loop;
  rollback;
  
end;
/

declare
  type table_id_type is table of number index by binary_integer;
  v_tab table_id_type;
  v_name emp.last_name%type;
  v_sal emp.salary%type;
  
begin
  v_tab(1) := 100;
  v_tab(3) := 200;
  for i in v_tab.first..v_tab.last loop 
    if v_tab.exists(i) then -- �迭�� ����ִ� �κ��� Ȯ���ϰ� �ִ� �κи� ����ϱ�
      update emp set salary = salary * 1.1 where employee_id = v_tab(i) returning last_name, salary into v_name, v_sal;
      dbms_output.put_line(v_name || ' ����� �޿��� ' || v_sal || '�� �����Ǿ����ϴ�');
    else
      dbms_output.put_line(i || ' ��� ��ȣ�� �����ϴ�.');
    end if;
  end loop;
  rollback;
  
end;
/

-- 1���� �迭
declare
  type num_type is table of number index by pls_integer;
  v_num num_type;
  
begin
  for i in 100..110 loop
    v_num(i) := i;
  end loop;
  for i in v_num.first..v_num.last loop
    dbms_output.put_line(v_num(i));
  end loop;
  
end;
/

-- 2���� �迭
declare
  type dept_rec_type is record(id number, name varchar2(30), mgr number, loc number);
  v_rec dept_rec_type;
  type dept_tab_type is table of v_rec%type index by pls_integer;
  v_tab dept_tab_type;
  
begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i * 10;
  end loop;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).id);
  end loop;

end;
/

declare
  type dept_rec_type is record(id number, name varchar2(30), mgr number, loc number);

  type dept_tab_type is table of dept_rec_type index by pls_integer;
  v_tab dept_tab_type;
  
begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i * 10;
  end loop;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).id);
  end loop;

end;
/

declare
  type dept_tab_type is table of departments%rowtype index by pls_integer;
  v_tab dept_tab_type;

begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i*10;
  end loop;
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).department_id);
  end loop;

end;
/