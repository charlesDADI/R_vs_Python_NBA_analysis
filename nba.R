setwd("/home/charles-abner/works/R/R_Nba/")

##Read in a csv file
nba <- read.csv("nba_2013.csv")

##Find the number of players
dim(nba)

##Look at the first row of the data
head(nba, 1)

##Find the average of each statistic
sapply(nba, mean, na.rm=TRUE)

##Make pairwise scatterplots
library(GGally)
ggpairs(nba[,c("ast", "fg", "trb")])

##Make clusters of the players
library(cluster)
set.seed(1)
isGoodCol <- function(col){
  sum(is.na(col)) == 0 && is.numeric(col) 
}
goodCols <- sapply(nba, isGoodCol)
clusters <- kmeans(nba[,goodCols], centers=5)
labels <- clusters$cluster

##Plot players by cluster
nba2d <- prcomp(nba[,goodCols], center=TRUE)
twoColumns <- nba2d$x[,1:2]
clusplot(twoColumns, labels)

##Split into training and testing sets
trainRowCount <- floor(0.8 * nrow(nba))
set.seed(1)
trainIndex <- sample(1:nrow(nba), trainRowCount)
train <- nba[trainIndex,]
test <- nba[-trainIndex,]


##Univariate linear regression
fit <- lm(ast ~ fg, data=train)
predictions <- predict(fit, test)

##Calculate summary statistics for the model
summary(fit)

##Fit a random forest model
library(randomForest)
predictorColumns <- c("age", "mp", "fg", "trb", "stl", "blk")
rf <- randomForest(train[predictorColumns], train$ast, ntree=100)
predictions <- predict(rf, test[predictorColumns])

##Calculate error
mean((test["ast"] - predictions)^2)

##Download a webpage
library(RCurl)
url <- "http://www.basketball-reference.com/boxscores/201506140GSW.html"
data <- readLines(url)

##

library(rvest)
page <- read_html(url)
table <- html_nodes(page, ".stats_table")[3]
rows <- html_nodes(table, "tr")
cells <- html_nodes(rows, "td a")
teams <- html_text(cells)

extractRow <- function(rows, i){
  if(i == 1){
    return
  }
  row <- rows[i]
  tag <- "td"
  if(i == 2){
    tag <- "th"
  }
  items <- html_nodes(row, tag)
  html_text(items)
}

scrapeData <- function(team){
  teamData <- html_nodes(page, paste("#",team,"_basic", sep=""))
  rows <- html_nodes(teamData, "tr")
  lapply(seq_along(rows), extractRow, rows=rows) 
}

data <- lapply(teams, scrapeData)

##

##

##

##

