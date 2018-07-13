/*[문제34] 사원들 중에 job_id가 'SA_REP' 사원들의 이름, 부서 이름을 출력하고 부서 배치를 받지 않는
사원들에 대해서는 "부서 배치를 못 받았습니다." 출력해야 합니다.
또한 출력할때 카운터 수를 출력해주세요.(조인은 이용하지 마세요)
1 사원이름 : Tucker, 부서이름 : Sales
2 사원이름 : Bernstein, 부서이름 : Sales
3 사원이름 : Hall, 부서이름 : Sales
4 사원이름 : Olsen, 부서이름 : Sales
5 사원이름 : Cambrault, 부서이름 : Sales
6 사원이름 : Tuvault, 부서이름 : Sales
7 사원이름 : King, 부서이름 : Sales
8 사원이름 : Sully, 부서이름 : Sales
9 사원이름 : McEwen, 부서이름 : Sales
10 사원이름 : Smith, 부서이름 : Sales
11 사원이름 : Doran, 부서이름 : Sales
12 사원이름 : Sewall, 부서이름 : Sales
13 사원이름 : Vishney, 부서이름 : Sales
14 사원이름 : Greene, 부서이름 : Sales
15 사원이름 : Marvins, 부서이름 : Sales
16 사원이름 : Lee, 부서이름 : Sales
17 사원이름 : Ande, 부서이름 : Sales
18 사원이름 : Banda, 부서이름 : Sales
19 사원이름 : Ozer, 부서이름 : Sales
20 사원이름 : Bloom, 부서이름 : Sales
21 사원이름 : Fox, 부서이름 : Sales
22 사원이름 : Smith, 부서이름 : Sales
23 사원이름 : Bates, 부서이름 : Sales
24 사원이름 : Kumar, 부서이름 : Sales
25 사원이름 : Abel, 부서이름 : Sales
26 사원이름 : Hutton, 부서이름 : Sales
27 사원이름 : Taylor, 부서이름 : Sales
28 사원이름 : Livingston, 부서이름 : Sales
29 사원이름 : grant, 부서이름 : 부서 배치를 못 받았습니다.
30 사원이름 : Johnson, 부서이름 : Sales */

declare
  type emp_rec_type is record(lname emp.last_name%type, deptid emp.department_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  v_deptname departments.department_name%type;
  
begin
  select last_name, department_id bulk collect into v_emp_tab from emp where job_id = 'SA_REP';
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is null then
      dbms_output.put_line( i || ' 사원이름 : ' ||v_emp_tab(i).lname || ', 부서이름: 부서 배치를 못 받았습니다.');
    else
      select department_name into v_deptname from departments where department_id = v_emp_tab(i).deptid;
      dbms_output.put_line( i || ' 사원이름 : ' ||v_emp_tab(i).lname || ', 부서이름: ' || v_deptname);
    end if;
  end loop;

end;
/

-- departments 테이블에 접근하는 횟수를 줄여보자 -> **스칼라 서브쿼리**를 쓰자
declare
  type emp_rec_type is record(lname emp.last_name%type, deptid emp.department_id%type);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  type deptid_tab_type is table of departments.department_name%type index by pls_integer;
  v_deptid_tab deptid_tab_type;
  
begin
  select last_name, department_id bulk collect into v_emp_tab from emp where job_id = 'SA_REP';
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is not null then
      v_deptid_tab(v_emp_tab(i).deptid) := null;
    end if;
  end loop;
  
  for i in v_deptid_tab.first..v_deptid_tab.last loop
    select department_name into v_deptid_tab(i) from departments where department_id = i;
  end loop;
  
  for i in v_emp_tab.first..v_emp_tab.last loop
    if v_emp_tab(i).deptid is null then
      dbms_output.put_line( i || ' 사원이름 : ' ||v_emp_tab(i).lname || ', 부서이름: 부서 배치를 못 받았습니다.');
    else
      dbms_output.put_line( i || ' 사원이름 : ' ||v_emp_tab(i).lname || ', 부서이름: ' || v_deptid_tab(v_emp_tab(i).deptid));
    end if;
  end loop;
  
end;
/

/**선생님 답들**/
DECLARE
 cursor emp_cursor is
	SELECT last_name, department_id FROM employees WHERE job_id = 'SA_REP';
 v_dept_name departments.department_name%type;
 v_c number := 1;
BEGIN
	FOR c_rec IN emp_cursor LOOP
		begin
			SELECT department_name INTO v_dept_name FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : '||v_dept_name);
			v_c := v_c+1;

    EXCEPTION
      when no_data_found then 
      dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : 부서 배치를 못 받았습니다.');
       v_c := v_c + 1;
    END;
  END LOOP;

END;
/

DECLARE
  v_dept_name departments.department_name%type;
  v_c number := 1;

BEGIN
	FOR c_rec IN (SELECT last_name, department_id FROM  employees WHERE job_id = 'SA_REP') LOOP
    begin
      SELECT department_name INTO v_dept_name	FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      when no_data_found then 
        dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : 부서배치를 못 받았습니다.');
        v_c := v_c + 1;
    end;
  END LOOP;

END;
/

declare
  cursor emp_cursor is select last_name, department_id from employees	where job_id = 'SA_REP';
  c_rec emp_cursor%rowtype;
  v_dept_name departments.department_name%type;
  v_c number := 1;

BEGIN
  open emp_cursor;
  LOOP
    FETCH emp_cursor INTO c_rec;
    EXIT WHEN emp_cursor%NOTFOUND;
  	begin
			SELECT department_name INTO v_dept_name FROM departments WHERE department_id = c_rec.department_id;
			dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      WHEN no_data_found THEN 
        dbms_output.put_line(v_c||  ' 사원이름 : '||c_rec.last_name ||', 부서이름 : 부서 배치를 못 받았습니다.');
		    v_c := v_c + 1;
    END;     
	END LOOP;
  CLOSE emp_cursor;

END;
/

DECLARE
 CURSOR emp_cursor IS	SELECT last_name, department_id FROM  employees	WHERE job_id = 'SA_REP';
 TYPE emp_tab_type IS TABLE OF emp_cursor%rowtype;
 v_tab emp_tab_type;
 v_dept_name departments.department_name%type;
 v_c number := 1;

BEGIN
 OPEN emp_cursor;
 FETCH emp_cursor BULK COLLECT INTO v_tab;
  FOR i IN v_tab.first..v_tab.last LOOP
		begin
      SELECT department_name INTO v_dept_name	FROM departments WHERE department_id = v_tab(i).department_id;
      dbms_output.put_line(v_c||  ' 사원이름 : '||v_tab(i).last_name ||', 부서이름 : '||v_dept_name);
			v_c := v_c+1;
    EXCEPTION
      WHEN no_data_found THEN 
        dbms_output.put_line(v_c||  ' 사원이름 : '||v_tab(i).last_name ||', 부서이름 : 부서 배치를 못 받았습니다.');
		    v_c := v_c + 1;
    END;
	end loop;
  CLOSE emp_cursor;

END;
/

/*****스칼라 서브쿼리!! 활용: 동일한 값이 들어갈 때 캐시기능을 적용*****/
DECLARE
 cursor emp_cursor is	select rownum no, e.last_name, 
  nvl((select  department_name from departments where department_id = e.department_id), '부서 배치를 못받았습니다.') dept_name	from employees e	where  e.job_id = 'SA_REP';
 TYPE emp_tab_type IS TABLE OF emp_cursor%rowtype;
 v_tab emp_tab_type;

BEGIN
  open emp_cursor;
  fetch emp_cursor bulk collect into v_tab;
  FOR i IN v_tab.first..v_tab.last LOOP
    dbms_output.put_line(v_tab(i).no||  ' 사원이름 : '||v_tab(i).last_name ||', 부서이름 : '||v_tab(i).dept_name);
  end loop;
  CLOSE emp_cursor;

END;
/


DECLARE
 TYPE emp_rec_type IS RECORD(no number, name varchar2(30), dept_name varchar2(50));
 TYPE emp_tab_type IS TABLE OF emp_rec_type;
 v_tab emp_tab_type;
BEGIN
	select rownum, e.last_name, nvl((select department_name from departments where department_id = e.department_id), '부서 배치를 못받았습니다.') 
  bulk collect into v_tab FROM employees e WHERE  e.job_id = 'SA_REP';
  for i in v_tab.first..v_tab.last loop
  	dbms_output.put_line(v_tab(i).no||  ' 사원이름 : '||v_tab(i).name ||', 부서이름 : '||v_tab(i).dept_name);
  END LOOP;

end;
/

/*[문제35] 전체 사원 들의 사번, 이름, 급여, 입사일, 근무연수를 출력합니다.
또한 근무연수가 13년 이상이고 급여는 10000 미만인 사원들은 예외사항이 발생하도록 한 후 
메시지 출력하고  프로그램 수행이 완료된 후에 분석할수있도록  years 테이블에 정보가 입력이 되도록 프로그램을 작성합니다. 근무연수는 소수점은 버리세요
SQL> create table years(id number, name varchar2(30), sal number, year number);
<화면 출력>
....
201, Hartstein, 13000, 04/02/17, 12
202, Fay, 6000, 05/08/17, 10
203, Mavris, 6500, 02/06/07, 13
사원 203 근무연수는 13 년이고 급여는 6500 입니다.
204, Baer, 10000, 02/06/07, 13
205, Higgins, 12008, 02/06/07, 13
206, Gietz, 8300, 02/06/07, 13
사원 206 근무연수는 13 년이고 급여는 8300 입니다.
....
SQL> select * from years; */
create table years(id number, name varchar2(30), sal number, year number);
select * from years;
truncate table years; --테이블 데이터 전체 삭제 & rollback 불가능

-- exception 없이 구현
declare
  type emp_rec_type is record(id emp.employee_id%type, name emp.last_name%type, sal emp.salary%type, hdate emp.hire_date%type, wyear number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
    
begin
  select employee_id, last_name, salary, hire_date, trunc(months_between(sysdate, hire_date)/12) bulk collect into v_emp_tab from emp;
  for i in v_emp_tab.first..v_emp_tab.last loop
    dbms_output.put_line(v_emp_tab(i).id || ', ' || v_emp_tab(i).name || ', ' || v_emp_tab(i).sal || ', ' || v_emp_tab(i).hdate || ', ' || v_emp_tab(i).wyear);
    if v_emp_tab(i).wyear >= 13 and v_emp_tab(i).sal < 10000 then
      dbms_output.put_line('사원 ' || v_emp_tab(i).id || ' 근무연수는 ' || v_emp_tab(i).wyear || ' 년이고 급여는 ' || v_emp_tab(i).sal || ' 입니다.');
      insert into years values (v_emp_tab(i).id, v_emp_tab(i).name, v_emp_tab(i).sal, v_emp_tab(i).wyear);
    end if;
  end loop;
  
end;
/

-- exception 통해서 구현
declare
  type emp_rec_type is record(id emp.employee_id%type, name emp.last_name%type, sal emp.salary%type, hdate emp.hire_date%type, wyear number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;
  minor exception;
    
begin
  select employee_id, last_name, salary, hire_date, trunc(months_between(sysdate, hire_date)/12) bulk collect into v_emp_tab from emp;
  for i in v_emp_tab.first..v_emp_tab.last loop
    begin
      dbms_output.put_line(v_emp_tab(i).id || ', ' || v_emp_tab(i).name || ', ' || v_emp_tab(i).sal || ', ' || v_emp_tab(i).hdate || ', ' || v_emp_tab(i).wyear);
      if v_emp_tab(i).wyear >= 13 and v_emp_tab(i).sal < 10000 then
        raise minor;
      end if;
    
    exception
      when minor then
        dbms_output.put_line('사원 ' || v_emp_tab(i).id || ' 근무연수는 ' || v_emp_tab(i).wyear || ' 년이고 급여는 ' || v_emp_tab(i).sal || ' 입니다.');
        insert into years values (v_emp_tab(i).id, v_emp_tab(i).name, v_emp_tab(i).sal, v_emp_tab(i).wyear);
    end;
  end loop;
  commit;
end;
/

-- [문제36] 사원번호를 입력값으로 받아서 그사원의 급여를 10%인상하는 프로시저를 생성하세요. 프로시저이름은 raise_sal로 생성하세요.
create or replace procedure raise_sal(id number)
is 
begin
  update emp set salary = salary * 1.1 where employee_id = id;
  if sql%found then 
    dbms_output.put_line(id || '사원의 급여를 수정했습니다.');
  else
    dbms_output.put_line(id || '사원이 존재하지 않습니다.');
  end if;
  
end;
/










var b_id number
exec :b_id := 100


declare
  v_rec  employees%rowtype;

begin
  select * into v_rec from employees where employee_id = :b_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(:b_id || ' 사원은 존재하지 않습니다');
    
end;
/

--익명블럭의 단점: 리파싱이 안됨 / 공유가 안됨 / 입력값, 리턴값 처리를 툴에서 지원하는 기능에 의존할 수 밖에 없다

select * from session_privs;
select * from user_tab_privs;
drop procedure emp_proc;

/*procedure: bind변수 사용 불가, declare 대신 is & as 사용
create 하면 소스코드와 컴파일된 소스코드를 db에 저장
프로시저 내에서 매개변수는 상수로 취급
-> 프로시저 내에서 매개변수 수정 불가능*/ 
create or replace procedure emp_proc(p_id in number default 100) -- in 생략가능
is -- as 도 가능, 선언할 것이 없어도 사용해야 함
  v_rec  employees%rowtype;

begin
  select * into v_rec from employees where employee_id = p_id;
  dbms_output.put_line(v_rec.employee_id || ' ' || v_rec.last_name);

exception
  when no_data_found then
    dbms_output.put_line(p_id || ' 사원은 존재하지 않습니다');
    
end;
/
-- 프로시져 실행
exec emp_proc(100);
exec emp_proc; --default 값 입력됨
begin
  emp_proc(100);
end;
/

-- 프로시저의 소스코드 확인
select text from user_source where name = 'EMP_PROC';

-- 프로시저 생성시의 에러 확인
show error;

-- 출력용 매개변수: 변수명 out 타입
create or replace procedure emp_proc(p_id in number default 100, p_name out varchar2, p_sal out number) -- in 생략가능
is -- as 도 가능, 선언할 것이 없어도 사용해야 함

begin
  select last_name, salary into p_name, p_sal from employees where employee_id = p_id;
  dbms_output.put_line(p_name || ' ' || p_sal);

exception
  when no_data_found then
    dbms_output.put_line(p_id || ' 사원은 존재하지 않습니다');
    
end;
/

-- 프로시저의 매개변수 확인
desc emp_proc;

var b_name varchar2(30)
var b_sal number

exec emp_proc(200, :b_name, :b_sal);

print b_name b_sal

select * from employees where salary > :b_sal;

declare
  v_id number := 100;
  v_name varchar2(30);
  v_sal number;

begin
  emp_proc(v_id, v_name, v_sal);
  dbms_output.put_line(v_id || ' ' || v_name || ' ' || v_sal);

end;
/
-- in out 모드
create or replace procedure format_phone(p_phone_no in out varchar2)
is 
begin
  p_phone_no := substr(p_phone_no, 1, 3) || '-' || substr(p_phone_no, 4, 4) || '-' || substr(p_phone_no, 8);
end;
/

var b_phone varchar2(30);
exec :b_phone := '01012345678';

exec format_phone(:b_phone);

print b_phone;