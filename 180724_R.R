# [문제16] x 변수에 벡터값 1,2,3,5,6 을 입력한 후 3번째 요소 뒤에 4를 입력하세요.
x <- c(1,2,3,5,6)
x <- append(x, 4, after = 3)

# [문제17] 1부터  3씩 증가하는 10 이하의 정수값을 출력하세요.
seq(1, 10, 3)
seq(1, 10, length.out=100) #length.out = x : x개만큼 등분

# [문제18] 10 부터 20 까지의 값을 x 변수에 생성한 후 원소의 값이 15 이상이고 18 이하인 값들만 출력하세요.
x <- c(10:20)
x[which(15 <= x & 18 >= x)]

# [문제19] 10 부터 20 까지의 값을 x 변수에 생성한 후 원소의 값이 15 이상이고 18 이하인 값들만 2곱한 값으로 수정하세요.
x <- c(10:20)
x[which(15 <= x & 18 >= x)] <- x[which(15 <= x & 18 >= x)]*2

# [문제20] x 변수에 행렬을 구성하세요. 값은 1부터 10까지 입력하시고 5행 2열으로 만들면서 값은 열을 기준으로 생성하세요.
x <- matrix(c(1:10), nrow=5, byrow=FALSE)

#[문제21] x 변수에 열을 기준으로 11,12,13,14,15 값을 추가하세요.
x <- cbind(x, c(11:15))
x
# [문제22] x 변수에 행을 기준으로 16,17,18 값을 추가하세요.
x <- rbind(x, c(16:18))
x

# [문제23] x변수에 6행의 값을 20,21,22 로 수정하세요.
x[6,] <- c(20:22)
x

# [문제24] x 변수에 6행을 제거해주세요.
x <- x[-6,]
x

# [문제25] x 배열을 생성하세요. 1부터 12까지 값을 가지고있는 배열을 생성하세요. 면은 3개가 만들어지도록하세요.
x <- array(c(1:12), dim=c(2,2,3))
x <- array(1:12, dim=c(2,2,3))

#[문제26] x 배열 변수에 컬럼이름은 'a','b'로 설정하세요.
colnames(x) <- c('a','b')

#[문제27] x 배열 변수에 행이름은 'row1','row2'로 설정하세요.
rownames(x) <- c('row1','row2')

#[문제28] x 배열 변수에 면을 2로 수정하세요.
dim(x) <- c(3,2,2)
x

# [문제29] 벡터에 있는 값 "large", "medium", "small", "small", "large", "medium" 을 factor 변수로 구성하세요. 
# 변수이름은x로 생성하시고 levels samall, medium, large 순으로 지정하세요.
x <- factor(c('large','medium','small','small','large','medium'), levels=c('small', 'medium','large'),ordered=TRUE)
x

#[문제30] x factor형 목록이름중에 small 을 s로 수정하세요.
levels(x)[1] <- 's'
levels(x)[levels(x) == 'small'] <- 's'
x

# [문제31] 아래와 같은 모양의 변수를 생성하세요. 변수 이름은 df로 하세요.
# <화면출력>
# df
# name sql  plsql
# 1  king  96     75
# 2 smith  82     91
# 3  jane  78     86
df <- data.frame(name=c('king','smith','jane'), sql=c(96, 82, 78), plsql=c(75, 91, 86), stringsAsFactors=FALSE)
df

# [문제32] df변수에 james, 90, 80 추가 해주세요.
# <화면출력>
# > df
# name sql plsql
# 1  king  96    75
# 2 smith  82    91
# 3  jane  78    86
# 4 james  90    80
df[4,] <- c('james', 90, 80)
df
df <- rbind(df, c('james',90,80))
df <- rbind(df, data.frame(name='james',sql=90,plsql=80))

# [문제33] james에 대한 row 정보만 출력하세요.
# <화면출력>
# name sql plsql  r
# 4 james  90    80 60
df[df$name=='james',]
















#matrix(행렬)
#- 벡터처럼 한가지 유형의 스칼라 값만 저장
#- matrix 함수를 이용해서 행렬을 생성
#- 행과 열을 지정

x <- c(1:9) #1차원 배열
x <- matrix(c(1:9), nrow=3) #nrow : 행의 수
x <- matrix(c(1:9), ncol=3) #ncol : 열의 수
x <- matrix(c(1:9), nrow=3, ncol=3)
x <- matrix(c(1:9), nrow=1)
x <- matrix(c(1:9), ncol=1)
x <- matrix(c(1:9))
x
nrow(x) #행의 수
ncol(x) #열의 수
dim(x) #행,열의 수

x <- matrix(c(1:9), nrow=3, byrow=TRUE) #byrow: TRUE-행부터 값을 채움 / FALSE-열부터 값을 채움

x <- matrix(c(1,2,3,4), nrow=2, byrow=TRUE, dimnames=list(c('row1', 'row2'), c('col1', 'col2')))

x <- matrix(c(1:9), ncol=3)

dimnames(x) <- list(c('a1', 'a2', 'a3'), c('b1', 'b2', 'b3')) #행렬의 컬럼이름 수정
rownames(x) #행의 이름
rownames(x) <- c('r1', 'r2', 'r3')
colnames(x) #열의 이름
colnames(x) <- c('c1', 'c2', 'c3')

cells <- c(1:9)
rname <- c('r1', 'r2', 'r3')
cname <- c('c1', 'c2', 'c3')
x <- matrix(cells, nrow=3, byrow=TRUE, dimnames=list(rname,cname))
class(x)
mode(x)

#x[행, 열]
x[1, 1]
x[2, 1]
x[1,] #인덱스 생략: 모든 인덱스
x[1, -2] #-인덱스: 해당 인덱스를 제외하고
x[1, 2:3]
x[c(1,3), c(1,2)]
x['r1',] #행이름 사용 가능
x[, 'c2'] #열이름 사용 가능

x[1,1] <-10
x

#행렬의 연산
x <- matrix(c(1:4), ncol=2)
x+10
x-8
x*2
x/5
10-x
x^2
x+x
x-x
x*x
x%*%x

t(x) #t(행렬명): 전치행렬
solve(x) #solve(행렬명): 역행렬
x %*% solve(x) #단위행렬

x <- matrix(c(1:6), ncol=3)
dim(x)
dim(x) <- c(3,2) #행렬의 행과 열 구조 변경

x <- matrix(c(1:9), nrow=3)
y <- matrix(c(1:9), nrow=3)
x
y
cbind(x, y) #열이 추가되도록 합침
rbind(x, y) #행이 추가되도록 합침

#array(배열)
#- 같은 데이터 타입을 갖는 3차원 배열구조
#- array함수를 이용해 배열 생성

x <- array(c(1:6), dim=c(2,3))
x <- array(c(1:24), dim=c(2,3,4))
x[1,1,]
x[1,,]
x[,,4]
dimnames(x)
dimnames(x) <- list(c('r1','r2'), c('c1','c2','c3'))
rownames(x)
colnames(x)
class(x)
mode(x)
str(x)
is.matrix(x)
is.array(x)

#factor(팩터)
#- 범주형: 데이터를 미리 정해진 유형으로 분류
#- level: A,B,C,D,E, '좋음', '보통', '나쁨'
#- 종류: 순서형(ordinal), 명목형(nominal)
#- 순서형(ordinal): 데이터간 순서를 둘 수 있는 경우(A,B,C,D..)
#- 명목형(nominal): 데이터간 크기 비교가 불가능한 경우(남,여)
x <- factor('좋음', c('좋음', '보통', '나쁨'))
x
str(x)
mode(x)
class(x)

y <- factor('좋음', c('좋음', '보통', '나쁨'), ordered=TRUE)
str(y)
mode(y)
class(y)
nlevels(y) #level의 갯수
levels(y) #level의 목록
levels(y)[1]
levels(y) <- c('good', 'normal', 'bad')
y
is.factor(y)

gender <- factor(c('male','male','female'), c('male', 'female'))
gender
x <- ordered(c('a','b'), c('a', 'b', 'c'))
x
is.ordered(x)

x <- factor(c('large','medium', 'small', 'small', 'large', 'medium'), levels=c('small', 'medium', 'large'))

x <- append(x, 'tiny', 6) #level에 없는 데이터를 추가할 경우 기존 factor 데이터들이 문자로 바뀌어버림

x <- as.vector(x) #벡터형으로 바꾼 후 수정
x <- append(x, 'tiny', 6)
x <- as.factor(x)
x


#data frame(데이터프레임)
#- 각기 다른 데이터 타입을 갖는 컬럼으로 이루어진 2차원 테이블 구조(DB의 TABLE과 유사)
#- data.frame()함수를 이용해 각 컬럼, 행을 구성한다.
df <- data.frame(x=c(1,2,3,4,5), y=c(16,7,8,9,10))
df
mode(df)
class(df)
str(df) # 5 obs(row의 수). of 2 variables(컬럼의 수)

df$x #df의 x변수 값만 보겠다
df$y #df의 y변수 값만 보겠다

df <- data.frame(name=c('scott','harden','curry'),sql=c(90, 80, 70), plsql=c(70,80,90))
df
str(df) #데이터프레임에서 문자열은 기본적으로 factor형으로 저장

df <- data.frame(name=c('scott','harden','curry'),sql=c(90, 80, 70), plsql=c(70,80,90), stringsAsFactors=FALSE)
df
str(df)

df[1,1] <- 'james'
df$sql
df$r <- c(80, 70, 60) #컬럼추가
df$r <- NULL #컬럼삭제
df[,1]
df[,'sql', drop=FALSE] #결과를 세로로
df$name[2]
df$plsql[-1]

x <- data.frame(1:3)
colnames(x) <- c('val')
rownames(x) <- c('a','b','c')
x

d <- data.frame(a=1:3, b=4:6, c=7:9)
d
names(d)%in%c('b','c')
d[,names(d)%in% c('b','c')] #'b','c'를 포함한 열만 출력
d[,!names(d)%in% c('b','c')] #'b','c'를 포함하지 않은 열만 출력
d[, -c(2,3)]
d[,-c('b','c')] #오류: 열 이름 벡터로는 제한할 수 없음

d[4,] <- c(7,7,7)
d[,4] <- c(9,9,9,9)
d <- d[-4,-4] #행,열 제거
d
x <- data.frame(x=1:1000)
x
head(x) #데이터의 앞부분
head(x, n=10)
tail(x) #데이터의 뒷부분
tail(x, 10)
