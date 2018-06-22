/* index scan
1. index unique scan
2. index range scan
3. inlist iterator - in / or ������ �϶� 
4. index skip scan - 9i �������� ����
5. index full scan */
-- �ϳ��� ���̺� 4�� �̻��� index�� �ǰ����� ���� -> �ʹ� ���� index�� �����ȹ ����� ������

-- ���̺� �ɸ� �ε��� Ȯ��
select * from user_ind_columns where table_name = 'EMP';


-- ���̺� ���Ե� �÷��� �������� Ȯ��
select * from user_constraints where table_name = 'EMP';
select * from user_cons_columns where table_name = 'EMP';

-- �ε��� ����
create index emp_last_first_idx on emp(last_name, first_name);
create index emp_dept_idx on emp(department_id);

-- �����ȹ ����
explain plan for select * from emp where last_name = 'King' and first_name = 'Steven';
explain plan for select * from emp where department_id = 10;

-- �����ȹ�� ��Ʈ �ֱ�
-- full scan
explain plan for select /*+ full(e)*/* from emp e where employee_id = 100;
-- ������ index���
explain plan for select /*+ index(e emp_dept_id_idx)*/ * from emp e where department_id = 10;
-- ������ index�� range scan
explain plan for select /*+ index_rs(e emp_dept_id_idx)*/ * from emp e where department_id = 10;
-- skip scanning�� ��ȿ�� ���� ��Ȳ�� ���� ���� index�� ����
explain plan for select /*+ index(e emp_first_idx)*/* from emp e where first_name = 'Steven';
-- ������ index�� skip scanning
explain plan for select /*+ index_ss(e emp_last_first_idx)*/* from emp e where first_name = 'Steven';
-- ������ index�� fast full scan
explain plan for select /*+ index_ffs(e emp_id_pk) */ count(*) from emp e; -- not null ������ �ɸ� index�� ���� count: �д� block�� �ٿ� I/O �ּ�ȭ
-- ������ index�� descending�ϰ� ����
select /*+ index_desc(e emp_id_pk) */ employee_id from emp e;


-- index�� �־ ���ϴ� �÷��� ���� ���ٸ� full scan���� �����ϴ� ���� ȿ�����̴�
explain plan for select * from emp e where department_id = 50;
explain plan for select /*+ full(e)*/* from emp e where department_id = 50;

-- �����ȹ Ȯ��
select * from table(dbms_xplan.display(null, null, 'typical'));

-- random I/O: Ư�� row�� ã�� ���� ���� ������ �� �߻�
-- serial I/O:  block ������ ���ӵ� row�� ������ �� �߻�

-- primary key �߰�
alter table emp add constraint emp_id_pk primary key(employee_id);

select department_id, count(*)
from emp
group by department_id;

-- ���ϴ� �÷��� �ߺ��� üũ distinctive column check
select count(distinct department_id) from emp;

explain plan for select last_name, first_name from emp;

explain plan for select employee_id from emp;

-- count(*): null ���� / count(�÷�): null ����
explain plan for select count(*) from emp e; -- pk �Ǵ� not null ������ �ɸ� index�� ���� count: �д� block�� �ٿ� I/O �ּ�ȭ

-- parallel_index: index����ó��, (multiblock i/o�� �����ϴ� )fast full scan�� ���� ���� 
explain plan for 
select /*+ index_ffs(e emp_id_pk) 
           parallel_index(e, emp_id_pk, 2) */ 
           count(*) 
from emp e;

select * from table(dbms_xplan.display(null, null, 'typical'));

-- index range scan descending / index�� sort�� ����� ������ �����Ƿ� ���� ������ �߻����� ����
explain plan for
select *
from emp 
where employee_id > 0
order by employee_id desc;

-- ����� ������� �ʴ� ���(maxã��)
select /*+ index_asc(e emp_id_pk) */ employee_id
from emp e
where rownum <= 1;

-- INDEX FULL SCAN (MIN/MAX)�� ���ؼ� MIN/MAX ������ �����Ѵ�
-- min, max�� �Բ� ���� ��� index full scan�� �ȴ�
explain plan for select max(employee_id), min(employee_id) from emp;
explain plan for select max(employee_id) from emp union all select min(employee_id) from emp;

-- ������ select ���� �����ȹ�� ���� ������� ����
select /*+ gather_plan_statistics */ *
from emp
where employee_id = 100;

-- ������ ������� Ȯ��
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
-- E-Rows: ������ row�� ��
-- A-Rows: ���� row�� ��
-- buffers: �޸𸮿��� ã�� block�� ��(�Ʒ����� ���� ������ ��)

select /*+ gather_plan_statistics */ *
from emp
where department_id = 50;

select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));

-- clustering factor: row�� �������� ǥ���ϴ� factor / �ϳ��� row���� ���� row�� �ٸ� block�� ���� �� 1�� �þ

select /*+ gather_plan_statistics full(e) */ *
from emp e
where department_id = 50;