rm(list=ls())

library(png)
library(grid)

infile = paste0(getwd(),"/cards.rds")
dat=readRDS(infile)

dat = dat[81:90,]

pdf("out.pdf", height=8.5, width=11)
par(mfcol=c(2,2)) # fills in by column
par(mar=c(2,1,2,1)) # bottom, left, top, right

for(i in 1:nrow(dat)){
  datt = dat[i,]
  
  
  plot.new()
  polygon(c(0,0,1,1), c(0,1,1,0), border="black", lwd=3)
  text(.02, .95, "Documentary", pos=4)
  text(.5,.8,datt$title, cex=1.2)
  text(.5,.6, paste0("Director: ", datt$director))
  text(.5,.5, paste0("Runtime: " , datt$runtime, " Minutes"))
  text(.5,.4, paste0("Closed Caption: ", datt$cc))
  text(.02, .05, datt$format, pos=4)
  
  # put in barcode
  if(nchar(datt$barcode)==8){
    pngfile = paste0('barcode_png/', datt$barcode, '.png')
    if(file.exists(pngfile)){
      mypng = readPNG(pngfile)
      
      # top left
      if(i%%4 ==1){
      grid.raster(mypng, .25, .62, width=.1)
      }
      # bottom left
      else if (i%%4 == 2){
        grid.raster(mypng, .25, .12, width=.1)
      }
      # top right
      else if (i%%4 == 3){
        grid.raster(mypng, .75, .62, width=.1)
      }
      # bottom right
      else if (i%%4 == 0){
        grid.raster(mypng, .75, .12, width=.1)
      }
    }
  }
  
  
  
  # if a multiple of 4, create new page in pdf
  if(i%%4 == 0){
    #grid.newpage()
  }
}



dev.off()