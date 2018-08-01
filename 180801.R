# [문제121] 부서이름별 소속사원들의 인원수를 출력하세요.
setwd('c:/data')
emp <- read.csv('emp_new.csv')
dept <- read.csv('dept.csv')
#aggregate
aggregate(EMPLOYEE_ID~DEPARTMENT_NAME, merge(emp,dept,by='DEPARTMENT_ID'),NROW)
#tapply
x <- merge(emp,dept,by='DEPARTMENT_ID')
tapply(x$EMPLOYEE_ID, x$DEPARTMENT_NAME, NROW)
#select d.department_name, count(e.employee_id) from employees e, departments d where e.department_id = d.department_id group by d.department_name;

# [문제122] 최고 급여를 받는 사원의 이름, 급여, 부서코드, 부서이름를 출력하세요.

x[merge(emp, dept, by='DEPARTMENT_ID')$SALARY==max(x$SALARY), c("LAST_NAME", "SALARY", "DEPARTMENT_ID", "DEPARTMENT_NAME")]
# select e.last_name, e.salary, e.department_id, d.department_name from employees e, departments d where e.department_id = d.department_id and e.salary = (select max(salary) from employees);

# [문제123] 부서이름,직업별 급여의 총액을 구하세요.
#aggregate
aggregate(SALARY~DEPARTMENT_NAME+JOB_ID, merge(emp,dept,by='DEPARTMENT_ID'),sum)
#tapply
x <- merge(emp,dept,by='DEPARTMENT_ID')
tapply(x$SALARY, data.frame(x$DEPARTMENT_NAME, x$JOB_ID), sum, default = 0)
# select d.department_name, e.job_id, sum(e.salary) from employees e, departments d where e.department_id = d.department_id group by d.department_name, e.job_id order by 1,2;

# [문제124] loc.csv 파일을 loc 변수로 로드하세요. Toronto 지역에 근무하는 사원들의 LAST_NAME,SALARY,DEPARTMENT_ID,DEPARTMENT_NAME,STREET_ADDRESS 정보를 출력하세요.
loc <- read.csv('loc.csv')
x <- merge(emp[,c("DEPARTMENT_ID","LAST_NAME", "SALARY")], dept[, c("DEPARTMENT_ID","DEPARTMENT_NAME","LOCATION_ID")], by='DEPARTMENT_ID')
y <- merge(x, loc[,c("LOCATION_ID", "STREET_ADDRESS", "CITY")], by='LOCATION_ID')
y[y$CITY=='Toronto', c("LAST_NAME", "SALARY", "DEPARTMENT_ID", "DEPARTMENT_NAME", "STREET_ADDRESS")]
# select e.last_name, e.salary, e.department_id, d.department_name, l.street_address from employees e, departments d, locations l where e.department_id = d.department_id and d.location_id = l.location_id and l.city = 'Toronto';
#효율적인 merge의 순서를 고려한 방법
x <- merge(dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME","LOCATION_ID")], loc[loc$CITY=='Toronto',c("LOCATION_ID","STREET_ADDRESS","CITY")],by='LOCATION_ID')
y <- merge(x[,c("DEPARTMENT_ID","DEPARTMENT_NAME","STREET_ADDRESS")], emp[,c("LAST_NAME", "SALARY","DEPARTMENT_ID")], by='DEPARTMENT_ID')

# [문제125] 아래 화면의 결과처럼 출력해주세요.
# 부서이름 부서별급여
# Administration       4400
# Marketing      19000
# Purchasing      24900
# Human Resources       6500
# Shipping     156400
# IT      28800
# Public Relations      10000
# Sales     304500
# Executive      63040
# Finance      51608
# Accounting      20308
# 소속부서X       7000
# 사원총급여     696456
#dataframe의 값을 수정하여 NA값 처리
dept <- read.csv('dept.csv', stringsAsFactors = F)
x <- merge(dept[,c("DEPARTMENT_ID","DEPARTMENT_NAME")], emp[,c("DEPARTMENT_ID","SALARY")], by='DEPARTMENT_ID', all.y = T)
x[is.na(x$DEPARTMENT_NAME), "DEPARTMENT_NAME"] <- '소속부서x'
x[,"DEPARTMENT_ID"] <- NULL
total <- data.frame(DEPARTMENT_NAME='사원총급여', SALARY=sum(x[,1]))
rbind(x, total)
#NA제외/NA값 각각의 dataframe을 만들어서 rbind
x <- aggregate(SALARY~DEPARTMENT_NAME, merge(emp,dept,by='DEPARTMENT_ID'),sum)
colnames(x) <- c('부서이름', '부서별급여')
y <- data.frame(부서이름='소속부서X',부서별급여=emp[is.na(emp$DEPARTMENT_ID),'SALARY'])
total <- data.frame(부서이름='사원총급여',부서별급여=sum(z[,2]))
result <- rbind(x,y,total)
result
# select nvl(d.department_name,'소속부서X'), sum(e.salary) from departments d, employees e where e.department_id = d.department_id(+) group by d.department_name
# union all
# select '사원총급여', sum(salary) from employees order by 1,2;

# [문제126] 30번 부서 사원이면서 급여는 3000이상 받는 사원들의 last_name, hire_date, salary, job_id, department_id 출력해주세요.
# 단 subset 함수를 이용하세요.
subset(emp, DEPARTMENT_ID == 30 & SALARY >= 3000, select=c(LAST_NAME, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID))
# select last_name, hire_date, salary, job_id, department_id from emp where department_id = 30 and salary >= 3000;

# [문제127] 입사한 날짜가 2002,2003년도에 입사한 사원들의 last_name, hire_date, salary, job_id, department_id 출력해주세요.
# 단 subset 함수를 이용하세요.
subset(emp, substr(HIRE_DATE,1,4)%in%c('2002','2003'),select=c(LAST_NAME, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID))
# select last_name, hire_date, salary, job_id, department_id from emp where substr(hire_date, 1, 4) in (2002, 2003);

# [문제128] 문제126번 결과하고 문제127결과를 하나로 합쳐 주세요.
x <- subset(emp, DEPARTMENT_ID == 30 & SALARY >= 3000, select=c(LAST_NAME, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID))
y <- subset(emp, substr(HIRE_DATE,1,4)%in%c('2002','2003'),select=c(LAST_NAME, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID))
rbind(x,y)
merge(x,y,all=T)
# select last_name, hire_date, salary, job_id, department_id from emp where department_id = 30 and salary >= 3000
# union all
# select last_name, hire_date, salary, job_id, department_id from emp where substr(hire_date, 1, 4) in (2002, 2003);

# [문제129] 문제126번 결과하고 문제127결과 하나로 합치되 중복되는 데이터는 제거해주세요.
z <- rbind(x,y)
unique(z)

library(doBy)
orderBy(~LAST_NAME, unique(z))
# select last_name, hire_date, salary, job_id, department_id from emp where substr(hire_date, 1, 4) in (2002, 2003)
# union all
# select last_name, hire_date, salary, job_id, department_id from emp where department_id = 30 and salary >= 3000 and not exists(select * from emp where substr(hire_date, 1, 4) in (2002, 2003));

# [문제130] 150번 사원의 급여보다 더 많은 급여를 받는 사원들의 last_name, salary 를 출력하세요.
subset(emp, SALARY > emp[emp$EMPLOYEE_ID==150, "SALARY"], select=c(LAST_NAME, SALARY))
# select last_name, salary from emp where salary > (select salary from emp where employee_id = 150);

# [문제131] 사원 테이블에서 가장 많은 급여를 받는 사원의 이름과 월급을 출력하세요.
subset(emp, SALARY == max(SALARY), select=c(LAST_NAME, SALARY))
# select last_name, salary from emp where salary = (select max(salary) from emp);

# [문제132] job_id가  SA_REP인 사원의 최대급여 이상 받는 사원들의 last_name,salary,job_id를 출력하세요.
subset(emp, SALARY >= max(emp[emp$JOB_ID=='SA_REP', "SALARY"]), select=c(LAST_NAME, SALARY, JOB_ID))
# select last_name, salary, job_id from emp where salary >= (select max(salary) from emp where job_id = 'SA_REP');

# [문제133]  KING 에게 보고하는 사원들의 last_name, salary를 출력하세요.
subset(emp, MANAGER_ID %in% emp[emp$LAST_NAME=='King',"EMPLOYEE_ID"], select=c(LAST_NAME, SALARY))
# select last_name, salary from emp where manager_id in (select employee_id from emp where last_name = 'King');

#--------------------------------------------------------------------------

# subset(): 조건에 맞는 데이터를 선택
emp[emp$DEPARTMENT_ID==20,]
subset(emp, DEPARTMENT_ID==20) #NA값은 제외됨

emp[,c("LAST_NAME","SALARY","DEPARTMENT_ID")]
subset(emp, select=c(LAST_NAME, SALARY, DEPARTMENT_ID))

#특정 컬럼을 제외한 나머지 컬럼을 조회하는 방법
emp[,!names(emp) %in% c("LAST_NAME","SALARY","DEPARTMENT_ID")] 
subset(emp,select=-c(LAST_NAME, SALARY, DEPARTMENT_ID))

emp[emp$SALARY >= 10000, !names(emp) %in% c("LAST_NAME","SALARY","DEPARTMENT_ID")]
subset(emp, SALARY >= 10000, select=-c(LAST_NAME, SALARY, DEPARTMENT_ID))

#sqldf 
# sql을 이용해서 데이터를 처리
# mysql, sqlite
# 문자날짜는 인식 / date형식은 인식못함
install.packages('sqldf')
library(sqldf)

?sqldf

sqldf('select * from emp')
sqldf('select * from dept')
sqldf('select * from loc')
sqldf('select job_id from emp')
sqldf('select distinct job_id from emp')
sqldf('select * from emp where department_id = 20')
sqldf('select * from emp limit 10')
sqldf('select last_name, salary from emp order by salary desc')
sqldf('select count(*) from emp')

NROW(emp$SALARY)
sum(emp$SALARY)
mean(emp$SALARY)
sd(emp$SALARY)
var(emp$SALARY)
max(emp$SALARY)
min(emp$SALARY)
sqldf('select count(employee_id), sum(salary), avg(salary), variance(salary), stdev(salary), max(salary), min(salary) from emp')
sqldf('select department_id, sum(salary) from emp group by department_id')
sqldf('select department_id, sum(salary) from emp group by department_id having sum(salary) >= 20000')
sqldf('select department_id, job_id, sum(salary) from emp group by department_id having sum(salary) >= 20000')
sqldf('select department_id, job_id, sum(salary) from emp group by department_id, job_id having sum(salary) >= 20000')
sqldf('select last_name, upper(last_name), lower(last_name), substr(last_name, 1, 2), length(last_name), leftstr(last_name, 2), rightstr(last_name, 2), reverse(last_name) from emp')
sqldf('select salary/3, round(salary/3, 0), ceil(salary/3) from emp') #trunc 없음
sqldf('select * from emp where department_id is null')
sqldf('select * from emp where department_id is not null')
sqldf('select * from emp where department_id in (10,20)')
sqldf('select * from emp where salary between 10000 and 20000')
sqldf('select e.last_name, d.department_name from emp e, dept d where e.department_id = d.department_id')
sqldf('select e.last_name, d.department_name from emp e join dept d on e.department_id = d.department_id')
sqldf('select e.last_name, department_name from emp e join dept d using(department_id)')
sqldf('select e.last_name, d.department_name from emp e left outer join dept d on e.department_id = d.department_id') #right outer join은 없음 / 사용하는 테이블의 위치를 바꿔 사용
sqldf('select e.last_name, d.department_name from emp e left outer join dept d on e.department_id = d.department_id 
      union 
      select e.last_name, d.department_name from dept d left outer join emp e on e.department_id = d.department_id') #full outer join 구현
sqldf('select e.last_name, d.department_name from emp e left outer join dept d on e.department_id = d.department_id 
      union all 
      select e.last_name, d.department_name from dept d left outer join emp e on e.department_id = d.department_id')
sqldf('select e.last_name, d.department_name from emp e left outer join dept d on e.department_id = d.department_id 
      intersect 
      select e.last_name, d.department_name from dept d left outer join emp e on e.department_id = d.department_id')
sqldf('select e.last_name, d.department_name from emp e left outer join dept d on e.department_id = d.department_id 
      except
      select e.last_name, d.department_name from dept d left outer join emp e on e.department_id = d.department_id') #minus(차집합) 구현
sqldf('select * from emp where salary > (select salary from emp where employee_id = 150)') #subquery
sqldf('select hire_date from emp where hire_date > 20070101')