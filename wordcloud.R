library(tm)
library(RColorBrewer)
library(wordcloud)
library(jsonlite) # Using the jsonlite version of fromJSON()

raw_data <- fromJSON(txt = "") # file location

# Using tm to convert to corpus and perform preprocessing
text.corpus <- VCorpus(VectorSource(raw_data$text))
text.corpus <- tm_map(text.corpus, removePunctuation)
text.corpus <- tm_map(text.corpus, content_transformer(tolower))
text.corpus <- tm_map(text.corpus, function(x) removeWords(x, stopwords("english")))
text.corpus <- tm_map(text.corpus, function(x) removeWords(x, "amp"))
text.corpus <- tm_map(text.corpus, function(x) removeWords(x, "realdonaldtrump"))

# Turning into TDM 
tdm <- TermDocumentMatrix(text.corpus)
m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
pal <- brewer.pal(9, "YlOrRd")

#Defining the output file
png("wordcloud.png", width=3840, height=2160, units="px")

#Creating wordcloud
wordcloud(d$word, d$freq, scale=c(25,1), 
          min.freq=5, max.words=25, random.order=T, 
          rot.per=.25, colors=pal,  vfont=c("sans serif","plain"))

#Closing output file
dev.off()
