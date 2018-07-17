/*[����42] �����ȣ�� �Է°����� �޾Ƽ� �� ����� �ٹ� ����� ���ϴ� �Լ��� �����ϼ���. 
�� ���� �����ȣ�� ������ ���� ���� ������ȣ,�޽����� ��µǵ��� �ؾ��մϴ�. 
<�Լ� ����> 
execute dbms_output.put_line(get_year(100)) 
12 
select employee_id, last_name, get_year(employee_id) years_func 
from employees 
order by 1; 
EMPLOYEE_ID LAST_NAME  YEARS_FUNC 
----------- ---------- ----------  
        100 King               12        
        101 Kochhar            10          
        102 De Haan            15          
        103 hunold             10          
execute dbms_output.put_line(get_year(300)) 

begin  
dbms_output.put_line(get_year(300)); 
end; 
/ 
* 
ERROR at line 1: 
ORA-20000: 300�� ����� �������� �ʽ��ϴ�. 
ORA-06512: at "HR.GET_YEAR", line 14 
ora-01403: no data found 
ora-06512: at line 1  */
execute dbms_output.put_line(get_year(100));
select employee_id, last_name, get_year(employee_id) years_func from employees;
execute dbms_output.put_line(get_year(300));

create or replace function get_year(p_id number)
return number
is 
  v_wyear number;
  
begin
  select trunc(months_between(sysdate, hire_date)/12) into v_wyear from employees where employee_id = p_id;
  return v_wyear;
exception
  when no_data_found then
    raise_application_error(-20000, p_id||'�� ����� �������� �ʽ��ϴ�.', True);

end get_year;
/

/*[����43] �μ��ڵ带 �Է°����� �޾Ƽ� �μ��̸��� return �ϴ� �Լ��� ������ּ���. 
�μ��ڵ尡 ���� ��� '�˼����� �μ�'�� return�ؾ� �մϴ�. 
<�Լ� ������> 
select employee_id, last_name, department_id, dept_name_func(department_id) dept_name 
from employees; 
EMPLOYEE_ID LAST_NAME            DEPARTMENT_ID DEPT_NAME 
----------- -------------------- ------------- -------------------- 
        177 Livingston                      80 Sales 
        178 grant                              �˼����� �μ� 
         
exec dbms_output.put_line(dept_name_func(20)) 
marketing */
select employee_id, last_name, department_id, dept_name_func(department_id) dept_name from employees;
exec dbms_output.put_line(dept_name_func(20));

create or replace function dept_name_func(p_deptid number)
return varchar2
is
  v_dname departments.department_name%type;
  
begin
  select department_name into v_dname from departments where department_id = p_deptid;
  return v_dname;
  
exception
  when no_data_found then
    return '�˼����� �μ�';

end dept_name_func;
/

--������ : �Լ��� ������̺��� row�Ǽ���ŭ ���ư��� 
--�ذ� : ĳ�� ����� �ִ� scalar���������� ������� 

/*deterministic 
- �Լ��� �����ϴ� ��Ʈ : ĳ�ñ���� ���ư��� �Ѵ� 
  (���⼭�� �μ��ڵ��� ������ ����ŭ(���� �μ��ڵ�� 1���� ����) �Լ��� ���ư���) */
  
create or replace function dept_name_func(p_deptid number)
return varchar2
deterministic
is
  v_dname departments.department_name%type;
  
begin
  select department_name into v_dname from departments where department_id = p_deptid;
  return v_dname;
  
exception
  when no_data_found then
    return '�˼����� �μ�';

end dept_name_func;
/

/*[����44] ����Ÿ�� �÷� ������ ���̺� �ִ� �����ʹ� �������ĸ� ��� �� �־�� �ϴµ�  
�׷��� �ʴ� �����͸� Ȯ�� �ϴ� �Լ��� �����ϼ���. null �Ǵ� ���ڰ� ��� ������ 0��� ���ڴ� 1 ����ϼ���. 
desc locations 
 Name                                      Null?    Type 
 ----------------------------------------- -------- ------------------------- 
 LOCATION_ID                               NOT NULL NUMBER(4) 
 STREET_ADDRESS                                     VARCHAR2(40) 
 POSTAL_CODE                                        VARCHAR2(12) 
 CITY                                      NOT NULL VARCHAR2(30) 
 STATE_PROVINCE                                     VARCHAR2(25) 
 COUNTRY_ID                                         CHAR(2) 

select postal_code, as_number(postal_code)  from locations; 
POSTAL_CODE              AS_NUMBER(POSTAL_CODE) 
------------------------ ---------------------- 
                                              0 
00989                                         1 
10934                                         1 
1689                                          1 
6823                                          1 
26192                                         1 
99236                                         1 
50090                                         1 
98199                                         1 
m5v 2L7                                       0 
ysw 9T2                                       0  */

select postal_code, as_number(postal_code)  from locations;

-- if�� Ȱ��
create or replace function as_number(p_code varchar2)
return number
is
  v_num number;
begin
  if p_code is null then
    return 0;
  else
    v_num := to_number(p_code);
    return 1;
  end if;

exception
  when others then
    return 0;
    
end as_number;
/

-- nvl Ȱ��
create or replace function as_number(p_code varchar2)
return number
is
  v_num number;
begin
  v_num := to_number(nvl(p_code, 'Null'));
  return 1;

exception
  when others then
    return 0;
  
end as_number;
/

/*[����45] 1����100���� ���� ���ϴ� �Լ��� �����ϼ���. 
�� �μ������� 0�� ������ ��ü ���� ���ϰ�, 1�� ������ Ȧ���� ���� ���ϰ�,  
2�� ������ ¦���� ���� ���ϰ�, �ٸ� ���ڰ��� ������ ������ ������ �ؾ� �մϴ�. 
<�Լ� ȣ��> 
exec dbms_output.put_line(calc(0)) 
5050 
exec dbms_output.put_line(calc(1)) 
2500 
exec dbms_output.put_line(calc(2)) 
2550 
exec dbms_output.put_line(calc(3)) 
BEGIN dbms_output.put_line(calc(3)); END; 
* 
ERROR at line 1: 
ORA-20000: �μ������� 0(��ü),1(Ȧ��),2(¦��)���� �Է°��Դϴ�. 
ORA-06512: at "HR.CALC", line 23 
ora-06512: at line 1 */
exec dbms_output.put_line(calc(0));
exec dbms_output.put_line(calc(1));
exec dbms_output.put_line(calc(2));
exec dbms_output.put_line(calc(3));

create or replace function calc(p_num number)
return number
is
  v_sum number := 0;
begin
  if p_num = 0 then
    for i in 1..100 loop
      v_sum := v_sum + i;
    end loop;
    return v_sum;
    
  elsif p_num = 1 then
    for i in 1..100 loop
      if mod(i, 2) = 1 then
        v_sum := v_sum + i;
      end if;
    end loop;
    return v_sum;
    
  elsif p_num = 2 then
    for i in 1..100 loop
      if mod(i, 2) = 0 then
        v_sum := v_sum + i;
      end if;
    end loop;
    return v_sum;
    
  else 
    raise_application_error(-20000, '�μ������� 0(��ü), 1(Ȧ��), 2(¦��)���� �Է°��Դϴ�.', True);
  end if;

end calc;
/

/*[����46] �����ȣ�� �Է°����� �޾Ƽ� �� ����� �ҵ������ �������� 1�� ~ 3�� ��ҵ�, 4�� ~ 8�� �߼ҵ�, �׿� ������ ���ҵ��̶�� ���� ����Ѵ�. 
select employee_id, salary, income(employee_id) income 
from employees 
order by 2 desc; 
EMPLOYEE_ID     SALARY INCOME 
----------- ---------- ---------- 
        100      24000 ��ҵ� 
        102      17000 ��ҵ� 
        101      17000 ��ҵ� 
        145      14000 ��ҵ� 
        146      13500 �߼ҵ� 
        108    13208.8 �߼ҵ� 
        205      12008 �߼ҵ�  */

select employee_id, salary, income(employee_id) income from employees;

-- 2�����迭 Ȱ��
create or replace function income(p_id number)
return varchar2
is
  type emp_rec_type is record(id employees.employee_id%type, rank number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;

begin
  select employee_id, rank()over(order by salary desc) bulk collect into v_emp_tab from employees order by employee_id;
  if v_emp_tab(p_id - 99).rank <= 3 then
    return '��ҵ�';
  elsif v_emp_tab(p_id - 99).rank between 4 and 8 then
    return '�߼ҵ�';
  else
    return '���ҵ�';
  end if;
  
end income;
/

show error;
-- �ζ��κ� Ȱ��
create or replace function income(p_id number)
return varchar2
is
  v_rank number;
begin
  select rank into v_rank from (select employee_id, rank()over(order by salary desc) as rank from employees) where employee_id = p_id;
  if v_rank <= 3 then
    return '��ҵ�';
  elsif v_rank between 4 and 8 then
    return '�߼ҵ�';
  else
    return '���ҵ�';
  end if;
end income;
/









-------------------------------------------------------------------------------- 

/*#package 
: ���ü��ִ� �������α׷�(���ν���,�Լ�), ����(global), Ÿ���� ��Ƴ��� ���α׷� 
- ���α׷� �ٱ������� ����� �� �ִ�. 

1.spec(public) 
- �ʼ��� �����ؾ��Ѵ� 
- ����, Ÿ�� , ���ν���    (������) 
- begin���� ���� 
- ���� �Ѵ� �� 
- ����� �����ڵ��� ��� ���α׷� �ٱ����� ��밡�� 
- spec�� ��������� ���� �����ڵ��� �ٱ����� ����� �� ���� 
create or replace package comm_pkg 
is 
  g_comm number :=0.1;   -- �۷ι� �����ν� ��𼭵� ��밡���ϴ� 
  procedure reset_comm(p_comm in number); -- ��Ű�� ���� ���ν��� ���� 
end comm_pkg; 
/ 

2.body(private) 
- ���� �ҽ� 
- begin���� ���� 
- �Լ��� ����ϰ� �ʹٸ� ���ν��� �տ� �����ؾ� �Ѵ�. 
- ȣ���ϰ��� �ϴ� ���α׷��� �׻� ���� ���ǰ� �Ǿ��־���Ѵ�(���� or �ٱ��ʿ�) */


create or replace package body comm_pkg 
is 
  function validate_comm(v_comm in number)
  return boolean 
  is 
    v_max_comm number; 
  begin 
    select max(commission_pct) into v_max_comm from employees; 
    if v_comm > v_max_comm then 
      return FALSE; 
    else 
      return TRUE; 
    end if; 
  end validate_comm; 

  procedure reset_comm(p_comm in number) 
  is 
  begin 
    if validate_comm(p_comm) then 
      dbms_output.put_line('old :' ||g_comm); 
      g_comm := p_comm; 
      dbms_output.put_line('new :' ||g_comm);    
    else 
      raise_application_error(-20000,'invalid'); 
    end if; 
  end reset_comm; 
end comm_pkg; 
/ 

--ȣ���ϰ��� �ϴ� ���α׷��� �ڿ� �����Ͽ����� �ҷ��� �� �ִ� ��� 
create or replace package body comm_pkg 
is 
  function validate_comm(v_comm in number) --�ʿ��� �κп� ���� ������� ���ش�(�Լ��� ���ϰ�����)
  return boolean 
  
  procedure reset_comm(p_comm in number) 
  is 
  begin 
    if validate_comm(p_comm) then 
      dbms_output.put_line('old :' ||g_comm); 
      g_comm := p_comm; 
      dbms_output.put_line('new :' ||g_comm);    
    else 
      raise_application_error(-20000,'invalid'); 
    end if; 
  end reset_comm; 
  
  function validate_comm(v_comm in number)
  return boolean 
  is 
    v_max_comm number; 
  begin 
    select max(commission_pct) into v_max_comm from employees; 
    if v_comm > v_max_comm then 
      return FALSE; 
    else 
      return TRUE; 
    end if; 
  end validate_comm; 

end comm_pkg; 
/ 

/*�� ��Ű���� ����� �ɱ�? 
- ���������� ���� ������ : �׻� �Բ� ����ϴ� �ΰ��� ���α׷��� ���� ����� �ȴٸ� ���������� ���� �þ�� 
- �۷ι� ������ ����ϰ� ������ */

create or replace procedure reset_comm(p_comm in number) 
is 
  g_comm number := 0.1; 
begin 
  if validate_comm(p_comm) then 
    dbms_output.put_line('old :' ||g_comm); 
    g_comm := p_comm; 
    dbms_output.put_line('new :' ||g_comm);    
  else 
    raise_application_error(-20000,'invalid'); 
  end if; 
end reset_comm; 
/ 

create or replace function validate_comm(v_comm in number) 
return boolean 
is 
  v_max_comm number; 
begin 
  select max(commission_pct) into v_max_comm from employees; 
  if v_comm > v_max_comm then 
    return FALSE; 
  else 
    return TRUE; 
  end if; 
end validate_comm; 
/ 

/*over loading 
: ������ �̸��� ���ν���, �Լ��� ���� �� �ִ�. 
to_char(��¥, ����) 
to_char(����, ����) 
- ���ĸŰ������� ������ �ٸ��ų�, ���(in,out,in out)�� �ٸ��ų� Ÿ���� �޶�� over loading�� �� �ִ� */

create or replace package pack_over 
is 
  type date_tab_type is table of date index by pls_integer; 
  type num_tab_type is table of number index by pls_integer; 
  procedure init(tab out date_tab_type, n number); 
  procedure init(tab out num_tab_type, n number); 
end pack_over; 
/ 
-- ���ĸŰ������� Ÿ���� �ٸ��� ������ ������ �̸��� procedure�� ���� �� �ִ� 

create or replace package body pack_over 
is 
  procedure init(tab out date_tab_type, n number) 
  is 
  begin 
    for i in 1..n loop 
      tab(i) := sysdate; 
    end loop; 
  end init; 

  procedure init(tab out num_tab_type, n number) 
  is 
  begin 
    for i in 1..n loop 
      tab(i) := i; 
    end loop; 
  end init; 
  
end pack_over; 
/ 

declare 
  date_tab pack_over.date_tab_type; 
  num_tab pack_over.num_tab_type; 
begin 
  pack_over.init(date_tab,5); 
  pack_over.init(num_tab,5); 
   
  for i in 1..5 loop 
    dbms_output.put_line(date_tab(i)); 
    dbms_output.put_line(num_tab(i)); 
  end loop; 
end; 
/