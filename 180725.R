# [문제34]. emp 변수에 있는 데이터 중에 급여가 3000 인 사원들의 last_name, salary를 출력하세요. 단 emp 변수에 컬럼정보를 확인하시고 수행하세요.
names(emp)
emp[emp$SALARY==3000, c('LAST_NAME', 'SALARY')]
# desc emp
# select last_name, salary from emp where salary = 3000;

# [문제35] 급여가 2000 이상인 사원들의 last_name, salary를 출력하세요.
emp[emp$SALARY>=2000, c('LAST_NAME', 'SALARY')]
# select last_name, salary from emp where salary >= 2000;

# [문제36] job이 ST_CLERK인 사원들의 이름과 월급과 직업을  출력하세요.
emp[emp$JOB_ID=='ST_CLERK', c('LAST_NAME', 'SALARY', 'JOB_ID')]
# select last_name, salary, job_id from emp where job_id = 'ST_CLERK';

# [문제37] job이 ST_CLERK이 아닌 사원들의 이름과 월급과 직업을  출력하세요.
emp[emp$JOB_ID!='ST_CLERK', c('LAST_NAME', 'SALARY', 'JOB_ID')]
# select last_name, salary, job_id from emp where job_id != 'ST_CLERK';

# [문제38] 오라클의 in 연산자와 비슷한 R연산자는?
%in%

# [문제39] job이 AD_ASST, MK_MAN 인 사원들의 employee_id,last_name,job_id를 출력하세요.
emp[emp$JOB_ID%in%c('AD_ASST', 'MK_MAN'), c('EMPLOYEE_ID', 'LAST_NAME', 'JOB_ID')]
#select employee_id, last_name, job_id from emp where job_id in ('AD_ASST', 'MK_MAN');

# [문제40] job이 ST_CLERK, SH_CLERK, SA_REP 아닌 사원들의 employee_id,last_name,job_id를 출력하세요.
emp[!emp$JOB_ID%in%c('ST_CLERK','SH_CLERK', 'SA_REP'), c('EMPLOYEE_ID', 'LAST_NAME', "JOB_ID")]
#select employee_id, last_name, job_id from emp where job_id not in ('ST_CLERK', 'SH_CLERK', 'SA_REP');

# [문제41] 부서번호가 10번,20번인 사원들의 last_name, salary, department_id를 출력하세요.
emp[emp$DEPARTMENT_ID%in%c(10, 20), c("LAST_NAME", "SALARY", "DEPARTMENT_ID")]
#select last_name, salary, department_id from emp where department_id in (10, 20);

# [문제42] 오라클의 연결 연산자 와 비슷한 R 연산자는?
# 오라클		       R
# || concat   		paste(,,,,)

# [문제43] 아래결과와 같이 출력되도록하세요. 
# Grant 의 직업은  SH_CLERK  입니다.
help(paste)
paste(emp[,'LAST_NAME'],'의 직업은',emp[,'JOB_ID'],'입니다.')
paste0(emp$LAST_NAME,'의 직업은',emp$JOB_ID,'입니다.')

# [문제44] R에서 NA(결측치)를 체크하는 함수는?
is.na()

# [문제45] commission_pct에  NA 인 사원들의 last_name, salary, commission_pct를 출력하세요.
emp[is.na(emp$COMMISSION_PCT), c("LAST_NAME", "SALARY", "COMMISSION_PCT")]
# select last_name, salary, commission_pct from emp where commission_pct is null;

# [문제46] department_id에 NA 인 사원들의 last_name, salary, department_id를 출력하세요.
emp[is.na(emp$DEPARTMENT_ID), c("LAST_NAME", "SALARY", "DEPARTMENT_ID")]
# select last_name, salary, department_id from emp where department_id is null;

# [문제47] commission_pct에  NA가 아닌 사원들의 last_name, salary, commission_pct를 출력하세요.
emp[!is.na(emp$COMMISSION_PCT), c("LAST_NAME", "SALARY", "COMMISSION_PCT")]
# select last_name, salary, commission_pct from emp where commission_pct is not null;

# [문제48] 30번 부서 사원들이면서 급여는 3000이상인 사원들의 employee_id, salary, department_id를 출력하세요.
emp[emp$DEPARTMENT_ID==30 & emp$SALARY >= 3000 , c("EMPLOYEE_ID", "SALARY", "DEPARTMENT_ID")]
# select employee_id, salary, department_id from emp where department_id = 30 and salary >= 3000;
#조건이 걸린 키값에 NA값이 있다면 해당열은 모두 NA가 되어 출력됨
#na.omit(): na가 있는 행을 모두 제거
na.omit(emp[emp$DEPARTMENT_ID==30 & emp$SALARY >= 3000 , c("EMPLOYEE_ID", "SALARY", "DEPARTMENT_ID")]) 

# [문제49] 20번부서 사원이면서 급여는 10000를 초과한 사원 또는 급여가 2500 미만의 사원들의 employee_id, salary, department_id를 출력하세요.
emp[(emp$DEPARTMENT_ID==20 & emp$SALARY > 10000)|emp$SALARY<2500, c("EMPLOYEE_ID", "SALARY", "DEPARTMENT_ID")]
emp[emp$DEPARTMENT_ID==20 & emp$SALARY > 10000|emp$SALARY<2500, c("EMPLOYEE_ID", "SALARY", "DEPARTMENT_ID")]
emp[emp$SALARY<2500, c("EMPLOYEE_ID", "SALARY", "DEPARTMENT_ID")]
# select employee_id, salary, department_id from emp where (department_id = 20 and salary > 10000) or salary < 2500;

# [문제50]last_name의 첫번째 글자가 A 로 시작하는 사원들의 last_name, salary를 출력하세요.
emp[grep('^A', emp$LAST_NAME,ignore.case=FALSE), c("LAST_NAME", "SALARY")]
emp[grep('^A.*', emp$LAST_NAME,ignore.case=FALSE), c("LAST_NAME", "SALARY")]

# [문제51]last_name의 끝글자가 g 로 끝나는 사원들의 last_name, salary를 출력하세요.
emp[grep('g$', emp$LAST_NAME, ignore.case=FALSE), c("LAST_NAME", "SALARY")]
emp[grep('*g$', emp$LAST_NAME, ignore.case=FALSE), c("LAST_NAME", "SALARY")]
emp[grep('*.g$', emp$LAST_NAME, ignore.case=FALSE), c("LAST_NAME", "SALARY")]
 
# [문제52]last_name의 z 를 포함하고 있는 사원들의 last_name, salary를 출력하세요.
emp[grep('z', emp$LAST_NAME, ignore.case=TRUE), c("LAST_NAME","SALARY")]
emp[grep('z', emp$LAST_NAME, ignore.case=TRUE), c("LAST_NAME","SALARY")]
emp[grep('^.*z.*$', emp$LAST_NAME, ignore.case=TRUE), c("LAST_NAME","SALARY")]
 
# [문제53]last_name의 두번째 철자가 u 인 사원들의 last_name, salary를 출력하세요.
emp[grep('^.u', emp$LAST_NAME, ignore.case=FALSE), c("LAST_NAME", "SALARY")]

# [문제54] developer글자를 첫글자 대문자, 뒤글자는 소문자로 변환하세요.
word <- 'developer'
last <- nchar(word)
paste0(toupper(substr(word, 1, 1)),tolower(substr(word,2,last)))

library(tools)
toTitleCase(word)

install.packages('stringr')
library(stringr)
str_to_title(word)










# 데이터 자료형
# 1.vector: 같은 데이터 타입을 갖는 1차원 배열
# 2. list: 서로 다른 데이터타입을 갖는 1차원 배열, 중첩 가능
# 3. matrix: 같은 데이터 타입을 갖는 2차원 배열
# 4. array: 같은 데이터 타입을 갖는 3차원 배열
# 5. factor: 목록, 범주형 데이터
# 6. data.frame: 서로 다른 데이터 타입을 갖는 컬럼으로 이루어진 2차원 배열
# 7. table: data.frame과 동일한 구조를 갖는데 속도가 빠르다

a <- c(1,2)
b <- list(c('king',100))
c <- matrix(c(1:4), nrow=2, byrow=TRUE)
d <- array(1:12, dim=c(2,2,3))
e <- factor(c('male','female'))
f <- data.frame(x=c(1,2))

class(a)
class(b)
class(c)
class(d)
class(e)
class(f)

mode(a)
mode(b)
mode(c)
mode(d)
mode(e)
mode(f)

str(a)
str(b)
str(c)
str(d)
str(e)
str(f)

is.numeric(a)
is.character(a)
is.integer(a)
is.factor(e)
is.matrix(c)
is.array(d)
is.data.frame(f)
is.list(b)

getwd()
setwd('c:/data')

emp <- read.csv('emp_new.csv', header=T, stringsAsFactors=F)
str(emp)
names(emp) #컬럼이름
emp[emp$EMPLOYEE_ID==100, c('LAST_NAME', 'SALARY')]
#select last_name, salary from emp where employee_id = 100

emp

# grep함수: 문자 패턴을 찾을 때 사용되는 함수
# ^ : 첫번째
# $ : 마지막
# . : 한자리수
# * : wild card(%)
# <예>
# emp[grep("aa", emp$LAST_NAME),c("LAST_NAME","SALARY")]
# emp[grep("[x-z]", emp$LAST_NAME, ignore.case = TRUE),c("LAST_NAME","SALARY")]
# ignore.case = TRUE 대소문자 구분안한다.
# ignore.case = FALSE 대소문자 구분한다.

# 문자함수
# nchar: 문자수를 리턴하는 함수(length)
nchar('R developer')
nchar('R developer', type='chars')
nchar('R developer', type='bytes')

nchar('빅데이터')
nchar('빅데이터', type='chars')
nchar('빅데이터', type='bytes')

# strsplit: 부분문자로 분리하는 함수
strsplit('R Developer', split=character(0))
strsplit('R Developer', split=' ')
str(unlist(strsplit('R,Developer', split=',')))

# toupper:대문자
toupper('r developer')

# tolower: 소문자
tolower('R DEVELOPER')

# substr
substr('R Developer', 1, 3)

# sub: 첫번째 일치하는 문자만 바꾸는 함수
sub('R', 'Python', 'R Programmer R Developer')

# gsub: 일치하는 모든 문자를 바꾸는 함수
gsub('R', 'Python', 'R Programmer R Developer')
gsub('[0-2]', '*', '12303405')

# 숫자함수
# round
round(45.926)
round(45.926, 2)
round(45.926, -1)

# trunc
trunc(45.926)
trunc(45.926, 2) #뒤의 인자가 의미가 없음
trunc(45.926, -2)

# signif
signif(45.926, 3)

# floor: 같거나 작은 정
floor(45.9256)

# 날짜함수
# 1. 현재날짜시간
Sys.Date()
Sys.time()
date()

# 2. as.Date(): 문자날짜를 날짜형으로 변환하는 함수
as.Date('2018-07-25')
as.Date('2018/07/25')
as.Date('20180725', format='%Y%m%d')
# format
# %Y: 세기를 포함한 연도(4자리)
# %y: 세기를 생략한 연도(2자리)
# %m: 숫자달
# %B: 문자달
# %d: 일
# %A: 요일
# %u: 숫자요일 1(월)~7(일)
# %w: 숫자요일 0(일)~6(토)
# %H: 시
# %M: 분
# %S: 초

as.Date('2018년 1월 2일', format='%Y년%m월%d일')
format(Sys.time(), '%y %m %d %u')
