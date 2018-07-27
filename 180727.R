# [문제67] last_name, hire_date를  출력하는데 먼저 입사한 사원부터 출력하세요.
getwd()
setwd('c:/data')
emp <- read.csv('emp_new.csv', stringsAsFactors = F, header = T)
library(doBy)
orderBy(~HIRE_DATE, emp[, c("LAST_NAME", "HIRE_DATE")])

# [문제68] df이름의 data frame 변수를 선언합니다.
# id 컬럼의 값은 100,101,102,103,104,  
# weight 컬럼의 값은 60,90,75,95,65, 
# size 컬럼의 값은 small, large, medium,large,small 값으로 생성하세요.
df <- data.frame(id = c(100:104), weight = c(60, 90, 75, 95, 65), size = c('small', 'large', 'medium', 'large', 'small'))

# [문제69] df변수에 weight 컬럼을 기준으로 오름차순 정렬해서 df 변수에 값을 출력하세요.(order 함수를 이용하세요)
df[order(df$weight),]
# select weight from df order by weight;

# [문제70] df변수에 size, weight 컬럼을 기준으로 오름차순 정렬하세요.(order 함수를 이용하세요)
df[order(df$weight, df$size), ] #선행컬럼을 먼저 정렬 후 후행 컬럼 정렬
# select size, weight from df order by size, weight;

# [문제71] df 변수에 있는 weight 컬럼을 기준으로 내림차순 정렬하세요.(order 함수를 이용하세요)
df[order(df$weight, decreasing = T), ]
df[order(-df$weight), ]
# select weight from df order by weight desc;

# [문제72] 30번 부서 사원들의 last_name, salary를  출력하세요.
# 단 salary를 기준으로 내림차순정렬하세요.
na.omit(orderBy(~-SALARY, emp[emp$DEPARTMENT_ID==30, c("LAST_NAME", "SALARY")]))
# select last_name, salary from emp where department_id = 30 order by salary desc;

# [문제73] job_id가  ST_CLERK 가 아닌 사원들의 last_name, salary, job_id를 출력하는데 급여가 높은 사원부터 출력되게하세요.(orderBy 함수를 이용하세요)
orderBy(~-SALARY, emp[emp$JOB_ID!='ST_CLERK', c("LAST_NAME", "SALARY", "JOB_ID")])
# select last_name, salary, job_id from emp where job_id != 'ST_CLERK' order by salary desc;

# [문제74] 사원 last_name, salary, commission_pct를 출력하는데 commission_pct를 기준으로 오름차순정렬하세요.(orderBy를 이용하세요)
orderBy(~COMMISSION_PCT, emp[, c("LAST_NAME", "SALARY", "COMMISSION_PCT")])
# select last_name, salary, commission_pct from emp order by commission_pct;

# [문제75] commission_pct를 받고 있는 사원들의 last_name, salary, commission_pct를 출력하는데 commission_pct를 기준으로 오름차순정렬하세요.(orderBy를 이용하세요)
na.omit(orderBy(~COMMISSION_PCT, emp[, c("LAST_NAME", "SALARY", "COMMISSION_PCT")]))
orderBy(~COMMISSION_PCT, emp[!is.na(emp$COMMISSION_PCT), c("LAST_NAME", "SALARY", "COMMISSION_PCT")])
# select last_name, salary, commission_pct from emp where commission_pct is not null order by commission_pct;

# [문제76] 6의 9승을 출력하세요 
6^9
# select power(6, 9) from dual;

# [문제77] 10을 3으로 나눈 나머지값을 출력하세요 
10%%3
# select mod(10, 3) from dual;

# [문제78] last_name, salary에 12를  곱해서 출력하고 컬럼명이 한글로 연봉으로  데이터 프레임으로 출력하세요 
x <- data.frame(last_name = emp$LAST_NAME, '연봉' = emp$SALARY*12, stringsAsFactors = F)
# select last_name, salary * 12 as 연봉 from emp;

# [문제79] last_name과 연봉을 출력하는데 연봉이 높은것부터 출력하세요 
orderBy(~-연봉, x[, c("last_name", "연봉")])
# select last_name, 연봉 from x order by 연봉 desc;
orderBy(~-연봉, data.frame(emp$LAST_NAME, 연봉=emp$SALARY*12))

# [문제80] 문제79를 round 함수를 이용해서 아래와 같이 백단위에서 반올림되게 하세요. 
# 4:  JONES 35700  ----->  36000
x$연봉 <- round(x$연봉, -3)
orderBy(~-연봉, data.frame(emp$LAST_NAME, 연봉=round(emp$SALARY*12, -3)))
# select last_name, round(연봉, -3) from x;

# [문제81] 최대월급을 출력하세요
max(emp$SALARY)
# select max(salary) from emp;
 
# [문제82] 직업이 ST_CLERK 인 사원들중에 최대월급을 출력하세요
max(emp[emp$JOB_ID=='ST_CLERK', "SALARY"])
# select max(salary) from emp where job_id = 'ST_CLERK';

# [문제83] 부서번호별로 급여에 총액을 출력하세요.
aggregate(SALARY~DEPARTMENT_ID,emp,sum)
# select department_id, sum(salary) from emp group by department_id;

# [문제84] 부서번호, 직업별로 급여에 총액을 출력하세요.
aggregate(SALARY~DEPARTMENT_ID+JOB_ID,emp,sum)
# select department_id, job_id, sum(salary) from emp group by department_id, job_id;

# [문제85] 부서번호별 최대월급을 출력하는데 최대월급이 높은것부터 출력하세요.
orderBy(~-SALARY, aggregate(SALARY~DEPARTMENT_ID,emp,max))
# select department_id, max(salary) as maxsal from emp group by department_id order by maxsal desc;

# [문제86] 직업별 인원수를 출력하세요.
aggregate(EMPLOYEE_ID~JOB_ID,emp,NROW)
# select job_id, count(*) from emp group by job_id;

#-----------------------------------------------------------

# 그룹함수
x <- c(100,90,80,70)
sum(x) #합
mean(x) #평균
var(x) #분산
sd(x) #표준편
max(x) #최대값
min(x) #최소값
length(x) #갯수
NROW(x) #갯수

x <- c(100,90,80,70,NA)
sum(x,na.rm = T)
sum(x,na.rm = F)
mean(x, na.rm=T)
var(x, na.rm=T)
sd(x, na.rm=T)
max(x, na.rm=T)
min(x, na.rm=T)
length(x) #NA를 포함한 갯수
length(na.omit(x)) #NA를 제외한 갯수
NROW(x) #NA를 포함한 갯수

# select sum(salary), avg(salary) from emp;
# select dept_id, sum(salary) from emp group by dept_id;

#aggregate 함수
# 데이터를 분할하고 각 그룹으로 묶은 후 그룹함수를 적용한다
# aggregate(계산될 컬럼~분할해야 할 기준컬럼, 데이터, 함수)
aggregate(SALARY~JOB_ID, emp, sum)
# select job_id, sum(salary) from emp group by job_id;

#apply
# - 행렬, 배열, 데이터프레임에 함수를 적용한 결과를 벡터, 리스트, 배열 형태로 리턴한다.
- 행렬에서 행이나 열의 방향으로 함수를 적용
apply(x, MARGIN, FUN)
# x: 행렬, 배열, 데이터프레임
# MARGIN: 함수를 적용할 때 방향을 지정 / 1: 행방향, 2: 열방향, c(1,2): 행,열
# FUN: 적용할 함수 / sum, mean, var, sd, max, min
m <- matrix(1:4, ncol=2)
m
dim(m)
apply(m,1, sum)
apply(m,2,sum)

df <- data.frame(name=c('king','smith','jane'), sql=c(90,NA,70), python=c(75,90,NA))
df
apply(df[,2:3],1,sum)
apply(df[,2:3],1,sum, na.rm=T)

apply(df[,2:3],2,sum)
apply(df[,2:3],2,sum, na.rm=T)

# rowSums(): 배열, 행렬, 데이터프레임의 행의 합
# rowMeans(): 배열, 행렬, 데이터프레임의 행의 평균
rowSums(df[,2:3],na.rm=T)
rowMeans(df[,2:3], na.rm=T)

# colSums(): 배열, 행렬, 데이터프레임의 열의 합
# colMeans(): 배열, 행렬, 데이터프레임의 열의 평균
colSums(df[,2:3],na.rm=T)
colMeans(df[,2:3], na.rm=T)

# lapply 
# - 벡터, 리스트, 데이터프레임에 함수를 적용하고 그 결과를 리스트로 리턴하는 함수
# - 리스트: 서로 다른 데이터 타입의 값을 저장하는 자료형
x <- lapply(df[,2:3], mean, na.rm=T)
x
str(x)
mean(x$sql)
mean(x$python)
lapply(x, mean)

lapply(df[,2:3], mean, na.rm=T)
apply(df[,2:3],2,mean,na.rm=T)
colMeans(df[,2:3],na.rm=T)

#list -> data.frame
unlist(lapply(df[,2:3], mean, na.rm=T)) #리스트 -> 벡터
matrix(unlist(lapply(df[,2:3], mean, na.rm=T)), ncol=2, byrow=T) #벡터 -> 매트릭스
x <- as.data.frame(matrix(unlist(lapply(df[,2:3], mean, na.rm=T)), ncol=2, byrow=T)) #매트릭스 -> 데이터프레임

str(x)
class(x)
mode(x)
names(x) <- c('sql', 'python')
x

# sapply
# - 벡터, 리스트, 데이터프레임에 함수를 적용하고 그 결과를 벡터로 리턴하는 함
x <- sapply(df[,2:3],mean,na.rm=T)
str(x)
class(x)
mode(x)
x
x <- as.data.frame(matrix(sapply(df[,2:3], mean, na.rm=T), ncol=2, byrow=T))
colnames(x) <- c('sql', 'python')
rownames(x) <- 'score'
x

# tapply
# - 벡터, 데이터프레임에 저장된 데이터를 주어진 기준에 따라 그룹으로 묶은 뒤 그룹함수를 적용하고 그 결과를 array형식으로 리턴하는 함수
tapply(emp$SALARY, emp$DEPARTMENT_ID, sum)
aggregate(SALARY~DEPARTMENT_ID, emp, sum)

tapply(emp$SALARY, data.frame(emp$DEPARTMENT_ID, emp$JOB_ID), sum, default=0) #행: department_id 열: job_id 값: salary 
aggregate(SALARY~DEPARTMENT_ID+JOB_ID, emp, sum)
