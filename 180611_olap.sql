select * from user_users;

-- ���̺� ����
create table test(id number);
select * from user_tables;
create table test1(id number) tablespace users;

-- ���̺� ����
drop table test purge;
drop table test1 purge;

create table emp (id number(4), name varchar2(20), day date) tablespace users;

select * from emp;

-- ���ο� row ����
desc emp --������ Ÿ�� Ȯ�� �� ����

insert into emp(id, name, day)
values(1, 'ȫ�浿', to_date('2018-06-11', 'yyyy-mm-dd'));

insert into emp(id, name, day)
values(2, '����ȣ', sysdate);

--data�� null�� �ִ� ���
insert into emp(id, name, day)
values(3, '������', null);

insert into emp(id, name)
values(4, '���θ�');

insert into emp
values(5, '�����', sysdate);

--�ǵ�����
rollback;

--����
commit;

create table emp_new(id number(4), name varchar2(20), day date)
tablespace users;

select * from emp;
select * from emp_new;

-- ���̺� ����
-- �����͸� �����Ͽ� ����
insert into emp_new(id, name, day)
select * from emp;

drop table emp_new purge;

-- �״�� �����Ͽ� ���̺� ����
create table emp_new
as select * from emp;

-- ���̺��� ������ �����Ͽ� ���ο� ���̺� ����
create table emp_new
as select * from emp where 1=2;

commit;
rollback;