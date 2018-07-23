# [문제1] x변수에 1,3,5,7,9 값을 입력, y 변수에 1,2,3,4,5 값을 입력하세요.
x <- c(1,3,5,7,9)
y <- c(1,2,3,4,5)

# [문제2] x 변수와 y 변수를 중복성 없이 하나로 합친후에 u 변수에 넣어 주세요.
u <- sort(union(x,y), decreasing = FALSE)
u
# [문제3] x 변수와 y 변수의 값들중에 중복성만 추출해서 i 변수에 넣어주세요.
i <- intersect(x,y)

# [문제4] x 변수의 값과 y 변수의 값중에 순수하게 x 변수에 들어 있는 값만 추출해서 m 변수에 넣어 주세요.
m <- setdiff(x, y)
m
# [문제5] x 변수의 값과 y 변수의 값이 일치가 되면 TRUE 아니면 FALSE를 출력해주세요.
identical(x, y)

# [문제6] x 변수에 값들을 10을 곱한 결과를 x 변수에 적용하세요.
x <- x * 10

# [문제7] x 변수에 있는 50을 5로 수정하세요.
x
x[3] <- 5

# [문제8]  x 변수에 있는 10 30  5 70 90을  원래의 값으로 1,3,5,7,9로 되돌려 주세요.단 union, 정수 나누기, sort 만 사용하세요
x <- c(10, 30, 5, 70, 90)
x <- sort(union((x[-3]%/%10), x[3]))

x[which(5 == x)] <- 50
x <- x%/%10
x
# [문제9] x변수에 11숫자를 제일 뒤에 입력하세요. 단 append와 length를 이용하세요.
append(x, 11, after=length(x))

# [문제10] x 변수에 제일 뒤에 있는 값을 NA로 수정하세요. 단 length를 이용하세요.
x[length(x)] <- NA

# [문제11] lst 변수에 name = 'king' , height = 180, weight = 70 값을 넣어 주세요.
lst <- list(name = 'king', height = 180, weight = 70)
lst

# [문제12] lst 변수에  blood = 'A' 추가하세요.
lst$blood <- 'A'
lst

# [문제13] lst 변수에 name의 값을 'scott'로 수정하세요.
lst$name <- 'scott'

# [문제14] lst변수에 2번인덱스 값만 출력해주세요.
lst[[2]]

# [문제15] lst변수에 blood 이름을 blood type 이름으로 수정하세요.
names(lst) <- c('name', 'height', 'weight', 'blood type')
names(lst)[4] <- 'blood type'
lst

'scott'%in%lst
which(lst=='scott')













# 변수 값 할당연산자(<-, <<-, =)
x <- 1
x
print(x)

y <<- 2
y
print(y)

z = 3
z
print(z)

x+y+z
sum(x <- c(1,2,3,4,5)) #<- : 전역변수 할당 c(): 1차원 배열 

x

sum(y = c(1,2,3,4,5)) # = : 지역변수 할당
y

sum(d = c(1,2,3,4,5))
d

x <- 2
print(x)
class(x)

y <- 2L #L: 숫자를 정수로 표현
print(y)
class(y)

Z <- x+y #실수형과 정수형을 연산시 실수형 결과 리턴
print(z)
class(z)

str(z) #타입과 값을 모두 반

is.numeric(z)
is.integer(y)

#character
s1 <- 'hello'
s1
class(s1)
s2 <- "안녕하세요"
class(s2)
is.character(s2)

#boolean
# AND : &
# OR : |
TRUE & TRUE
TRUE & FALSE
TRUE | TRUE
TRUE | FALSE
T & T
T & F
T | T
T | F

T <- TRUE #T를 변수 이름으로 지정
T
class(T) 
is.logical(T) #boolean형태의 변수인지 확인
is.logical(z)
F <- FALSE
F

#NA(Not Available): 결측값, 데이터 입력중 실수로 값이 입력되지 않은 경우
a <- 100; b <- 90; c <- NA;
a
b
c
a+b+c #NA가 포함된 연산은 NA리턴
is.na(c) #NA인지 확인
is.na(a)

#NULL: 변수가 초기화되지 않았을 때 사용, undefined 값을 표현
x <- NULL
x
is.na(x)
is.null(x)

y <- 100
x + y #NULL이 포함된 연산은 타입 리턴

z <- NA
z + y #NA가 포함된 연산은 NA리턴

#산술연산자
100 - 99
99 - 100
2*3
100/2

100/3
100%/%3
100%%3
10^2
10**2

#비교연산자
10 > 5
10 < 5
10 >= 5
10 <= 5
10 == 5
10 != 5

10 > 9 & 10 >= 10
10 < 9 | 10 >= 10

#지수표기법
1e2 #1*10^2
5e-1 #5*10^-1
100000 #1e+5

#자료형
#1. vector(벡터)
# - 같은 데이터 타입을 갖는 1차원 배열구조(R의 기본 데이터구조)
# - c() : combine value
# - 중첩불가능
# - 단일 데이터타입
# - 데이터 변환규칙: integer < double(실수) < character
x <- c(1,2,3,4,5)
x
mode(x)
class(x)
str(x)

x <- c(1,2,3,4,'5')
x
mode(x)
class(x)
str(x)

x <- c(1,2,3.14,4,5)
x
mode(x)
class(x)
str(x)

x <- c(1,2,3,c(4,5))

s1 <- c('서울', '대구', '광주', '부산')
mode(s1)
class(s1)
str(s1)

x <- c(1,2,3, sum=c(4,5))
y <- c(1,2,3,sum(c(4,5)))
x
y

x <- c('국어'=90, '수학'=c(95, 90), '과학'=100)
x
z <- c('과목'=c(80, 90, 96))
z
names(z) <- c('국어', '영어', '수학') #names(): 컬럼명 설정
z

names(z) <- NULL
names(z) <- NA

y<-c(1,2,3,4,5)
names(y) <- c('하나', '둘', '셋', '넷', '다섯')
y

length(y)
NROW(y)

y[1]
y[1:3]
y[-1] #1번을 제외하고
y[c(-1,-3)] #1, 3번을 제외하고
y['하나'] #컬럼명으로 찾기
y[c('하나', '다섯')]
y[-1:-4]

x <- 1:100
x
x <- c(1:1000)
x 

#sequence: 자동 일련번호 생성
#seq(시작값, 종료값, 증가분)
seq(1, 5, 1)
seq(0, 1000, 5)

10:1

x <- c(2,4,6,8,10)
x
seq_along(x)

rep(1:5, times=2)
rep(1:5, each=2)
rep(1:5, each=2, times=2)

#벡터의 값 수정
x <- c(1:5)
x[2] <- 8
x
x[3:5] <- c(30, 40, 50)
x
#벡터의 값 추가
x[6] <- 60
x[8] <- 80
x
x[7] <- 70
x
append(x, 90, after=8)
x
x <- append(x, 90, after=8)
x
x <- append(x, 50, after=5)
x

#벡터 연산
x <- c(1:5)
x + 10
x * 10
x / 2
x %/% 2
x %% 2

#배열 비교
x <- c(1,2,3)
y <- c(1,2,3)
z <- c(1,2,4)
x == y
x == z

identical(x, y)
identical(x, z)
w <- c(1:5)
x == w
identical(x,w)

x <- c(1,2,3,4)
y <- c(1,4,6)
x == y
identical(x, y) #두 벡터의 값이 같을 시 TRUE
setequal(x, y) #두 벡터가 같은 집할일 시 TRUE
union(x, y) #합집합
intersect(x, y) #교집합
setdiff(x, y) #차집합
1 %in% x
5 %in% x

x <- c('b', 'a', 'd', 'a', NA)
x
'a' %in% x
x == 'a'
x[x=='a']
which('a' == x) #x에서 'a'의 인덱스 리
x[which('a' == x)]

is.na(x)
which(NA == x)
which(is.na(x))

x <- c(1:5)
y <- c(1,2,3,4,5)
setequal(x, y)
identical(x, y) #x는 integer, y는 number타입이라 FALSE
y <- as.integer(y)
identical(x, y)

help(identical)
?identical

#list
#- 서로 다른 데이터 타입을 갖는 벡터 혹은 다른 리스트를 저장 가능한 구조
#- list(키 = 값, 키 = 값..)
x <- list(name = '홍길동', addr = '서울시', pn = '010-1111-1234')
x
str(x)
class(x)
mode(x)
x$name
x$addr

x[1]
x[1:3]
#list 요소추가
x$sal <- 10000
x
#list 요소 제거
x$sal <- NULL
x
#list 요소 수정
x$pn <- '010-1234-1004'
x

y <- list(a=list(val=c(1,2,3)), b=list(val=c(1,2,3,4)))
y

y$a
y$b
