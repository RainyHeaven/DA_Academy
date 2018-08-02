# [문제134] 자신의 관리자 보다 더 많은 급여를 받는 사원이름, 사원급여, 관리자이름, 관리자급여를 출력하세요.
rm(list=ls())
setwd('c:/data')
emp <- read.csv('emp_new.csv', stringsAsFactors = F)
#sqldf
library(sqldf)
sqldf('select e.last_name, e.salary, m.last_name as mgrname, m.salary as mgrsal from emp e, (select employee_id, last_name, salary from emp) m  where m.employee_id = e.manager_id and e.salary > m.salary')

# [문제135] 자신의 부서 평균 급여보다 많이 받는 사원들의 정보를 출력하세요.
#sqldf
sqldf('select e.* from emp e, (select department_id, round(avg(salary)) as avgsal from emp group by department_id) d where e.department_id = d.department_id and e.salary > d.avgsal')
sqldf('select e.* from emp e where e.salary > (select round(avg(salary)) as avgsal from emp where department_id = e.department_id)')

# [문제136] fruits_sales.csv file 읽어 들인 후 과일 이름별 판매량, 판매합계를 구하세요.(tapply를 이용하세요)
# qty price
# apple   44 66000
# banana  31 70000
# berry   52 95100
# orange  21 83000
fs <- read.csv('fruits_sales.csv')
fs
#개별결과 생성
x <- tapply(fs$qty, fs$name, sum)
y <- tapply(fs$price, fs$name, sum)
#결과셋 만들기
#rbind
z <- rbind(x, y)
t(z)
#cbind
z <- cbind(qty=x,price=y)
z
#data.frame
z <- rbind(x, y)
data.frame(qty=z[1,], price=z[2,], row.names = colnames(z))

# [문제137] fruits_sales.csv file 읽어 들인 후 과일 이름별 판매량, 판매합계를 구하세요.(aggregate를 이용하세요)
# qty price
# apple   44 66000
# banana  31 70000
# berry   52 95100
# orange  21 83000
#개별결과생성
x <- aggregate(qty~name, fs, sum)
y <- aggregate(price~name, fs, sum)
#cbind
x <- cbind(x,y[2])
colnames(x)[1] <- ''

#merge
x <- merge(x,y)
colnames(x)[1] <- ''
x

# [문제138] fruits_sales.csv file 읽어 들인 후 과일 이름별 판매량, 판매합계를 구하세요.(sqldf를 이용하세요)
# qty price
# apple   44 66000
# banana  31 70000
# berry   52 95100
# orange  21 83000
sqldf('select name as " ", sum(qty) as qty, sum(price) as price from fs group by name')

# [문제139] fruits_sales.csv file 읽어 들인 후 년도별로 판매량 중에 가장 많은 판매를 한 년도를 출력해주세요.(tapply를 이용하세요)
x <- tapply(fs$qty, fs$year,sum)
names(x[x==max(x)])
rownames(x)[x==max(x)]

# [문제140] fruits_sales.csv file 읽어 들인 후 년도별로 판매량 중에 가장 많은 판매를 한 년도를 출력해주세요.(aggregate를 이용하세요)
x <- aggregate(qty~year, fs, sum)
x[x[2]==max(x[2]),'year']

# [문제141] fruits_sales.csv file 읽어 들인 후 년도별로 판매량 중에 가장 많은 판매를 한 년도를 출력해주세요.(sqldf를 이용하세요)
sqldf('with fr as (select year, sum(qty) as qsum from fs group by year) select year as bestYear from fr where qsum = ((select max(qsum) as sumax from fr))')

# [문제142] fruits_sales.csv file 읽어 들인 후 과일 이름별 판매량, 판매합계를 구하세요.
# ddply함수를 이용하세요.
ddply(fs, 'name', summarise, netQty=sum(qty), netSales=sum(qty))

# [문제143] emp 데이터 프레임을 새로운 df 이름으로 복제하세요.
# df 데이터 프레임에  새로운 comm 컬럼을 생성하는데 COMMISSION_PCT 값을 기반으로 값을 입력하시고
# 결측값은 기존 COMMISSION_PCT의 평균 값으로 입력해주세요.(단 mutate함수를 이용하세요)
df <- emp
df <- mutate(df, comm=ifelse(is.na(COMMISSION_PCT), round(mean(COMMISSION_PCT, na.rm=T),2), COMMISSION_PCT))
head(df)

#--------------------------------------------------------------------------------------

aggregate(SALARY~DEPARTMENT_ID, emp, mean)
aggregate(SALARY~DEPARTMENT_ID+JOB_ID, emp, mean)

#ddply
# 데이터프레임을 분할하고 함수를 적용한 뒤 데이터프레임으로 결과를 반환하는 함수
install.packages('plyr')
library(plyr)
## ddply(데이터, 기준컬럼, 함수)
ddply(emp, 'DEPARTMENT_ID', summarise, avg_sal=mean(SALARY))
###summarise: 인자에 함수를 적용한 결과를 새로운 데이터프레임으로 반환함
ddply(emp, c('DEPARTMENT_ID', 'JOB_ID'), summarise, member=NROW(EMPLOYEE_ID), avg_sal=mean(SALARY), sum_sal=sum(SALARY))

ddply(fs, 'name', summarise, maxQty=max(qty), minPrice=min(price))

###transform: 각 행별로 연산을 수행해서 행별 값을 출력
# 인자로 주어진 계산 결과를 새로운 컬럼에 추가한 데이터프레임을 반환
ddply(fs, 'name', transform, s_qty=sum(qty))

ddply(fs, 'year', transform, s_qty=sum(qty))

ddply(fs, 'name', transform, pct_qty=(100*qty/sum(qty)), s_qty=sum(qty))
ddply(fs, 'year', transform, pct_qty=(100*qty/sum(qty)), s_qty=sum(qty))

#dplyr
install.packages('dplyr')
library(dplyr)

## filter: 조건을 통해 필터링 하는 함수
filter(emp, DEPARTMENT_ID==20)
filter(emp, DEPARTMENT_ID==20)[,c('LAST_NAME','SALARY')]
filter(emp, DEPARTMENT_ID==20)[,2:5]
filter(emp, DEPARTMENT_ID==20 & SALARY >= 3000)[,1:5]

## select: 여러 컬럼이 있는 데이터프레임에서 특정 컬럼만 선택
select(emp, LAST_NAME, SALARY)
select(emp, 1,4,6)
select(emp, 1:5)
select(emp, -SALARY, -COMMISSION_PCT)
select(emp, -c(SALARY, COMMISSION_PCT))

# %>%: 여러문장을 조합해서 사용하는 방법
# 윗줄의 인자를 아래줄에서 사용할 수 있도록 
emp%>%
  select(LAST_NAME, JOB_ID, SALARY)%>%
  filter(SALARY>=10000)%>%
  arrange(SALARY) #오름차순 정렬

emp%>%
  select(LAST_NAME, JOB_ID, SALARY)%>%
  filter(SALARY>=10000)%>%
  arrange(desc(SALARY)) #내림차순 정렬

# mutate : 새로운 컬럼을 추가
emp$SAL <- emp$SALARY * 12
emp$SAL <- NULL

df <- mutate(emp, SAL=SALARY*12)
str(df)

emp%>%
  select(LAST_NAME, JOB_ID, SALARY, COMMISSION_PCT)%>%
  mutate(ANNUAL_SAL=SALARY*12+ifelse(is.na(COMMISSION_PCT), 0, SALARY*COMMISSION_PCT))%>%
  arrange(desc(ANNUAL_SAL))

###summarise: 인자에 함수를 적용한 결과를 새로운 데이터프레임으로 반환함
emp%>%
  summarise(sum_sal=sum(SALARY), mean_sal=mean(SALARY))

emp%>%
  summarise(max_sal=max(SALARY), min_sal=min(SALARY))

##group_by: 지정된 컬럼으로 그룹화
emp%>%
  group_by(DEPARTMENT_ID)%>%
  summarise(sum_sal=sum(SALARY))

emp%>%
  group_by(JOB_ID)%>%
  summarise(sum_sal=sum(SALARY))

##summarise_at: 개별 컬럼들의 집합에 동일한 함수 적용
emp%>%
  summarise_at(c('SALARY', 'COMMISSION_PCT'), sum, na.rm=T)

## summarise_if(조건, 함수): 조건에 맞는 컬럼에 모두 함수를 적용
emp%>%
  summarise_if(is.numeric, sum, na.rm=TRUE)