/*[����6]�����ȣ�� �Է°����� �޾Ƽ� �� ����� �޿��� 10%�λ��ϴ� ���α׷��� �����ϼ���.
ȭ���� ��µǴ� ����� ���� �� ���ް� ���� �� ������ �Ʒ��� ���� ��� �� transaction�� rollback �ϼ���.
���� �� ���� : 24000
���� �� ���� : 26400 */

drop table emp purge;
create table emp as select * from employees;

alter table emp add constraint emp_empid_pk primary key(employee_id);

var b_id number
execute :b_id := 100

declare
  sal emp.salary%type;

begin
  select salary into sal from emp where employee_id = :b_id;
  update emp set salary = salary * 1.1 where employee_id = :b_id;
  if sql%found then
    dbms_output.put_line('���� �� ���� : ' || sal);
    dbms_output.put_line('���� �� ���� : ' || (sal * 1.1));
    rollback;
  else
    dbms_output.put_line('������ �����߽��ϴ�')
  end if;

end;
/


declare
  v_sal emp.salary%type;
  v_name emp.last_name%type;

begin
  select salary into v_sal from emp where employee_id = :b_id;
  dbms_output.put_line('���� �� ���� : ' || v_sal);
  
  -- returning: DML���忡 fetch����� �߰��� / ���� column�� ���� ���� / 1�� row�� ����
  update emp set salary = salary * 1.1 where employee_id = :b_id returning salary, last_name into v_sal, v_name;
  dbms_output.put_line('���� �� ���� : ' || (v_sal) || '����̸��� : ' || v_name);
  
  rollback;

end;
/

/*[����7] �����ȣ�� �Է°����� �޾Ƽ� �� ����� �����ϴ� ���α׷��� �����ϼ���.
ȭ���� ��µǴ� ����� �Ʒ��� ���� ��� �� transaction�� rollback �ϼ���.
(emp ���̺� ����ϼ���.)
<ȭ�����>
������ ����� ��� ��ȣ�� 100 �̰�  ����� �̸��� King �Դϴ�. */

var b_id number
execute :b_id := 100

declare
  v_name emp.last_name%type;

begin
  delete from emp where employee_id = :b_id returning last_name into v_name;
  dbms_output.put_line('������ ����� ��� ��ȣ�� ' || :b_id || ' �̰� ����� �̸��� ' || v_name || ' �Դϴ�.');
  rollback;

end;
/
select * from emp where employee_id = 100;

/*[����8] �μ��ڵ带 �Է°����� �޾Ƽ� �� �μ��� �ٹ��ϴ� ����� �ο����� ����Ͻð� 
�� �μ� ������� �޿��߿� 10000 �̸��� ����� 10% �λ��� �޿��� �����ϴ� ���α׷��� �ۼ��ϼ���.
ȭ������� �� rollback �ϼ���.(emp ���̺� ����ϼ���)
<ȭ�����>
20 �μ��� �ο�����  2�� �Դϴ�.
20 �μ��� ������ ROW�� ���� 1 �Դϴ�. */

var b_id number
execute :b_id := 20

declare
  v_cnt number;

begin
  select count(*) into v_cnt from emp where department_id = :b_id;
  update emp set salary = salary * 1.1 where department_id = :b_id and salary < 10000;
  dbms_output.put_line(:b_id || ' �μ��� �ο����� ' || v_cnt || '�� �Դϴ�.');
  dbms_output.put_line(:b_id || ' �μ��� ������ ROW�� ���� ' || sql%rowcount || ' �Դϴ�.');
  rollback;
end;
/

/*[����9] ���̸� �Է°����� �޾Ƽ� ����, ���, û�ҳ�, ���� ������ּ���
���� 1�� �̻� 6�� �̸�
��� ���� : 6�� �̻� 13 �̸�
û�ҳ� 13�̻� 19�� �̸�
���� 19�� �̻� */
var b_myage number
exec :b_myage := 15

begin 
  if :b_myage >= 1 and :b_myage < 6 then dbms_output.put_line('���� �Դϴ�');
  elsif :b_myage >= 6 and :b_myage < 13 then dbms_output.put_line('��� �Դϴ�');
  elsif :b_myage >= 13 and :b_myage < 19 then dbms_output.put_line('û�ҳ� �Դϴ�');
  elsif :b_myage >= 19 then dbms_output.put_line('���� �Դϴ�');
  else dbms_output.put_line('�ùٸ� ���̸� �Է����ּ���');
  end if;
  
end;
/

-- [����10] ���ڸ� �Է°� �޾Ƽ� ¦�� ���� Ȧ�� ������ ����ϴ� ���α׷��� �ۼ��ϼ���.
var v_a number
execute :v_a := 7

begin
  if mod(:v_a, 2) = 1 then dbms_output.put_line('Ȧ���Դϴ�.');
  elsif mod(:v_a, 2) = 0 then dbms_output.put_line('¦���Դϴ�.');
  else dbms_output.put_line('�ùٸ� ���ڸ� �Է��ϼ���');
  end if;

end;
/

/*[����11] �޿�, Ŀ�̼Ǹ� �Է� ������ �޾Ƽ� �ΰ��� ���ϴ� ���α׷��� ���弼��.
<ȭ�����>
�� ���ε� ������ ���� �Է����ּ���
<ȭ�����>
�޿��� �ԷµǾ����ϴ�.10000
<ȭ�����>
Ŀ�̼Ǹ� �ԷµǾ����ϴ�.10 
<ȭ�����>
10010 */
var b_sal number
var b_comm number
exec :b_sal := 10000;
exec :b_comm := 10;

begin
  if :b_comm is null and :b_sal is not null then dbms_output.put_line('�޿��� �ԷµǾ����ϴ�.' || :b_sal);
  elsif :b_sal is null and :b_comm is not null then dbms_output.put_line('Ŀ�̼Ǹ� �ԷµǾ����ϴ�.' || :b_comm);
  elsif :b_sal is not null and :b_comm is not null then dbms_output.put_line(:b_sal + :b_comm);
  else dbms_output.put_line('�� ���ε� ������ ���� �Է����ּ���.');
  end if;

end;
/

/*[����12] �ΰ��� ���ڸ� �Է��ؼ� �ش� ������ ���̰��� ����ϼ���.
���ڸ� ��� �Է��ϴ� ū ���ڿ��� ���� ���ڷ� ���⸦ �ϼ���.*/

var v_a number
var v_b number
execute :v_a := 10
execute :v_b := 7

print v_a v_b

begin
  if :v_a > :v_b then dbms_output.put_line(:v_a - :v_b);
  else dbms_output.put_line(:v_b - :v_a);
  end if;

end;
/

/*[����13] �����ȣ�� �Է°����� �޾Ƽ� �� ����� �ٹ��������� ����ϰ� �ٹ���������
150���� �̻��̸� �޿��� 20% �λ��� �޿��� ����, 
149���� ���� �۰ų� ���� 100���� ���� ũ�ų� ������  10%�λ��� �޿��� ����,
100���� �̸��� �ٹ��ڴ� �ƹ� �۾��� �������� �ʴ� ���α׷��� �ۼ��ϼ���.
�׽�Ʈ�� ������ rollback �մϴ�.(emp ���̺� ���)
<ȭ�� ���>
100 ����� �ٹ��������� 154 �Դϴ�. �޿��� 20% �����Ǿ����ϴ�.
<ȭ�� ���>
166 ����� �ٹ��������� 97 �Դϴ�. 100 ���� �̸��̹Ƿ�  �޿� ���� �ȵ˴ϴ�. */

var b_empid number
exec :b_empid := 100

declare 
  v_wmonth number;
  
begin
  select trunc(months_between(sysdate, hire_date), 0) into v_wmonth from emp where employee_id = :b_empid;
  
  if v_wmonth >= 150 then update emp set salary = salary * 1.2 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� 20% �λ�Ǿ����ϴ�.');
  elsif v_wmonth between 100 and 149 then update emp set salary = salary * 1.1 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�.');
  else dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. 100���� �̸��̹Ƿ� �޿� ������ �����ϴ�.');
  end if;
    
  rollback;
  
end;
/

-- ���� 14�� : ����13���� case������ �ذ��Ͻÿ�
declare 
  v_wmonth number;
  
begin
  select trunc(months_between(sysdate, hire_date), 0) into v_wmonth from emp where employee_id = :b_empid;
  
  case
  when v_wmonth >= 150 then update emp set salary = salary * 1.2 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� 20% �λ�Ǿ����ϴ�.');
  when v_wmonth between 100 and 149 then update emp set salary = salary * 1.1 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. �޿��� 10% �λ�Ǿ����ϴ�.');
  else dbms_output.put_line(:b_empid || '����� �ٹ��������� ' || v_wmonth || '�Դϴ�. 100���� �̸��̹Ƿ� �޿� ������ �����ϴ�.');
  end case;
    
  rollback;
  
end;
/

/*[����15] ȭ���� ���� 1 ���� 10 ���� ����ϴ� ���α׷��� �ۼ��մϴ�. �� 4,8���� ������� ������.
<ȭ�����>
1
2
3
5
6
7
9
10 */
-- if��
declare
  i number := 1;

begin
  loop 
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    elsif i > 10 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

declare
  i number := 1;

begin
  loop 
    if i = 4 or i = 8 then null;
    else dbms_output.put_line(i);
    end if;
    i := i + 1;
    exit when i > 10;
  end loop;

end;
/

-- while��
declare
  i number := 1;
  
begin
  while i <= 11 loop
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    elsif i > 10 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

-- for��
begin
  for i in 1..10 loop
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

begin 
  for i in 1..10 loop
    if i = 4 or i = 8 then null;
    else dbms_output.put_line(i);
    end if;
  end loop;

end;
/

begin 
  for i in 1..10 loop
    if i != 4 and i != 8 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/


--[����16] 1������ 100���� ¦���� ����ϼ���.(�⺻ loop, while loop, for loop)
--loop
declare
  i number := 1;

begin
  loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    elsif i > 100 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

-- while
declare
  i number := 1;

begin
  while i <= 100 loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    end if;
    i := i + 1;
  end loop;

end;
/

-- for
begin
  for i in 1 .. 100 loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

-- [����17] 1������ 100���� Ȧ���� ����ϼ���.
--loop
declare
  i number := 1;

begin
  loop
    if i > 100 then exit;
    elsif mod(i, 2) = 1 then dbms_output.put_line(i); 
    end if;
    i := i + 1;
  end loop;

end;
/

-- while
declare
  i number := 1;

begin
  while i <= 100 loop
    if mod(i, 2) = 1 then dbms_output.put_line(i);
    end if;
    i := i + 1;
  end loop;

end;
/

-- for
begin
  for i in 1 .. 100 loop
    if mod(i, 2) = 1 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

/*[����18] ������ 2�� ����ϴ� ���α׷��� �ۼ��ϼ���.
2 * 1 = 2
2 * 2 = 4
2 * 3 = 6
2 * 4 = 8
2 * 5 = 10
2 * 6 = 12
2 * 7 = 14
2 * 8 = 16
2 * 9 = 18*/

declare
  v_dan number := 2;
  v_result number;

begin
  for i in 1..9 loop
    v_result := v_dan * i;
    dbms_output.put_line(v_dan || ' * ' || i || ' = ' || v_result);
  end loop;

end;
/






-- �������: boolean
declare
  v_flag boolean := true;
  
begin
  if v_flag then
    dbms_output.put_line('��');
  end if;

end;
/

declare
  v_flag boolean := true;
  
begin
  if v_flag then
    dbms_output.put_line('��');
  else
    dbms_output.put_line('����');
  end if;

end;
/

/*if��
if ���� then �����϶� ������ ���;
elsif ���� then �����϶� ������ ���;
else ���� ���� �� ������ ���;
end if;

- �񱳿�����
x > y / x < y / x = y / x <> y / x >= y / x <= y
- ��������
and, or, not
- null ��
is null, is not null */

declare
 v_grade char(1) := upper('c');
 v_appraisal varchar2(30);
 
begin
  v_appraisal := case v_grade when 'A' then '�����߾��' when 'B' then '���߾��' when 'C' then '������ ���ؿ�' else '�ϰ� ����̾�!!' end;
  dbms_output.put_line('����� ' || v_grade || ' �򰡴� ' || v_appraisal );
  
end;
/

declare
 v_grade char(1) := upper('c');
 v_appraisal varchar2(30);
 
begin
  v_appraisal := case when v_grade = 'A' then '�����߾��' when v_grade in ('B', 'C') then '���߾��' when v_grade = 'D' then '������ ���ؿ�' else '�ϰ� ����̾�!!' end;
  dbms_output.put_line('����� ' || v_grade || ' �򰡴� ' || v_appraisal );
  
end;
/

/*case ��
case
  when ��1 then �����϶� �۾�
  when ��2 then �����϶� �۾�
  else ������ ������ �۾�
end case
*/

-- �ݺ���
-- loop��
declare 
  i number := 1;

begin
  loop
    dbms_output.put_line(i);
    i := i + 1;
    if i > 10 then exit;
    end if;
  end loop;

end;
/

-- while loop ��
declare
  i number := 1;

begin
  while i <= 10 loop
    dbms_output.put_line(i);
    i := i+1;
    if i = 5 then exit;
  end loop;

end;
/

-- for ��
begin 
  for i in 1..10 loop
    dbms_output.put_line(i);
    -- i := i + 1; <- ����: count ������ �Ҵ� �Ұ�
  end loop;
  
end;
/

declare
  v_start number := 1;
  v_end number := 10;

begin
  for i in reverse v_start..v_end loop -- reverse: ū������ �������� loop
    dbms_output.put_line(i);
  end loop;

end;
/

