import barcode
from barcode.writer import ImageWriter

code39 = barcode.get_barcode_class('code39')

f = open("barcodes.txt","r")
barcodes = f.read().split("\n")


for code in barcodes:
    bc = code39(code, add_checksum=False, writer=ImageWriter())
    outfile = "barcode_png/"+code
    bc.save(outfile)

    
f.close()

