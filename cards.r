filename = "TAP001.TXT"
dat= read.csv(filename)
dat[1:100,]

title = dat$X.71..71
format = dat$DVD
barcode = dat$X.8
director = dat$X.2
runtime = dat$X
dvd.date = dat$X.12
genre = dat$SEE


dat = list(title, genre, format, barcode, director, runtime, dvd.date)
dat=lapply(dat, as.character)

dat = data.frame(matrix(unlist(dat), nrow=length(dat[[1]]), byrow=F))
colnames(dat) = c("title", "genre","format", "barcode", "director", "runtime", "dvd_date")
dat[988:1100,]
