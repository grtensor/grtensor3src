#!/usr/bin/python

import sys

with open(sys.argv[1]) as f:
   lines = f.readlines()
   macro = "no macro yet"
   macros = []
   for line in lines:
      if "macro" in line:
      	 # macro line of the form:
      	 # macro( gr = grG_ObjDef[C(dn,dn,dn,dn)]):
         line = line.replace("macro(", "")
         line = line.replace("):", "")
         line = line.replace(");", "")
         s = line.split("=")
         #print "lhs: %s rhs: %s" % (s[0], s[1])
         macro = s[0].strip()
         value = s[1].strip()
         if macro in macros:
            print "$undef %s" % macro
         else:
            macros.append(macro)
         print "$define %s %s" % (macro, value)
      else:
	     print line.rstrip()
