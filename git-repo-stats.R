
commits <- read.csv("/tmp/commits-stats.csv", header = TRUE, sep = " ")

x <- seq(1, nrow(commits), 1)

df <- data.frame(x, commits$addedLines, commits$deletedLines, commits$modifiedFiles)

revdf <- df[rev(rownames(df)),]

library("ggplot2")

ggplot (revdf, aes(x, y=value, color=variable)) + geom_line(aes(y=commits$addedLines, col="Added Lines")) + geom_line(aes(y=commits$deletedLines, col="Deleted Lines")) + geom_line(aes(y=commits$modifiedFiles, col="Modified Files"))