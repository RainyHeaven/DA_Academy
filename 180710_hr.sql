/*[문제27]배열 변수에 있는 100,101,102,103,104, 200 사원번호를 기준으로 사원 이름, 근무개월수 150개월이상 되었으면 급여(salary)를 10% 인상한 급여로 수정한 후 , 인상 전 급여, 인상 후 급여를 출력하는  프로그램을 작성하세요.
사원 번호 : 100 사원 이름 :  King    근무개월수 :  166 인상 전 급여 : 24000 인상 후 급여 : 26400
사원 번호 : 101 사원 이름 :  Kochhar 근무개월수 :  139 17000 급여는 인상할 수 없습니다.
사원 번호 : 102 사원 이름 :  De Haan 근무개월수 :  195 인상 전 급여 : 17000 인상 후 급여 : 18700
사원 번호 : 103 사원 이름 :  Hunold  근무개월수 :  135 9000 급여는 인상할 수 없습니다.
사원 번호 : 104 사원 이름 :  ernst   근무개월수 :  119 6000 급여는 인상할 수 없습니다.
사원 번호 : 200 사원 이름 :  Whalen  근무개월수 :  163 인상 전 급여 : 4400 인상 후 급여 : 4840 */

declare
  type rec_emp_type is record(lname emp.last_name%type, wmonth number, sal emp.salary%type);
  type tab_num_type is table of number;
  v_empid tab_num_type := tab_num_type(100, 101, 102, 103, 104, 200);
  v_sal rec_emp_type;
  v_newsal emp.salary%type;
  
begin
  for i in v_empid.first..v_empid.last loop
    select last_name, trunc(months_between(sysdate, hire_date)), salary into v_sal.lname, v_sal.wmonth, v_sal.sal from employees where employee_id = v_empid(i);
    if v_sal.wmonth >= 150 then
      update emp set salary = salary * 1.1 where employee_id = v_empid(i) returning salary into v_newsal;
      dbms_output.put_line('사원 번호 : ' || v_empid(i) || ' 사원 이름 : ' || rpad(v_sal.lname, 8, ' ') || '근무개월수 : ' || v_sal.wmonth || ' 인상 전 급여 : ' || v_sal.sal || ' 인상 후 급여 : ' || v_newsal);
    else
      dbms_output.put_line('사원 번호 : ' || v_empid(i) || ' 사원 이름 : ' || rpad(v_sal.lname, 8, ' ') || '근무개월수 : ' || v_sal.wmonth || ' ' || v_sal.sal || ' 급여는 인상할 수 없습니다.');
    end if;
  end loop;
  rollback;

end;
/

/*[문제28] 배열에 1,2,4,5,6,10,20,21,55,60,22,8,0,6,20,40,6,9 값이 있습니다.
	 찾는 숫자의 배열 위치 정보 총갯수 정보를 출력하세요.
<화면결과>
20 값은 배열에 7,15 위치에 있으며 총 2 개 있습니다.
100 값은 없습니다. */
declare
  type target_num_type is table of number;
  type loc_num_type is table of number index by pls_integer;
  v_tlist target_num_type := target_num_type(1,2,4,5,6,10,20,21,55,60,22,8,0,6,20,40,6,9);
  v_loc loc_num_type;
  v_target number;
  v_loc_char varchar2(100);

begin  
  v_target := 20;
  for i in v_tlist.first..v_tlist.last loop
    if v_tlist(i) = v_target then
      v_loc(i) := i;
    end if;
  end loop;
  
  if v_loc.count > 0 then
    for i in v_loc.first..v_loc.last loop
      if v_loc.exists(i) then
        v_loc_char := v_loc_char || ',' || v_loc(i);
      end if;
    end loop;
    dbms_output.put_line(v_target || ' 값은 배열에 ' || ltrim(v_loc_char, ',') || '위치에 있으며 총 ' || v_loc.count || '개 있습니다.');
  else
    dbms_output.put_line(v_target || ' 값은 없습니다.');
  end if;

end;
/

/*[문제29] 사원의 last_name 값을 입력 받아서 그 사원의 employee_id, last_name, department_name 출력하고 
만약의 없는 last_name을 입력 할경우에는  "Hong 이라는 사원은 존재하지 않습니다."  출력 하는 프로그램을 만드세요.
입력값 : king
Employee Id = 156 Name = King Department Name = Sales
Employee Id = 100 Name = King Department Name = Executive

입력값 : hong
hong 이라는 사원은 존재하지 않습니다. */

var ename varchar2(10);
exec :ename := 'hong';

declare
  cursor emp_cur is select e.employee_id, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
  
begin  
  for emp_rec in emp_cur loop
    if emp_cur%found then
      dbms_output.put_line('Employee Id = ' || emp_rec.employee_id || ' Name = ' || initcap(:ename) || ' Department Name = ' || emp_rec.department_name);
    else -- fetch된 결과가 없을 시 for문을 바로 탈출해버려 else문은 실행되지 않음
      dbms_output.put_line(initcap(:ename) || '이라는 사원은 존재하지 않습니다.');
    end if;
  end loop;

end;
/

declare
  cursor emp_cur is select e.employee_id, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
  v_result emp_cur%rowtype;
  
begin  
  open emp_cur;
  loop
    fetch emp_cur into v_result;
    if emp_cur%rowcount = 0 then
      dbms_output.put_line(initcap(:ename) || '이라는 사원은 존재하지 않습니다.');
      exit;
    elsif emp_cur%notfound then
      exit;
    end if;
    dbms_output.put_line('Employee Id = ' || v_result.employee_id || ' Name = ' || initcap(:ename) || ' Department Name = ' || v_result.department_name);
  end loop;
  close emp_cur;
    
end;
/

declare
 cursor c1 is select e.employee_id, e.last_name, d.department_name from employees e, departments d where e.department_id = d.department_id and e.last_name = initcap(:ename);
 v_c number := 0;

begin
  for v_rec in c1 loop
    DBMS_OUTPUT.PUT_LINE('Employee Id = ' || v_rec.employee_id ||' Name = ' || v_rec.last_name ||' Department Name = '||v_rec.department_name);
    v_c := c1%rowcount;
  end loop;
      
  if v_c = 0 then 
    dbms_output.put_line(initcap(:ename) ||' 이라는 사원은 존재하지 않습니다.');
  else
    DBMS_OUTPUT.PUT_LINE(initcap(:ename) ||' 이라는 사원은 '|| v_c ||' 명 입니다.');
  end if;
  
end;
/







/*조합데이터유형
- 스칼라 유형과는 달리 다중값을 보유할 수 있다
- 레코드 형식: 서로 다른 데이터 유형의 값을 저장
- 배열: 동일한 데이터 유형의 값을 저장
  - index by table(연관 배열)
  - nested table(중첩 테이블)
  - varray
*/

declare
  type tab_char_type is table of varchar2(10) index by pls_integer;
  v_city tab_char_type;
  
begin
  v_city(1) := '서울';
  v_city(2) := '대전';
  v_city(3) := '부산';
  v_city(4) := '광주';
  
  dbms_output.put_line(v_city.count);
  dbms_output.put_line(v_city.first);
  dbms_output.put_line(v_city.last);
  dbms_output.put_line(v_city.next(1));
  dbms_output.put_line(v_city.prior(2));
  
  v_city.delete(3); -- 해당 인덱스 삭제
  v_city.delete(1, 3); -- 1번부터 3번까지 삭제
  v_city.delete; -- 전부 삭제
  
  for i in v_city.first..v_city.last loop
    if v_city.exists(i) then
      dbms_output.put_line(v_city(i));
    else
      dbms_output.put_line(i || ' 요소는 존재하지 않습니다.');
    end if;
  end loop;
  
end;
/


declare
  type tab_char_type is table of varchar2(10); -- nested table 배열 타입
  v_city tab_char_type := tab_char_type('서울', '대전', '부산', '광주');
  
begin
  
  dbms_output.put_line(v_city.count);
  dbms_output.put_line(v_city.first);
  dbms_output.put_line(v_city.last);
  dbms_output.put_line(v_city.next(1));
  dbms_output.put_line(v_city.prior(2));
  
  --v_city.delete(3); -- 해당 인덱스 삭제
  --v_city.delete(1, 3); -- 1번부터 3번까지 삭제
  --v_city.delete; -- 전부 삭제
  v_city.extend(1); -- 배열에 data를 추가하기 위해 확장
  v_city(5) := '대구';
  
  for i in v_city.first..v_city.last loop
    if v_city.exists(i) then
      dbms_output.put_line(v_city(i));
    else
      dbms_output.put_line(i || ' 요소는 존재하지 않습니다.');
    end if;
  end loop;
  
end;
/

-- varray
declare
  type tab_char_type is varray(5) of varchar2(10);
  v_city tab_char_type := tab_char_type('서울', '부산', '대전');
  
begin
  v_city.extend(2);
  v_city(4) :='광주';
  v_city(5) := '대구';
  for i in v_city.first..v_city.last loop
    dbms_output.put_line(v_city(i));
  end loop;
  
end;
/

/* cursor: 메모리 포인터, sql문 실행 메모리 영역
implicit cursor(암시적 커서)
- 커서를 오라클이 생성, 관리한다
- select... into.. : 반드시 1개 row만 fetch해야 한다 */

declare
  -- 1.커서 선언
  cursor emp_cur is select last_name from employees where department_id = 20; 
  v_name varchar2(30);

begin
  -- 2. 커서 open: 메모리 할당, parse, bind, execute, fetch
  open emp_cur; 
  
  -- 3. fetch: 커서에 있는 active set 결과를 변수에 로드하는 단계 
  loop
    fetch emp_cur into v_name;
    exit when emp_cur%notfound;
    dbms_output.put_line(v_name);
  end loop;
  -- 4. 커서 close: 메모리 해지
  close emp_cur;
  
end;
/

declare
  -- 1.커서 선언
  cursor emp_cur is select e.last_name, e.salary, d.department_name from employees e, departments d where e.department_id = 20 and d.department_id = 20; 
  v_rec emp_cur%rowtype;

begin
  -- 2. 커서 open: 메모리 할당, parse, bind, execute, fetch
  open emp_cur; 
  
  -- 3. fetch: 커서에 있는 active set 결과를 변수에 로드하는 단계 
  loop
    fetch emp_cur into v_rec;
    exit when emp_cur%notfound; -- fetch가 완료되면 loop 탈출
    dbms_output.put_line(v_rec.last_name);
    dbms_output.put_line(v_rec.salary);
    dbms_output.put_line(v_rec.department_name);
  end loop;
  -- 4. 커서 close: 메모리 해지
  close emp_cur;
  
end;
/

declare
  cursor emp_cur is select * from employees where department_id = 20;
  
begin
  for emp_rec in emp_cur loop -- for loop 구조를 이용: record변수 자동생성 / open, fetch, close 단계 자동
    dbms_output.put_line(emp_rec.last_name);
  end loop;

end;
/