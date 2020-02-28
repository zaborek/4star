# prints list of titles to file
setwd("/Users/zaborek/private/projects/4star")
infile = paste0(getwd(),"/cards.rds")
dat=readRDS(infile)

tmp = dat[dat$genre=="Foreign", c("country", "title", "barcode")]

tmp = tmp[do.call(order,tmp),]

tmp$country[tmp$country==""] = "Unknown Country"


write.csv(tmp, file="foreign_titles.csv",row.names = F)