#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE:
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: July 16, 1994
#
#
# Purpose: grarray command
#
# Revisions:
#
# July  16, 94   Created
# July  11, 96   Now returns an array rather than assigning to the 2nd arg [dp]
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#----------------------------------------------------------
# grarray
#
# Accept a single object name and return a array
# containing that object.
#----------------------------------------------------------

grarray := proc()
local 	a, b, c, new_args, M, num,N, indices, newIndices, gname,
      	i, object, objParm, Aname:
global  grG_calc, grG_simp, grG_callComp, grG_fnCode:

     if nargs <> 1 then
       ERROR ( `A single indexed tensor name must be supplied as an argument.` ):
     else
       objParm := args[1]:
     fi:
     #
     # check that the object exists and has been calc'd
     # 
     new_args := grF_screenArgs( [objParm], true, false);
     gname := new_args[nops(new_args)-1]:
     object := new_args[nops(new_args)]:
     num := nops(object):
     N := Ndim[gname]:
     if num = 0 then
       ERROR(`Please use grcomponent for scalars.`):
     fi:
     Aname := array( seq(1..N,a=1..num)):
     #
     #
     #
     indices := seq([i],i=1..N):
     for a to num-1 do
       newIndices := NULL:
       for b to N do
         for c in indices do
          newIndices := newIndices, [op(c),b]:
         od:
       od:
       indices := newIndices:
     od:
     for a in indices do
       Aname[op(a)] := grG_||(grG_ObjDef[object][grC_root])[gname,op(a)]:
     od:
     RETURN ( eval ( Aname ) ):
end:
