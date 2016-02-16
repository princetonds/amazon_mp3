##############################################
# Analyze Amazon MP3 player reviews
# Data@Night, 2016/2/15
# datasci@princeton.edu
# 
##############################################

lapply(c("data.table", "ggplot2", "tm"), require, character.only=T)

if (!exists("df.mp3")) {
  df.mp3 <- as.data.frame(fread("mp3_reviews.csv"))
  df.mp3[,c("rating", "helpfulVotesNum", "totalVotesNum")] <- apply(
    df.mp3[,c("rating", "helpfulVotesNum", "totalVotesNum")], 2, as.numeric)
  df.mp3$createDate <- as.Date(df.mp3$createDate)
  
  # convert classes
  df.mp3[,c("fullText", "reviewTitle")] <- apply(df.mp3[,c("fullText", "reviewTitle")], 2, as.character)
  df.mp3[,c("productName")] <- as.factor(df.mp3$productName)
  
  # preprocess text
  df.mp3[,c("fullText", "reviewTitle")] <- apply(df.mp3[,c("fullText", "reviewTitle")], 2, tolower)
  df.mp3[,c("fullText", "reviewTitle")] <- data.frame(gsub("&quot;", "", as.matrix(df.mp3[,c("fullText", "reviewTitle")])),
                                                      stringsAsFactors=F)
}

# Example of clustering reviews to find patterns. (Let's compare 5-star reviews to 1-star reviews.)
# PCA -> KMeans
# 1 star reviews
corpus.one.star <- Corpus(VectorSource(df.mp3$fullText[df.mp3$rating == 1]))
tdm.one.star <- TermDocumentMatrix(corpus.one.star)
tfidf.one.star <- weightTfIdf(tdm.one.star)
mat.one.star <- t(as.matrix(tfidf.one.star)) # cols=terms, rows=observations
mat.one.star <- scale(mat.one.star, center=T) # scale and center for PCA
# Run PCA
# print("Running PCA ...")
# pca.one.star <- prcomp(mat.one.star, scale=TRUE, center=TRUE)

# # run Kmeans
# print("Running KMeans ...")
# kmeans.one.stars <- kmeans(mat.one.star, centers=3)
# kmeans.one.stars.labels <- kmeans.one.stars$cluster
# df.mp3$cluster <- rep(NA, nrow(df.mp3))
# df.mp3$cluster[df.mp3$rating == 1] <- kmeans.one.stars.labels
# qplot(df.mp3$cluster)




