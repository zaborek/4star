rm(list=ls())

library(png)
library(grid)

infile = paste0(getwd(),"/cards.rds")
dat=readRDS(infile)





printcardpdf = function(dat, outfile, png.w_=.22, png.h_=.12){
  png.w = png.w_
  png.h = png.h_
  pdf(outfile, height=8.5, width=11)
  par(mfcol=c(2,2)) # fills in by column
  par(mar=c(2,1,2,1)) # bottom, left, top, right
  
  for(i in 1:nrow(dat)){
    datt = dat[i,]
    
    
    plot.new()
    polygon(c(0,0,1,1), c(0,1,1,0), border="black", lwd=3)
    top.text = datt$genre
    if(nchar(datt$country)>0){
      top.text = paste0(top.text, " - ", datt$country)
    }
    if(datt$subtitles=="Subtitled"){
      top.text = paste0(top.text, " - ", datt$subtitles)
    }
    text(.02, .95, top.text, pos=4)
    text(.5,.77,datt$title, cex=1.28)
    text(.5,.6, paste0("Director: ", datt$director))
    text(.5,.52, paste0("Play Time: " , datt$runtime, " Minutes"))
    text(.5,.46, paste0("Year: " , datt$rel_year))
    text(.5,.38, paste0("Closed Captioned: ", datt$cc))
    text(.02, .05, datt$format, pos=4)
    
    # put in barcode
    if(nchar(datt$barcode)==8){
      pngfile = paste0('barcode_png/', datt$barcode, '.png')
      if(file.exists(pngfile)){
        mypng = readPNG(pngfile)
        
        # top left

        if(i%%4 ==1){
          grid.raster(mypng, .25, .62, width=png.w, height=png.h)
        }
        # bottom left
        else if (i%%4 == 2){
          grid.raster(mypng, .25, .12, width=png.w, height=png.h)
        }
        # top right
        else if (i%%4 == 3){
          grid.raster(mypng, .75, .62, width=png.w, height=png.h)
        }
        # bottom right
        else if (i%%4 == 0){
          grid.raster(mypng, .75, .12, width=png.w, height=png.h)
        }
      }
    }
    polygon(c(0,0,1,1), c(0,1,1,0), border="black", lwd=3)
    
    
    
    # if a multiple of 4, create new page in pdf
    if(i%%4 == 0){
      #grid.newpage()
    }
  }
  dev.off()
  
}

genres = sort(unique(dat$genre))
png.w = .26
png.h = .12
dim_ = paste0("w=",as.character(png.w),"h=",as.character(png.h))
for(genre in genres){
  cat("printing ", genre)
  cat("\n")
  outdvd = paste0(getwd(),"/outpdf/white/",tolower(genre),
                  "_dvd_", dim_, ".pdf")
  outbd = paste0(getwd(),"/outpdf/blue/",tolower(genre),
                 "_bd_", dim_, ".pdf")
  
  printcardpdf(dat[dat$genre==genre&dat$format=="DVD",],
               outdvd, png.w_ = png.w, png.h_ = png.h)
  printcardpdf(dat[dat$genre==genre&dat$format=="Blu-ray",],
               outbd, png.w_ = png.w, png.h_ = png.h)
}
cat("done \n")


#####
# print master pdf file of all videos, order by title
#####
#cat("printing master \n")
#dat = dat[order(dat$title),]
#masterout =   outbd = paste0(getwd(),"/outpdf/master_upto_20191028.pdf")
#printcardpdf(dat, masterout, png.w_ = png.w, png.h_ = png.h)

#cat("done \n")