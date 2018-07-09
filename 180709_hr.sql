-- [문제19] 단을 입력값으로 받아서 그 단에 대해서만 출력하시고 만약에 단 입력값이 없으면 전체 구구단이 출력되도록 작성하세요.
var b_dan number
execute :b_dan := 2
execute :b_dan := null

begin
  if :b_dan is not null then
    dbms_output.put_line('구구단 ' || :b_dan || '단입니다.');
    for i in 1..9 loop
      dbms_output.put_line(:b_dan || ' * ' || i || ' = ' || :b_dan * i);
    end loop;
  else
    for i in 2..9 loop
    dbms_output.put_line('구구단 ' || i || '단입니다.');
      for j in 1..9 loop
        dbms_output.put_line(i || ' * ' || j || ' = ' || i * j);
      end loop;
    dbms_output.put_line('');
    end loop;
  end if;
end;
/

/*[문제20] 사원 테이블의 employee_id, last_name 을 출력하는 프로그램입니다.
       사원번호는 100번 부터 해서 5씩 증가한 정보를 출력하시고 120번으로 끝내도록 해주세요.
<화면 출력>
100  King
105  Austin
110  Chen
115  khoo
120  Weiss */

declare
  v_empid number := 100;
  v_lname employees.last_name%type;

begin
  while v_empid <= 120 loop
    select last_name into v_lname from employees where employee_id = v_empid;
    dbms_output.put_line(v_empid || '번 사원의 이름은 ' || v_lname || '입니다.');
    v_empid := v_empid + 5;
  end loop;

end;
/

/*[문제21] 사원 번호를 입력 값으로 받아서 그 사원의 급여를 출력하는 프로그램을 작성합니다. 
또한 급여 1000당 별(*) 하나를 출력해주세요.(반복문을 이용하세요)
<화면출력>
employee_id => 200  salary => 4400
star is => ****     */

-- 반복문 활용
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  v_star varchar2(10) := '';
  
begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  
  for i in 1..trunc(v_sal/1000) loop
    v_star := v_star || '*';
  end loop;
  dbms_output.put_line('star is => ' || v_star);
  
end;
/

--substr활용
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  v_star varchar2(10) := '**********';

begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  dbms_output.put_line('star is => ' || substr(v_star, 0, trunc(v_sal/1000)));
  
end;
/

-- rpad활용
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;

begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  dbms_output.put_line('star is =>' || rpad(' ', trunc(v_sal/1000)+1, '*'));
  
end;
/

-- put 활용
var b_empid number;
exec :b_empid := 200;
declare 
  v_sal employees.salary%type;
  
begin
  select salary into v_sal from employees where employee_id = :b_empid;
  dbms_output.put_line('employee_id => ' || :b_empid || ' salary => ' || v_sal);
  
  for i in 1..trunc(v_sal/1000) loop
    dbms_output.put('*'); -- 출력내용을 쌓아두는 명령
  end loop;
  dbms_output.new_line; -- 쌓인 내용을 출력하는 명령
  
end;
/

/* 22번 문제: continue문을 사용하지 않고 같은 기능을 구현하기
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    continue when i > 5; --11g에서 등장
    v_total := v_total + i;
    dbms_output.put_line('Out of loop total is : ' || v_total);
  end loop;
  
end;
/  */
-- if문 활용
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    if i <= 5 then
      v_total := v_total + i;
      dbms_output.put_line('Out of loop total is : ' || v_total);
    end if;
  end loop;
  
end;
/
-- sub loop 활용
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    loop
      exit when i > 5
      v_total := v_total + i;
      dbms_output.put_line('Out of loop total is : ' || v_total);
      exit;
    end loop;
  end loop;
  
end;
/

/* 문제 23 continue문을 쓰지 않고 
declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      continue toploop when i+j > 5; -- continue문의 활용: 돌아갈 loop문을 지정할 수 있음
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/  */
-- exit when 활용
declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      exit when i+j > 5;
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/

-- [문제24]구구단 2단을 for loop를 이용해서 출력하세요. 단 2 * 6은 제외 시켜주세요.
-- if 활용
begin
  for i in 1..9 loop
    if i != 6 then
      dbms_output.put_line('2 * ' || i || ' = ' || 2*i);
    end if;
  end loop;

end;
/

-- continue 활용
begin
  for i in 1..9 loop
    continue when i = 6;
    dbms_output.put_line('2 * ' || i || ' = ' || 2*i);
  end loop;

end;
/

/*[문제25] 배열 변수에 있는 100,101,102,103,104, 200 사원들의 근무한 개월수를 출력하고 근무개월수가 150개월이상 되었으면 급여(salary)를 10% 인상한 급여로 수정하는 프로그램 작성하세요.
<출력 결과>
100는 근무개월수가 166 입니다. 급여는 10% 인상되었습니다.
101는 근무개월수가 139 입니다. 급여는 인상할 수 없습니다.
102는 근무개월수가 195 입니다. 급여는 10% 인상되었습니다.
103는 근무개월수가 135 입니다. 급여는 인상할 수 없습니다.
104는 근무개월수가 119 입니다. 급여는 인상할 수 없습니다.
200는 근무개월수가 163 입니다. 급여는 10% 인상되었습니다. */

declare 
  type empid_type is table of number index by binary_integer;
  v_empid empid_type;
  v_wmonth number;

begin
  v_empid(1) := 100;
  v_empid(2) := 101;
  v_empid(3) := 102;
  v_empid(4) := 103;
  v_empid(5) := 104;
  v_empid(6) := 200;
  for i in v_empid.first..v_empid.last loop
    select trunc(months_between(sysdate, hire_date)) into v_wmonth from emp where employee_id = v_empid(i);
    if v_wmonth >= 150 then
      update emp set salary = salary * 1.1 where employee_id = v_empid(i);
      dbms_output.put_line(v_empid(i) || '는 근무개월수가 ' || v_wmonth || '입니다. 급여는 10% 인상되었습니다.');
    else
      dbms_output.put_line(v_empid(i) || '는 근무개월수가 ' || v_wmonth || '입니다. 급여는 인상할 수 없습니다.');
    end if;
  end loop;
  rollback;
end;
/

/*[문제26] 배열변수안에 있는 사원 번호 값을 기준으로 (100,110,200) 
그 사원의 last_name, hire_date, department_name 정보를 배열변수에 담아놓은 후 
화면에 출력하는 프로그램을 작성하세요.
<화면결과>
100 사원의 이름은 King, 입사한 날짜는 2003-06-17, 근무 부서이름은 Executive 입니다.
110 사원의 이름은 Chen, 입사한 날짜는 2005-09-28, 근무 부서이름은 Finance 입니다.
200 사원의 이름은 whalen, 입사한 날짜는 2003-09-17, 근무 부서이름은 administration 입니다. */

declare 
  type rec_type is record(id number, last_name employees.last_name%type, hire_date employees.hire_date%type, department_name departments.department_name%type);
  type tab_type is table of rec_type index by pls_integer;
  v_tab tab_type;
begin
  v_tab(1).id := 100;
  v_tab(2).id := 110;
  v_tab(3).id := 200;
  for i in v_tab.first..v_tab.last loop
    select e.last_name, e.hire_date, d.department_name into v_tab(i).last_name, v_tab(i).hire_date, v_tab(i).department_name from emp e, departments d where e.department_id = d.department_id and employee_id = v_tab(i).id;
    dbms_output.put_line(v_tab(i).id || '사원의 이름은 ' || v_tab(i).last_name || ', 입사한 날짜는 ' || to_char(v_tab(i).hire_date, 'yyyy-mm-dd') || ', 근무 부서이름은 ' || v_tab(i).department_name || '입니다.');
  end loop;

end;
/








-- continue문
declare
  v_total number := 0;

begin
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    continue when i > 5; --11g에서 등장
    v_total := v_total + i;
    dbms_output.put_line('Out of loop total is : ' || v_total);
  end loop;
  
end;
/

declare
  v_total number := 0;
  
begin
  <<toploop>>
  for i in 1..10 loop
    v_total := v_total + i;
    dbms_output.put_line('Total is : ' || v_total);
    for j in 1..10 loop
      continue toploop when i+j > 5; -- continue문의 활용: 돌아갈 loop문을 지정할 수 있음
      v_total := v_total + i;
      dbms_output.put_line(v_total);
    end loop;
  end loop;

end;
/

declare
  v_dept_id departments.department_id%type;
  v_dept_name departments.department_name%type;
  v_mgr_id departments.manager_id%type;
  v_loc_id departments.location_id%type;

begin
  select * into v_dept_id, v_dept_name, v_mgr_id, v_loc_id from departments where department_id = 10;
  dbms_output.put_line('부서ID: ' || v_dept_id || ', 부서명: ' || v_dept_name || ', 매니저명: ' || v_mgr_id || ', 지역ID: ' || v_loc_id);
  
end;
/

declare
  type dept_record_type is record
  (dept_id departments.department_id%type not null := 10, dept_name varchar2(30), dept_mgr number, dept_loc number, dept_rec departments%rowtype); -- user define type
  v_rec dept_record_type;
  
begin
  select * into v_rec.dept_rec from departments where department_id = v_rec.dept_id;
  dbms_output.put_line(v_rec.dept_rec.department_name);
  
end;
/

declare
  v_rec departments%rowtype;
  
begin
  select * into v_rec from departments where department_id = 10;
  dbms_output.put_line(v_rec.department_id);
  dbms_output.put_line(v_rec.department_name);
  dbms_output.put_line(v_rec.manager_id);
  dbms_output.put_line(v_rec.location_id);
  
end;
/

-- 배열

begin 
  update emp set salary = salary * 1.1 where employee_id = 100;
  update emp set salary = salary * 1.1 where employee_id = 200;
  rollback;

end;
/

declare
  type table_id_type is table of number index by binary_integer;
  v_tab table_id_type;
  
begin
  v_tab(1) := 100;
  v_tab(3) := 200;
  for i in v_tab.first..v_tab.last loop -- 배열.first: 가장 작은 index / 배열.last: 가장 큰 index
    update emp set salary = salary * 1.1 where employee_id = v_tab(i);
  end loop;
  rollback;
  
end;
/

declare
  type table_id_type is table of number index by binary_integer;
  v_tab table_id_type;
  v_name emp.last_name%type;
  v_sal emp.salary%type;
  
begin
  v_tab(1) := 100;
  v_tab(3) := 200;
  for i in v_tab.first..v_tab.last loop 
    if v_tab.exists(i) then -- 배열에 비어있는 부분을 확인하고 있는 부분만 사용하기
      update emp set salary = salary * 1.1 where employee_id = v_tab(i) returning last_name, salary into v_name, v_sal;
      dbms_output.put_line(v_name || ' 사원의 급여가 ' || v_sal || '로 수정되었습니다');
    else
      dbms_output.put_line(i || ' 요소 번호가 없습니다.');
    end if;
  end loop;
  rollback;
  
end;
/

-- 1차원 배열
declare
  type num_type is table of number index by pls_integer;
  v_num num_type;
  
begin
  for i in 100..110 loop
    v_num(i) := i;
  end loop;
  for i in v_num.first..v_num.last loop
    dbms_output.put_line(v_num(i));
  end loop;
  
end;
/

-- 2차원 배열
declare
  type dept_rec_type is record(id number, name varchar2(30), mgr number, loc number);
  v_rec dept_rec_type;
  type dept_tab_type is table of v_rec%type index by pls_integer;
  v_tab dept_tab_type;
  
begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i * 10;
  end loop;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).id);
  end loop;

end;
/

declare
  type dept_rec_type is record(id number, name varchar2(30), mgr number, loc number);

  type dept_tab_type is table of dept_rec_type index by pls_integer;
  v_tab dept_tab_type;
  
begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i * 10;
  end loop;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).id);
  end loop;

end;
/

declare
  type dept_tab_type is table of departments%rowtype index by pls_integer;
  v_tab dept_tab_type;

begin
  for i in 1..5 loop
    select * into v_tab(i) from departments where department_id = i*10;
  end loop;
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line(v_tab(i).department_id);
  end loop;

end;
/