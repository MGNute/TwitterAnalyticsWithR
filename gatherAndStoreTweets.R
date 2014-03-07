#********************************************************
# gatherAndStoreTweets.R - A script to search for a specific string and 
#	store them in an ODBC database.
#
# Requirements:
#    -	a file called "twitCred.Rdata" stored in the working directory
#	continaing a Twitter Credentials object called "twitCred". See
#	the documentation or the twittR package for how to make this.
#    -	an ODBC database set up and ready to go (name is a string in the
#	parameters.)
#    - 	a table set up in this database that will accomodate a tweets data
#	frame perfectly. (The best way to set this up is to run the sqlSave
#	procedue at the bottom once the first time with "append=F" rather 
#	than "T" as it is there.)
#
# Recommended:
#    -	a stored procedure in the database that will dump these tweets into 
#	a larger table and remove duplicates, then clear out this table. 
#	(Mine is called "updatealltweets" and its execution at the bottom 
#	is commended out. )
#	
#********************************************************	

#setup
#setwd("C:\\") #Make this your active direction to save things, etc...
library(twitteR)
library(RODBC)

options(RCurlOptions = list(cainfo = system.file("CurlSSL", 
	"cacert.pem", package = "RCurl")))

#********************************************************
#	PARAMETERS
#
searchString<-"ThingYouWantToSearchFor lang:en" #Your search string
dbName<-"myDb" 					#the name of your OBC database
tblName<-"tblMostRecentTweets"			#the name of your tweets table

#********************************************************


load(file="twitCred.Rdata") #gets your Twitter Credentials
source("functionDefinitions.R")	#load getDateTime() function
registerTwitterOAuth(twitCred)

results<-searchTwitter(searchString,n=200)
db<-odbcConnect("dirtxtrusted")


n<-length(results)
a<-cbind(data.frame(results[[1]]$toDataFrame()[,1:4]),
	data.frame(format(results[[1]]$created,"%Y%m%d_%H%M%S"),stringsAsFactors=F),
	data.frame(results[[1]]$toDataFrame()[,6:16]))
names(a)[5]<-"created";
a$created<-as.character(a$created)
a[2,]<-cbind(data.frame(results[[2]]$toDataFrame()[,1:4]),
	data.frame(format(results[[2]]$created,"%Y%m%d_%H%M%S"),stringsAsFactors=F),
	data.frame(results[[2]]$toDataFrame()[,6:16]))

for (i in 3:n) {
a[i,]<-cbind(data.frame(results[[i]]$toDataFrame()[,1:4]),
	data.frame(format(results[[i]]$created,"%Y%m%d_%H%M%S"),stringsAsFactors=F),
	data.frame(results[[i]]$toDataFrame()[,6:16]))
}

sqlSave(db,a,tablename=tblName,nastring="NA",append=T)
#sqlQuery(db,"execute dbo.updatealltweets")
save(results,file=paste("results_",getDateTime(),".RData",sep=""))
odbcClose(db)
