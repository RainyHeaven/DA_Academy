/*[����47] �����ȣ�� �Է°����� �޾Ƽ� ���, �̸�, �μ��̸��� ����ϴ� ���ν����� �����ϼ���.
SQL> exec id_proc(100)
�����ȣ : 100  ��� �̸� : King  �μ��̸� : Executive
PL/SQL procedure successfully completed.

SQL> exec id_proc(200)
�����ȣ : 200  ��� �̸� : Whalen  �μ��̸� : Administration
PL/SQL procedure successfully completed.

SQL> exec id_proc(300)
300����� �������� �ʽ��ϴ�.
pl/sql procedure successfully completed. */
exec id_proc(100);
exec id_proc(200);
exec id_proc(300);

create or replace procedure id_proc(p_id number)
is
  type emp_rec_type is record(lname employees.last_name%type, dname departments.department_name%type);
  v_emp_rec emp_rec_type;
  
begin
  select last_name, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_id;
  dbms_output.put_line('�����ȣ : '||p_id||' ��� �̸� : '||v_emp_rec.lname||' �μ��̸� : '||v_emp_rec.dname);
  
exception
  when no_data_found then
    dbms_output.put_line(p_id||'����� �������� �ʽ��ϴ�.');
  
  when others then
    dbms_output.put_line(sqlerrm);
  
end id_proc;
/

/* [����48] ����̸��� �Է°����� �޾Ƽ� �����ȣ, �̸�, �μ��̸��� ����ϴ� ���ν����� �����ϼ���.
SQL> exec name_proc('de haan')
�����ȣ : 102  ��� �̸� : De Haan  �μ��̸� : Executive
PL/SQL procedure successfully completed.

SQL> exec name_proc('king')
�����ȣ : 156  ��� �̸� : King  �μ��̸� : Sales
�����ȣ : 100  ��� �̸� : King  �μ��̸� : Executive
PL/SQL procedure successfully completed.

SQL> exec name_proc('hong')
hong ����� �������� �ʽ��ϴ�.
PL/SQL procedure successfully completed. */
exec name_proc('de haan');
exec name_proc('king');
exec name_proc('hong');

create or replace procedure name_proc(p_name in varchar2)
is
  type emp_rec_type is record(id employees.employee_id%type, dname departments.department_name%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  v_name employees.last_name%type;
  
begin
  v_name := initcap(p_name);
  select employee_id, (select department_name from departments where department_id = e.department_id) bulk collect into v_emp_tab from employees e where last_name = v_name;
  if v_emp_tab.count = 0 then
    dbms_output.put_line(p_name||' ����� �������� �ʽ��ϴ�');
  else
    for i in v_emp_tab.first..v_emp_tab.last loop
      dbms_output.put_line('�����ȣ : '||v_emp_tab(i).id||' ��� �̸� : '||v_name||' �μ��̸� : '||v_emp_tab(i).dname);
    end loop;
  end if;
  
exception
  when others then
    dbms_output.put_line(sqlerrm);
    
end name_proc;
/

/*[����49] �����ȣ �Ǵ� ����̸��� �Է°����� �޾Ƽ� �����ȣ, �̸�, �μ��̸��� ����ϴ� ��Ű���� �����ϼ���.
SQL> execute emp_find.find(100)
�����ȣ: 100 ����̸�: King �μ��̸�: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find(500)
500����� �������� �ʽ��ϴ�.
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('king')
�����ȣ: 156 ����̸�: King �μ��̸�: Sales
�����ȣ: 100 ����̸�: King �μ��̸�: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('de haan')
�����ȣ: 102 ����̸�: De Haan �μ��̸�: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('hong')
Hong����� �������� �ʽ��ϴ�.
PL/SQL procedure successfully completed. */
execute emp_find.find(100);
execute emp_find.find(500);
execute emp_find.find('king');
execute emp_find.find('de haan');
execute emp_find.find('hong');

create or replace package emp_find
is
  type emp_rec_type is record(id employees.employee_id%type, lname employees.last_name%type, dname departments.department_name%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_rec emp_rec_type;
  v_emp_tab emp_tab_type;
  procedure find(p_id in number);
  procedure find(p_name in varchar2);

end emp_find;
/


create or replace package body emp_find
is
  procedure find(p_id number)
  is
  begin
    select employee_id, last_name, (select department_name from departments where department_id = e.department_id) into v_emp_rec from employees e where employee_id = p_id;
    dbms_output.put_line('�����ȣ : '||p_id||' ��� �̸� : '||v_emp_rec.lname||' �μ��̸� : '||v_emp_rec.dname);
  exception
    when no_data_found then
      dbms_output.put_line(p_id||'����� �������� �ʽ��ϴ�.');
    when others then
      dbms_output.put_line(sqlerrm);
  end find;
  
  procedure find(p_name in varchar2)
  is    
  begin
    select employee_id, last_name, (select department_name from departments where department_id = e.department_id) bulk collect into v_emp_tab from employees e where last_name = initcap(p_name);
    if v_emp_tab.count = 0 then
      dbms_output.put_line(p_name||' ����� �������� �ʽ��ϴ�');
    else
      for i in v_emp_tab.first..v_emp_tab.last loop
        dbms_output.put_line('�����ȣ : '||v_emp_tab(i).id||' ��� �̸� : '||v_emp_tab(i).lname||' �μ��̸� : '||v_emp_tab(i).dname);
      end loop;
    end if;
    
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      
  end find;

end emp_find;
/

/*[����50] ������� �޿��� 10% �λ��ϴ� ���α׷��� �������ּ���. 
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,180,190,200);
begin 
    emp_pkg.update_sal(v_num);
end;
/
�����ȣ : 100        ����̸� : King       ���� �޿� : 29040
�����ȣ : 103        ����̸� : Hunold     ���� �޿� : 9900
�����ȣ : 107        ����̸� : Lorentz    ���� �޿� : 4620
�����ȣ : 110        ����̸� : Chen       ���� �޿� : 9020
�����ȣ : 112        ����̸� : Urman      ���� �޿� : 8580
�����ȣ : 115        ����̸� : Khoo       ���� �޿� : 3410
�����ȣ : 160        ����̸� : Doran      ���� �޿� : 8250
�����ȣ : 170        ����̸� : Fox        ���� �޿� : 10560
�����ȣ : 180        ����̸� : Taylor     ���� �޿� : 3520
�����ȣ : 190        ����̸� : gates      ���� �޿� : 3190
�����ȣ : 200        ����̸� : Whalen     ���� �޿� : 5808 */
-- �׽�Ʈ
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,180,190,200);
begin 
    emp_pkg.update_sal(v_num);
end;
/
rollback;

create or replace package emp_pkg
is
  type numlist is table of number;
  procedure update_sal(p_list numlist);
  
end emp_pkg;
/

create or replace package body emp_pkg
is
  procedure update_sal(p_list numlist)
  is    
    type emp_rec_type is record(lname employees.last_name%type, nsal employees.salary%type);
    type emp_tab_type is table of emp_rec_type;
    v_emp_tab emp_tab_type;
    
  begin
    forall i in p_list.first..p_list.last
      update employees set salary = salary * 1.1 where employee_id = p_list(i) returning last_name, salary bulk collect into v_emp_tab;
    for i in p_list.first..p_list.last loop
      dbms_output.put_line('�����ȣ : '||rpad(p_list(i), 10, ' ')||'����̸� : '||rpad(v_emp_tab(i).lname, 10, ' ')||'���� �޿� : '||rpad(v_emp_tab(i).nsal, 10, ' '));
    end loop;
  end update_sal;

end emp_pkg;
/

/*[����51] �迭������ ���� ���ϴ� �͸��� ���α׷��� �ۼ��ϼ���. 
v_1 := 1,2,3,4,5
v_2 := 1,3

<ȭ����>

2 ���� ���Դϴ�.
4 ���� ���Դϴ�.
5 ���� ���Դϴ�. */

-- v_1 �������� v_2�� ���� �� ���
declare
  type numlist is table of number;
  v_1 numlist;
  v_2 numlist;
  
begin
  v_1 := numlist(1, 2, 3, 4, 5);
  v_2 := numlist(1, 3);
  for i in v_1.first..v_1.last loop
    for j in v_2.first..v_2.last loop
      if v_1(i) = v_2(j) then
        exit;
      elsif j = v_2.last then
        dbms_output.put_line(v_1(i)||' ���� ���Դϴ�.');
      end if;
    end loop;
  end loop;
  
end;
/

-- �ΰ��� ���� ���Ͽ� ��ġ���� �ʴ� ���� �����Ͽ� ���
-- for ���� ���� ���� ����ϴ� ����
declare
  type numlist is table of number;
  v_1 numlist;
  v_2 numlist;
  type output is table of number index by pls_integer;
  v_output output;
  
begin
  v_1 := numlist(1, 3, 4, 5);
  v_2 := numlist(1, 2, 3, 6, 7);
  -- v_1 - v_2
  for i in v_1.first..v_1.last loop
    for j in v_2.first..v_2.last loop
      if v_1(i) = v_2(j) then
        exit;
      elsif j = v_2.last then
        v_output(v_1(i)) := v_1(i);
        -- dbms_output.put_line(v_1(i)||' ���� ���Դϴ�.');
      end if;
    end loop;
  end loop;
  
  -- v_2 - v_1
  for i in v_2.first..v_2.last loop
    for j in v_1.first..v_1.last loop
      if v_2(i) = v_1(j) then
        exit;
      elsif j = v_1.last then
        v_output(v_2(i)) := v_2(i);
        --dbms_output.put_line(v_2(i)||' ���� ���Դϴ�.');
      end if;
    end loop;
  end loop;
  
  -- �����Ͽ� ���
  for i in v_output.first..v_output.last loop
    if v_output.exists(i) then
      dbms_output.put_line(v_output(i)||' �� ���� ���Դϴ�.');
    end if;
  end loop;
  
end;
/

-- ��3�� �迭�� ����� ������(��ø�� ��)�� ������ ���� Ȯ��
declare
  type numlist is table of number;
  v_1 numlist;
  v_2 numlist;
  type listsum is table of number index by pls_integer;
  v_listsum listsum;

begin
  v_1 := numlist(1, 3, 4, 5);
  v_2 := numlist(1, 2, 3, 6, 7);

  for i in v_1.first..v_1.last loop
    if v_listsum.exists(v_1(i)) then
      v_listsum(v_1(i)) := v_listsum(v_1(i)) + 1;
    else
      v_listsum(v_1(i)) := 1;
    end if;
  end loop;
  
  for i in v_2.first..v_2.last loop
    if v_listsum.exists(v_2(i)) then
      v_listsum(v_2(i)) := v_listsum(v_2(i)) + 1;
    else
      v_listsum(v_2(i)) := 1;
    end if;
  end loop;
  
  for i in v_listsum.first..v_listsum.last loop
    if v_listsum(i) = 1 then
      dbms_output.put_line(i||' ���� ���Դϴ�.');
    end if;
  end loop;
  
end;
/

/*[����52] ������� �޿��� 10% �λ��ϴ� ���α׷��� �������ּ���.
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,250,180,190,200,250,300);
begin 
    emp_pkg.update_sal(v_num);
    rollback;
end;
/
�����ȣ : 100        ����̸� : King       ���� �޿� : 29040
�����ȣ : 103        ����̸� : Hunold     ���� �޿� : 9900
�����ȣ : 107        ����̸� : Lorentz    ���� �޿� : 4620
�����ȣ : 110        ����̸� : Chen       ���� �޿� : 9020
�����ȣ : 112        ����̸� : Urman      ���� �޿� : 8580
�����ȣ : 115        ����̸� : Khoo       ���� �޿� : 3410
�����ȣ : 160        ����̸� : Doran      ���� �޿� : 8250
�����ȣ : 170        ����̸� : Fox        ���� �޿� : 10560
�����ȣ : 180        ����̸� : Taylor     ���� �޿� : 3520
�����ȣ : 190        ����̸� : Gates      ���� �޿� : 3190
�����ȣ : 200        ����̸� : Whalen     ���� �޿� : 5808
250 ó������ �ʴ� ���Դϴ�.
300 ó������ �ʴ� ���Դϴ�. */
-- �׽�Ʈ
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,250,180,190,200,250,300);
begin 
    emp_pkg.update_sal(v_num);
    rollback;
end;
/

-- Ǯ��
create or replace package emp_pkg
is
  type numlist is table of number;
  procedure update_sal(p_list numlist);
  
end emp_pkg;
/

create or replace package body emp_pkg
is
  procedure update_sal(p_list numlist)
  is    
    type emp_rec_type is record(empid employees.employee_id%type, lname employees.last_name%type, nsal employees.salary%type);
    type emp_tab_type is table of emp_rec_type;
    v_emp_tab emp_tab_type;
    
  begin
    forall i in p_list.first..p_list.last
      update employees set salary = salary * 1.1 where employee_id = p_list(i) returning employee_id, last_name, salary bulk collect into v_emp_tab;  
    for i in p_list.first..p_list.last loop
      for j in v_emp_tab.first..v_emp_tab.last loop
        if p_list(i) = v_emp_tab(j).empid then
          dbms_output.put_line('�����ȣ : '||rpad(v_emp_tab(j).empid, 10, ' ')||'����̸� : '||rpad(v_emp_tab(j).lname, 10, ' ')||'���� �޿� : '||rpad(v_emp_tab(j).nsal, 10, ' '));
          exit;
        elsif j = v_emp_tab.last then
          dbms_output.put_line(p_list(i)||' ó������ �ʴ� ���Դϴ�.');
        end if;
      end loop;
    end loop;
  end update_sal;

end emp_pkg;
/

-- ���ÿ� ���� ������ ��� ��ø�� �� ���ְ� ������� ����ϱ�
create or replace package emp_pkg
is
  type numlist is table of number;
  procedure update_sal(p_list numlist);
  
end emp_pkg;
/

create or replace package body emp_pkg
is
  procedure update_sal(p_list numlist)
  is    
    type emp_rec_type is record(empid employees.employee_id%type, lname employees.last_name%type, nsal employees.salary%type);
    type emp_tab_type is table of emp_rec_type;
    v_emp_tab emp_tab_type;
    type error_tab_type is table of number index by pls_integer;
    v_error error_tab_type;
    
  begin
    forall i in p_list.first..p_list.last
      update employees set salary = salary * 1.1 where employee_id = p_list(i) returning employee_id, last_name, salary bulk collect into v_emp_tab;  
    for i in v_emp_tab.first..v_emp_tab.last loop
      dbms_output.put_line('�����ȣ : '||rpad(v_emp_tab(i).empid, 10, ' ')||'����̸� : '||rpad(v_emp_tab(i).lname, 10, ' ')||'���� �޿� : '||rpad(v_emp_tab(i).nsal, 10, ' '));
    end loop;
    
    for i in p_list.first..p_list.last loop
      for j in v_emp_tab.first..v_emp_tab.last loop
        if p_list(i) = v_emp_tab(j).empid then
          exit;
        elsif j = v_emp_tab.last then
          v_error(p_list(i)) := 1;
        end if;
      end loop;
    end loop;
    
    for i in v_error.first..v_error.last loop
      if v_error.exists(i) then
        dbms_output.put_line(i||' ó������ �ʴ� ���Դϴ�.');
      end if;
    end loop;
  end update_sal;

end emp_pkg;
/

/*[���� 53] �Է°����� ���� ���ڵ��� ���� ���ϴ� �Լ�, ����� ���ϴ� �Լ��� ��Ű������ �����ϼ���.
declare
 v_num agg_pack.num_type := agg_pack.num_type(10,5,2,1,8,9,20,21);
begin
  dbms_output.put_line('�� : '||agg_pack.sum_fc(v_num));
  dbms_output.put_line('��� : '||agg_pack.avg_fc(v_num));
end;
/
�� : 76
��� : 9.5 */
-- �׽�Ʈ
declare
 v_num agg_pack.num_type := agg_pack.num_type(10,5,2,1,8,9,20,21);
begin
  dbms_output.put_line('�� : '||agg_pack.sum_fc(v_num));
  dbms_output.put_line('��� : '||agg_pack.avg_fc(v_num));
end;
/

-- Ǯ��
create or replace package agg_pack
is
  type num_type is table of number;
  function sum_fc(p_num in num_type) return number;
  function avg_fc(p_num in num_type) return number;

end agg_pack; 
/

create or replace package body agg_pack
is   
  function sum_fc(p_num in num_type)
  return number
  is
    v_sum number := 0;
  begin
    for i in p_num.first..p_num.last loop
      v_sum := (v_sum + p_num(i));
    end loop;
    return v_sum;
  end sum_fc;
  
  function avg_fc(p_num in num_type)
  return number
  is 
    v_avg number;
  begin
    v_avg := (sum_fc(p_num)/p_num.count);
    return v_avg;
  end avg_fc;

end agg_pack;
/

-- [����54] 10,10,10,20,20,40,40,50,50,50,60,60,60,30,30,30,30 �󵵼��� �迭�� �̿��ؼ� ���ϼ���.
declare
  type nlist_type is table of number;
  type result_type is table of number index by pls_integer;
  v_nlist nlist_type := nlist_type(10, 10, 10, 20, 20, 40, 40, 50, 50, 50, 60, 60, 60, 30, 30, 30, 30);
  v_result result_type;
  i number;
begin
  for i in v_nlist.first..v_nlist.last loop
    if v_result.exists(v_nlist(i)) then
      v_result(v_nlist(i)) := v_result(v_nlist(i)) + 1;
    else
      v_result(v_nlist(i)) := 1;
    end if;
  end loop;
  
  /* for�� Ȱ��
  for i in v_result.first..v_result.last loop
    if v_result.exists(i) then
      dbms_output.put_line(i||'�� �󵵼� '||v_result(i));
    end if;
  end loop; */
  
  i := v_result.first;
  
  -- next Ȱ��
  loop
    dbms_output.put_line(i||'�� �󵵼� '||v_result(i));
    i := v_result.next(i);
    exit when v_result.next(i) is null;
  end loop;
  
end;
/












-- ��Ű���� Ŀ�� ���ӻ���
create or replace package pack_cur
is	
  procedure open;
	procedure next(p_num number);
	procedure close;
end pack_cur;
/

create or replace package body pack_cur
is
	cursor c1 is  -- private cursor
		select  employee_id, last_name
		from    employees
		order by employee_id desc;
	v_empno number;
	v_ename varchar2(10);

  procedure open 
  is  
	begin  
	 if not c1%isopen then
           open c1;
           dbms_output.put_line('c1 cursor open');
         end if;
  end open; -- ��Ű������ open�� Ŀ���� close�� ������ �����ְ� �ȴ�
  
  procedure next(p_num number)
  is  
  begin  
		loop 
		    exit when c1%rowcount >= p_num;
		    fetch c1 into v_empno, v_ename;
		    dbms_output.put_line('Id :' ||v_empno||'  Name :' ||v_ename);
		end loop;
   end next;

   procedure close is
   begin
			if c1%isopen then
          			close c1;
				dbms_output.put_line('c1 cursor close');
      			end if;
   end close;
end pack_cur;
/

/*
sql> set serveroutput on 
         
sql> execute pack_cur.open
c1 cursor open
   
sql> execute pack_cur.next(3)
id :206  name :gietz
id :205  name :higgins
id :204  name :baer

sql> execute pack_cur.next(6)
id :203  name :mavris
id :202  name :fay
id :201  name :hartstein

sql> execute pack_cur.close
c1 cursor close */

-- fetch bulk limit
create or replace package pack_cur
is	
  	procedure open;
	procedure next(p_num number);
	procedure close;
end pack_cur;
/

create or replace package body pack_cur
is
	cursor c1 is  
		select  employee_id, last_name
		from    employees
		order by employee_id desc;
	
  procedure open 
  is  
  begin  
      if not c1%isopen then
          open c1;
          dbms_output.put_line('c1 cursor open');
      end if;
  end open;
  
  procedure next(p_num number)
  is
	type tab_type is table of c1%rowtype;
	v_tab tab_type;  
  begin  
       
	if c1%notfound then
	  dbms_output.put_line('�����Ͱ� �����ϴ�.');
	  return;
	else
		fetch c1 bulk collect into v_tab limit p_num; -- limit: bulk collect into�� row���� ������
      	end if;
   
   for i in v_tab.first..v_tab.last loop
     dbms_output.put_line('Id :' ||v_tab(i).employee_id||'  Name :' ||v_tab(i).last_name);
   end loop;
  end next;

	procedure close is
	begin
			if c1%isopen then
          			close c1;
				dbms_output.put_line('c1 cursor close');
      			end if;
	end close;
end pack_cur;
/

-- �׽�Ʈ
set serveroutput on 
         
execute pack_cur.open;
   
execute pack_cur.next(50);

execute pack_cur.close;

declare
  type emp_rec_type is record(jid employees.job_id%type, lname employees.last_name%type);
  type emp_tab_type is table of emp_rec_type;
  type emp_result_type is table of varchar2(300) index by varchar2(20);
  v_emp_tab emp_tab_type;
  v_result emp_result_type;
  v_index varchar2(20);
  
begin
  select job_id, last_name bulk collect into v_emp_tab from employees;
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_result.exists(v_emp_tab(i).jid) then
      v_result(v_emp_tab(i).jid) := v_result(v_emp_tab(i).jid)||', '||v_emp_tab(i).lname;
    else
      v_result(v_emp_tab(i).jid) := v_emp_tab(i).lname;
    end if;
  end loop;
  
  v_index := v_result.first;
  
  loop
    dbms_output.put_line('job_id�� '||v_index||'�� ��� : '||v_result(v_index));
    v_index := v_result.next(v_index);
    exit when v_index is null;
  end loop;
  
end;
/