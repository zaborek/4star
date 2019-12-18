# this file takes a date as an argument to produce three output pdfs
# a dvd output pdf in /outpdf/white/YYYY-MM-DD_dvd.pdf containing all dvd titles entered into system after date
# a blu-ray output pdf in /outpdf/blue/YYYY-MM-DD_bd.pdf containing all blu-ray titles entered into system after date
# a master output pdf in /outpdf/cardmaster.pdf containing all titles up to provided date
# contact author: Nick Zaborek, nick.zaborek@gmail.com

#######################################################################
# edit this to print all titles entered on or after the specified date!
#######################################################################
title_date = "2019-10-01" # must be in "YYYY-MM-DD" format
update_master = FALSE     # set to either TRUE or FALSE, to update master card set; takes a few mins to update

##### do not edit below this line!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
library(png)
library(grid)

infile = paste0(getwd(),"/cards.rds")
dat=readRDS(infile)


printcardpdf = function(dat, outfile, png.w_=.26, png.h_=.12){
  png.w = png.w_
  png.h = png.h_
  pdf(outfile, height=8.5, width=11)
  par(mfcol=c(2,2)) # fills in by column
  par(mar=c(2,1,2,1)) # bottom, left, top, right
  
  for(i in 1:nrow(dat)){
    if(nrow(dat)==0){
      plot.new()
      text(.02, .95, "NO FILES FOUND", pos=4)
      break} # break out if empty dataset...
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

# set up output file specs
outdvd = paste0(getwd(),"/outpdf/white/",title_date,"_dvd.pdf")
outbd = paste0(getwd(),"/outpdf/blue/", title_date,"_bd.pdf")
outmaster = paste0(getwd(),"/outpdf/cardmaster.pdf")

# get date and format subset indices
idx.date.dvd = which(as.Date(dat$dvd_date)>=as.Date(title_date) & dat$format=="DVD")
idx.date.bd = which(as.Date(dat$dvd_date)>=as.Date(title_date) & dat$format=="Blu-ray")

#order by title

# print dvd
cat("printing new DVDs \n ")
printcardpdf(dat[idx.date.dvd,], outdvd)

# print bd
cat("printing new Blu-rays \n ")
printcardpdf(dat[idx.date.bd,], outbd)

# print master
if(update_master){
  t = Sys.time()
  cat("Updating master card file... \n ")
  printcardpdf(dat, outbd)
  cat("printing master took ", (Sys.time() - t)/60, " minutes.\n")
}
cat("Done! \n ")
