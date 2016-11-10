#!/usr/bin/python

import sys

print "readlib(makehelp);\n"

with open(sys.argv[1]) as f:
   lines = f.readlines()
   macro = "no macro yet"
   for line in lines:
		line = line.rstrip()
		if "help" in line:
			name = line.replace(".help", "")
			print "makehelp( %s, \"help/%s\", \"lib/maple.help\"):\n" %(name, line)	
