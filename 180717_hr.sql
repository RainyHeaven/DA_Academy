/*[문제42] 사원번호를 입력값으로 받아서 그 사원의 근무 년수를 구하는 함수를 생성하세요. 
단 없는 사원번호가 들어오면 내가 만든 오류번호,메시지가 출력되도록 해야합니다. 
<함수 수행> 
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
ORA-20000: 300번 사원은 존재하지 않습니다. 
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
    raise_application_error(-20000, p_id||'번 사원은 존재하지 않습니다.', True);

end get_year;
/

/*[문제43] 부서코드를 입력값으로 받아서 부서이름을 return 하는 함수를 만들어주세요. 
부서코드가 없을 경우 '알수없는 부서'가 return해야 합니다. 
<함수 수행결과> 
select employee_id, last_name, department_id, dept_name_func(department_id) dept_name 
from employees; 
EMPLOYEE_ID LAST_NAME            DEPARTMENT_ID DEPT_NAME 
----------- -------------------- ------------- -------------------- 
        177 Livingston                      80 Sales 
        178 grant                              알수없는 부서 
         
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
    return '알수없는 부서';

end dept_name_func;
/

--문제점 : 함수가 사원테이블의 row건수만큼 돌아간다 
--해결 : 캐시 기능이 있는 scalar서브쿼리를 사용하자 

/*deterministic 
- 함수에 선언하는 힌트 : 캐시기능이 돌아가게 한다 
  (여기서는 부서코드의 종류의 수만큼(같은 부서코드는 1번만 수행) 함수가 돌아간다) */
  
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
    return '알수없는 부서';

end dept_name_func;
/

/*[문제44] 문자타입 컬럼 이지만 테이블에 있는 데이터는 숫자형식만 들어 가 있어야 하는데  
그렇지 않는 데이터를 확인 하는 함수를 생성하세요. null 또는 문자가 들어 있으면 0출력 숫자는 1 출력하세요. 
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

-- if문 활용
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

-- nvl 활용
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

/*[문제45] 1부터100까지 합을 구하는 함수를 생성하세요. 
단 인수값으로 0이 들어오면 전체 합을 구하고, 1이 들어오면 홀수만 합을 구하고,  
2가 들어오면 짝수만 합을 구하고, 다른 숫자값이 들어오면 오류가 나도록 해야 합니다. 
<함수 호출> 
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
ORA-20000: 인수값으로 0(전체),1(홀수),2(짝수)값만 입력값입니다. 
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
    raise_application_error(-20000, '인수값으로 0(전체), 1(홀수), 2(짝수)값만 입력값입니다.', True);
  end if;

end calc;
/

/*[문제46] 사원번호를 입력값으로 받아서 그 사원의 소득순위를 기준으로 1위 ~ 3위 고소득, 4위 ~ 8위 중소득, 그외 순위는 저소득이라는 값을 출력한다. 
select employee_id, salary, income(employee_id) income 
from employees 
order by 2 desc; 
EMPLOYEE_ID     SALARY INCOME 
----------- ---------- ---------- 
        100      24000 고소득 
        102      17000 고소득 
        101      17000 고소득 
        145      14000 고소득 
        146      13500 중소득 
        108    13208.8 중소득 
        205      12008 중소득  */

select employee_id, salary, income(employee_id) income from employees;

-- 2차원배열 활용
create or replace function income(p_id number)
return varchar2
is
  type emp_rec_type is record(id employees.employee_id%type, rank number);
  type emp_tab_type is table of emp_rec_type;
  v_emp_tab emp_tab_type;

begin
  select employee_id, rank()over(order by salary desc) bulk collect into v_emp_tab from employees order by employee_id;
  if v_emp_tab(p_id - 99).rank <= 3 then
    return '고소득';
  elsif v_emp_tab(p_id - 99).rank between 4 and 8 then
    return '중소득';
  else
    return '저소득';
  end if;
  
end income;
/

show error;
-- 인라인뷰 활용
create or replace function income(p_id number)
return varchar2
is
  v_rank number;
begin
  select rank into v_rank from (select employee_id, rank()over(order by salary desc) as rank from employees) where employee_id = p_id;
  if v_rank <= 3 then
    return '고소득';
  elsif v_rank between 4 and 8 then
    return '중소득';
  else
    return '저소득';
  end if;
end income;
/









-------------------------------------------------------------------------------- 

/*#package 
: 관련성있는 서브프로그램(프로시저,함수), 변수(global), 타입을 모아놓은 프로그램 
- 프로그램 바깥에서도 사용할 수 있다. 

1.spec(public) 
- 필수로 생성해야한다 
- 변수, 타입 , 프로시져    (생성자) 
- begin절이 없다 
- 선언만 한다 ★ 
- 선언된 생성자들은 모두 프로그램 바깥에서 사용가능 
- spec에 선언되있지 않은 생성자들은 바깥에서 사용할 수 없다 
create or replace package comm_pkg 
is 
  g_comm number :=0.1;   -- 글로벌 변수로써 어디서든 사용가능하다 
  procedure reset_comm(p_comm in number); -- 패키지 내에 프로시져 생성 
end comm_pkg; 
/ 

2.body(private) 
- 실제 소스 
- begin절은 선택 
- 함수를 사용하고 싶다면 프로시저 앞에 정의해야 한다. 
- 호출하고자 하는 프로그램은 항상 먼저 정의가 되어있어야한다(먼저 or 바깥쪽에) */


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

--호출하고자 하는 프로그램을 뒤에 선언하였더라도 불러올 수 있는 방법 
create or replace package body comm_pkg 
is 
  function validate_comm(v_comm in number) --필요한 부분에 먼저 선언부터 해준다(함수는 리턴값까지)
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

/*왜 패키지에 만드는 걸까? 
- 유지관리의 편리성 때문에 : 항상 함께 사용하는 두개의 프로그램을 각각 만들게 된다면 유지보수할 것이 늘어난다 
- 글로벌 변수를 사용하고 싶을때 */

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
: 동일한 이름의 프로시저, 함수를 만들 수 있다. 
to_char(날짜, 문자) 
to_char(숫자, 문자) 
- 형식매개변수의 갯수가 다르거나, 모드(in,out,in out)가 다르거나 타입이 달라야 over loading할 수 있다 */

create or replace package pack_over 
is 
  type date_tab_type is table of date index by pls_integer; 
  type num_tab_type is table of number index by pls_integer; 
  procedure init(tab out date_tab_type, n number); 
  procedure init(tab out num_tab_type, n number); 
end pack_over; 
/ 
-- 형식매개변수의 타입이 다르기 때문에 동일한 이름의 procedure을 만들 수 있다 

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