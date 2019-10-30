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
cc = dat$N
cc1 = dat$N.1


dat = list(title, genre, format, barcode, director, runtime, dvd.date, cc, cc1)
dat=lapply(dat, as.character)

dat = data.frame(matrix(unlist(dat), nrow=length(dat[[1]]), byrow=F))
colnames(dat) = c("title", "genre","format", "barcode", "director",
                  "runtime", "dvd_date", "cc", "cc1")


# remove records:
#sold:
idx.sold = which(dat$genre %in% c("Z", "ZDA", "ZDC", "ZDD", "ZDE", "ZDF", "ZDR", "ZDS", "ZDV"))
dat = dat[-idx.sold,]

#goto:
idx.goto = which(dat$genre == "SEE")
dat = dat[-idx.goto,]

#pornos:
idx.porno = which(dat$genre == "X")
dat = dat[-idx.porno,]



