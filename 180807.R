# [문제145] 성별 현황을 조사 자료를 이용하여 성별 인구 비율을 원형 차트로 만드세요.
# 성별 현황
# 구분	조사수
# ----	------
# 남자	226965
# 여자	241319
data <- c(226965, 241319)
name <- c('남자', '여자')
ratio <- paste0(round(data/sum(data)*100), '%')
clr <- c('blue', 'red')
#pie
pie(data, labels=ratio, main='성별 인구 현황', col=clr, radius=0.7)
legend(0.5,1.2,name,fill=clr, cex=0.8)

#pie3D
library(plotrix)
pie3D(data, labels=ratio, explode=0.1, labelcex=1.2, col=clr, main='성별 인구 현황', start=90, theta=1.1)
legend(0.4,1,name,fill=clr, cex=0.8)

legend('topright',name,fill=clr, cex=0.8)

p <- pie3D(data, labels=ratio, explode=0.1, labelcex=1.2, col=clr, main='성별 인구 현황', start=90, theta=1.1)
pie3D.labels(p, labels=name, labelrad=0.5, labelcex=1, labelcol='whitesmoke')

# [문제146] 성별 현황을 조사 자료를 이용하여 성별 인구수를 막대그래프로 만드세요.
# 성별 현황
# 구분	조사수
# ----	------
# 남자	226965
# 여자	241319
#barplot
bar <- barplot(height=data, width=0.5, names.arg=name, horiz=F, col=clr, xlab='성별', ylab='인구수(명)', ylim=c(0, 300000))
text(x=bar,y=data, labels=ratio, pos=3)

bar <- barplot(height=data, width=1, names.arg=name, horiz=F, col=clr, main='성별 인구 현황', xlab='성별', axes=F, ylim=c(0, 290000))
text(x=bar, y=data, labels=paste0(data, '명'), pos=3)

# [문제147] 부서별 인원수 막대그래프를 생성하세요. 단 부서없는 사원들의 인원수도 포함하세요.
setwd('c:/data')
emp <- read.csv('emp_new.csv')
#tapply
data <- tapply(emp$EMPLOYEE_ID,ifelse(is.na(emp$DEPARTMENT_ID), 'NA', emp$DEPARTMENT_ID), NROW)
name <- names(data)
bp <- barplot(height=data, width=0.5, names.arg=name, horiz=F, col=terrain.colors(length(data)), main='부서별 인원수', xlab='부서ID', ylab='인원수(명)', ylim=c(0, 50))
text(x=bp, y=data, labels=paste0(data, '명'), pos=3)

#aggregate
dept_cn <- aggregate(EMPLOYEE_ID~ifelse(is.na(DEPARTMENT_ID), '부서없음', DEPARTMENT_ID), emp, length)
names(dept_cn) <- c('dept_id', 'cn')
bp <- barplot(dept_cn$cn, names.arg=dept_cn$dept_id, main='부서별 인원수', xlab='부서', col=rainbow(length(dept_cn$dept_id)), cex.name=0.7, axes=F)
text(x=bp, y=dept_cn$cn, labels=paste0(dept_cn$cn, '명'),cex=0.9, pos=3)

#ddply
library(plyr)
x <- ddply(emp, 'DEPARTMENT_ID', summarise, cn=NROW(EMPLOYEE_ID))
data <- x$cn
name <- ifelse(is.na(x$DEPARTMENT_ID), 'NA', x$DEPARTMENT_ID)
bp <- barplot(height=data, width=0.5, names.arg=name, horiz=F, col=terrain.colors(length(data)), main='부서별 인원수', xlab='부서ID', ylab='인원수(명)', ylim=c(0, 50))
text(x=bp, y=data, labels=paste0(data, '명'), pos=3)

# [문제148] 부서 이름별 급여 총액에 대해서 막대그래프를 생성하세요.단 부서없는 사원들의 인원수도 포함하세요.
dept <- read.csv('dept.csv', stringsAsFactors=F)
# sqldf
library(sqldf)
raw <- sqldf('select d.department_name, sum(e.salary) as sumSal from emp e left join dept d on e.department_id=d.department_id group by d.department_name')
data <- raw$sumSal
name <- ifelse(is.na(raw$DEPARTMENT_NAME), 'NA', raw$DEPARTMENT_NAME)

# 그래프그리기
bp <- barplot(height=data, width=0.1, names.arg=name, cex.names=0.7, horiz=F, col=rainbow(length(data)), main='부서별 총액 급여', xlab='부서이름', ylab='총 급여($)', ylim=c(0,350000), las=2)
text(x=bp, y=data, labels=paste0(data, '$'), cex=0.7, pos=1, offset=0.1)

# 최고급여, 최저급여, 부서없음을 하나로 달기/서로 중첩되지 않는다면...
x <- c(rep('', length(name)))
x[which(data==max(data))] <- '최고급여'
x[which(data==min(data))] <- '최저급여'
x[which(is.na(raw$DEPARTMENT_NAME))] <- '부서없음'
text(x=bp, y=data, labels=x, cex=0.7, pos=3, col='red')

#최고급여 label을 별개로 달기
text(x=bp[data==max(data)], y=data[data==max(data)], labels='최고급여', cex=0.7, pos=3, col='red')

#최저급여 label을 별개로 달기
text(x=bp[data==min(data)], y=data[data==min(data)], labels='최저급여', cex=0.7, pos=3, col='red')

#부서없음 label을 별개로 달기
text(x=bp[is.na(raw$DEPARTMENT_NAME)], y=raw[is.na(raw$DEPARTMENT_NAME), 2], labels='부서없음', cex=0.7, pos=3, col='red')

# [문제149] fruits_sales.csv을 읽어 들인 후 년도별, 과일이름별 판매량을  그룹형 막대 그래프로 만드세요.
sales <- read.csv('fruits_sales.csv')

#orderBy
raw <- orderBy(~year+name, sales)[,1:3]

## 연도별 > 과일이름별
data <- matrix(raw$qty, ncol=4, byrow=T)
name <- unique(raw$year)
label <- unique(raw$name)
bp <- barplot(data, names.arg=name, main='연도별 과일 판매량', xlab='연도', ylab='판매량', legend.text=label, col=c('red', 'yellow', 'purple', 'orange'), ylim=c(0, 25),beside=T)
text(x=bp, y=data, labels=data, pos=3)

## 과일이름별 > 연도별
data <- matrix(raw$qty, ncol=4, byrow=F)
name <- unique(raw$name)
label <- unique(raw$year)
bp <- barplot(data, names.arg=name, main='과일별 연간 판매량', xlab='과일명', ylab='판매량', legend.text=label, col=topo.colors(length(name)), ylim=c(0, 25), beside=T)
text(x=bp, y=data, labels=data, pos=3)

# tapply
## 연도별 > 과일이름별
data <- tapply(sales$qty, list(sales$year, sales$name), sum)
name <- rownames(data)
label <- colnames(data)
bp <- barplot(data, names.arg=name, main='연도별 과일 판매량', xlab='연도', ylab='판매량', legend.text=label, col=c('red', 'yellow', 'purple', 'orange'), ylim=c(0, 25),beside=T)
text(x=bp, y=data, labels=data, pos=3)

## 과일이름별 > 연도별
data <- tapply(sales$qty, list(sales$name, sales$year), sum)
name <- rownames(data)
label <- colnames(data)
bp <- barplot(data, names.arg=name, main='과일별 연간 판매량', xlab='과일명', ylab='판매량', legend.text=label, col=topo.colors(length(name)), ylim=c(0, 25), beside=T)
text(x=bp, y=data, labels=data, pos=3)

bp <- barplot(data, names.arg=name, main='과일별 연간 판매량', xlab='과일명', ylab='판매량', col=topo.colors(length(name)), ylim=c(0, 25), beside=T)
legend('topright', title='과일', legend=label, pch=15, col=c('red', 'yellow', 'purple', 'orange'), cex=0.7)

library(plotrix)
#barlabels(x축, y축, 라벨값, cex=텍스트크기, prop=라벨위치)
barlabels(bp, data, data, cex=0.8, prop=1.04)
# boxed.labels(x축, y축, 라벨값, cex=텍스트크기, border=F(테두리 없앨시), srt=회전각도, bg=배경색)
boxed.labels(bp, data, data, cex=0.8, border=F, srt=0, bg=c('red','yellow','purple', 'orange'))
#------------------------------------------------------------------------------------------------------------------------------
# pie3D에서 pie내부에 label 달기
# pie3D.labels(파이3D차트, labels=라벨명, labelrad=라벨위치(0~1), labelcex=글자크기, labelcol=색)

x1 <- c(2, 6, 9, 5)
x2 <- c(8, 10, 15, 6)
data <- rbind(x1, x2)
name <- c('영업1팀', '영업2팀', '영업3팀', '영업4팀')
label <- c('2016년', '2017년')

# beside=T: group bar chart를 만드는 옵션(T는 옆으로 붙은 바, F는 위로 붙은 바)
barplot(data, names.arg=name, main='영업팀별 실적', xlab='영업팀', ylab='판매실적(억원)', legend.text=label, col=c('darkblue', 'red'), beside=T)

# las: x축 이름을 회전하는 옵션
# 1: x: 가로 y:가로
# 2: x: 세로 y: 가로
# 3: x: 세로 y: 세로
bp <- barplot(height=data, width=0.1, names.arg=name, cex.names=0.7, horiz=F, col=rainbow(length(data)), main='부서별 총액 급여', xlab='부서이름', ylab='총 급여($)', ylim=c(0,350000), las=2)

library(plotrix)
?barlabels
#barlabels(x축, y축, 라벨값, cex=텍스트크기, prop=라벨위치)
barlabels(bp, data, data, cex=0.8, prop=1.04)
# boxed.labels(x축, y축, 라벨값, cex=텍스트크기, border=F(테두리 없앨시), srt=회전각도, bg=배경색)
boxed.labels(bp, data, data, cex=0.8, border=F, srt=0, bg=c('red','yellow','purple', 'orange'))