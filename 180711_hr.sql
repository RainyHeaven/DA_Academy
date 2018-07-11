/* [����30] 2006�⵵�� �Ի��� ������� �ٹ� �����̸����� �޿��� �Ѿ�, ����� ����ϼ���.
<ȭ�����>
Seattle ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ��10,400 �̰� ��ձ޿��� ��5,200 �Դϴ�.
South San Francisco ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ��37,800 �̰� ��ձ޿��� ��2,907 �Դϴ�.
Southlake ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ��13,800 �̰� ��ձ޿��� ��6,900 �Դϴ�.
oxford ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ��59,100 �̰� ��ձ޿��� ��8,442 �Դϴ�. */

declare
  cursor sal2006 is select l.city, sum(e.salary) as sumsal, round(avg(e.salary)) as avgsal
                    from employees e, departments d, locations l
                    where e.department_id = d.department_id
                    and d.location_id = l.location_id
                    and e.hire_date between to_date('20060101', 'yyyymmdd') and to_date('20061231 235959', 'yyyymmdd hh24miss')
                    group by l.city;

begin
  for sal_rec in sal2006 loop
    dbms_output.put_line(sal_rec.city || ' ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ' || trim(to_char(sal_rec.sumsal, 'l999g999')) || ' �̰� ��ձ޿��� ' || trim(to_char(sal_rec.avgsal, 'l999g999')) || ' �Դϴ�.');
  end loop;
  
end;
/
-- bulk collect into Ȱ��
declare
  type rec_type is record(city locations.city%type, sumsal number, avgsal number);
  type tab_type is table of rec_type;
  v_tab tab_type;

begin
  select l.city, sum(e.salary) as sumsal, round(avg(e.salary)) as avgsal
  bulk collect into v_tab
  from employees e, departments d, locations l
  where e.department_id = d.department_id
  and d.location_id = l.location_id
  and e.hire_date between to_date('20060101', 'yyyymmdd') and to_date('20061231 235959', 'yyyymmdd hh24miss')
  group by l.city;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).city || ' ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ' || trim(to_char(v_tab(i).sumsal, 'l999g999')) || ' �̰� ��ձ޿��� ' || trim(to_char(v_tab(i).avgsal, 'l999g999')) || ' �Դϴ�.');
  end loop;

end;
/

-- Ŀ�� ���� ���� for���� �ٷ� select���� ���� �� �ڵ����� Ŀ�� ������
-- ����� Ŀ�������� �̸��� ���� -> Ŀ���� �Ӽ��� Ȯ���� �� ����
begin 
  for v_rec in (select l.city, sum(e.salary) as sumsal, round(avg(e.salary)) as avgsal
                    from employees e, departments d, locations l
                    where e.department_id = d.department_id
                    and d.location_id = l.location_id
                    and e.hire_date between to_date('20060101', 'yyyymmdd') and to_date('20061231 235959', 'yyyymmdd hh24miss')
                    group by l.city;) loop
    dbms_output.put_line(sal_rec.city || ' ���ÿ� �ٹ��ϴ� ������� �Ѿױ޿��� ' || trim(to_char(sal_rec.sumsal, 'l999g999')) || ' �̰� ��ձ޿��� ' || trim(to_char(sal_rec.avgsal, 'l999g999')) || ' �Դϴ�.');
  end loop;
  
end;
/

/*[����31] 30�� �μ� ������� �̸�, �޿�, �ٹ�������, �μ��̸��� ����ϰ� �� ����� �߿� �ٹ��������� 150���� �̻��� ������� �޿��� 10%�λ��ϴ� ���α׷��� �ۼ��ϼ���.
<ȭ�� ���>
����̸� : Raphaely �޿� : 11000 �ٹ������� : 172 �μ� �̸� :  Purchasing
Raphaely 10%�λ� �޿��� �����߽��ϴ�.
����̸� : Khoo �޿� : 3100 �ٹ������� : 167 �μ� �̸� :  Purchasing
Khoo 10%�λ� �޿��� �����߽��ϴ�.
����̸� : Baida �޿� : 2900 �ٹ������� : 136 �μ� �̸� :  Purchasing
����̸� : tobias �޿� : 2800 �ٹ������� : 141 �μ� �̸� :  purchasing
����̸� : Himuro �޿� : 2600 �ٹ������� : 125 �μ� �̸� :  Purchasing
����̸� : Colmenares �޿� : 2500 �ٹ������� : 116 �μ� �̸� :  Purchasing */
-- rowid Ȱ��
declare
  cursor sal_cur is select e.rowid, e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name from emp e, departments d where e.department_id = 30 and d.department_id = 30;
  
begin
  for sal_rec in sal_cur loop
    dbms_output.put_line('����̸� : ' || sal_rec.last_name || ' �޿� : ' || sal_rec.salary || ' �ٹ������� : ' || sal_rec.wmonth || ' �μ� �̸� : ' || sal_rec.department_name );
    if sal_rec.wmonth >= 150 then    
      update emp set salary = salary * 1.1 where rowid = sal_rec.rowid;
      if sql%found then
        dbms_output.put_line(sal_rec.last_name || ' 10%�λ� �޿��� �����߽��ϴ�.');
      end if;
    end if;
  end loop;
  rollback;

end;
/
-- for update & current of Ȱ��
declare
  cursor sal_cur is select e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name from emp e, departments d where e.department_id = 30 and d.department_id = 30
  for update of e.last_name nowait;
  v_newsal number
  
begin
  for sal_rec in sal_cur loop
    dbms_output.put_line('����̸� : ' || sal_rec.last_name || ' �޿� : ' || sal_rec.salary || ' �ٹ������� : ' || sal_rec.wmonth || ' �μ� �̸� : ' || sal_rec.department_name );
    if sal_rec.wmonth >= 150 then
      update emp set salary = salary * 1.1 where current of sal_cur; -- current of �� ������ returning �� ��� �Ұ�
      if sql%found then
        dbms_output.put_line(sal_rec.last_name || ' 10%�λ� �޿��� '|| v_newsal ||'�� �����߽��ϴ�.');
      end if;
    end if;
  end loop;
  rollback;

end;
/

-- bulk collect into Ȱ��
declare
  type rec_type is record(rowid varchar2(18), lname emp.last_name%type, sal emp.salary%type, wmonth number, deptname departments.department_name%type);
  type tab_type is table of rec_type;
  v_tab tab_type;
  v_newsal number;
  
begin
  select e.rowid, e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name bulk collect into v_tab from emp e, departments d where e.department_id = 30 and d.department_id = 30;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line('����̸� : ' || v_tab(i).lname || ' �޿� : ' || v_tab(i).sal || ' �ٹ������� : ' || v_tab(i).wmonth || ' �μ� �̸� : ' || v_tab(i).deptname );
    if v_tab(i).wmonth >= 150 then
      update emp set salary = salary * 1.1 where rowid = v_tab(i).rowid returning salary into v_newsal;
      if sql%found then
        dbms_output.put_line(v_tab(i).lname || ' 10%�λ� �޿��� '|| v_newsal ||'�� �����߽��ϴ�.');
      end if;
    end if;
  end loop;
  rollback;

end;
/











declare
  cursor parm_cur_80 is
    select employee_id, last_name, job_id
    from employees
    where department_id = 80
    and job_id = 'SA_MAN';

  cursor parm_cur_50 is
    select employee_id, last_name, job_id
    from employees
    where department_id = 50
    and job_id = 'ST_MAN';
    
  v_rec1 parm_cur_80%rowtype;
  
begin 
  open parm_cur_80;
  loop
    fetch parm_cur_80 into v_rec1;
    exit when parm_cur_80%notfound;
    dbms_output.put_line(v_rec1.last_name);
  end loop;
  close parm_cur_80;
  
  for v_rec2 in parm_cur_50 loop
    dbms_output.put_line(v_rec2.last_name);
  end loop;
  
end;
/
-- �� ������ ������: 2���� Ŀ������ �����ȹ�� �������� ����

/*parameter�� ���� cursor
- �����ȹ�� ���� �� �� �ֵ��� parameter�� ���� Ŀ�� ����
- parameter�� ������� ������� ����
- ������ ������ ������ �� ��� */

declare
  cursor parm_cur(p_id number, p_job varchar2) is -- Ŀ����(���� �Ű�����)
    select employee_id, last_name, job_id
    from employees
    where department_id = p_id
    and job_id = p_job;

  v_rec1 parm_cur%rowtype;
  
begin 
  open parm_cur(80, 'SA_MAN'); -- Ŀ����(���� �Ű�����)
  loop
    fetch parm_cur into v_rec1;
    exit when parm_cur%notfound;
    dbms_output.put_line(v_rec1.last_name);
  end loop;
  close parm_cur;
  
  for v_rec2 in parm_cur(50, 'ST_MAN') loop
    dbms_output.put_line(v_rec2.last_name);
  end loop;
  
end;
/

-- by index rowid ���
declare
  cursor sal_cur is
    select e.employee_id, e.last_name, e.salary, d.department_name
    from employees e, departments d
    where e.department_id = 20 and d.department_id = 20;
  
begin
  for emp_rec in sal_cur loop
    dbms_output.put_line(emp_rec.last_name);
    dbms_output.put_line(emp_rec.salary);
    dbms_output.put_line(emp_rec.department_name);
    
    update employees set salary = salary * 1.1 where employee_id = emp_rec.employee_id;
  end loop;

end;
/

-- by user rowid scan���� ����
declare
  cursor sal_cur is
    select e.rowid, e.last_name, e.salary, d.department_name
    from employees e, departments d
    where e.department_id = 20 and d.department_id = 20;
  
begin
  for emp_rec in sal_cur loop
    dbms_output.put_line(emp_rec.last_name);
    dbms_output.put_line(emp_rec.salary);
    dbms_output.put_line(emp_rec.department_name);
    
    update employees set salary = salary * 1.1 where rowid = emp_rec.rowid;
  end loop;

end;
/

declare
  cursor sal_cur is
    select e.last_name, e.salary, d.department_name
    from employees e, departments d
    where e.department_id = 20 and d.department_id = 20
    for update of e.employee_id wait 3; 
    -- for update �÷���: �ش� �÷��� �ִ� ���̺� lock�� �� -> rowid���� ������ �ְ� ��
    -- wait ��: �ش� �� ��ŭ ��ٸ���, �� �ȿ� lock�� Ǯ���� ������ �����߻� / nowait: ��ٸ��� �ʰ� �ٷ� ���� �߻�
      
begin
  for emp_rec in sal_cur loop
    dbms_output.put_line(emp_rec.last_name);
    dbms_output.put_line(emp_rec.salary);
    dbms_output.put_line(emp_rec.department_name);
    update employees set salary = salary * 1.1 where current of sal_cur; -- Ŀ���� ������ �ִ� rowid
  end loop;

end;
/

declare
  cursor emp_cur is select * from employees where department_id = 20;
  v_rec emp_cur%rowtype;

begin
  open emp_cur;
  loop
    fetch emp_cur into v_rec;
    exit when emp_cur%notfound;
    dbms_output.put_line(v_rec.last_name);
  end loop;
  close emp_cur;

end;
/

-- bulk collect into �迭: 10g���� ���� ���

declare
  type tab_type is table of employees%rowtype;
  v_tab tab_type;

begin
  select * bulk collect into v_tab from employees where department_id = 20;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).last_name);
  end loop;
  
end;
/

declare
  cursor emp_cur is select * from employees where department_id = 20;
  type tab_type is table of emp_cur%rowtype;
  v_tab tab_type;

begin
  open emp_cur;
  fetch emp_cur bulk collect into v_tab;
  close emp_cur;
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).last_name);
  end loop;
  
end;
/

declare
  type rec_type is record(lname emp.last_name%type, sal emp.salary%type);
  type tab_type is table of rec_type;
  v_tab tab_type;

begin
  update employees set salary = salary * 1.1 where department_id = 20 
  returning last_name, salary bulk collect into v_tab;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).lname || ' ' || v_tab(i).sal);
  end loop;
  rollback;
end;
/

drop table emp purge;

create table emp as select * from employees;

begin
  delete from emp where department_id = 10;
  delete from emp where department_id = 20;
  delete from emp where department_id = 30;

end;
/

declare
  type numlist is table of number;
  v_num numlist := numlist(10, 20, 30);
 
begin
  delete from emp where department_id = v_num(1);
  dbms_output.put_line(sql%rowcount || ' rows deleted.');
  
  delete from emp where department_id = v_num(2);
  dbms_output.put_line(sql%rowcount || ' rows deleted.');
  
  delete from emp where department_id = v_num(3);
  dbms_output.put_line(sql%rowcount || ' rows deleted.');
  
  rollback;

end;
/

declare
  type numlist is table of number;
  v_num numlist := numlist(10, 20, 30);
 
begin
  for i in v_num.first..v_num.last loop
    delete from emp where department_id = v_num(i);
    dbms_output.put_line(sql%rowcount || ' rows deleted.');
  end loop;
  rollback;

end;
/

declare
  type numlist is table of number;
  v_num numlist := numlist(10, 20, 30, 40, 50);
 
begin
  forall i in v_num.first..v_num.last -- �迭�������� ��� ���� ������ DML���� �ѹ��� SQL�������� ������
    delete from emp where department_id = v_num(i);
  dbms_output.put_line(sql%rowcount);
  for i in v_num.first..v_num.last loop
    dbms_output.put_line(sql%bulk_rowcount(i) || ' rows deleted.');
  end loop;
  rollback;

end;
/