install.packages("tm")
library(tm)
data1 <- readLines("c:/data/오바마.txt")
data1


corp1 <- Corpus(VectorSource(data1)) # 벡터 -> corpus 변환
# DataframeSource
corp1

summary(corp1)
inspect(corp1)

corp1[[1]]
corp1[[1]]$meta
corp1[[1]]$content


## 말뭉치에서 gsub함수 사용방법

tostring <- content_transformer(function(x,from,to) gsub(from,to,x))

corp2 <- tm_map(corp1,tostring,"It’s","It is")
corp2[[1]]$content

corp2 <- tm_map(corp2,tostring,"I’ve","I have")
corp2 <- tm_map(corp2,tostring,"It’s","It is")
corp2 <- tm_map(corp2,tostring,"We’re","We are")
corp2 <- tm_map(corp2,tostring,"we’ve","We have")
corp2 <- tm_map(corp2,tostring,"don’t","do not")

#corp2 <- tm_map(corp2,tostring,"well-wishes","wellWishes")

corp2 <- tm_map(corp2,tostring,"~","")
corp2 <- tm_map(corp2,tostring,"!","")
corp2 <- tm_map(corp2,tostring,",","")
corp2 <- tm_map(corp2,tostring,"’","")
corp2 <- tm_map(corp2,tostring,";","")
corp2 <- tm_map(corp2,tostring,"?","")
corp2 <- tm_map(corp2,tostring,"\\.","")
corp2 <- tm_map(corp2,tostring,"\\(","")
corp2 <- tm_map(corp2,tostring,"\\)","")


## 말뭉치에 있는 2개 이상 연이어 있는 공백을 1개의 공백으로 변환

corp2 <- tm_map(corp2,stripWhitespace)

## 대문자를 소문자로 변환

corp2 <- tm_map(corp2,tolower)

## 숫자표현을 제거

corp2 <- tm_map(corp2,removeNumbers)


## 문장부호, 특수문자를 제거

#corp2 <- tm_map(corp2,removePunctuation)

## 불용어 등록

sword2 <- c(stopwords('en'), "and","but","not") 
corp2 <- tm_map(corp2, removeWords,sword2) # 불용어제거(전치사, 관사..)

inspect(corp2)

corp2[[1]]$content

##
#corp2 <- tm_map(corp2,PlainTextDocument)


tdm <- TermDocumentMatrix(corp2)
tdm 

m <- as.matrix(tdm)
m


freq1 <- sort(rowSums(m),decreasing=T)
head(freq1)

freq1[names(freq1)=='and']

freq2 <- sort(colSums(m),decreasing=T)
freq2
tdm2

findFreqTerms(tdm2,10)

findAssocs(tdm2,"people",0.5)


library(RColorBrewer)

palete <- brewer.pal(7,"Set3")
wordcloud(names(freq1), freq=freq1, scale=c(5,1), min.freq=1,colors=palete)
