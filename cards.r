setwd("/Users/zaborek/private/projects/4star") #work
filename = "TAP001_20200211.TXT"
dat= read.csv(filename)
dat[1:100,]

title = as.character(dat$X.71..71)
format = dat$DVD
barcode = dat$X.8
director = dat$X.2
runtime = dat$X
rel.year = dat$X00 + 2000
dvd.date = dat$X.12
genre = dat$SEE
cc = dat$N
cc1 = dat$N.1
subbed = as.character(dat$X.1)
loc = dat$X.16

# fix release years ##################################
dvd.date = as.character(dvd.date)
dvd.date = as.Date(dvd.date, "%m/%d/%y")
dvd.year = as.numeric(substr(dvd.date,1,4))

idx.oops = which(dvd.year < rel.year)
rel.year[idx.oops] = rel.year[idx.oops]-100


# fix sub and country information #####################
idx.sub = grep(pattern="\\*S", subbed)

country.info = trimws(gsub("(\\.|\\*|\\d).*", "", subbed[idx.sub]))
country.info = gsub(",\\s", "/", country.info)
country.info = gsub("/\\s", "/", country.info)
country.info[which(nchar(country.info)<2)] = ""

sub.info = country = rep("", nrow(dat))
sub.info[idx.sub] = "Subtitled"
country[idx.sub] = country.info




# location = 1 only!!!, final cost, make sure unique pages



dat = list(title, genre, format, barcode, director, runtime, rel.year, dvd.year, dvd.date, cc, cc1, country, sub.info, loc)
dat=lapply(dat, as.character)

dat = data.frame(matrix(unlist(dat), nrow=length(dat[[1]]), byrow=F), stringsAsFactors = F)
colnames(dat) = c("title", "genre","format", "barcode", "director",
                  "runtime", "rel_year", "dvd_year", "dvd_date", "cc", "cc1", "country", "subtitles", "location")

# modify to "" if NA for datt$country
idx.na = which(is.na(dat$country))
dat$country[idx.na] = ""
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

#cleaners:
idx.cln = which(dat$genre == "CLN")
dat = dat[-idx.cln,]

# update 20191216
# create dataset of for sale but renewed titles with loc=2 but no Z
dat.sale = dat[which(dat$loc==2),]

# location ne 1
idx.eq1 = which(dat$loc ==1)
dat = dat[idx.eq1,]

# add two leading zeros barcode scanning
dat$barcode = paste0("00", dat$barcode)
dat.sale$barcode = paste0("00", dat.sale$barcode)


# Edit genre info to be full
dat$genre[dat$genre=="A"] = "Action"
dat$genre[dat$genre=="C"] = "Comedy"
dat$genre[dat$genre=="D"] = "Drama"
dat$genre[dat$genre=="DR6"] = "Drama"
dat$genre[dat$genre=="E"] = "Documentary"
dat$genre[dat$genre=="EFR"] = "Documentary"
dat$genre[dat$genre=="F"] = "Foreign"
dat$genre[dat$genre=="H"] = "Horror"
dat$genre[dat$genre=="J"] = "Juvenile"
dat$genre[dat$genre=="M"] = "Music"
dat$genre[dat$genre=="Q"] = "Silent"
dat$genre[dat$genre=="R"] = "Television"
dat$genre[dat$genre=="S"] = "Science Fiction"
dat$genre[dat$genre=="T"] = "Anime"
dat$genre[dat$genre=="V"] = "Mystery"
dat$genre[dat$genre=="W"] = "Western"

dat.sale$genre[dat.sale$genre=="A"] = "Action"
dat.sale$genre[dat.sale$genre=="C"] = "Comedy"
dat.sale$genre[dat.sale$genre=="D"] = "Drama"
dat.sale$genre[dat.sale$genre=="DR6"] = "Drama"
dat.sale$genre[dat.sale$genre=="E"] = "Documentary"
dat.sale$genre[dat.sale$genre=="EFR"] = "Documentary"
dat.sale$genre[dat.sale$genre=="F"] = "Foreign"
dat.sale$genre[dat.sale$genre=="H"] = "Horror"
dat.sale$genre[dat.sale$genre=="J"] = "Juvenile"
dat.sale$genre[dat.sale$genre=="M"] = "Music"
dat.sale$genre[dat.sale$genre=="Q"] = "Silent"
dat.sale$genre[dat.sale$genre=="R"] = "Television"
dat.sale$genre[dat.sale$genre=="S"] = "Science Fiction"
dat.sale$genre[dat.sale$genre=="T"] = "Anime"
dat.sale$genre[dat.sale$genre=="V"] = "Mystery"
dat.sale$genre[dat.sale$genre=="W"] = "Western"



#edit format to be blu ray not bd
dat$format[dat$format=="BD"] = "Blu-ray"
dat.sale$format[dat.sale$format=="BD"] = "Blu-ray"

#edit Y to Yes and N to NO
dat$cc[dat$cc=="N"] = "No"
dat$cc[dat$cc=="Y"] = "Yes"

dat.sale$cc[dat.sale$cc=="N"] = "No"
dat.sale$cc[dat.sale$cc=="Y"] = "Yes"


outfile = paste0(getwd(),"/cards.rds")
saveRDS(dat, file = outfile)

# already ran this, no need to do again.
# outfile2 = paste0(getwd(),"/cards_sale.rds")
# saveRDS(dat.sale, file = outfile2)


# get existing barcodes
bc = read.table(paste0(getwd(),"/barcodes.txt"), colClasses = "character")
bcnew = dat$barcode[!(dat$barcode %in% bc[,1])]

# save new barcodes to txt for python to read
if(length(bcnew)>0){
write.table(bcnew, "barcodes_new.txt", sep="",
            row.names = F, col.names = F, quote=F)
}
# write all barcodes to barcodes.txt
write.table(dat$barcode, "barcodes.txt", sep="",
            row.names = F, col.names = F, quote=F)

