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
}

