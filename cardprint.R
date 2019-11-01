rm(list=ls())

library(png)
library(grid)

infile = paste0(getwd(),"/cards.rds")
dat=readRDS(infile)





printcardpdf = function(dat, outfile){
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
        png.w = .17
        if(i%%4 ==1){
          grid.raster(mypng, .25, .62, width=png.w)
        }
        # bottom left
        else if (i%%4 == 2){
          grid.raster(mypng, .25, .12, width=png.w)
        }
        # top right
        else if (i%%4 == 3){
          grid.raster(mypng, .75, .62, width=png.w)
        }
        # bottom right
        else if (i%%4 == 0){
          grid.raster(mypng, .75, .12, width=png.w)
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

for(genre in genres){
  cat("printing ", genre)
  cat("\n")
  outdvd = paste0("/outpdf/",tolower(genre),"_dvd.pdf")
  outbd = paste0("/outpdf/",tolower(genre),"_bd.pdf")
  
  printcardpdf(dat[dat$genre==genre&dat$format=="DVD",], outdvd)
  printcardpdf(dat[dat$genre==genre&dat$format=="Blu-ray",], outbd)
}
cat("done")
