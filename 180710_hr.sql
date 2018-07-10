/*[����27]�迭 ������ �ִ� 100,101,102,103,104, 200 �����ȣ�� �������� ��� �̸�, �ٹ������� 150�����̻� �Ǿ����� �޿�(salary)�� 10% �λ��� �޿��� ������ �� , �λ� �� �޿�, �λ� �� �޿��� ����ϴ�  ���α׷��� �ۼ��ϼ���.
��� ��ȣ : 100 ��� �̸� :  King    �ٹ������� :  166 �λ� �� �޿� : 24000 �λ� �� �޿� : 26400
��� ��ȣ : 101 ��� �̸� :  Kochhar �ٹ������� :  139 17000 �޿��� �λ��� �� �����ϴ�.
��� ��ȣ : 102 ��� �̸� :  De Haan �ٹ������� :  195 �λ� �� �޿� : 17000 �λ� �� �޿� : 18700
��� ��ȣ : 103 ��� �̸� :  Hunold  �ٹ������� :  135 9000 �޿��� �λ��� �� �����ϴ�.
��� ��ȣ : 104 ��� �̸� :  ernst   �ٹ������� :  119 6000 �޿��� �λ��� �� �����ϴ�.
��� ��ȣ : 200 ��� �̸� :  Whalen  �ٹ������� :  163 �λ� �� �޿� : 4400 �λ� �� �޿� : 4840 */

declare
  type rec_emp_type is record(lname emp.last_name%type, wmonth number, sal emp.salary%type);
  type tab_num_type is table of number;
  v_empid tab_num_type := tab_num_type(100, 101, 102, 103, 104, 200);
  v_sal rec_emp_type;
  v_newsal emp.salary%type;
  
begin
  for i in v_empid.first..v_empid.last loop
    select last_name, trunc(months_between(sysdate, hire_date)), salary into v_sal.lname, v_sal.wmonth, v_sal.sal from employees where employee_id = v_empid(i);
    if v_sal.wmonth >= 150 then
      update emp set salary = salary * 1.1 where employee_id = v_empid(i) returning salary into v_newsal;
      dbms_output.put_line('��� ��ȣ : ' || v_empid(i) || ' ��� �̸� : ' || rpad(v_sal.lname, 8, ' ') || '�ٹ������� : ' || v_sal.wmonth || ' �λ� �� �޿� : ' || v_sal.sal || ' �λ� �� �޿� : ' || v_newsal);
    else
      dbms_output.put_line('��� ��ȣ : ' || v_empid(i) || ' ��� �̸� : ' || rpad(v_sal.lname, 8, ' ') || '�ٹ������� : ' || v_sal.wmonth || ' ' || v_sal.sal || ' �޿��� �λ��� �� �����ϴ�.');
    end if;
  end loop;
  rollback;

end;
/

/*[����28] �迭�� 1,2,4,5,6,10,20,21,55,60,22,8,0,6,20,40,6,9 ���� �ֽ��ϴ�.
	 ã�� ������ �迭 ��ġ ���� �Ѱ��� ������ ����ϼ���.
<ȭ����>
20 ���� �迭�� 7,15 ��ġ�� ������ �� 2 �� �ֽ��ϴ�.
100 ���� �����ϴ�. */
declare
  type target_num_type is table of number;
  type loc_num_type is table of number index by pls_integer;
  v_tlist target_num_type := target_num_type(1,2,4,5,6,10,20,21,55,60,22,8,0,6,20,40,6,9);
  v_loc loc_num_type;
  v_target number;
  v_loc_char varchar2(100);

begin  
  v_target := 20;
  for i in v_tlist.first..v_tlist.last loop
    if v_tlist(i) = v_target then
      v_loc(i) := i;
    end if;
  end loop;
  
  if v_loc.count > 0 then
    for i in v_loc.first..v_loc.last loop
      if v_loc.exists(i) then
        v_loc_char := v_loc_char || ',' || v_loc(i);
      end if;
    end loop;
    dbms_output.put_line(v_target || ' ���� �迭�� ' || ltrim(v_loc_char, ',') || '��ġ�� ������ �� ' || v_loc.count || '�� �ֽ��ϴ�.');
  else
    dbms_output.put_line(v_target || ' ���� �����ϴ�.');
  end if;

end;
/

/*[����29] ����� last_name ���� �Է� �޾Ƽ� �� ����� employee_id, last_name, department_name ����ϰ� 
������ ���� last_name�� �Է� �Ұ�쿡��  "Hong �̶�� ����� �������� �ʽ��ϴ�."  ��� �ϴ� ���α׷��� ���弼��.
�Է°� : king
Employee Id = 156 Name = King Department Name = Sales
Employee Id = 100 Name = King Department Name = Executive

�Է°� : hong
hong �̶�� ����� �������� �ʽ��ϴ�. */

var ename varchar2(10);
exec :ename := 'hong';

declare
  cursor emp_cur is select e.employee_id, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
  
begin  
  for emp_rec in emp_cur loop
    if emp_cur%found then
      dbms_output.put_line('Employee Id = ' || emp_rec.employee_id || ' Name = ' || initcap(:ename) || ' Department Name = ' || emp_rec.department_name);
    else -- fetch�� ����� ���� �� for���� �ٷ� Ż���ع��� else���� ������� ����
      dbms_output.put_line(initcap(:ename) || '�̶�� ����� �������� �ʽ��ϴ�.');
    end if;
  end loop;

end;
/

declare
  cursor emp_cur is select e.employee_id, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
  v_result emp_cur%rowtype;
  
begin  
  open emp_cur;
  loop
    fetch emp_cur into v_result;
    if emp_cur%rowcount = 0 then
      dbms_output.put_line(initcap(:ename) || '�̶�� ����� �������� �ʽ��ϴ�.');
      exit;
    elsif emp_cur%notfound then
      exit;
    end if;
    dbms_output.put_line('Employee Id = ' || v_result.employee_id || ' Name = ' || initcap(:ename) || ' Department Name = ' || v_result.department_name);
  end loop;
  close emp_cur;
    
end;
/

declare
 cursor c1 is select e.employee_id, e.last_name, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
 v_c number := 0;

begin
  for v_rec in c1 loop
    DBMS_OUTPUT.PUT_LINE('Employee Id = ' || v_rec.employee_id ||' Name = ' || v_rec.last_name ||' Department Name = '||v_rec.department_name);
    v_c := c1%rowcount;
  end loop;
      
  if v_c = 0 then 
    dbms_output.put_line(initcap(:ename) ||' �̶�� ����� �������� �ʽ��ϴ�.');
  else
    DBMS_OUTPUT.PUT_LINE(initcap(:ename) ||' �̶�� ����� '|| v_c ||' �� �Դϴ�.');
  end if;
  
end;
/







/*���յ���������
- ��Į�� �������� �޸� ���߰��� ������ �� �ִ�
- ���ڵ� ����: ���� �ٸ� ������ ������ ���� ����
- �迭: ������ ������ ������ ���� ����
  - index by table(���� �迭)
  - nested table(��ø ���̺�)
  - varray
*/

declare
  type tab_char_type is table of varchar2(10) index by pls_integer;
  v_city tab_char_type;
  
begin
  v_city(1) := '����';
  v_city(2) := '����';
  v_city(3) := '�λ�';
  v_city(4) := '����';
  
  dbms_output.put_line(v_city.count);
  dbms_output.put_line(v_city.first);
  dbms_output.put_line(v_city.last);
  dbms_output.put_line(v_city.next(1));
  dbms_output.put_line(v_city.prior(2));
  
  v_city.delete(3); -- �ش� �ε��� ����
  v_city.delete(1, 3); -- 1������ 3������ ����
  v_city.delete; -- ���� ����
  
  for i in v_city.first..v_city.last loop
    if v_city.exists(i) then
      dbms_output.put_line(v_city(i));
    else
      dbms_output.put_line(i || ' ��Ҵ� �������� �ʽ��ϴ�.');
    end if;
  end loop;
  
end;
/


declare
  type tab_char_type is table of varchar2(10); -- nested table �迭 Ÿ��
  v_city tab_char_type := tab_char_type('����', '����', '�λ�', '����');
  
begin
  
  dbms_output.put_line(v_city.count);
  dbms_output.put_line(v_city.first);
  dbms_output.put_line(v_city.last);
  dbms_output.put_line(v_city.next(1));
  dbms_output.put_line(v_city.prior(2));
  
  --v_city.delete(3); -- �ش� �ε��� ����
  --v_city.delete(1, 3); -- 1������ 3������ ����
  --v_city.delete; -- ���� ����
  v_city.extend(1); -- �迭�� data�� �߰��ϱ� ���� Ȯ��
  v_city(5) := '�뱸';
  
  for i in v_city.first..v_city.last loop
    if v_city.exists(i) then
      dbms_output.put_line(v_city(i));
    else
      dbms_output.put_line(i || ' ��Ҵ� �������� �ʽ��ϴ�.');
    end if;
  end loop;
  
end;
/

-- varray
declare
  type tab_char_type is varray(5) of varchar2(10);
  v_city tab_char_type := tab_char_type('����', '�λ�', '����');
  
begin
  v_city.extend(2);
  v_city(4) :='����';
  v_city(5) := '�뱸';
  for i in v_city.first..v_city.last loop
    dbms_output.put_line(v_city(i));
  end loop;
  
end;
/

/* cursor: �޸� ������, sql�� ���� �޸� ����
implicit cursor(�Ͻ��� Ŀ��)
- Ŀ���� ����Ŭ�� ����, �����Ѵ�
- select... into.. : �ݵ�� 1�� row�� fetch�ؾ� �Ѵ� */

declare
  -- 1.Ŀ�� ����
  cursor emp_cur is select last_name from employees where department_id = 20; 
  v_name varchar2(30);

begin
  -- 2. Ŀ�� open: �޸� �Ҵ�, parse, bind, execute, fetch
  open emp_cur; 
  
  -- 3. fetch: Ŀ���� �ִ� active set ����� ������ �ε��ϴ� �ܰ� 
  loop
    fetch emp_cur into v_name;
    exit when emp_cur%notfound;
    dbms_output.put_line(v_name);
  end loop;
  -- 4. Ŀ�� close: �޸� ����
  close emp_cur;
  
end;
/

declare
  -- 1.Ŀ�� ����
  cursor emp_cur is select e.last_name, e.salary, d.department_name from employees e, departments d where e.department_id = 20 and d.department_id = 20; 
  v_rec emp_cur%rowtype;

begin
  -- 2. Ŀ�� open: �޸� �Ҵ�, parse, bind, execute, fetch
  open emp_cur; 
  
  -- 3. fetch: Ŀ���� �ִ� active set ����� ������ �ε��ϴ� �ܰ� 
  loop
    fetch emp_cur into v_rec;
    exit when emp_cur%notfound; -- fetch�� �Ϸ�Ǹ� loop Ż��
    dbms_output.put_line(v_rec.last_name);
    dbms_output.put_line(v_rec.salary);
    dbms_output.put_line(v_rec.department_name);
  end loop;
  -- 4. Ŀ�� close: �޸� ����
  close emp_cur;
  
end;
/

declare
  cursor emp_cur is select * from employees where department_id = 20;
  
begin
  for emp_rec in emp_cur loop -- for loop ������ �̿�: record���� �ڵ����� / open, fetch, close �ܰ� �ڵ�
    dbms_output.put_line(emp_rec.last_name);
  end loop;

end;
/