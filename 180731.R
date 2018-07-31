# [문제106] x변수에 1부터 10까지 입력한 후 홀수인지 짝수인지를 출력하세요.
# 1  2  3  4  5  6  7  8  9 10
# "홀수" "짝수" "홀수" "짝수" "홀수" "짝수" "홀수" "짝수" "홀수" "짝수"
x <- 1:10
#ifelse
ifelse(x%%2==0,'짝수','홀수')

#if
for(i in x){if(i%%2==0){print('짝수')}else{print('홀수')}}

#switch
for(i in x){switch(i%%2+1,print('짝수'), print('홀수'))}

#sql
# declare
#   type tab_type is table of number index by pls_integer;
#   x tab_type;
# begin
#   for i in 1..10 loop
#     x(i) := i;
#   end loop;
#   for i in x.first..x.last loop
#     if mod(x(i),2)=0 then
#     dbms_output.put_line('짝수');
#   else
#     dbms_output.put_line('홀수');
#   end if;
#   end loop;
# end;
# /

# [문제107] mysentence 이름의 벡터 변수에 'Well begun is half done' 이 값을 입력한 후 공백문자를 기준으로 분리해서 word 변수에 입력하세요. 
# word 변수에 타입을 체크한 후 word 변수에 입력된 값의 수를 출력하세요.
mysentence <- 'Well begun is half done'
word <- strsplit(mysentence,' ')
class(word)
mode(word)       
str(word)

class(word[1])
mode(word[1])       
str(word[1])

class(word[[1]])
mode(word[[1]])       
str(word[[1]])

#length
length(word[[1]])

#NROW
NROW(word[[1]])

#sapply
sapply(word, length)

# [문제108] 문제107에서 만든 word변수에 있는 값을  리스트 변수 letters에 하나씩 저장하세요.
letters <- list()
for(i in word[[1]]){letters <- append(letters, i)}
letters

letters <- list(rep(NA, 5))
for(i in 1:length(word[[1]])){letters[i] <- word[[1]][i]}
letters

# [문제109] 문제108에서 생성한 letters 변수에 있는 값을 myword변수에 하나의 문장으로 넣어 주세요.
# > myword
# [1] "Well begun is half done"
myword <- NULL
#for
for(i in letters){myword <- paste0(myword, i,' ')}

#뒷공백 제거
for(i in 1:length(letters)){if(i < length(letters)){myword <- paste0(myword,letters[i],' ')}else{myword <- paste0(myword,letters[i])}}

#while
i <- 0
while(i<=length(letters)){
  i <- i + 1
  if(i < length(letters)){paste0(myword,letters[i],' ')}else{paste0(myword,letters[i])}
  }

#for / paste & collapse
for(i in letters){myword <- paste(c(myword, i), collapse = ' ')}
myword
# [문제 110] hap함수에 인자값을 입력하게 되면 1부터 입력한 숫자까지누적합을 구하세요
hap <- function(x){
  res <- 0
  for(i in 1:x){res <- res + i}
  return(res)
}

# [문제 111] 인수값에 따라 합을 구하세요.
hap <- function(...){
  x <- list(...)
  res <- 0
  for(i in x){res <- res + i}
  return(res)
}
hap(1,2)
hap(1,2,3)
hap(10,20,30,40)
hap(1,3,5,1:100)

# [문제112] x변수에 1:5 까지 입력되어 있다 아래 화면 처럼 출력하세요.
x <- 1:5
result <- list()
#if
for(i in x){
  if(i%%2==0){result[i] <- '짝수'}else{result[i] <- '홀수'}
}

#ifelse
as.list(ifelse(x%%2==0, '짝수', '홀수'))


#lapply
checker <- function(x){
  if(x%%2==0){return('짝수')}else{return('홀수')}
}
result <- lapply(x, checker)

lapply(x, function(x){ifelse(x%%2==0, '짝수', '홀수')})

# [문제113] 사원 번호를 입력 값으로 받아서 사원의 LAST_NAME, SALARY를 출력하는 함수를 생성하세요.
# > find(100)
# LAST_NAME SALARY
# 10      King  24000
setwd('c:/data')
emp <- read.csv('emp_new.csv')
find <- function(id){emp[emp$EMPLOYEE_ID==id,c("LAST_NAME", "SALARY")]}
find(100)

# [문제114] 20번 부서에 소속되어 있는 사원들의 LAST_NAME, SALARY, JOB_ID, DEPARTMENT_NAME을 출력하세요
x <- merge(emp, dept, by='DEPARTMENT_ID')[, c('LAST_NAME', 'SALARY', 'JOB_ID', 'DEPARTMENT_ID')]
x[x$DEPARTMENT_ID==20,]

merge(emp, dept, by='DEPARTMENT_ID')[merge(emp, dept, by='DEPARTMENT_ID')$DEPARTMENT_ID == 20, c('LAST_NAME', 'SALARY', 'JOB_ID', 'DEPARTMENT_ID')]

merge(emp[emp$DEPARTMENT_ID==20,c("LAST_NAME","SALARY","JOB_ID","DEPARTMENT_ID")], dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], by='DEPARTMENT_ID')
# select e.last_name, e.salary, e.job_id, d.department_name from emp e, dept d where d.department_id = 20 and e.department_id = 20;

# [문제115] salary가 3000 이상이고 job_id는 ST_CLERK인 사원들의 employee_id, salary, job_id, department_id,department_name을 출력하세요.
x <- merge(emp, dept, by='DEPARTMENT_ID')[, c('EMPLOYEE_ID', 'SALARY', 'JOB_ID', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]
x[emp$SALARY>=3000&emp$JOB_ID=='ST_CLERK',]

merge(emp, dept, by='DEPARTMENT_ID')[merge(emp, dept, by='DEPARTMENT_ID')$SALARY>=3000 & merge(emp, dept, by='DEPARTMENT_ID')$JOB_ID=='ST_CLERK', c('EMPLOYEE_ID', 'SALARY', 'JOB_ID', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]

merge(emp[emp$SALARY>=3000 & emp$JOB_ID=='ST_CLERK',c('EMPLOYEE_ID', 'SALARY', 'JOB_ID', 'DEPARTMENT_ID')], dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], by='DEPARTMENT_ID')
# select e.employee_id, e.salary, e.job_id, e.department_id, d.department_name from emp e, dept d where e.department_id = d.department_id and e.salary >= 3000 and e.job_id = 'ST_CLERK';


# [문제116]  커미션이 NA 인 사원들의 last_name, commission_pct, department_id, department_name을 출력하세요.
x <- merge(emp,dept, by='DEPARTMENT_ID')[, c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]
x[is.na(x$COMMISSION_PCT),]

merge(emp,dept, by='DEPARTMENT_ID')[is.na(merge(emp,dept, by='DEPARTMENT_ID')$COMMISSION_PCT), c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]

merge(emp[is.na(emp$COMMISSION_PCT), c("LAST_NAME", "COMMISSION_PCT", "DEPARTMENT_ID")], dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], by='DEPARTMENT_ID')
# select e.last_name, e.commission_pct, e.department_id, d.department_name from emp e, dept d where e.department_id = d.department_id and e.commission_pct is null;

# [문제117]  커미션이 NA가 아닌 사원들의 last_name, commission_pct,department_id, department_name을 출력하세요.
x <- merge(emp,dept, by='DEPARTMENT_ID')[, c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]
x[!is.na(x$COMMISSION_PCT),]

merge(emp,dept, by='DEPARTMENT_ID')[!is.na(merge(emp,dept, by='DEPARTMENT_ID')$COMMISSION_PCT), c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]
merge(emp[!is.na(emp$COMMISSION_PCT), c("LAST_NAME", "COMMISSION_PCT", "DEPARTMENT_ID")], dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], by='DEPARTMENT_ID')
# select e.last_name, e.commission_pct, e.department_id, d.department_name from emp e, dept d where e.department_id = d.department_id and e.commission_pct is not null;

# [문제118]커미션이 NA가 아닌 사원들의 last_name, commission_pct, department_id, department_name을 출력하세요.
# 단 department_id가 NA인 사원도 출력해주세요.
x <- merge(emp,dept, by='DEPARTMENT_ID', all.x = T)[, c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]
x[!is.na(x$COMMISSION_PCT),]

merge(emp,dept, by='DEPARTMENT_ID', all.x = T)[!is.na(merge(emp,dept, by='DEPARTMENT_ID', all.x = T)$COMMISSION_PCT), c('LAST_NAME', 'COMMISSION_PCT', 'DEPARTMENT_ID', 'DEPARTMENT_NAME')]

merge(emp[!is.na(emp$COMMISSION_PCT), c("LAST_NAME", "COMMISSION_PCT", "DEPARTMENT_ID")], dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], by='DEPARTMENT_ID', all.x = T)
# select e.last_name, e.commission_pct, department_id, d.department_name from emp e left join dept d using(department_id) where e.commission_pct is not null;

# [문제119] 사원의 last_name, 관리자 last_name을 출력해주세요. 관리자가 없는 사원도 출력해주세요.
merge(data.frame(last_name=emp$LAST_NAME, mgr_id=emp$MANAGER_ID), data.frame(mgr_id = emp$EMPLOYEE_ID, mgr_name = emp$LAST_NAME), by='mgr_id', all.x = T)[, c('last_name', 'mgr_name')]
# select last_name, (select last_name from emp where employee_id = e.manager_id) as mgrname from emp e;

# [문제120] 부서이름별 총액 급여를 출력하세요.
#tapply
x <- merge(emp, dept, by='DEPARTMENT_ID')[,c('DEPARTMENT_NAME', 'SALARY')]
tapply(x$SALARY, x$DEPARTMENT_NAME, sum, default=0)
#aggregate
aggregate(SALARY~DEPARTMENT_NAME, merge(emp, dept, by='DEPARTMENT_ID')[,c('DEPARTMENT_NAME', 'SALARY')], sum)
# select d.department_name, sum(e.salary) from emp e, dept d where e.department_id = d.department_id group by d.department_name;

#----------------------------------------------------------------------------------

#함수(function)
# - 사용자가 정의하는 함수를 생성할 수 있다
# - 자주 반복되어 사용하는 기능을 정의하는 프로그램
# - 코드가 간단해짐
# 
# 함수이름 <- function(){
#   함수가 수행할 코드
#   return(반환값) #선택
# }

Sys.Date()
date1 <- function(){
  return(Sys.Date())
}
date1()

time <- function(){
  Sys.time()
}
time()

hap <- function(x, y){
  res <- x+y
  return(res)
}

hap(1,2)

# 가변인수
f <- function(...){
  x <- list(...)
  for(i in x){print(i)}
  
}

f(1,2)
f(1,2,3,4)
f('a','b','c','d')

# 중첩함수
f <- function(x,y){
  print(x)
  f2 <- function(y){
    y <- x*y
    print(y)}
  f2(y)
}
f(10,20)

# 전역변수(global variable)
# 함수에 상관없이 프로그램 전체에서 사용할 수 있는 변수

# 지역변수(local variable)
# 함수내에서 정의되고 사용하는 변수

# 매개변수(parameter variable)
# 함수의 인수로 사용하는 변수

x<-1;y<-2;z<-3;
f <- function(x){
  y <- x*10 #지역변수/ 글로벌 변수에 영향을 미치지 않음
  print(x);print(y);print(z)
}
f(x)


x<-1;z<-3;
f <- function(x){
  y <<- x*10 
  print(x);print(y);print(z)
}
f(x)
x;y;z

f <- function(x){
  y = x*10 #지역변수 / 글로벌 변수에 영향을 미치지 않음
  print(x);print(y);print(z)
}

f(x)
x;y;z
rm(x1)
sum(x1 <- c(1,2,3,4,5)) #x1 생성됨
x1

sum(y1 <<- c(1,2,3,4,5))
y1

sum(z1 = c(1,2,3,4,5)) #z1이 생성되지 않음
z1

# merge(join)
# 두 데이터 프레임의 공통된 값을 기준으로 병합한다
x1 <- data.frame(id=c(100,200,300),sql=c(70,90,80))
y1 <- data.frame(id=c(100,200,500), python=c(80,70,60))
rbind(x1,y1) #병합 실행안됨
cbind(x1,y1) #원하는대로 병합안됨

merge(x1,y1)
merge(x1,y1,all=T) #full outer join
merge(x1,y1,all.x=T) #left outer join
merge(x1,y1,all.y=T) #right outer join

x1 <- data.frame(id=c(100,200,300),sql=c(70,90,80))
x2 <- data.frame(id=c(100,200,300),sql=c(80,70,60))
x3 <- data.frame(no=c(100,200,500),python=c(80,60,70))
x4 <- merge(x1,x3,by.x='id',by.y='no', all=T) #이름이 다른 컬럼을 기준으로 합치기
merge(x4, x2, by.x='id', by.y='id')
emp <- read.csv('emp_new.csv')
dept <- read.csv('dept.csv')
dept

merge(emp,dept,by='DEPARTMENT_ID') #sql의 join using과 동일

#필요한 열만 출력하는 방법
# select last_name, department_name from emp join dept using(department_id);
merge(emp,dept,by='DEPARTMENT_ID')[,c('LAST_NAME', 'DEPARTMENT_NAME')]
