TwitterAnalyticsWithR
=====================

Experimenting with the twittR package and Analytics


gatherAndStoreTweets.R
---------------------
A script to search for tweets containing a specific string and store them in an ODBC database. Since searches are capped out in quantity, this allows us to build a training set to do analysis with.

functionDefinitions.R
---------------------
Right now just one convenient function to reformat a date as a string in the form "YYYYMMDD_hhmmss"
