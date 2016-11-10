#!/usr/bin/python

import sys
import re

def gr_data(line):
   nline = line
   # want grG_XXX_[ => gr_data[ 
   match = True
   while match:
      m = re.search("grG_(\w+)\[", nline)
      if m:
            nline = nline.replace(m.group(0), "gr_data[%s," % m.group(1))
      else:
         match = False
         m = re.search("grG_\.(\w+)\[", nline)
         if m:
            nline = nline.replace(m.group(0), "gr_data[%s," % m.group(1))
            match = True
   return nline

with open(sys.argv[1]) as f:
   lines = f.readlines()
   macro = "no macro yet"
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

         if macro == "gr":
         	# for object defintions get lots of false matches on 'gr'
         	macro = "gr["
         	value = value + "["
      else:
         if macro in line:
            line = line.replace(macro, value)
         else:
            line = line.replace("Ndim||grG_metricName", "Ndim[grG_metricName]")
            if not "ObjDef" in line and  "multipleDef" not in line:
               line = gr_data(line)
         print line.rstrip()



