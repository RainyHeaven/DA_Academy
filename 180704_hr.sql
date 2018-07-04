--[����136] SQL���� union�� union all�� ��ȯ�ϼ���. �� ����Ǽ��� �����ؾ��մϴ�.
-- 35��
select * from employees where department_id = 80
union
select * from employees where job_id = 'SA_REP';

SELECT * FROM employees e WHERE department_id = 80
UNION ALL
SELECT * FROM employees d WHERE job_id = 'SA_REP'
AND NOT EXISTS(SELECT 'x' FROM employees WHERE department_id = 80 AND employee_id = d.employee_id);

select * from employees where department_id = 80 or job_id = 'SA_REP';

SELECT * FROM employees WHERE department_id = 80
UNION ALL
SELECT * FROM employees WHERE job_id = 'SA_REP'
and department_id <> 80 or department_id is null;

SELECT * FROM employees WHERE department_id = 80
UNION ALL
SELECT * FROM employees WHERE job_id = 'SA_REP' and lnnvl (department_id = 80);


/*[����1] ȭ���� ��� ó�� ���α׷��� �ۼ��ϼ���.
TODAY'S : 2018-07-04
TOMORROW'S : 2018-07-05*/
BEGIN
dbms_output.put_line('TODAY''S : ' || to_char(SYSDATE, 'YYYY-MM-DD'));
dbms_output.put_line(q'[TOMORROW'S : ]'|| to_char(sysdate+1, 'YYYY-MM-DD'));
END;
/


-- PLSQL(Procedure Language Structured Query Language)
select * from employees where employee_id = 100;
select * from employees where employee_id = 101;
select * from employees where employee_id = 102;


BEGIN
  dbms_output.put_line('Gomok');
  dbms_output.put_line('���õ� �ູ����!!');
END;
/

-- ��������
DECLARE
  /* local variable, private variable, ��������
  scalar date type(���ϰ��� �����ϴ� ����) */
  v_a NUMBER(7); -- ���� ����, bind������ �ٸ��� number�� ���� ���� ����
  v_b NUMBER(3) := 100; -- �ʱⰪ �Ҵ�
  v_c VARCHAR2(10) NOT NULL := 'plsql'; -- ������ not null �������� �� �� ����(�ٸ� ���������� �Ұ���)
  v_d constant date default sysdate; -- ��� ����

BEGIN
  v_a := 200;
  -- v_d := sysdate + 1; ����� �ٸ� ������ ���� �Ұ�
  dbms_output.put_line('v_a ������ �ִ� ���� ' || v_a);
  dbms_output.put_line('v_b ������ �ִ� ���� ' || (v_b+100));
  dbms_output.put_line('v_c ������ �ִ� ���� ' || v_c);
  dbms_output.put_line('v_d ������ �ִ� ���� ' || (v_d+10));

END;
/

-- bind variable: global variable, public variable, ��������

var b_total number

DECLARE
  v_sal NUMBER := 1000;
  v_comm NUMBER := 100;
  v_total NUMBER;

BEGIN
  :b_total := v_sal + v_comm; -- ���α׷� �ȿ��� ���ε庯���� ����ϱ� ���ؼ��� �� : �� ����Ѵ�
  dbms_output.put_line(:b_total);

END;
/

select * from employees where salary > :b_total;

var b_total NUMBER
var b_sal NUMBER
var b_comm NUMBER

exec :b_sal := 10000
exec :b_comm := 100

DECLARE
  v_sal NUMBER := :b_sal;
  v_comm NUMBER := :b_comm;
  
BEGIN
  :b_total := v_sal + v_comm;
  dbms_output.put_line(:b_total);

END;
/

DECLARE
  v_name VARCHAR2(20);

BEGIN
  dbms_output.put_line('my name is : ' || v_name); -- ���� || null => ����
  v_name := 'james';
  dbms_output.put_line('my name is : ' || v_name);
  v_name := 'ȫ�浿';
  dbms_output.put_line('my name is : ' || v_name);
  
END;
/

-- ���κ�� & ������
<<outer>> -- label
declare
  v_sal number(8, 2) := 60000;
  v_comm number(8, 2) := v_sal * 0.20;
  v_message varchar2(100) := ' eligible for commssion';
  
begin
  declare
    v_sal number(8, 2) := 50000;
    v_comm number(8, 2) := 0;
    v_total number(8, 2) := v_sal + v_comm; -- ������ ���� ����� ������ ���κ������ ������
  
  begin
    outer.v_sal := 70000;
    v_message := 'clerk not ' || v_message;
    dbms_output.put_line(v_total);
    dbms_output.put_line(v_sal);
    dbms_output.put_line(outer.v_sal);
    dbms_output.put_line(v_comm);
    dbms_output.put_line(v_message);
  end;
  dbms_output.put_line(v_sal);
  dbms_output.put_line(v_comm);
  dbms_output.put_line(v_message);
  --dbms_output.put_line(v_total);  
end;
/  