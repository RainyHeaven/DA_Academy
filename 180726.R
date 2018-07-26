#[문제55] last_name의 글자의 수가 10이상인 사원의 employee_id, last_name 출력하세요.
setwd('c:/data')
getwd()
emp <- read.csv('emp_new.csv', header=TRUE, stringsAsFactors=FALSE)
emp[ nchar(emp$LAST_NAME)>= 10, c("EMPLOYEE_ID", "LAST_NAME")]
#select employee_id, last_name from emp where len(last_name ) >= 10;

# [문제56] last_name, last_name의 첫번째 철자부터 세번째 철자까지 함께 출력하세요.
paste0(emp[, "LAST_NAME"], substr(emp[,"LAST_NAME"], 1, 3))
#select last_name||substr(last_name, 1, 3) from emp;

# [문제57] last_name의 두번째 철자가 m  인 사원들의 last_name, salary를 출력하세요.
emp[substr(emp[,"LAST_NAME"],2,2)=='m', c("LAST_NAME", "SALARY")]
# select last_name, salary from emp where substr(last_name, 2, 1) = 'm';
emp[grep('^.m', emp$LAST_NAME), c("LAST_NAME", "SALARY")]

# [문제58] last_name의 두번째 철자가 m 또는 g 인 사원들의 last_name, salary를 출력하세요.
emp[substr(emp[,"LAST_NAME"],2,2)=='m'|substr(emp[,"LAST_NAME"],2,2)=='g', c("LAST_NAME","SALARY")]
#select last_name, salary from emp where substr(last_name,2,1)='m' or substr(last_name,2,1)='g';
emp[substr(emp$LAST_NAME, 2, 2)%in%c('m','g'), c("LAST_NAME", "SALARY")]
emp[c(grep('^.m', emp$LAST_NAME), grep('^.g', emp$LAST_NAME)), c("LAST_NAME", "SALARY")]
emp[grep('^.m|^.g', emp$LAST_NAME), c("LAST_NAME", "SALARY")]
emp[grepl('^.m', emp$LAST_NAME)|grepl('^.g', emp$LAST_NAME), c("LAST_NAME", "SALARY")]

# [문제59] last_name, salary값을 화면에 출력할때 0은 * 로 출력하세요.
gsub(0, '*',emp[,c("LAST_NAME","SALARY")])
data.frame('last_name'=emp[, "LAST_NAME"], 'salary'=gsub(0, '*', emp[, "SALARY"]), stringsAsFactors = FALSE)
#select last_name, replace(salary, 0, '*') from emp;
paste(emp$LAST_NAME, gsub(0, '*', emp$SALARY))

# [문제60] last_name의 제일 뒷글자만 대문자 앞글자들은 소문자로 출력하세요.
lname <- emp[,"LAST_NAME"]
paste0(tolower(substr(lname,1, nchar(lname)-1)),toupper(substr(lname,nchar(lname), nchar(lname))))
# select lower(substr(last_name,1,length(last_name)-1))||upper(substr(last_name,length(last_name))) from emp;

# [문제61] s 백터 변수를 생성해서 "BIG DATA MARKETING" 입력한 후 단어로 분리해주세요.
s <- c('BIG DATA MARKETING')
strsplit(s, split=' ')
# declare
# v_sentence varchar2(100) := 'BIG DATA MARKETING';
# v_blank number;
# v_start number := 1;
# v_word varchar2(20);
# v_ind number := 1;
# begin
# loop
# select instr(v_sentence, ' ', 1, v_ind) into v_blank from dual;
# if v_blank = 0 then
# select substr(v_sentence, v_start) into v_word from dual;
# else
#   select substr(v_sentence, v_start, v_blank-v_start) into v_word from dual;
# end if;
# v_start := v_blank+1;
# v_ind := v_ind + 1;
# dbms_output.put_line(v_word);
# exit when v_blank = 0;
# end loop;
# end;
# /

#[문제62] 2002-06-07에 입사한 사원들의 last_name, hire_date를  출력하세요.
emp[emp$HIRE_DATE == 20020607, c("LAST_NAME", "HIRE_DATE")]
# select last_name, hire_date from emp where hire_date = '20020607';

#[문제63] 사원의 last_name, 근무일수를 출력하세요.
data.frame('last_name' = emp$LAST_NAME, '근무일수' = difftime(Sys.Date(), as.Date(as.character(emp$HIRE_DATE), '%Y%m%d')))
# select last_name, trunc(months_between(sysdate, hire_date)*30) as Work_day from emp;

# [문제64] 사원의 last_name, 입사한 요일을 출력하세요.
data.frame('last_name' = emp$LAST_NAME, '입사요일' = weekdays(as.Date(as.character(emp$HIRE_DATE), '%Y%m%d')))
# select last_name, to_char(hire_date, 'day') from emp;

# [문제65] 오늘 날짜를 기준으로  100개월 되는 날짜의 요일을 출력하세요.
weekdays(Sys.Date() + months(100))
# select to_char(add_months(sysdate, 100), 'day') from dual;
format(Sys.Date() + months(100), '%A')
wday(Sys.Date() + months(100), label=T)
#일일이 형변환을 하기보다 데이터셋의 형을 바꿔주면 편함
emp$HIRE_DATE <- as.Date(as.character(emp$HIRE_DATE), format='%Y%m%d')

# [문제 66] 부서번호를 중복제거해주세요.
as.integer(na.omit(unique(emp$DEPARTMENT_ID)))
sort(unique(emp$DEPARTMENT_ID))
# select distinct(department_id) from emp;

--














# 날짜함수
# 1. 현재 날짜 시간
# Sys.Date()
# Sys.time()
# date()
# 
# 2. as.Date(): 문자날짜를 날짜형으로 변환하는 함수
# as.Date('2018-07-26')
# as.Date('2018/07/26')
# as.Date('20180726', format='%Y%m%d')
# 
# 3. format()
# %Y: 세기를 포함한 연도(4자리)
# %y: 세기를 포함하지 않은 연도(2자리)
# %m: 숫자달
# %B: 문자달
# %b: 문자들의 약어
# %d: 일
# %A: 요일
# %a: 요일의 약어
# %u: 숫자요일1(월) ~ 7(일)
# %w: 숫자요일0(일) ~ 6(토)
# %H: 시
# %M: 분
# %S: 초
# %z: timezone의 시간
# %Z: timezone name

format(Sys.time(), '%y%m%d %z%Z')
format(Sys.time(), '%A %a %u %U')
365 - as.integer(format(Sys.time(), '%j'))

# 4. weekdays(): 요일을 출력하는 함수
weekdays(Sys.Date())
weekdays(as.Date('19860125', format='%Y%m%d'))
format(as.Date('1986-01-25'), '%A')

# 5. 날짜 계산
Sys.Date() + 101
Sys.Date() - 206
as.Date('20180726', format='%Y%m%d') + 120
as.Date('20180524', format='%Y%m%d') - as.Date('20181122', format='%Y%m%d')
as.Date('20181122', format='%Y%m%d') - as.Date('20180524', format='%Y%m%d')
as.Date('20181122', format='%Y%m%d') - Sys.Date()
as.numeric(as.Date('20181122', format='%Y%m%d') - as.Date('20180524', format='%Y%m%d'))

# 6. difftime 함수: 두 날짜간의 일수를 계산하는 함수
difftime('2018-11-22', Sys.Date())
round(as.numeric(difftime('2018-11-22', Sys.Date())))

# 7. as.difftime 함수: 시간의 차이
as.difftime('18:20:00') - as.difftime('09:30:00')
as.numeric(as.difftime('18:20:00') - as.difftime('09:30:00'))

# 8. lubridate
install.packages('lubridate')
library(lubridate)
#now() 현재시간
now()
year(now()) #연도
date <- now()
month(date, label=T) #월, level 표시
month(date, label=F)
format(Sys.time(), '%m')
day(date) #일 format(Sys.time(), '%d')
wday(date, week_start=1) #요일/월요일 기준 format(Sys.time(), '%A')
wday(date, week_start=7, label=T) #요일/일요일 기준
years(10)
months(100)
now() + years(10)
now() + months(100)
now() + days(100)
now() + hours(3)
now() + minutes(100)
now() + seconds(100)
now() + years(1) + months(1) + days(1) + hours(10) + minutes(20) + seconds(60)
now() + hm('08:00')
now() + hms('02:30:59')
year(date) <- 2017 #현재 시간이 들어있는 변수의 값을 바꾸고 싶을 때
date
day(date) <- 1

# 9. 분기
quarters(Sys.Date()) #현재 날짜의 분기정

class(Sys.Date())
class(Sys.time())
mode(Sys.Date())
mode(Sys.time())
#POSIX(Portable Operating System Interface)
# - Unix간 소통 가능한 프로그램 인터페이스 규약
# - POSIXct(continuous), POSIXt(POSIXlt)(list time)
# - r은 날짜 시간 데이터를 처리할 수 있도록 POSIXct, POSIXt(POSIXlt) 클래스를 사용한다
Sys.time()
time <- as.POSIXlt(Sys.time())
time
unlist(time) 
#mon: 월(0~11), year: 연도(1900년을 0으로 기준한), wday: 일요일0, isdst: 서머타임 적용여부, gmtoff: timezone 시(초)

date <- '2018-07-26'
class(as.Date(date))     
strptime(date, format='%Y-%m-%d') #time, date 타입을 POSIX 타입으로
class(strptime(date, format='%Y-%m-%d'))

# 중복제거
unique(emp$JOB_ID)

# 정렬(sort)
x <- c(3,2,4,8,6,5,10,NA,1,11,NA,15)
sort(x)
sort(x, decreasing=F) #오름차순
sort(x, decreasing=T) #내림차순
sort(x, decreasing=F, na.last=NA) #NA출력 안함
sort(x, decreasing=F, na.last=T) #NA를 마지막에 출력
sort(x, decreasing=F, na.last=F) #NA 처음에 출력

rev(sort(x)) #역정렬

# order: 정렬의 색인을 반환
x <- c(6,10,2,8,4)
sort(x)
order(x)

x[order(x)] #sort(x)와 똑같은 결과
x[order(x, decreasing=T, na.last=NA)]
x[order(x, decreasing=T, na.last=T)]
x[order(x, decreasing=F, na.last=F)]

# doBy: 데이터 프레임에 정렬
install.packages('doBy')
library(doBy)

orderBy(~SALARY, emp[,c("LAST_NAME", "SALARY")]) #salary 기준으로 오름차순 정렬
orderBy(~-SALARY, emp[,c("LAST_NAME", "SALARY")]) #salary 기준으로 내림차순 정렬
orderBy(~DEPARTMENT_ID-SALARY, emp[,c("LAST_NAME", "SALARY", "DEPARTMENT_ID")]) #department_id는 오름차순 , salary는 내림차순으로 정렬
#select last_name, salary, department_id from emp order by department_id, salary desc;
