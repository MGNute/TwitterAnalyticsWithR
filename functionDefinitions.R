getDateTime<-function() {
	dt<-format(Sys.Date(),"%Y%m%d_")
	tm<-format(Sys.time(),"%H%M%S")
	getDateTime<-paste(dt,tm,sep="")
}