##############################################
# Analyze Amazon MP3 player reviews
# Data@Night, 2016/2/15
# datasci@princeton.edu
# 
##############################################

lapply(c("data.table", "ggplot2"), require, character.only=T)

if (!exists("df.mp3")) {
  df.mp3 <- as.data.frame(fread("mp3_reviews.csv"))
  df.mp3[,c("rating", "helpfulVotesNum", "totalVotesNum")] <- apply(
    df.mp3[,c("rating", "helpfulVotesNum", "totalVotesNum")], 2, as.numeric)
  df.mp3$createDate <- as.Date(df.mp3$createDate)
  
  # convert classes
  df.mp3[,c("fullText", "reviewTitle")] <- apply(df.mp3[,c("fullText", "reviewTitle")], 2, as.character)
  df.mp3[,c("productName")] <- as.factor(df.mp3$productName)
  
  # preprocess text
  require(qdap)
  df.mp3[,c("fullText", "reviewTitle")] <- apply(df.mp3[,c("fullText", "reviewTitle")], 2, tolower)
  df.mp3[,c("fullText", "reviewTitle")] <- data.frame(gsub("&quot;", "", as.matrix(df.mp3[,c("fullText", "reviewTitle")])),
                                                      stringsAsFactors=F)
  
  # remove stopwords (leave out if you want the raw review text)
  f_remove_stopwords <- function(x) {
    return(paste(rm_stopwords(x, unlist=T, strip=T, apostrophe.remove=T), collapse=" "))
  }
  df.mp3$fullText <- as.character(sapply(df.mp3$fullText, f_remove_stopwords))
  df.mp3$reviewTitle <- as.character(sapply(df.mp3$reviewTitle, f_remove_stopwords))
}



