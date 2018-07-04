--[문제136] SQL문을 union을 union all로 변환하세요. 단 결과건수가 동일해야합니다.
-- 35건
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


/*[문제1] 화면의 결과 처럼 프로그램을 작성하세요.
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
  dbms_output.put_line('오늘도 행복하자!!');
END;
/

-- 지역변수
DECLARE
  /* local variable, private variable, 지역변수
  scalar date type(단일값만 보유하는 변수) */
  v_a NUMBER(7); -- 변수 선언, bind변수와 다르게 number에 길이 지정 가능
  v_b NUMBER(3) := 100; -- 초기값 할당
  v_c VARCHAR2(10) NOT NULL := 'plsql'; -- 변수에 not null 제약조건 걸 수 있음(다른 제약조건은 불가능)
  v_d constant date default sysdate; -- 상수 선언

BEGIN
  v_a := 200;
  -- v_d := sysdate + 1; 상수는 다른 값으로 수정 불가
  dbms_output.put_line('v_a 변수에 있는 값은 ' || v_a);
  dbms_output.put_line('v_b 변수에 있는 값은 ' || (v_b+100));
  dbms_output.put_line('v_c 변수에 있는 값은 ' || v_c);
  dbms_output.put_line('v_d 변수에 있는 값은 ' || (v_d+10));

END;
/

-- bind variable: global variable, public variable, 전역변수

var b_total number

DECLARE
  v_sal NUMBER := 1000;
  v_comm NUMBER := 100;
  v_total NUMBER;

BEGIN
  :b_total := v_sal + v_comm; -- 프로그램 안에서 바인드변수를 사용하기 위해서는 꼭 : 을 사용한다
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
  dbms_output.put_line('my name is : ' || v_name); -- 문자 || null => 문자
  v_name := 'james';
  dbms_output.put_line('my name is : ' || v_name);
  v_name := '홍길동';
  dbms_output.put_line('my name is : ' || v_name);
  
END;
/

-- 메인블락 & 서브블락
<<outer>> -- label
declare
  v_sal number(8, 2) := 60000;
  v_comm number(8, 2) := v_sal * 0.20;
  v_message varchar2(100) := ' eligible for commssion';
  
begin
  declare
    v_sal number(8, 2) := 50000;
    v_comm number(8, 2) := 0;
    v_total number(8, 2) := v_sal + v_comm; -- 변수가 현재 블락에 없으면 메인블락에서 가져옴
  
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