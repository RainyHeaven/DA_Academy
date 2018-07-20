/*[����58] �����ȣ�� �Է°����� �޾Ƽ� �޿��� 10% �λ��ϴ� update_proc ���ν����� �����ϼ���.
green ������ ������ �� �ý��� ���� CREATE SESSION �ο��Ͻð� update_proc ���ν��� execute ������ �ο� �մϴ�.
������̺� �޿��� ������ �� commit �߻��ϸ� �޿��� �����ϴ� ����ڰ���, ��¥, �����ȣ, ���� �޿�, ���ο� �޿��� �������̺�(audit_emp_sal) ������ �� �� �ִ� Ʈ����(sal_audit)�� �����ϼ���.
(�� �޿��� �����޿��ϰ� ���Ӱ� ����� �޿��� Ʋ����쿡�� �������̺� ���������� ����ǵ����ϼ���) */

-- <green ���� ����>
CREATE USER green IDENTIFIED BY oracle DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp QUOTA UNLIMITED ON users ACCOUNT UNLOCK;

-- <�������̺� ����>
create table audit_emp_sal(name varchar2(30), day timestamp,id number, old_sal number, new_sal number);

-- < sal_audit trigger����>
create or replace trigger sal_audit_trigger
after update of salary on employees for each row 
when (old.salary != new.salary)
begin
  insert into audit_emp_sal(name, day, id, old_sal, new_sal) values(user, systimestamp, :old.employee_id, :old.salary, :new.salary);
end sal_audit_trigger;
/

-- < update_proc ����>
create or replace procedure update_proc(p_id in number)
is 
begin
  update employees set salary = salary * 1.1 where employee_id = p_id;
end update_proc;
/

-- < update_proc execute ���� green������ �ο�>
grant execute on update_proc to green;

-- <green ���� �۾�>
conn green/oracle;
select * from user_tab_privs;
execute hr.update_proc(100);
rollback;
execute hr.update_proc(200);
commit;

-- < �������̺� ��ȸ>
conn hr/hr;
select * from audit_emp_sal;
truncate table audit_emp_sal;

-- trigger soucecode ��ȸ
select * from user_triggers where trigger_name = 'SAL_AUDIT_TRIGGER';
select text from user_source;

-- [����59]������� �޿��� ������ �� �� ����� job_id �� ���� �ӱݿ��� �ְ� �ӱ� ���̿� �޿������θ� �Է�, �����ϵ��� �ϴ� ���α׷��� �ۼ��ϼ���. Ʈ���Ÿ� �̿��ϼž� �մϴ�.
select * from jobs;
select job_id, salary from employees where employee_id = 115;

create or replace trigger check_salary_trg
before insert or update of salary on employees for each row
declare
  v_maxsal number;
  v_minsal number;
begin
  select min_salary, max_salary into v_minsal, v_maxsal from jobs where job_id = :new.job_id;
  if :new.salary not between v_minsal and v_maxsal then
    raise_application_error(-20100, 'Invalid salary $'||:new.salary||'. Salaries for job'||:new.job_id||' must be between $'||v_minsal||' and $'||v_maxsal, true);
  end if;
end check_salary_trg;
/

update employees set salary = 3000 where employee_id = 115;
rollback;
update employees set salary = 6000 where employee_id = 115;
insert into employees(employee_id, last_name, email, hire_date, job_id, salary) values(300, 'happy', 'happy', sysdate, 'PU_CLERK', 5000);
rollback;
insert into employees(employee_id, last_name, email, hire_date, job_id, salary) values(300, 'happy', 'happy', sysdate, 'PU_CLERK', 6000);

/*[����60] �����ȣ, �޿��� �Է°����� �޾Ƽ� �����ϴ� ���α׷��� �����ϼ���.
�� ������� �޿��� ������ �� �� ����� job_id �� ���� �ӱݿ��� �ְ� �ӱ� ���̿� �޿������θ� �����ؾ��մϴ�. */
drop trigger check_salary_trg;

create or replace procedure emp_sal_proc(p_id number, p_sal number)
is
  v_max employees.salary%type;
  v_min employees.salary%type;
  v_jid employees.job_id%type;
begin
  select e.job_id, j.min_salary, j.max_salary into v_jid, v_min, v_max from employees e, jobs j where e.employee_id = p_id and e.job_id = j.job_id;
  if p_sal between v_min and v_max then
    update employees set salary = p_sal where employee_id = p_id;
  else
    raise_application_error(-20100, 'Invalid salary $'||p_sal||'. Salaries for job '||v_jid||' must be between $'||v_min||' and $'||v_max, true);
  end if;
end emp_sal_proc;
/

show error;
exec emp_sal_proc(115,7000);

-- [����61] PLSQL ������ �����ϴ� 50���� �л����� ������� �������� ������ ����� ������ ����. �� �ڷḦ ��������ǥ�� �����ϼ���.
B, A, B, A, A, B, O, A, A, A, 
B, AB, B, AB, AB, A, A, O, AB, O, 
B, O, B, B, A, A, O, A, A, AB, 
B, O, B, B, B, A, AB, A, A, B, 
B, B, O, B, O,B, A, A, AB, A, 

declare
  type btype_type is table of varchar2(10);
  type result_type is table of number index by varchar2(10);
  v_btype btype_type;
  v_result result_type;
  ind varchar2(10);
begin
  v_btype := btype_type('b', 'a', 'b', 'a', 'a', 'b', 'o', 'a', 'a', 'a', 'b', 'ab', 'b', 'ab', 'ab', 'a', 'a', 'o', 'ab', 'o', 'b', 'o', 'b', 'b', 'a', 'a', 'o', 'a', 'a', 'ab', 'b', 'o', 'b', 'b', 'b', 'a', 'ab', 'a', 'a', 'b', 'b', 'b', 'o', 'b', 'o','b', 'a', 'a', 'ab', 'a');
  for i in v_btype.first..v_btype.last loop
    if v_result.exists(v_btype(i)) then
      v_result(v_btype(i)) := v_result(v_btype(i)) + 1;
    else
      v_result(v_btype(i)) := 1;
    end if;
  end loop;
  ind := v_result.first;
  dbms_output.put_line('-------- IT WILL������ ���� --------');
  loop
    dbms_output.put_line(rpad(upper(ind), 3, ' ')||': '||rpad(v_result(ind), 3, ' ')||'|'||lpad(' ', v_result(ind), '��'));
    ind := v_result.next(ind);
    exit when ind is null;
  end loop;
  dbms_output.put_line('---------------------------------');
end;
/
    









create or replace function query_call_sql(p_a in number)
return number
is 
  v_sal number;
begin
  select salary into v_sal from employees where employee_id = 170;
  return p_a + v_sal;
end query_call_sql;
/

exec dbms_output.put_line(query_call_sql(1000));

-- update�� �Լ��� ���ÿ� ���� ���̺��� read / write ����� mutating error �߻�
update employees set salary = query_call_sql(10000) where employee_id = 101;

create table log_table(username varchar2(30), day timestamp, message varchar2(100));
create table temp_table(n number);
create or replace procedure log_message(p_message in varchar2)
is
begin
  insert into log_table(username, day, message) values(user, current_date, p_message);
  commit;
end;
/

select * from log_table;
select * from temp_table;

begin
  insert into temp_table(n) values(100);
  log_message('�ұ�����');
end;
/
rollback;

delete from temp_table;
truncate table log_table;
commit;

create or replace procedure log_message(p_message in varchar2)
is
  pragma autonomous_transaction; -- ���� transaction ó�� / ���ο� commit �Ǵ� rollback�� �ݵ�� �־�� ��
begin
  insert into log_table(username, day, message) values(user, current_date, p_message);
  commit;
end;
/

begin
  insert into temp_table(n) values(100);
  log_message('�ұ�����');
end;
/
rollback;

select * from log_table;
select * from temp_table;

-- ��� update�� üũ, ����ϴ� Ʈ����
create or replace trigger sal_audit_trigger
after update of salary on employees for each row 
when (old.salary != new.salary)
declare
  pragma autonomous_transaction;
begin
  insert into audit_emp_sal(name, day, id, old_sal, new_sal) values(user, systimestamp, :old.employee_id, :old.salary, :new.salary);
  commit;
end sal_audit_trigger;
/