# [문제144] 부서별 급여의 총액을 pie chart를 생성하세요.
#tapply
x <- tapply(emp$SALARY, emp$DEPARTMENT_ID, sum)
pie(x, label=names(x), main='부서별 급여 총액')
pie(x, label=paste0(names(x),'번 부서 급여 총액 ', x), main='부서별 급여 총액')

#aggregate
x <- aggregate(SALARY~DEPARTMENT_ID, emp, sum)
pie(x[[2]], label=paste0(x[[1]], '번 부서', x[[2]], '만원'), main='부서별 급여 총액')

df <- aggregate(SALARY~DEPARTMENT_ID, emp, sum)
label1 <- paste(df$DEPARTMENT_ID, '부서', sep="")
label2 <- paste(df$SALARY, '만원', sep="")
pie(df$SALARY, labels=label2, main= '부서별 총액 급여', col=rainbow(length(df$SALARY)), radius=0.5)
legend(1,1,label1,fill=rainbow(length(df$SALARY)))

# ---------------------------------------------------------------------------------

# 통계학
# - 관심 대상의 관련 데이터를 수집, 요약, 정리하여 불확실한 사실에 대한 결론이나 일반적인 규칙성을 발견하는 학문
# - 해결하고 싶은 문제의 답을 찾기 위한 분석에 필요함

# 자료
# - 문제 해결을 위한 원재료로서 처리되지 않은 숫자, 문자, 일련의 사실이나 기록들의 모임
# - 가치 판단의 근거가 되는 재료

# 양적자료
# - 숫자, 크기, 측정되는 값
# - 연속형 자료: 키, 몸무게
# - 이산형 자료: 출생아수, 남학생 수, 왼손잡이의 수
# 
# 질적자료
# - 의미를 내포한 자료
# - 순위형 자료: 학점(A,B,C,D,F), 매우그렇다, 보통이다
# - 명목형 자료: 성별, 거주지역, 혈액형


# ----------------------------------------------------------#
#         |  <요약방법>   |   <자료정리>      |  <그래프>   #
# 질적자료|  도표, 그래프 |  도수분포표       | 막대그래프  #
#         |               |  분할표           | 원그래프    #
# ----------------------------------------------------------#
# 양적자료|  수치, 그래프 |  평균, 분산,      | 히스토그램  #
#         |               |  표준편차, 중앙값 | 상자도표    #
#         |               |                   | 시계열도표  #
#         |               |                   | 산점도      #
# ----------------------------------------------------------#

# 기술통계
# - 자료 수집, 정리
# - 자료의 형태를 표현
# - 자료의 특성값 도출

# 추측통계
# - 표본으로부터 관찰하고자 하는 특성값 도출
# - 이를 바탕으로 모집단의 특성 파악

# pie chart
# - 일반적으로 질적 자료 상대도수분포표를 나타내기 위해 사용되는 그래프
# - 하나의 원을 각 계급의 상대도수에 대응하는 면적 또는 부분으로 나눈다
# - pie(데이터, labels=라벨값, main=타이틀명, col=파이색, clockwise=T(시계방향), init.angle=시작각도)

# A회사: 100억
# B회사: 50억
# C회사: 30억
# D회사: 10억
s <- c(100, 50, 30, 10)
company <- c('A회사', 'B회사','C회사','D회사')
pie(s, labels=company, main='회사별 매출액', col=c('red','blue','green','yellow'))
pie(s, labels=company, main='회사별 매출액', col=rainbow(length(s)))
rainbow(7) #무지개색
## 팔레트.colors(12)
heat.colors(12) #적색, 황색에 치우친색
terrain.colors(12) #지구 지형색
topo.colors(12) #청색에 가까운색
cm.colors(12) #핑크, 블루
gray.colors(12) #회색

pie(s, labels=company, main='회사별 매출액', col=gray.colors(length(s)), clockwise=F)
pie(s, labels=company, main='회사별 매출액', col=gray.colors(length(s)), clockwise=F, init.angle=90)
pie(s, labels=company, main='회사별 매출액', col=gray.colors(length(s)), clockwise=F, init.angle=180)
pie(s, labels=company, main='회사별 매출액', col=gray.colors(length(s)), clockwise=T, init.angle=180)

p <- round(s/sum(s)*100)
label <- paste(company, p)
label
label <- paste0(label, '%')
label

pie(s, label=label, main='회사별 매출액')

#legend: 파이차트의 범례 생성
legend(1,1,label1,fill=rainbow(length(df$SALARY)))

## plotrix
install.packages('plotrix')
library(plotrix)

pie3D(s, labels=label, explode=0.1, labelcex=0.8)
pie3D(s, labels=label, explode=0.2, labelcex=0.8)
### explode : 부채꼴들의 간격(0~1)
### labelcex : label의 문자 크기

# 막대그래프
# - 질적 자료를 표현하는 그래프
# - 각 계급 이름 위에 고정 너비의 막대를 도수에 비례한 길이로 표현
# - barplot(height=데이터, width=너비(0~1), names.arg=컬럼명, horiz=F(수직그래프일때), col=컬러, main=타이틀명, xlab=x축이름, ylab=y축이름, ylim=y축크기)
sales <-  c(150,100,70,30)
team <- c('영업1팀', '영업2팀', '영업3팀','영업4팀')
?barplot
barplot(height=sales, width=0.5, names.arg = team, horiz=F, col=rainbow(length(sales)), main='영업팀별 영업실적', xlab='영업팀', ylab='영업실적(억원)', ylim=c(0, 180))
# height: 막대 크기를 나타내는 벡터(숫자)
# width: 막대 너비
# names.arg: 막대 아래 출력되는 이름
# col: 막대 색상
# main: 제목
# sub: 부제목
# horiz: TRUE(수평막대), FALSE(수직막대)
# xlab: x축 이름
# ylab: y축 이름
# ylim: y축 크기
# xlim: x축 크기

##text(): 막대의 특정 위치에 막대의 수치 표시
bp <- barplot(height=sales, width=0.5, names.arg = team, horiz=F, col=rainbow(length(sales)), main='영업팀별 영업실적', xlab='영업팀', ylab='영업실적(억원)', ylim=c(0, 180))
text(x=bp, y=sales, labels=round(sales), pos=3)
?text
## pos위치
## 1: 막대 끝 선의 아래쪽
## 2: 막대 끝 선의 왼쪽
## 3: 막대 끝 선의 위쪽
## 4: 막대 끝 선의 오른쪽

label <- paste0(sales, '억원')
text(x=bp, y=sales, labels=label, pos=3, cex=0.5)

# stacked bar chart(스택형 바 차트)
x1 <- c(2, 6, 9, 5)
x2 <- c(8, 10, 15, 6)
data <- rbind(x1, x2)
name <- c('영업1팀', '영업2팀', '영업3팀', '영업4팀')
label <- c('2016년', '2017년')

barplot(data, names.arg=name, main='영업팀별 실적', xlab='영업팀', ylab='판매실적(억원)', ylim=c(0, 30), col=c('darkblue', 'red'), legend.text = label)
