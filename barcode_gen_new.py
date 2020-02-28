# goal is to print only those barcodes not already in /barcode_png yet still in # barcodes.txt
import barcode
import sys
from barcode.writer import ImageWriter
from os import listdir

code39 = barcode.get_barcode_class('code39')

# barcodes within existing images
existing_barcodes = [png for png in listdir("/Users/zaborek/private/projects/4star/barcode_png/")]
existing_barcodes = [code[0:8] for code in existing_barcodes]
    
# all barcode numbers
f = open("barcodes.txt","r")
barcodes = f.read().split("\n")

# keep only those without images
new_barcodes = list(set(barcodes).difference(existing_barcodes))
print(new_barcodes)

for code in new_barcodes:
    bc = code39(code, add_checksum=False, writer=ImageWriter())
    outfile = "barcode_png/"+code
    bc.save(outfile)

    
f.close()

