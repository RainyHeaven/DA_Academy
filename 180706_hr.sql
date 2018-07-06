/*[문제6]사원번호를 입력값으로 받아서 그 사원의 급여를 10%인상하는 프로그램을 수행하세요.
화면의 출력되는 결과는 수정 전 월급과 수정 후 월급이 아래와 같이 출력 후 transaction은 rollback 하세요.
수정 전 월급 : 24000
수정 후 월급 : 26400 */

drop table emp purge;
create table emp as select * from employees;

alter table emp add constraint emp_empid_pk primary key(employee_id);

var b_id number
execute :b_id := 100

declare
  sal emp.salary%type;

begin
  select salary into sal from emp where employee_id = :b_id;
  update emp set salary = salary * 1.1 where employee_id = :b_id;
  if sql%found then
    dbms_output.put_line('수정 전 월급 : ' || sal);
    dbms_output.put_line('수정 후 월급 : ' || (sal * 1.1));
    rollback;
  else
    dbms_output.put_line('수정에 실패했습니다')
  end if;

end;
/


declare
  v_sal emp.salary%type;
  v_name emp.last_name%type;

begin
  select salary into v_sal from emp where employee_id = :b_id;
  dbms_output.put_line('수정 전 월급 : ' || v_sal);
  
  -- returning: DML문장에 fetch기능을 추가함 / 여러 column에 적용 가능 / 1개 row만 적용
  update emp set salary = salary * 1.1 where employee_id = :b_id returning salary, last_name into v_sal, v_name;
  dbms_output.put_line('수정 후 월급 : ' || (v_sal) || '사원이름은 : ' || v_name);
  
  rollback;

end;
/

/*[문제7] 사원번호를 입력값으로 받아서 그 사원을 삭제하는 프로그램을 수행하세요.
화면의 출력되는 결과는 아래와 같이 출력 후 transaction은 rollback 하세요.
(emp 테이블 사용하세요.)
<화면출력>
삭제된 사원의 사원 번호는 100 이고  사원의 이름은 King 입니다. */

var b_id number
execute :b_id := 100

declare
  v_name emp.last_name%type;

begin
  delete from emp where employee_id = :b_id returning last_name into v_name;
  dbms_output.put_line('삭제된 사원의 사원 번호는 ' || :b_id || ' 이고 사원의 이름은 ' || v_name || ' 입니다.');
  rollback;

end;
/
select * from emp where employee_id = 100;

/*[문제8] 부서코드를 입력값으로 받아서 그 부서의 근무하는 사원의 인원수를 출력하시고 
그 부서 사원들의 급여중에 10000 미만인 사원만 10% 인상한 급여로 수정하는 프로그램을 작성하세요.
화면출력한 후 rollback 하세요.(emp 테이블 사용하세요)
<화면출력>
20 부서의 인원수는  2명 입니다.
20 부서의 수정된 ROW의 수는 1 입니다. */

var b_id number
execute :b_id := 20

declare
  v_cnt number;

begin
  select count(*) into v_cnt from emp where department_id = :b_id;
  update emp set salary = salary * 1.1 where department_id = :b_id and salary < 10000;
  dbms_output.put_line(:b_id || ' 부서의 인원수는 ' || v_cnt || '명 입니다.');
  dbms_output.put_line(:b_id || ' 부서의 수정된 ROW의 수는 ' || sql%rowcount || ' 입니다.');
  rollback;
end;
/

/*[문제9] 나이를 입력값으로 받아서 유아, 어린이, 청소년, 성인 출력해주세요
유아 1세 이상 6세 미만
어린이 기준 : 6세 이상 13 미만
청소년 13이상 19세 미만
성인 19세 이상 */
var b_myage number
exec :b_myage := 15

begin 
  if :b_myage >= 1 and :b_myage < 6 then dbms_output.put_line('유아 입니다');
  elsif :b_myage >= 6 and :b_myage < 13 then dbms_output.put_line('어린이 입니다');
  elsif :b_myage >= 13 and :b_myage < 19 then dbms_output.put_line('청소년 입니다');
  elsif :b_myage >= 19 then dbms_output.put_line('성인 입니다');
  else dbms_output.put_line('올바른 나이를 입력해주세요');
  end if;
  
end;
/

-- [문제10] 숫자를 입력값 받아서 짝수 인지 홀수 인지를 출력하는 프로그램을 작성하세요.
var v_a number
execute :v_a := 7

begin
  if mod(:v_a, 2) = 1 then dbms_output.put_line('홀수입니다.');
  elsif mod(:v_a, 2) = 0 then dbms_output.put_line('짝수입니다.');
  else dbms_output.put_line('올바른 숫자를 입력하세요');
  end if;

end;
/

/*[문제11] 급여, 커미션를 입력 값으로 받아서 두값을 더하는 프로그램을 만드세요.
<화면출력>
두 바인드 변수에 값을 입력해주세요
<화면출력>
급여만 입력되었습니다.10000
<화면출력>
커미션만 입력되었습니다.10 
<화면출력>
10010 */
var b_sal number
var b_comm number
exec :b_sal := 10000;
exec :b_comm := 10;

begin
  if :b_comm is null and :b_sal is not null then dbms_output.put_line('급여만 입력되었습니다.' || :b_sal);
  elsif :b_sal is null and :b_comm is not null then dbms_output.put_line('커미션만 입력되었습니다.' || :b_comm);
  elsif :b_sal is not null and :b_comm is not null then dbms_output.put_line(:b_sal + :b_comm);
  else dbms_output.put_line('두 바인드 변수에 값을 입력해주세요.');
  end if;

end;
/

/*[문제12] 두개의 숫자를 입력해서 해당 숫자의 차이값을 출력하세요.
숫자를 어떻게 입력하던 큰 숫자에서 작은 숫자로 빼기를 하세요.*/

var v_a number
var v_b number
execute :v_a := 10
execute :v_b := 7

print v_a v_b

begin
  if :v_a > :v_b then dbms_output.put_line(:v_a - :v_b);
  else dbms_output.put_line(:v_b - :v_a);
  end if;

end;
/

/*[문제13] 사원번호를 입력값으로 받아서 그 사원의 근무개월수를 출력하고 근무개월수가
150개월 이상이면 급여를 20% 인상한 급여로 수정, 
149개월 보다 작거나 같고 100개월 보다 크거나 같으면  10%인상한 급여로 수정,
100개월 미만인 근무자는 아무 작업을 수행하지 않는 프로그램을 작성하세요.
테스트가 끝나면 rollback 합니다.(emp 테이블 사용)
<화면 출력>
100 사원은 근무개월수가 154 입니다. 급여는 20% 수정되었습니다.
<화면 출력>
166 사원은 근무개월수가 97 입니다. 100 개월 미만이므로  급여 수정 안됩니다. */

var b_empid number
exec :b_empid := 100

declare 
  v_wmonth number;
  
begin
  select trunc(months_between(sysdate, hire_date), 0) into v_wmonth from emp where employee_id = :b_empid;
  
  if v_wmonth >= 150 then update emp set salary = salary * 1.2 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 급여가 20% 인상되었습니다.');
  elsif v_wmonth between 100 and 149 then update emp set salary = salary * 1.1 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 급여가 10% 인상되었습니다.');
  else dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 100개월 미만이므로 급여 변동이 없습니다.');
  end if;
    
  rollback;
  
end;
/

-- 문제 14번 : 문제13번을 case문으로 해결하시오
declare 
  v_wmonth number;
  
begin
  select trunc(months_between(sysdate, hire_date), 0) into v_wmonth from emp where employee_id = :b_empid;
  
  case
  when v_wmonth >= 150 then update emp set salary = salary * 1.2 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 급여가 20% 인상되었습니다.');
  when v_wmonth between 100 and 149 then update emp set salary = salary * 1.1 where employee_id = :b_empid; dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 급여가 10% 인상되었습니다.');
  else dbms_output.put_line(:b_empid || '사원은 근무개월수가 ' || v_wmonth || '입니다. 100개월 미만이므로 급여 변동이 없습니다.');
  end case;
    
  rollback;
  
end;
/

/*[문제15] 화면의 숫자 1 부터 10 까지 출력하는 프로그램을 작성합니다. 단 4,8번은 출력하지 마세요.
<화면출력>
1
2
3
5
6
7
9
10 */
-- if문
declare
  i number := 1;

begin
  loop 
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    elsif i > 10 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

declare
  i number := 1;

begin
  loop 
    if i = 4 or i = 8 then null;
    else dbms_output.put_line(i);
    end if;
    i := i + 1;
    exit when i > 10;
  end loop;

end;
/

-- while문
declare
  i number := 1;
  
begin
  while i <= 11 loop
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    elsif i > 10 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

-- for문
begin
  for i in 1..10 loop
    if i >= 1 and i <= 10 and i != 4 and i != 8 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

begin 
  for i in 1..10 loop
    if i = 4 or i = 8 then null;
    else dbms_output.put_line(i);
    end if;
  end loop;

end;
/

begin 
  for i in 1..10 loop
    if i != 4 and i != 8 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/


--[문제16] 1번부터 100까지 짝수만 출력하세요.(기본 loop, while loop, for loop)
--loop
declare
  i number := 1;

begin
  loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    elsif i > 100 then exit;
    end if;
    i := i + 1;
  end loop;

end;
/

-- while
declare
  i number := 1;

begin
  while i <= 100 loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    end if;
    i := i + 1;
  end loop;

end;
/

-- for
begin
  for i in 1 .. 100 loop
    if mod(i, 2) = 0 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

-- [문제17] 1번부터 100까지 홀수만 출력하세요.
--loop
declare
  i number := 1;

begin
  loop
    if i > 100 then exit;
    elsif mod(i, 2) = 1 then dbms_output.put_line(i); 
    end if;
    i := i + 1;
  end loop;

end;
/

-- while
declare
  i number := 1;

begin
  while i <= 100 loop
    if mod(i, 2) = 1 then dbms_output.put_line(i);
    end if;
    i := i + 1;
  end loop;

end;
/

-- for
begin
  for i in 1 .. 100 loop
    if mod(i, 2) = 1 then dbms_output.put_line(i);
    end if;
  end loop;

end;
/

/*[문제18] 구구단 2단 출력하는 프로그램을 작성하세요.
2 * 1 = 2
2 * 2 = 4
2 * 3 = 6
2 * 4 = 8
2 * 5 = 10
2 * 6 = 12
2 * 7 = 14
2 * 8 = 16
2 * 9 = 18*/

declare
  v_dan number := 2;
  v_result number;

begin
  for i in 1..9 loop
    v_result := v_dan * i;
    dbms_output.put_line(v_dan || ' * ' || i || ' = ' || v_result);
  end loop;

end;
/






-- 조건제어문: boolean
declare
  v_flag boolean := true;
  
begin
  if v_flag then
    dbms_output.put_line('참');
  end if;

end;
/

declare
  v_flag boolean := true;
  
begin
  if v_flag then
    dbms_output.put_line('참');
  else
    dbms_output.put_line('거짓');
  end if;

end;
/

/*if문
if 조건 then 참값일때 실행할 명령;
elsif 조건 then 참값일때 실행할 명령;
else 참이 없을 때 실행할 명령;
end if;

- 비교연산자
x > y / x < y / x = y / x <> y / x >= y / x <= y
- 논리연산자
and, or, not
- null 비교
is null, is not null */

declare
 v_grade char(1) := upper('c');
 v_appraisal varchar2(30);
 
begin
  v_appraisal := case v_grade when 'A' then '참잘했어요' when 'B' then '잘했어요' when 'C' then '다음에 잘해요' else '니가 사람이야!!' end;
  dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal );
  
end;
/

declare
 v_grade char(1) := upper('c');
 v_appraisal varchar2(30);
 
begin
  v_appraisal := case when v_grade = 'A' then '참잘했어요' when v_grade in ('B', 'C') then '잘했어요' when v_grade = 'D' then '다음에 잘해요' else '니가 사람이야!!' end;
  dbms_output.put_line('등급은 ' || v_grade || ' 평가는 ' || v_appraisal );
  
end;
/

/*case 문
case
  when 비교1 then 참값일때 작업
  when 비교2 then 참값일때 작업
  else 참값이 없을때 작업
end case
*/

-- 반복문
-- loop문
declare 
  i number := 1;

begin
  loop
    dbms_output.put_line(i);
    i := i + 1;
    if i > 10 then exit;
    end if;
  end loop;

end;
/

-- while loop 문
declare
  i number := 1;

begin
  while i <= 10 loop
    dbms_output.put_line(i);
    i := i+1;
    if i = 5 then exit;
  end loop;

end;
/

-- for 문
begin 
  for i in 1..10 loop
    dbms_output.put_line(i);
    -- i := i + 1; <- 오류: count 변수는 할당 불가
  end loop;
  
end;
/

declare
  v_start number := 1;
  v_end number := 10;

begin
  for i in reverse v_start..v_end loop -- reverse: 큰수부터 역순으로 loop
    dbms_output.put_line(i);
  end loop;

end;
/

