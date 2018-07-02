#!/usr/bin/python3
import sys

file_to_read = str(sys.argv[1])

if (len(sys.argv) < 3):
	file_to_write = file_to_read + ".data"
else:
	file_to_write = str(sys.argv[2])


machinefile = open(file_to_write, "w")
asmfile		= open(file_to_read, "r")

text = asmfile.read()

text = text.replace(" ", "")

text = text.replace("NOP","0")
text = text.replace("LA","1")
text = text.replace("SA","2")
text = text.replace("LC","3")
text = text.replace("RIO","4")
text = text.replace("WIO","5")
text = text.replace("ADD","6")
text = text.replace("SUB","7")
text = text.replace("NOT","8")
text = text.replace("XOR","a")
text = text.replace("OR","9")
text = text.replace("AND","b")
text = text.replace("LSH","c")
text = text.replace("RSH","d")
text = text.replace("JMP","e")
text = text.replace("BZ","f")

machinefile.write(text)