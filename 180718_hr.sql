/*[문제47] 사원번호를 입력값으로 받아서 사번, 이름, 부서이름을 출력하는 프로시저를 생성하세요.
SQL> exec id_proc(100)
사원번호 : 100  사원 이름 : King  부서이름 : Executive
PL/SQL procedure successfully completed.

SQL> exec id_proc(200)
사원번호 : 200  사원 이름 : Whalen  부서이름 : Administration
PL/SQL procedure successfully completed.

SQL> exec id_proc(300)
300사원은 존재하지 않습니다.
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
  dbms_output.put_line('사원번호 : '||p_id||' 사원 이름 : '||v_emp_rec.lname||' 부서이름 : '||v_emp_rec.dname);
  
exception
  when no_data_found then
    dbms_output.put_line(p_id||'사원은 존재하지 않습니다.');
  
  when others then
    dbms_output.put_line(sqlerrm);
  
end id_proc;
/

/* [문제48] 사원이름을 입력값으로 받아서 사원번호, 이름, 부서이름을 출력하는 프로시저를 생성하세요.
SQL> exec name_proc('de haan')
사원번호 : 102  사원 이름 : De Haan  부서이름 : Executive
PL/SQL procedure successfully completed.

SQL> exec name_proc('king')
사원번호 : 156  사원 이름 : King  부서이름 : Sales
사원번호 : 100  사원 이름 : King  부서이름 : Executive
PL/SQL procedure successfully completed.

SQL> exec name_proc('hong')
hong 사원은 존재하지 않습니다.
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
    dbms_output.put_line(p_name||' 사원은 존재하지 않습니다');
  else
    for i in v_emp_tab.first..v_emp_tab.last loop
      dbms_output.put_line('사원번호 : '||v_emp_tab(i).id||' 사원 이름 : '||v_name||' 부서이름 : '||v_emp_tab(i).dname);
    end loop;
  end if;
  
exception
  when others then
    dbms_output.put_line(sqlerrm);
    
end name_proc;
/

/*[문제49] 사원번호 또는 사원이름을 입력값으로 받아서 사원번호, 이름, 부서이름을 출력하는 패키지를 생성하세요.
SQL> execute emp_find.find(100)
사원번호: 100 사원이름: King 부서이름: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find(500)
500사원은 존재하지 않습니다.
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('king')
사원번호: 156 사원이름: King 부서이름: Sales
사원번호: 100 사원이름: King 부서이름: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('de haan')
사원번호: 102 사원이름: De Haan 부서이름: Executive
PL/SQL procedure successfully completed.

SQL> execute emp_find.find('hong')
Hong사원은 존재하지 않습니다.
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
    dbms_output.put_line('사원번호 : '||p_id||' 사원 이름 : '||v_emp_rec.lname||' 부서이름 : '||v_emp_rec.dname);
  exception
    when no_data_found then
      dbms_output.put_line(p_id||'사원은 존재하지 않습니다.');
    when others then
      dbms_output.put_line(sqlerrm);
  end find;
  
  procedure find(p_name in varchar2)
  is    
  begin
    select employee_id, last_name, (select department_name from departments where department_id = e.department_id) bulk collect into v_emp_tab from employees e where last_name = initcap(p_name);
    if v_emp_tab.count = 0 then
      dbms_output.put_line(p_name||' 사원은 존재하지 않습니다');
    else
      for i in v_emp_tab.first..v_emp_tab.last loop
        dbms_output.put_line('사원번호 : '||v_emp_tab(i).id||' 사원 이름 : '||v_emp_tab(i).lname||' 부서이름 : '||v_emp_tab(i).dname);
      end loop;
    end if;
    
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      
  end find;

end emp_find;
/

/*[문제50] 사원들의 급여를 10% 인상하는 프로그램을 생성해주세요. 
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,180,190,200);
begin 
    emp_pkg.update_sal(v_num);
end;
/
사원번호 : 100        사원이름 : King       수정 급여 : 29040
사원번호 : 103        사원이름 : Hunold     수정 급여 : 9900
사원번호 : 107        사원이름 : Lorentz    수정 급여 : 4620
사원번호 : 110        사원이름 : Chen       수정 급여 : 9020
사원번호 : 112        사원이름 : Urman      수정 급여 : 8580
사원번호 : 115        사원이름 : Khoo       수정 급여 : 3410
사원번호 : 160        사원이름 : Doran      수정 급여 : 8250
사원번호 : 170        사원이름 : Fox        수정 급여 : 10560
사원번호 : 180        사원이름 : Taylor     수정 급여 : 3520
사원번호 : 190        사원이름 : gates      수정 급여 : 3190
사원번호 : 200        사원이름 : Whalen     수정 급여 : 5808 */
-- 테스트
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
      dbms_output.put_line('사원번호 : '||rpad(p_list(i), 10, ' ')||'사원이름 : '||rpad(v_emp_tab(i).lname, 10, ' ')||'수정 급여 : '||rpad(v_emp_tab(i).nsal, 10, ' '));
    end loop;
  end update_sal;

end emp_pkg;
/

/*[문제51] 배열변수에 값을 비교하는 익명블록 프로그램을 작성하세요. 
v_1 := 1,2,3,4,5
v_2 := 1,3

<화면결과>

2 없는 값입니다.
4 없는 값입니다.
5 없는 값입니다. */

-- v_1 기준으로 v_2에 없는 값 출력
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
        dbms_output.put_line(v_1(i)||' 없는 값입니다.');
      end if;
    end loop;
  end loop;
  
end;
/

-- 두개를 전부 비교하여 일치하지 않는 값을 정렬하여 출력
-- for 문을 각각 돌려 출력하는 형식
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
        -- dbms_output.put_line(v_1(i)||' 없는 값입니다.');
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
        --dbms_output.put_line(v_2(i)||' 없는 값입니다.');
      end if;
    end loop;
  end loop;
  
  -- 정렬하여 출력
  for i in v_output.first..v_output.last loop
    if v_output.exists(i) then
      dbms_output.put_line(v_output(i)||' 는 없는 값입니다.');
    end if;
  end loop;
  
end;
/

-- 제3의 배열을 만들고 교집합(중첩된 값)을 제외한 값을 확인
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
      dbms_output.put_line(i||' 없는 값입니다.');
    end if;
  end loop;
  
end;
/

/*[문제52] 사원들의 급여를 10% 인상하는 프로그램을 생성해주세요.
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,250,180,190,200,250,300);
begin 
    emp_pkg.update_sal(v_num);
    rollback;
end;
/
사원번호 : 100        사원이름 : King       수정 급여 : 29040
사원번호 : 103        사원이름 : Hunold     수정 급여 : 9900
사원번호 : 107        사원이름 : Lorentz    수정 급여 : 4620
사원번호 : 110        사원이름 : Chen       수정 급여 : 9020
사원번호 : 112        사원이름 : Urman      수정 급여 : 8580
사원번호 : 115        사원이름 : Khoo       수정 급여 : 3410
사원번호 : 160        사원이름 : Doran      수정 급여 : 8250
사원번호 : 170        사원이름 : Fox        수정 급여 : 10560
사원번호 : 180        사원이름 : Taylor     수정 급여 : 3520
사원번호 : 190        사원이름 : Gates      수정 급여 : 3190
사원번호 : 200        사원이름 : Whalen     수정 급여 : 5808
250 처리되지 않는 값입니다.
300 처리되지 않는 값입니다. */
-- 테스트
declare
   v_num  emp_pkg.numlist := emp_pkg.numlist(100,103,107,110,112,115,160,170,250,180,190,200,250,300);
begin 
    emp_pkg.update_sal(v_num);
    rollback;
end;
/

-- 풀이
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
          dbms_output.put_line('사원번호 : '||rpad(v_emp_tab(j).empid, 10, ' ')||'사원이름 : '||rpad(v_emp_tab(j).lname, 10, ' ')||'수정 급여 : '||rpad(v_emp_tab(j).nsal, 10, ' '));
          exit;
        elsif j = v_emp_tab.last then
          dbms_output.put_line(p_list(i)||' 처리되지 않는 값입니다.');
        end if;
      end loop;
    end loop;
  end update_sal;

end emp_pkg;
/

-- 예시와 같이 오류를 모아 중첩된 값 없애고 순서대로 출력하기
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
      dbms_output.put_line('사원번호 : '||rpad(v_emp_tab(i).empid, 10, ' ')||'사원이름 : '||rpad(v_emp_tab(i).lname, 10, ' ')||'수정 급여 : '||rpad(v_emp_tab(i).nsal, 10, ' '));
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
        dbms_output.put_line(i||' 처리되지 않는 값입니다.');
      end if;
    end loop;
  end update_sal;

end emp_pkg;
/

/*[문제 53] 입력값으로 받은 숫자들의 합을 구하는 함수, 평균을 구하는 함수를 패키지에서 생성하세요.
declare
 v_num agg_pack.num_type := agg_pack.num_type(10,5,2,1,8,9,20,21);
begin
  dbms_output.put_line('합 : '||agg_pack.sum_fc(v_num));
  dbms_output.put_line('평균 : '||agg_pack.avg_fc(v_num));
end;
/
합 : 76
평균 : 9.5 */
-- 테스트
declare
 v_num agg_pack.num_type := agg_pack.num_type(10,5,2,1,8,9,20,21);
begin
  dbms_output.put_line('합 : '||agg_pack.sum_fc(v_num));
  dbms_output.put_line('평균 : '||agg_pack.avg_fc(v_num));
end;
/

-- 풀이
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

-- [문제54] 10,10,10,20,20,40,40,50,50,50,60,60,60,30,30,30,30 빈도수를 배열을 이용해서 구하세요.
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
  
  /* for문 활용
  for i in v_result.first..v_result.last loop
    if v_result.exists(i) then
      dbms_output.put_line(i||'의 빈도수 '||v_result(i));
    end if;
  end loop; */
  
  i := v_result.first;
  
  -- next 활용
  loop
    dbms_output.put_line(i||'의 빈도수 '||v_result(i));
    i := v_result.next(i);
    exit when v_result.next(i) is null;
  end loop;
  
end;
/












-- 패키지의 커서 지속상태
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
  end open; -- 패키지에서 open한 커서는 close할 때까지 열려있게 된다
  
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
	  dbms_output.put_line('데이터가 없습니다.');
	  return;
	else
		fetch c1 bulk collect into v_tab limit p_num; -- limit: bulk collect into의 row수를 제한함
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

-- 테스트
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
    dbms_output.put_line('job_id가 '||v_index||'인 사원 : '||v_result(v_index));
    v_index := v_result.next(v_index);
    exit when v_index is null;
  end loop;
  
end;
/