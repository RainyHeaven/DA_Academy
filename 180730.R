# [문제87] 아래화면의 결과 처럼 데이터 프레임을 생성한 후 
# total 컬럼을 생성해서 sql과 python 의 합을 구하세요.(단 apply함수를 이용하세요)
# name 	sql 	python
# king	96	75
# smith	NA	91
# jane	78	86
# scott	90	NA

score <- data.frame(name=c('king', 'smith', 'jane','scott'), sql=c(96, NA, 78, 90), python=c(75, 91, 86, NA), stringsAsFactors = F)
score$total <- apply(score[,2:3], 1, sum, na.rm=T)
score

score <- cbind(score, total=apply(score[,c(2,3)], 1, sum, na.rm=T))
# create table score(name varchar2(10), sql number(10), python number(10)) tablespace users;
# insert into score values('king', 96, 75);
# insert into score values('smith', null, 91);
# insert into score values('jane', 78, 86);
# insert into score values('scott', 90, null);

# alter table score add total number(20);

# declare 
#   type sum_type is record(lname varchar2(20), sums number);
#   type tab_type is table of sum_type;
#   ssum tab_type;
# begin
#   select name, nvl(sql,0) + nvl(python,0) bulk collect into ssum from score;
#   forall i in 1..ssum.last
#     update score set total = ssum(i).sums where name = ssum(i).lname;
# end;
# /

#[문제88] 입사한 년도별 평균월급을 세로(aggregate), 가로(tapply)로 출력하세요.
getwd()
setwd('c:/data')
emp <- read.csv('emp_new.csv', stringsAsFactors = F)
#세로
class(emp$HIRE_DATE)
x <- aggregate(SALARY~format(as.Date(as.character(HIRE_DATE), format='%Y%m%d'), '%Y'), emp, mean)
colnames(x) <- c('hiredate','avgsal')
x

aggregate(list(AvgSal = emp$SALARY), list(HireYear = substr(emp$HIRE_DATE, 1, 4)), mean)
# select substr(hire_date,1,4) as HireYear, round(avg(salary)) as AvgSal from emp group by substr(hire_date,1,4) order by 1;

#가로
tapply(emp$SALARY, substr(emp$HIRE_DATE, 1, 4), mean)

# [문제89] 부서별 인원수를 세로(aggregate), 가로(tapply)로 출력하세요.
#세로
x <- aggregate(EMPLOYEE_ID~DEPARTMENT_ID, emp, NROW)
colnames(x) <- c('DEPARTMENT_ID', 'NET_PEOPLE')
x

aggregate(list(EmpId=emp$EMPLOYEE_ID), list(DepId=emp$DEPARTMENT_ID), NROW)
# select department_id, count(*) from emp group by department_id order by 1;

#가로
tapply(emp$EMPLOYEE_ID, emp$DEPARTMENT_ID, NROW)

# [문제90]job_id, hire_date(년도4자리) 총액 급여를 aggregate함수를 이용해서 생성하세요.
aggregate(list(SumSal=emp$SALARY), list(JobId=emp$JOB_ID, HireYear=substr(emp$HIRE_DATE, 1, 4)), sum)
# select job_id, substr(hire_date, 1, 4) as hireyear, sum(salary) from emp group by job_id,substr(hire_date, 1, 4) order by 2, 1;

# [문제91] job_id, hire_date(년도4자리) 총액 급여를 tapply함수를 이용해서 생성하세요.
# 단 NA 대신에 0 으로 출력하세요.
tapply(emp$SALARY, data.frame(JobId=emp$JOB_ID, HireYear=substr(emp$HIRE_DATE, 1, 4)), sum, default=0)

# [문제 92] 변수에 2를 입력한 후 그 변수의 값이 2의 배수면 '2의 배수'를 출력, 아니면 '2의 배수가 아니다' 출력해주세요
x <- 2
yes <- '2의 배수'
no <- '2의 배수가 아닙니다'
if(x%%2==0){yes}else{no}
ifelse(x%%2==0,yes, no)
# declare
# x number := 2;
# begin
# if mod(x,2)=0 then
# dbms_output.put_line('2의 배수');
# else
#   dbms_output.put_line('2의 배수가 아닙니다');
# end if;
# end;
# /


# [문제93] emp 변수에 있는 데이터를 가지고 새로운 df변수를 생성하세요.
# last_name, salary, 급여가 10000  이상이면 A, 5000이상 10000보다 작으면 B 나머지는 C가 입력되어 있는 새로운 컬럼을 생성하세요.  
# 컬럼이름은 name, sal, level 로 설정하세요.
df <- data.frame(name=emp$LAST_NAME, sal=emp$SALARY, level=ifelse(emp$SALARY>=10000, 'A', ifelse(emp$SALARY>=5000, 'B', 'C')))
df
# declare
#   type rec_type is record(name emp.last_name%type, sal emp.salary%type, level varchar2(10));
#   type tab_type is table of rec_type;
#   df tab_type;
# begin
#   select last_name, salary, null bulk collect into df from emp;
#   for i in df.first..df.last loop
#     if df(i).sal >= 10000 then
#       df(i).level := 'A';
#     elsif df(i).sal between 5000 and 9999 then
#       df(i).level := 'B';
#     else
#       df(i).level := 'C';
#     end if;
#     dbms_output.put_line(df(i).name||' '||df(i).sal||' '||df(i).level);
#   end loop;
# end;
# /


# [문제94] x 변수에 1부터 100까지 입력한 후 짝수값은 자신의 값에 10을 곱한 값으로 수정하세요.
x <- 1:100
x <- ifelse(x%%2==0,x*10,x)
x

x[x%%2==0] <- x[x%%2==0] * 10
# declare
#   type tab_type is table of number index by pls_integer;
#   x tab_type;
# begin
#   for i in 1..100 loop
#     x(i) := i;
#   end loop;
#   for i in 1..x.last loop
#     if mod(x(i), 2)=0 then
#       x(i) := i*10;
#     end if;
#     dbms_output.put_line(x(i));
#   end loop;
# end;
# /

# [문제95]  x <- c(2,10,6,4,3,NA,7,9,1)  x변수에 NA가 있는지를 검사하세요.
x <- c(2,10,6,4,3,NA,7,9,1)
is.na(x)

# [문제96] x 변수에 NA가 있는 인덱스 번호를 찾아 주세요.
which(is.na(x))
# declare
#   type tab_type is table of number;
#   x tab_type := tab_type(2, 10, 6, 4, 3, null, 7, 8, 1);
# begin
#   for i in x.first..x.last loop
#     if x(i) is null then
#       dbms_output.put_line(i);
#     end if;
#   end loop;
# end;
# /

# [문제97] x 변수에 NA가 있으면 0으로 설정하세요
x <- ifelse(is.na(x), 0,x)
# declare
#   type tab_type is table of number;
#   x tab_type := tab_type(2, 10, 6, 4, 3, null, 7, 8, 1);
# begin
#   for i in x.first..x.last loop
#     if x(i) is null then
#       x(i) := 0;
#     end if;
#   end loop;
# end;
# /

x[which(is.na(x))] <- 0

# [문제98] last_name, salary, commission_pct, 
# commission_pct NA 면 salary * 12,
# 아니면 (salary * 12) + (salary * 12 * commission_pct)을 수행하세요.
# > head(df)
# name   sal comm ann_sal
# 1  OConnell  2600   NA   31200
# 2     Grant  2600   NA   31200
# 3    Whalen  4400   NA   52800
# 4 Hartstein 13000   NA  156000
# 5       Fay  6000   NA   72000
# 6    Mavris  6500   NA   78000
df <- data.frame(name=emp$LAST_NAME, sal=emp$SALARY, comm=emp$COMMISSION_PCT, ann_sal=ifelse(is.na(emp$COMMISSION_PCT), emp$SALARY*12, (emp$SALARY*12)+(emp$SALARY*12*emp$COMMISSION_PCT)))
df
# declare
#   type rec_type is record(name emp.last_name%type, sal emp.salary%type, comm emp.commission_pct%type, ann_sal number);
#   type tab_type is table of rec_type;
#   df tab_type;
# begin
#   select last_name, salary, commission_pct, null bulk collect into df from emp;
#   for i in df.first..df.last loop
#     if df(i).comm is not null then
#       df(i).ann_sal := (df(i).sal * 12) * (1+df(i).comm);
#     else
#       df(i).ann_sal := df(i).sal * 12;
#     end if;
#     dbms_output.put_line(df(i).name||' '||df(i).sal||' '||df(i).comm||' '||df(i).ann_sal);
#   end loop;
# end;
# /

# [문제99] x변수에 1부터 100까지 입력한 후
# 1은 합을, 2는 평균, 3은 분산, 4는 표준편차를
# 구하는 switch문을 생성하세요.
x <- 1:100
y <- 4
switch(y, sum(x), mean(x), var(x), sd(x))
# create or replace procedure calc(p_num in number)
# is
#   rst number;
# begin
#   if p_num = 1 then
#     select sum(n) into rst from (select level n from dual connect by level <= 100);
#     dbms_output.put_line(rst);
#   elsif p_num = 2 then
#     select avg(n) into rst from (select level n from dual connect by level <= 100);
#     dbms_output.put_line(rst);
#   elsif p_num = 3 then
#     select variance(n) into rst from (select level n from dual connect by level <= 100);
#     dbms_output.put_line(rst);
#   elsif p_num = 4 then
#     select stddev(n) into rst from (select level n from dual connect by level <= 100);
#     dbms_output.put_line(rst);
#   end if;
# end;
# /

# [문제 100] 1부터 10까지 합을 for문을 이용해서 구하세요
x <- 0
for(i in 1:10){x <- x+i}
# declare
#   rst number := 0;
# begin
#   for i in 1..100 loop
#     rst := rst+i;
#   end loop;
#   dbms_output.put_line(rst);
# end;
# /

# [문제 101] 1부터 100까지 전체합, 짝수합, 홀수합을 출력하세요
t_sum <- 0
o_sum <- 0
e_sum <- 0
#if
for(i in 1:100){
  if(i%%2 == 0){e_sum <- e_sum + i
  }else{o_sum <- o_sum + i
  }
  t_sum <- t_sum + i
}
#switch
for(i in 1:100){
  x <- (i%%2)+1 
  switch(x, e_sum <- e_sum+i, o_sum <- o_sum+i)
  t_sum <- t_sum + i
}
o_sum
e_sum
t_sum
# declare
#   rst number := 0;
#   o_sum number := 0;
#   e_sum number := 0;
# begin
#   for i in 1..100 loop
#     rst := rst + i;
#     if mod(i, 2) = 0 then
#       e_sum := e_sum + i;
#     else
#       o_sum := o_sum + i;
#     end if;
#   end loop;
#   dbms_output.put_line('전체합:'||rst||' 짝수합: '||e_sum||' 홀수합: '||o_sum);
# end;
# /

# [문제 102] 1부터 100까지 짝수합, 홀수합을 tapply를 이용해서 구하세요
x <- 1:100
a <- tapply(x, x%%2==0, sum)
names(a) <- c('Odd Sum', 'Even Sum')
a

# [문제103] 1부터100까지 홀수만 x 변수에 입력해주세요.(for문을 이용하세요)
#list사용
x <- list()
#append(list, element)를 하면 순서대로 저장
for(i in 1:100){
  if(i%%2==1){x <- append(x, i)}
}
#append(element, list)를 하면 stack처럼 역순으로 저장
for(i in 1:100){
  if(i%%2==1){x <- append(i, x)}
}
x
#벡터 사용
z <- NULL
for(i in 1:100){
  if(i%%2==1){z <- c(z, i)}
}

#cbind
for(i in 1:100){
  if(i%%2==1){z <- cbind(z, i)}
}

#rbind
for(i in 1:100){
  if(i%%2==1){z <- rbind(z, i)}
}
z
# create table test_table(x number);
# begin
#   for i in 1..100 loop
#     if mod(i,2)=1 then
#       insert into test_table(x) values(i);
#     end if;
#   end loop;
# end;
# /


# [문제104] while문을 이용해서 2단을 출력하세요.
# [1] "2 x 1 = 2"
# [1] "2 x 2 = 4"
# [1] "2 x 3 = 6"
# [1] "2 x 4 = 8"
# [1] "2 x 5 = 10"
# [1] "2 x 6 = 12"
# [1] "2 x 7 = 14"
# [1] "2 x 8 = 16"
# [1] "2 x 9 = 18"
i <- 1
while(i <= 9){
  print(paste0('2 x ',i,' = ',2*i))
  i <- i + 1
}
# declare
#   i number := 1;
# begin
#   while i < 10 loop
#     dbms_output.put_line('2 x '||i||' = '||i*2);
#     i := i + 1;
#   end loop;
# end;
# /

# [문제105] repeat문을 이용해서 2단을 출력하세요.
# [1] "2 x 1 = 2"
# [1] "2 x 2 = 4"
# [1] "2 x 3 = 6"
# [1] "2 x 4 = 8"
# [1] "2 x 5 = 10"
# [1] "2 x 6 = 12"
# [1] "2 x 7 = 14"
# [1] "2 x 8 = 16"
# [1] "2 x 9 = 18"
i <- 1
repeat{
  if(i == 10){break
  }else{
      print(paste0('2 x ',i,' = ',2*i))
      i <- i +1}
}
# declare
#   i number := 1;
# begin
#   loop
#     dbms_output.put_line('2 x '||i||' = '||i*2);
#     i := i + 1;
#     exit when i = 10;
#   end loop;
# end;
# /

#------------------------------------------------------------------------------------------------------

# 현재 선언되어 있는 변수 확인
ls()
ls(x)

# 현재 선언되어 있는 변수 모두 삭제
rm(list=ls())

# 제어문
# 조건의 흐름을 제어
# 1. if문 : 조건에 따라 서로 다른 코드를 수행하도록 하는 문장
# if(조건){조건이 참일 때 수행하는 문장} 
# else {조건이 거짓일 때 수행하는 문장}

if(1>2){print('1이 2보다 크다')}
if(2>1){print('2가 1보다 크다')}else{print('2이 1보다 작다')}

if(1>2){
  print('1이 2보다 크다')
  }else{print('1은 2보다 작다')}
 
# 2. ifelse 함수
# ifelse(조건, 참, 거짓)

x <- 2
if(x==1) {'남은 기간 최선을 다하자'
  }else{if(x==2){'로또당첨'
    }else{if(x==3){'그냥 사는거지'}}}

# 3. switch
# switch(변수, 실행문1, 실행문2,...) 변수값에 따라 조건에 맞는 실행문을 수행한다
x <- 3
switch(x, '남은 기간 최선을 다하자', '행복하자', '건강하게 살자')

x <- '강'
switch(x, '산'='한라산', '바다'='제주도', paste0(x, ' 그냥 방콕하세요'))

# # 반복문
# 1. for 문
# for(변수 in 데이터변수){반복수행할 문장}
for(i in 1:10){print(i)}

# 2. while문
# while(조건){반복수행할 문장}
i <- 1
while(i <= 10){
  print(i)
  i <- i + 1
}

# 3. repeat
# repeat{
#   반복수행할 문장
#   break
#   }
i <- 1
repeat{
  print(i)
  if (i==10){break}
  i <- i+1
}
