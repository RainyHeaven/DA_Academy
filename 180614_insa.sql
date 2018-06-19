-- ���� 95  insa ������ ���̺��������.pdf�� ERD(Entity Relationship Diagram)�� Ȯ�� ���� table instance chart��  ���鼭 ���̺��� �����ϼ���.

create table dept
(dept_id number(3) constraint dept_id_pk primary key,
 dept_name varchar2(50) constraint dept_nn not null 
                        constraint dept_uk unique,
 mgr number(5));
 
 create table emp
 (id number(5) constraint emp_id_pk primary key,
  name varchar2(50) constraint emp_name_nn not null,
  hire_date date constraint emp_date_nn not null,
  sal number(8, 2) constraint emp_sal_ck check(sal > 100),
  mgr number(5),
  dept_id number(3),
  constraint emp_dept_id_fk foreign key(dept_id) references dept(dept_id),
  constraint emp_mgr_fk foreign key(mgr) references emp(id));
  
  desc emp;
  desc dept;
  
  select * from user_constraints where table_name = 'DEPT';
  
  alter table emp modify dept_id constraint emp_dept_id_nn not null;
  
  -- ���ݺ��� ������ ���ο� �����͸� �������� üũ
  --validate: �̰��Ǵ� ������ üũ / novalidate: ���Ӱ� ������ �����ͺ��� üũ
  alter table emp modify dept_id constraint emp_dept_id_nn not null enable novalidate;
  
  --novalidate Ȯ��
select *
from user_constraints
where table_name = 'EMP';
  
--�������� ��Ȱ��ȭ
--disable novalidate: ��뷮 �����͸� �̰� �� �� �ӵ����ϸ� �����ϱ� ���� ��Ȱ��ȭ(disable�� default)
--disable validate: ��� ���̺� DML ����, �б� ���� ������ ���̺�
--�������� Ȱ��ȭ
--enable novalidate: ���� �� �������� ����
--enable validate: ������ ����(enable�� default)

drop table test purge;
create table test(id number constraint test_id_nn not null disable novalidate);
  
select * 
from user_constraints
where table_name = 'TEST';

-- null�ӿ��� insert�� ����
insert into test(id)
values(null);

rollback;

alter table test
modify id constraint test_id_nn not null disable validate;

drop table test purge;
create table test
(id number,
 name char(10),
 sal number);
 insert into test(id, name, sal) values(1, 'a', 1000);
 insert into test(id, name, sal) values(2, 'b', 100);
 insert into test(id, name, sal) values(1, 'a', 2000);
 commit;
 
 select * from test;
 
 -- enable validate�� �⺻ ���̾ primary key�� ���ǰ� ���� �߻�
 alter table test add constraint test_id_pk primary key(id);
 
 -- primary key�� enable novalidate�� �Ұ�
 alter table test add constraint test_id_pk primary key(id)
 enable novalidate;
 
 --disable �⺻�� disable novalidate
 alter table test add constraint test_id_pk primary key(id) disable;
 select * from user_constraints where table_name = 'TEST';
 
  --���������� ȯ�氪�� ��ϵǾ��ִ� ������ ������
  --�������� Ȱ��ȭ�� �����Ǵ� �����͵��� ���� exceptions ���̺� ����
 @%ORACLE_HOME%\rdbms\admin\utlexpt1
 
 select * from tab;
 
 desc exceptions;
 
 --exceptions into ���̺��: ���ݵǴ� �÷��� ������ ���̺� ����
 alter table test enable constraint test_id_pk
 exceptions into exceptions;
 
 select * from exceptions;
 
 --rowid�� ���� Ȯ�� �� ����
 select * from test where rowid = 'AAAE/mAAEAAAAIFAAA';
 
 update test
 set id = 3
 where rowid = 'AAAE/mAAEAAAAIFAAA';
 
 alter table test add constraint test_sal_ck check(sal > 1000)
 enable novalidate;
 
 insert into test(id, name, sal)
 values(4, 'c', 500);
 
 -- primary key�� unique ���������� ���� �� ���� disable�� �ؾ���(���� enable novalidate �Ұ���)
 -- not null, foreign key, check ���������� enable novalidate ����
 
 alter table test enable constraint test_sal_ck
 exceptions into exceptions;
 
 alter table test add constraint test_sal_ck check(sal > 1000) enable novalidate;
 
 delete from exceptions;
 
 commit;
 
 alter table test enable constraint test_sal_ck exceptions into exceptions;
 
 select * from exceptions;
 
 update test
 set sal = null
 where rowid in ('AAAE/mAAEAAAAIFAAA', 'AAAE/mAAEAAAAIFAAB');
 
 select * from test;
 
 commit;
 
 delete from exceptions;
 
 commit;
 
 alter table test enable constraint test_sal_ck exceptions into exceptions;
 
 select * from exceptions;