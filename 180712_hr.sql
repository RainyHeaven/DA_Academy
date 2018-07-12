--[����32] ������̺� �μ��ڵ带 �Է°����� �޾Ƽ� �� ������� employee_id, last_name, salary, job_id�� ����ϴ� ���α׷��� �����ϼ���. ��   �μ��ڵ��߿� 50,80, null ���� �ԷµǸ� full table scan �׿� �μ� �ڵ尪�� �Է� �ԷµǸ� index range scan���� �����ȹ�� �и��ϼ���.
var b_id number
execute :b_id := 50
execute :b_id := 10
execute :b_id := null

-- �Ǽ�Ȯ��(������ Ȯ��)
select department_id, count(*) from emp group by department_id order by department_id;
/*
10	1
20	2
30	6
40	1
50	45
60	5
70	1
80	34
90	3
100	6
110	2
null 1
*/
-- �ε��� Ȯ�� & ����
select * from user_indexes where table_name = 'EMP';
create index emp_deptid_idx on emp(department_id);

declare
  type emp_rec_type is record(empid emp.employee_id%type, lname emp.last_name%type, sal emp.salary%type, jobid emp.job_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_tab emp_tab_type;

begin 
  if :b_id in (50, 80) then
    select /*+ full(emp) parallel(emp, 2)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id = :b_id;
    dbms_output.put_line(:b_id || '�� �μ� ����� �����Դϴ�.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('���ID: ' || v_tab(i).empid || ' �̸�: ' || v_tab(i).lname || ' �޿�: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' ��å: ' || v_tab(i).jobid);
    end loop;
  elsif :b_id is null then
    select /*+ full(emp)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id is null;
    dbms_output.put_line('�μ��� ���� ����� �����Դϴ�.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('���ID: ' || v_tab(i).empid || ' �̸�: ' || v_tab(i).lname || ' �޿�: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' ��å: ' || v_tab(i).jobid);
    end loop;
  else 
    select /*+ index_rs(emp emp_empid_pk)*/employee_id, last_name, salary, job_id bulk collect into v_tab from emp where department_id = :b_id;
    dbms_output.put_line(:b_id || '�� �μ� ����� �����Դϴ�.');
    for i in v_tab.first..v_tab.last loop
      dbms_output.put_line('���ID: ' || v_tab(i).empid || ' �̸�: ' || v_tab(i).lname || ' �޿�: ' || trim(to_char(v_tab(i).sal, 'l999g999g999')) || ' ��å: ' || v_tab(i).jobid);
    end loop;  
  end if;

end;
/

/*[����33] ��� ��ȣ�� �Է� ������ �޾Ƽ� ����� ��ȣ, �̸�, �μ��̸� ������ ����ϴ� ���α׷��� �ۼ��մϴ�.
�� 100�� ����� �Է°����� ������ ���ܻ����� �߻��ϵ��� �ؾ� �մϴ�.
���� ���� �����ȣ ���� ������ ���ܻ��� ó���� ����� �ּ���.
<ȭ�� ���>
SQL> var b_id number
SQL> execute :b_id := 200
Result=> �����ȣ : 200, ����̸� : Whalen, �μ��̸� : Administration
SQL> execute :b_id := 100
100 ����� ��ȸ�Ҽ� �����ϴ�.
SQL> execute :b_id := 300
300 ����� �������� �ʽ��ϴ�. */

var b_id number
exec :b_id := 300

declare
  type emp_rec is record(lname emp.last_name%type, dname departments.department_name%type);
  v_rec emp_rec;
  vip exception;
  
begin
  if :b_id = 100 then
    raise vip;
  else
    select e.last_name, d.department_name into v_rec from employees e, departments d where e.department_id = d.department_id and e.employee_id = :b_id;
    dbms_output.put_line('Result=> �����ȣ : ' || :b_id || ', ����̸� : ' || v_rec.lname || ', �μ��̸� : ' || v_rec.dname);
  end if;

exception
  when vip then
    dbms_output.put_line(:b_id || ' ����� ��ȸ�� �� �����ϴ�.');
  
  when no_data_found then
    dbms_output.put_line(:b_id || ' ����� �������� �ʽ��ϴ�.');

end;
/






/*�Ͻ��� Ŀ������ ����Ǵ� select�� : �ݵ�� 1�� row�� fetch�ؾ� �Ѵ�
select * from emplopyees where employee_id = �Էº��� 
*/
var b_id number;
exec :b_id := 300;

declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

end;
/

/*exception
- �����߿� �߻��� PL/SQL ����
- oracle�� ���� �Ͻ������� �߻�
- ���α׷��� ���� ��������� �߻�
*/
declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' ����� �������� �ʽ��ϴ�.');
    
end;
/

exec :b_id := 20;
declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where department_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

end;
/

declare
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where department_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' ����� �������� �ʽ��ϴ�.');
    
  when too_many_rows then
    dbms_output.put_line('�μ��� �������� ����� �ֽ��ϴ�. ����� Ŀ���� ����ϼ���.');
    
end;
/

-- ORA - 01403(������ select �����͸� �������� �ʾ��� ��, ���� �迭 ��Ҹ� �����Ϸ��� �� ��)
declare
  v_rec employees%rowtype;
begin  
  begin
    select * into v_rec from employees where employee_id = 300;
  
  exception
    when no_data_found then
      dbms_output.put_line('����� �������� �ʽ��ϴ�.');
  end;
  -- exceptionó���� ������� ���������� ó���ؾ� �� �۾��� ������ �� �κ��� ���������� �и��ϰ� �� �ۿ��� �����Ͽ� �ذ� ����
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name); 
    
end;
/
select salary from employees where department_id = 20;

-- ���α׷��� exception���� ����Ǹ� �� ���� transaction�� rollback��
declare
  v_rec employees%rowtype;

begin
  update employees set salary = salary * 1.1 where department_id = 20;
  
  select * into v_rec from employees where department_id= 20;
  
  dbms_output.put_line(v_rec.last_name);

end;
/

declare
  v_rec employees%rowtype;

begin
  update employees set salary = salary * 1.1 where department_id = 20; 
  select * into v_rec from employees where department_id= 20;
  dbms_output.put_line(v_rec.last_name);

exception
  when too_many_rows then
    dbms_output.put_line('�������� row�� fetch�� �� ����');
  
  when others then
    dbms_output.put_line('���� ����');
    dbms_output.put_line(sqlcode); -- ���� �߻��� ���� �ڵ�
    dbms_output.put_line(sqlerrm); -- ���� �߻��� ���� �ڵ� + �޼���

end;
/

select salary from employees where department_id = 20;
rollback;


declare

begin
  delete from departments where department_id = 20;

exception
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
    
end;
/

declare
  pk_error exception; -- exception �̸� ��
  pragma exception_init(pk_error, -2292); -- ������ exception�� ������ȣ�� ����

begin
  delete from departments where department_id = 20;

exception
  when pk_error then
    dbms_output.put_line('�� ���� �����ϴ� row���� �ֽ��ϴ�.');
    
  when others then
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
end;
/
-- exception ����
declare
  e_invalid exception;
  
begin
  update employees set salary = salary * 1.1 where employee_id = 300;
  if sql%notfound then
    raise e_invalid; -- raise exception�� : �ش� exception�� �߻���Ŵ
  end if;

exception
  when e_invalid then
    --dbms_output.put_line('������ �����Ͱ� �����ϴ�');
    null; 
  
end;
/

-- ������ ���� ���� 
begin
  update employees set salary = salary * 1.1 where employee_id = 300;
  if sql%notfound then
    raise_application_error(-20000, '������ �����Ͱ� �����ϴ�'); -- ������ȣ�� -20000 ~ -20999�� ���̿��� �����ؾ� ��.
  end if;
  
end;
/

declare 
  v_rec employees%rowtype;
  
begin
  select * into v_rec from employees where employee_id = 300;

exception
  when no_data_found then
    raise_application_error(-20000, '��ȸ �����Ͱ� �����ϴ�', true); -- ���� ������ ���� ���ϴ� ���� �޽����� ���, true �ɼ��� ���� ���� �����ڵ嵵 ǥ��

end;
/