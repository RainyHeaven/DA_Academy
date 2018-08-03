rm(list=ls())
setwd('c:/data')
sales <- read.csv('fruits_sales.csv', header=T, stringsAsFactors = F)

str(sales)

install.packages('reshape2')
library(reshape2)

#reshape2 패키지
## melt(): 컬럼이 많은 형태(wide)를 세로방향(long)형태로 변형
sales
?melt
melt(sales, id='year')
melt(sales, id='name')
melt(sales, id=c('name', 'year'))
m <- melt(sales, id=c('year', 'name'))
m
class(m)
str(m)

## dcast(): long을wide 형태로 변경
## dcast(데이터, 행이 될 항목~열이 될 항목, 값으로 사용할 항목, 결과형태)
dcast(m, year+name~variable) 
dcast(m, name~variable, sum) 
dcast(m, year~variable, sum) 
dcast(m, name~variable, sum, margins=T) #margins=T - 총합을 표시


# fomula 인자식
# A ~ B: A: 종속변수 B: 독립변수
# . : 전부
# + : 해당 변수를 고려대상에 추가
# - : 해당 변수를 고려대상에서 제외
# * : 상호작용항을 고려하되 각 개별항과 상호작용항이 될 수 있는 모든 조합을 알아서 배정
# ex)mpg ~ wt * cyl * gear는 아래와 동일하다
# mpg ~ wt + cyl + gear + wt:cyl + wt:gear + cyl:gear + wt:cyl:gear

# 정규표현식
## escape
## \' : '
## \" : "
## \n : 개행문자
## \r : 복귀문자
## \t : 탭문자

## 정량자
## * : 0번이상 매칭
## + : 1번 이상 매칭
## ? : 1번 이하 매칭
## {n} : 정확히 n번 매칭
## {n,} : n번 이상 매칭
## {n,m} : n~m번 매칭

## 연산자
## . : 어떤 문자 하나와 매칭
## [...] : 문자 리스트 / [] 내부에 지정된 문자중 하나와 매칭 / - 사용가능
## [^...] : 반전 문자 리스트 / [] 내부에 있는 것을 제외한 문자 어느것이나 매칭
## | : or
## (...) : 그룹연산

## 문자열 내부 패턴 위치
## ^ : 문자열 시작 위치 매칭
## $ : 문자열 끝 위치 매칭
## \b : 빈 문자열(단어 양쪽 끝 포함) 매칭
## \B : 단어 끝에 위치하지 않는 빈문자열 매칭

## 문자열 클래스 [:...:]
## [:digit:], \d, [0-9]: 숫자
## \D, [^0-9]: 숫자가 아님
## [:lower:], [a-z]: 영문 소문자
## [:upper:], [A-Z]: 영문 대문자
## [:alpha:], [[:lower:][:upper:]], [A-z] : 알파벳 대소문자
## [:alnum:], [[:alpha:][:digit:]], [A-z0-9], \w: 알파벳 + 숫자
## \W, [^A-z0-9] : 단어가 아닌 것
## [:xdigit:], [0-9A-Fa-f]: 16진수, 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f
## [:blank:]: 간격문자(스페이스, 탭)
## [:space:]: 공백문자(탭, 개행문자, 수직탭, 공백, 복귀문자, form feed)
## \s: 공백, ' '
## \S: 공백 아님
## [:punct:]: 구두점 문자 / ! " # % & ' ( ) * + , - . / : ; < = > ? @ [ ] ^ _ ' { | } ~ 
## [:graph:], [[:alnum:][:punct:]]: 그래픽(사람이 읽을수 있는) 문자
## [:print:], [[:alnum:][:punct:]\\s]: 출력가능한 문자
## [:cntrl:], [\x00-\x1f\x7F]: 제어문자(\n, \r 등)

# grep: 동일한 문자열을 문자열 벡터에서 찾아서 인덱스 번호를 리턴하는 함수
text <- c('a','ab','acb','accb','accccb', '$ab')
grep('a',text)
grep('ab', text)
grep('c',text, value=T)
grep('ac*b',text, value=T) 
grep('ac+b',text, value=T) 
grep('ac?b',text, value=T) 
grep('ac{2}b',text, value=T) 
grep('ac{2,}b',text, value=T)
grep('ac{2,3}b',text, value=T) 

text <- c('abcd', 'cdab','cabd','c abd')
grep('ab', text, value=T)
grep('^ab', text, value=T)
grep('ab$',text, value=T)
grep('\\bab',text,value=T)

text <- c('^ab', 'ab', 'abc', 'abd', 'abe', 'ab 12')
grep('ab', text, value=T)
grep('ab.', text, value=T)
grep('ab[c,d,e]', text, value=T)
grep('ab[c-e]', text, value=T)
grep('ab[^c]',text, value=T)
grep('\\^', text, value=T)
grep('\\$', text, value=T)

text <- c('sql','SQL', 'Sql100', 'PLSQL', 'plsql', 'R', 'r', 'r0', 'python', 'PYTHON', 'pyth0n', 'python#', '100', '*', '$','^', '*100', '$ASP')
grep('[0-9]', text, value=T)
grep('[[:digit:]]', text, value=T)
grep('[[:upper:]]', text, value=T)
grep('[[:lower:]]', text, value=T)
grep('[[:alpha:]]', text, value=T)
grep('[[:alnum:]]', text, value=T)
grep('[[:punct:]]', text, value=T)

gregexpr('[*|$|^]', text)
which(gregexpr('[*|$|^]', text)==1)
text[gregexpr('[*|$|^]', text) == 1]

emp <- read.csv('emp_new.csv')
grep('Steven', emp$FIRST_NAME, value=T)
emp[gregexpr('Ste(v|ph)en', emp$FIRST_NAME)==1,]

x <- c('Steven', 'Stephen')
# 문자 벡터를 하나의 문자열로 연결하기
grep(paste(x, collapse = '|'), emp$FIRST_NAME, value=T)

library(stringr)
text
#str_detect(데이터, 문자패턴): 데이터가 해당 문자패턴을 갖고있는지 확인하여 TRUE/FALSE 리턴
str_detect(text, 'SQL') #대문자SQL 찾
which(str_detect(text, 'SQL'))
text[str_detect(text, 'SQL')]

str_detect(text,'^s')
which(str_detect(text, '^s'))
text[str_detect(text, '^s')]
text[str_detect(text, 'n$')]
text[str_detect(text, '^[sS]')]
text[str_detect(text, '[qQ]')]
text[str_detect(text, ignore.case('s'))]
text[str_detect(text, regex('s', ignore_case = T))]
text[str_detect(text, fixed('s', ignore_case = T))]

#str_count(데이터, 문자패턴): 데이터내의 문자패턴 반복횟수 리턴
text <- c('sqls', 'ssqls', 'SQL')
str_count(text, 's')
str_count(text, 'S')
str_count(text, '[sS]')
str_count(text, ignore.case('s'))

# str_c(): 문자열을 연결하여 리턴
str_c('R', '빅데이터 분석')
text <- 'R'
str_c('프로그램 언어: ', text)
str_c(text, ' 은 데이터 분석 하기 위해 좋은 언어는 ', text,'이다')
text <- c('R', '빅데이터분석')
str_c(text, collapse=',') #str_c(벡터, collapse='구분할 문자') : 인자로 들어온 벡터들의 요소를 구분할 문자로 연결함

# str_dup(문자, 횟수): 문자열을 주어진 횟수만큼 반복해서 출력
str_dup('파도소리 듣고싶다', 10)

# str_length(문자): 문자열의 길이 리턴
str_length('해운대 가고싶다')

# str_locate(데이터, 문자): 데이터에서 문자가 처음으로 나오는 위치
str_locate('january', 'a')
str_locate_all('january', 'a')

# str_replace(데이터, 찾을문자, 바꿀문자): 데이터에서 문자를 찾아 바꿀문자로 바꿈
str_replace('빅데이터분석','빅데이터','가치')
str_replace('banana','a','*')
str_replace_all('banana','a','*')

# str_split(데이터, 기준): 데이터를 지정된 기준으로 분리하여 리턴
str <-  str_c('sql','/','plsql','/','r')
str
str_split(str,'/')

# str_sub(데이터, 기준): 주어진 문자열에서 지정된 길이 만큼의 문자를 잘라내는 함수
str_sub('행복하게 살자', start=1, end=2)
str_sub('행복하게 살자', start=-2)
str_sub('행복하게 살자', start=1, end=1)

hw <- "Hadley Wickham"
str_sub(hw, c(1, 8), c(6, 14))

# str_trim(): 접두, 접미 부분의 공백문자를 제거
str_trim('           R         ')
