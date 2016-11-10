#==============================================================================
# killing.mpl - functions for Killing vectors
#
# Revisions
# 24 June 1996	Created from Killing library.
#
#==============================================================================

#------------------------------------------------------------------------------
# KillingCoords( <metric> )
#------------------------------------------------------------------------------

KillingCoords := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local  a, gname, N, root, b, value, dispSeq, calcSeq:
global gr_data, grG_metricName:

 printf(`Testing Killing coordinates for %a\n`,grG_default_metricName):

 gname := grG_metricName:
 N := Ndim[gname]:

 #
 # for each coord vector
 #
 calcSeq := NULL:
 for a to N do
   root := grG_ObjDef[(coord||a)(up)][grC_root]:
   for b to N do
     value := 0:
     if a = b then
       value := 1:
     fi:
     gr_data[root,gname,b] := value:
   od:
   calcSeq := calcSeq, KillingTest[ coord||a]:
 od:
 grcalc( calcSeq):
 #
 # since we know these vectors will fit on a line, do this
 # pretty printing
 #
 print(`Killing Coordinate Test Results`):
 print(`Coordinate vector ` = [seq( gr_data[xup_,gname,b], b=1..N)]):
 for a to N do
     print(coord||a(up) = [seq( gr_data[coord||a||up_,gname,b], b=1..N)],
             gr_data[KillingTest_,gname, coord||a]);
 od:

end:

#==============================================================================