library(twitteR)
library(urltools)
library(stringr)
library(httr)
library(XML)
library(stringr)
library(RCurl)
library(rJava)
api_key <- "iXMW1rNmQcPSFjSrrPs16eDZB"
api_secret <- "cQo5ZC1zBtSRlVHWpNg9sDXObJxIjPOpjYzRFKl4x6Vb4itHSO"
access_token <- "2602353553-rOdV0CQIGrYXAEZ5QhSDk21OhjpBtVE6m3aCRIJ"
access_token_secret <- "yTUozNUqYdXjq9UbfDXoDhxv6vCOosJAcWLU6jb57sAVd"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
genre<-c("Acoustic","Alternative & Punk","Blues","Classical","Country & Folk","Dance & Electronic","Easy Listening", "Gospel & Religious", "Hip Hop & Rap", "Holiday", "Jazz","Latin","Metal","Moods","Other","Pop","R&B","Rock","Soundtrack","World")
User<-"RaedAyari"
tweets <- userTimeline(User, n=100)
length(tweets)
tweetdf <- twListToDF(tweets)
#liste des tweets
t<-tweetdf['text']

#retweeted?
rt<-tweetdf['retweeted']

#the number of retweets
retweetnumber<-tweetdf['retweetCount']

#checking if it is a link
j<-0
 for(i in 1:nrow(t))
 {
  j<-j+1
  posts[j]<-as.character(t[i,1])
  exist[j]<-url.exists(t[i,1])
 }
#turning posts into dataframes
Posts<-data.frame(posts)
isLink<-data.frame(exist)
SongCategory<-NULL

#getting the name of the song, the artist and the category
for(i in 1:nrow(t)){
  information<-NULL
information
  if(exist[i]==TRUE){
    r<-GET(posts[i])
    f<-content(r, "text")
    parsedHtml=htmlParse(f,asText = TRUE)
    title.xml <- xpathSApply(parsedHtml,"//span[@id='eow-title']",xmlValue)
    information<-unlist(strsplit(title.xml[1],"-"))
    information[1]
    information[2]
    song<-unlist(strsplit(information[2],"[-(.[)]"))
    song[1]
    Artist[i]<-str_extract(information[1], "[A-Z].*")
    songName[i]<-song[1]
   songName[i]
    genre.xml<-xpathSApply(parsedHtml,"//meta[@property='og:video:tag']",xmlGetAttr, "content")
    if (length(genre.xml)>0){
    for(j in 1:length(genre.xml)){
      
      if((genre.xml[j] %in% genre)==TRUE){
        SongCategory[i]<-genre.xml[j]  
      }
    } 
    }
  }
  }

SongCategories<-data.frame(SongCategory)
#filling the rows by the user name 
user<-NULL
for(i in 1:nrow(t)){
  user[i]<-User
}
#saving data into dataframes
users<-data.frame(user)
songNames<-data.frame(songName)
songNames
Artists<-data.frame(Artist)
Artists
#defining the columns names
col.names = c("user", "posts","exist","songName","Artist", "Category")

#binding all the data together 
FinalData<-data.frame(users,Posts,isLink,songNames,Artists,SongCategories)
FinalData
#saving data into csv file 
write.csv(FinalData, file = "TwitterData.csv")









