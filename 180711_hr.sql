/* [문제30] 2006년도에 입사한 사원들의 근무 도시이름별로 급여의 총액, 평균을 출력하세요.
<화면출력>
Seattle 도시에 근무하는 사원들의 총액급여는 ￦10,400 이고 평균급여는 ￦5,200 입니다.
South San Francisco 도시에 근무하는 사원들의 총액급여는 ￦37,800 이고 평균급여는 ￦2,907 입니다.
Southlake 도시에 근무하는 사원들의 총액급여는 ￦13,800 이고 평균급여는 ￦6,900 입니다.
oxford 도시에 근무하는 사원들의 총액급여는 ￦59,100 이고 평균급여는 ￦8,442 입니다. */

declare
  cursor sal2006 is select l.city, sum(e.salary) as sumsal, round(avg(e.salary)) as avgsal
                    from employees e, departments d, locations l
                    where e.department_id = d.department_id
                    and d.location_id = l.location_id
                    and e.hire_date between to_date('20060101', 'yyyymmdd') and to_date('20061231 235959', 'yyyymmdd hh24miss')
                    group by l.city;

begin
  for sal_rec in sal2006 loop
    dbms_output.put_line(sal_rec.city || ' 도시에 근무하는 사원들의 총액급여는 ' || trim(to_char(sal_rec.sumsal, 'l999g999')) || ' 이고 평균급여는 ' || trim(to_char(sal_rec.avgsal, 'l999g999')) || ' 입니다.');
  end loop;
  
end;
/
-- bulk collect into 활용
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
    dbms_output.put_line(v_tab(i).city || ' 도시에 근무하는 사원들의 총액급여는 ' || trim(to_char(v_tab(i).sumsal, 'l999g999')) || ' 이고 평균급여는 ' || trim(to_char(v_tab(i).avgsal, 'l999g999')) || ' 입니다.');
  end loop;

end;
/

-- 커서 선언 없이 for문에 바로 select문을 넣을 시 자동으로 커서 생성됨
-- 명시적 커서이지만 이름이 없음 -> 커서의 속성을 확인할 수 없음
begin 
  for v_rec in (select l.city, sum(e.salary) as sumsal, round(avg(e.salary)) as avgsal
                    from employees e, departments d, locations l
                    where e.department_id = d.department_id
                    and d.location_id = l.location_id
                    and e.hire_date between to_date('20060101', 'yyyymmdd') and to_date('20061231 235959', 'yyyymmdd hh24miss')
                    group by l.city;) loop
    dbms_output.put_line(sal_rec.city || ' 도시에 근무하는 사원들의 총액급여는 ' || trim(to_char(sal_rec.sumsal, 'l999g999')) || ' 이고 평균급여는 ' || trim(to_char(sal_rec.avgsal, 'l999g999')) || ' 입니다.');
  end loop;
  
end;
/

/*[문제31] 30번 부서 사원들의 이름, 급여, 근무개월수, 부서이름을 출력하고 그 사원들 중에 근무개월수가 150개월 이상인 사원들의 급여를 10%인상하는 프로그램을 작성하세요.
<화면 출력>
사원이름 : Raphaely 급여 : 11000 근무개월수 : 172 부서 이름 :  Purchasing
Raphaely 10%인상 급여로 수정했습니다.
사원이름 : Khoo 급여 : 3100 근무개월수 : 167 부서 이름 :  Purchasing
Khoo 10%인상 급여로 수정했습니다.
사원이름 : Baida 급여 : 2900 근무개월수 : 136 부서 이름 :  Purchasing
사원이름 : tobias 급여 : 2800 근무개월수 : 141 부서 이름 :  purchasing
사원이름 : Himuro 급여 : 2600 근무개월수 : 125 부서 이름 :  Purchasing
사원이름 : Colmenares 급여 : 2500 근무개월수 : 116 부서 이름 :  Purchasing */
-- rowid 활용
declare
  cursor sal_cur is select e.rowid, e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name from emp e, departments d where e.department_id = 30 and d.department_id = 30;
  
begin
  for sal_rec in sal_cur loop
    dbms_output.put_line('사원이름 : ' || sal_rec.last_name || ' 급여 : ' || sal_rec.salary || ' 근무개월수 : ' || sal_rec.wmonth || ' 부서 이름 : ' || sal_rec.department_name );
    if sal_rec.wmonth >= 150 then    
      update emp set salary = salary * 1.1 where rowid = sal_rec.rowid;
      if sql%found then
        dbms_output.put_line(sal_rec.last_name || ' 10%인상 급여로 수정했습니다.');
      end if;
    end if;
  end loop;
  rollback;

end;
/
-- for update & current of 활용
declare
  cursor sal_cur is select e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name from emp e, departments d where e.department_id = 30 and d.department_id = 30
  for update of e.last_name nowait;
  v_newsal number
  
begin
  for sal_rec in sal_cur loop
    dbms_output.put_line('사원이름 : ' || sal_rec.last_name || ' 급여 : ' || sal_rec.salary || ' 근무개월수 : ' || sal_rec.wmonth || ' 부서 이름 : ' || sal_rec.department_name );
    if sal_rec.wmonth >= 150 then
      update emp set salary = salary * 1.1 where current of sal_cur; -- current of 를 쓸때는 returning 절 사용 불가
      if sql%found then
        dbms_output.put_line(sal_rec.last_name || ' 10%인상 급여인 '|| v_newsal ||'로 수정했습니다.');
      end if;
    end if;
  end loop;
  rollback;

end;
/

-- bulk collect into 활용
declare
  type rec_type is record(rowid varchar2(18), lname emp.last_name%type, sal emp.salary%type, wmonth number, deptname departments.department_name%type);
  type tab_type is table of rec_type;
  v_tab tab_type;
  v_newsal number;
  
begin
  select e.rowid, e.last_name, e.salary, trunc(months_between(sysdate, e.hire_date)) as wmonth, d.department_name bulk collect into v_tab from emp e, departments d where e.department_id = 30 and d.department_id = 30;
  
  for i in v_tab.first..v_tab.last loop
    dbms_output.put_line('사원이름 : ' || v_tab(i).lname || ' 급여 : ' || v_tab(i).sal || ' 근무개월수 : ' || v_tab(i).wmonth || ' 부서 이름 : ' || v_tab(i).deptname );
    if v_tab(i).wmonth >= 150 then
      update emp set salary = salary * 1.1 where rowid = v_tab(i).rowid returning salary into v_newsal;
      if sql%found then
        dbms_output.put_line(v_tab(i).lname || ' 10%인상 급여인 '|| v_newsal ||'로 수정했습니다.');
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
-- 위 쿼리의 문제점: 2개의 커서에서 실행계획을 공유하지 못함

/*parameter를 갖는 cursor
- 실행계획을 공유 할 수 있도록 parameter를 통한 커서 생성
- parameter의 사이즈는 명시하지 않음
- 데이터 분포가 균일할 때 사용 */

declare
  cursor parm_cur(p_id number, p_job varchar2) is -- 커서명(형식 매개변수)
    select employee_id, last_name, job_id
    from employees
    where department_id = p_id
    and job_id = p_job;

  v_rec1 parm_cur%rowtype;
  
begin 
  open parm_cur(80, 'SA_MAN'); -- 커서명(실제 매개변수)
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

-- by index rowid 사용
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

-- by user rowid scan으로 유도
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
    -- for update 컬럼명: 해당 컬럼이 있는 테이블에 lock을 검 -> rowid값을 가지고 있게 됨
    -- wait 초: 해당 초 만큼 기다리고, 그 안에 lock이 풀리지 않으면 오류발생 / nowait: 기다리지 않고 바로 오류 발생
      
begin
  for emp_rec in sal_cur loop
    dbms_output.put_line(emp_rec.last_name);
    dbms_output.put_line(emp_rec.salary);
    dbms_output.put_line(emp_rec.department_name);
    update employees set salary = salary * 1.1 where current of sal_cur; -- 커서가 가지고 있는 rowid
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

-- bulk collect into 배열: 10g부터 나온 기능

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
  forall i in v_num.first..v_num.last -- 배열변수안의 모든 값을 적용한 DML문을 한번에 SQL엔진에게 전달함
    delete from emp where department_id = v_num(i);
  dbms_output.put_line(sql%rowcount);
  for i in v_num.first..v_num.last loop
    dbms_output.put_line(sql%bulk_rowcount(i) || ' rows deleted.');
  end loop;
  rollback;

end;
/