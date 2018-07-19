-- [문제55] 배열 변수에  20, 9, 8, 200,10, 3, 7, 11,100,101,210,5 값들이 쌓여 있습니다. 최대값을 구하는 프로그램을 작성하세요.
declare
  type numlist is table of number;
  v_nlist numlist;
  v_max number;
  
begin
  v_nlist := numlist(20, 9, 8, 200,10, 3, 7, 11,100,101,210,5);
  v_max := v_nlist(1);
  for i in 2..v_nlist.last loop
    if v_nlist(i) > v_max then
      v_max := v_nlist(i);
    end if;
  end loop;
  dbms_output.put_line('최대값은 '||v_max);

end;
/

-- [문제56] 배열 변수에  20, 9, 8, 200,10, 3, 7, 11,100,101,210,5 값들이 쌓여 있습니다. 최소값을 구하는 프로그램을 작성하세요.
declare
  type numlist is table of number;
  v_nlist numlist;
  v_min number;
  
begin
  v_nlist := numlist(20, 9, 8, 200,10, 3, 7, 11,100,101,210,5);
  v_min := v_nlist(1);
  for i in 2..v_nlist.last loop
    if v_nlist(i) < v_min then
      v_min := v_nlist(i);
    end if;
  end loop;
  dbms_output.put_line('최소값은 '||v_min);

end;
/

-- [문제57] 복제 테이블을 생성한후 emp_source 테이블에 dml이 발생하면 emp_target값도 함께 수행되도록 해주세요.
drop table emp_target purge;
drop table emp_source purge;

create table emp_target(id number, name varchar2(10), day timestamp default systimestamp, sal number);
create table emp_source(id number, name varchar2(10), day timestamp default systimestamp, sal number);

-- 테스트
select * from emp_source;
select * from emp_target;
insert into emp_source(id,name,day,sal) values(100,'ora1',default,1000);
commit;
update emp_source set sal = 2000 where id = 100;
update emp_source set name = 'oracle' where id = 100;
insert into emp_source(id,name,day,sal) values(2,user,default,3000);
delete from emp_source where id = 2;
rollback;

create or replace trigger auto_duplicate_trigger
after insert or delete or update on emp_source for each row
declare
begin
  if deleting then
    delete from emp_target where id = :old.id;
  elsif inserting then
    insert into emp_target(id, name, day, sal) values(:new.id, :new.name, :new.day, :new.sal);
  elsif updating then
    update emp_target set id = :new.id, name = :new.name, day = :new.day, sal = :new.sal;
  end if;
end;
/










/* Trigger 트리거
- 이벤트성 프로그램
- 어떤 이벤트(DML)가 발생할 때 자동으로 실행되는 프로그램 
- create trigger 시스템 권한이 필요
*/

select * from user_sys_privs;

drop table dept purge;
create table dept as select * from departments;
desc dept;

-- 문장트리거는 영향을 받은 row가 없어도 작동함
-- before 문장트리거
create or replace trigger dept_before
before
insert on dept
begin 
  dbms_output.put_line('insert하기 전에 문장트리거수행');
end;
/

-- after 문장트리거
create or replace trigger dept_after
after
insert on dept
begin 
  dbms_output.put_line('insert한 후에 문장트리거수행');
end;
/
-- 행 트리거는 영향을 받은 row가 있을 때만 수행
-- before 행 트리거
create or replace trigger dept_row_before
before insert on dept
for each row
begin 
  dbms_output.put_line('insert하기 전에 행 트리거수행');
end;
/

-- after 행 트리거
create or replace trigger dept_row_after
after insert on dept
for each row
begin 
  dbms_output.put_line('insert한 후에 행 트리거수행');
end;
/

create or replace trigger secure_dept
before insert or update or delete on dept
begin
  if to_char(sysdate, 'hh24:mi') between '14:00' and '16:00' then
    if inserting then
      raise_application_error(-20000, 'insert 시간이 아닙니다.');
    elsif updating then
      raise_application_error(-20001, 'update 시간이 아닙니다.');
    elsif deleting then
      raise_application_error(-20002, 'delete 시간이 아닙니다.');
    end if;
  end if;
end;
/

insert into dept(department_id, department_name, manager_id, location_id) values(300, 'IT', 100, 1500);
rollback;

create table copy_emp as select employee_id, last_name, salary, department_id from employees;

create or replace trigger copy_emp_trigger
before delete or insert or update of salary on copy_emp
for each row
when (new.department_id = 20 or old.department_id = 10)
declare
  v_sal number;
begin
  if deleting then
    dbms_output.put_line('old salary : '||:old.salary);
  elsif inserting then
    dbms_output.put_line('new salary : '||:new.salary);
  else
    v_sal := :new.salary - :old.salary;
    dbms_output.put_line('사원번호 : '||:new.employee_id||' 사원 이름: '||:old.last_name||' 이전급여 : '||:old.salary||' 수정된 급여 : '||:new.salary||' 급여차이 : '||v_sal);
  end if;
end;
/

-- 서로 다른 컬럼을 update 할때
create or replace trigger copy_emp_trigger
before delete or insert or update on copy_emp
for each row
when (new.department_id = 20 or old.department_id = 10)
declare
  v_sal number;
begin
  if deleting then
    dbms_output.put_line('old salary : '||:old.salary);
  elsif inserting then
    dbms_output.put_line('new salary : '||:new.salary);
  elsif updating('salary') then
    v_sal := :new.salary - :old.salary;
    dbms_output.put_line('사원번호 : '||:new.employee_id||' 사원 이름: '||:old.last_name||' 이전급여 : '||:old.salary||' 수정된 급여 : '||:new.salary||' 급여차이 : '||v_sal);
  end if;
end;
/

select * from copy_emp where department_id in (10, 20);
delete from copy_emp where department_id = 10;
insert into copy_emp(employee_id, last_name, salary, department_id) values(300, 'Gomok', 20000, 20);
update copy_emp set salary = salary * 1.1 where employee_id = 201;
rollback;

-- 트리거 확인
select * from user_triggers where table_name = 'COPY_EMP';