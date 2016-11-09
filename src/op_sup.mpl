#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: op_sup.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: June 8, 94
#
#
# Purpose: Operator support routines
#
# Revisions:
#
# Aug  6, 1994  Fixed grF_expandOperands bug [pm]
# Sep 23, 1994  expandOperands now sets grG_operands [pm]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#----------------------------------------------------------
# grF_isIndexed
#
# Return true if the object passed in is indexed
# (i.e. R[xxx](dn,dn) or R[xxx] )
#----------------------------------------------------------

grF_isIndexed := proc( objectParm)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

 ( type( objectParm, function) and type( op(0,objectParm),indexed) ) or
       type( objectParm, indexed);

end:

#----------------------------------------------------------
# grF_objectName
#
# Return the object without stuff in []'s
#----------------------------------------------------------

grF_objectName := proc( objectParm)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

 if grF_isIndexed( objectParm) then

   if type( objectParm, function) then
       op(0, op(0,objectParm))(op(objectParm));
   else
       op(0,objectParm);
   fi:
 else
   objectParm;
 fi:

end:

#----------------------------------------------------------
# grF_objectOperands
#
# Return the stuff in the []'s
#----------------------------------------------------------

grF_objectOperands := proc( objectParm)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

 if grF_isIndexed( objectParm) then
   if type( objectParm, function) then
     op(op(0, objectParm)): # strip off any functional args
   else
     op(objectParm):
   fi:
 else
   NULL;
 fi:

end:

#----------------------------------------------------------
# grF_expandOperands
#
# - build an operand sequence i.e. given Jump[g(dn,dn),Mint=schw]
# (with Mext taken from the global & equal to rw) return:
#
#   g(dn,dn), schw, rw
#   (according to order in operand list)
#
# ASSIGNS THE GLOBAL OPERAND VARIABLES (INCLUDING grG_metricName)
# (i.e. grG_object etc. )
#
# - if objects are themselves indexed, put in the correct
#   values
#
#----------------------------------------------------------

grF_expandOperands := proc( objectParm )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local a, objOperands, objectName, notDone, subSeq, opList,
      opSeq, returnVal, operands, b:

global grG_metricName, grG_operands:

 if grF_isIndexed( objectParm) then
   #
   # need to scan through the indices and expand them into
   # a sequence
   #
   objectName := grF_objectName( objectParm):
   objOperands := grF_objectOperands( objectParm):

   # sanity check
   if not assigned( grG_ObjDef[objectName][grC_root]) then
     ERROR(`Internal error - no definition for `,objectName):
   fi:

   #
   # are operands designated for this object ?
   #
   if assigned( grG_ObjDef[objectName][grC_operandSeq] ) then
     operands := grG_ObjDef[objectName][grC_operandSeq]:
     #
     # check all equations have legitamite left hand sides
     # and build a sequence of them
     #
     subSeq := NULL:
     for a in [objOperands] do
       if type(a,equation) then
         if not member( lhs(a), {operands}) then
           ERROR(a, ` is not a valid operand for `, objectName):
         fi:
         subSeq := subSeq, a:
       fi:
     od:
     opList := subs( subSeq, [operands]):
     #
     # SET UP DEFAULTS AS EQUATIONS
     #
     # absorb default operands until the first equation is reached
     #
     a := 1:
     while a <= nops([objOperands]) and
           not type( op(a, [objOperands]), equation) do
       subSeq := op(a, [operands]) = op(a, [objOperands]), subSeq:
       a := a + 1:
     od:
     opList := subs( subSeq, opList):
     #
     # now build a list of defaults and sub them in
     #
     notDone := {op(opList)} intersect {operands}:
     subSeq := NULL:
     for a in notDone do
       if not assigned( grG_default_||a) then
         ERROR(`No default value for operand `, a):
       else
         subSeq := a=grG_default_||a, subSeq:
       fi:
     od:
     opList := subs( subSeq, opList):
     #
     # check if any of the resulting operands are themselves
     # indexed. If so use recursive calls to flesh them out
     #
     opSeq := NULL:
     for a to nops(opList) do

       if grF_isIndexed( opList[a]) then
         #
         # need to expand this one recursivly
         #
         opSeq := opSeq, grF_expandOperands(opList[a]):
       else
         opSeq := opSeq, opList[a]:
       fi:
       #
       # assign the globals
       #
       b := op( a, [operands]):
       grG_||b := opList[a]:
     od:
     grG_operands := opSeq:
     returnVal := objectName[opSeq]:

   else
     #
     # no operands defined, so it must be a metricName
     #
     if not member( objOperands, grG_metricSet) then
       ERROR( objOperands, ` is not a valid metric`):
     fi:
     grG_metricName := objOperands:
     returnVal := objectName:
   fi:

 else
   returnVal := objectParm:
 fi:

 returnVal;

end:



#----------------------------------------------------------
# grF_findBaseObject
#
# Used to resolve objects which involve nested operators
# and provide the caller with information on the underlying
# object, and the operands to be used for the assignment.
#
# e.g. If Jump is passed the object Box[R(dn,dn)] it
#      tells the caller that the base object is R(dn,dn).
#
#----------------------------------------------------------

grF_findBaseObject := proc( objectParm)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local obj, objOperands,a, operandSeq, newObject:

global object:

 if not grF_isIndexed( objectParm) then
    RETURN(objectParm):

 else
   #
   # keep digging through indexed objects until we find
   # the root object
   #
   obj := objectParm:
   while grF_isIndexed( obj) do
     #
     # Pull apart the name
     #
     if type( obj, function) then
        objOperands := op(op(0, obj)): # strip off any functional args
        obj := op(0, op(0,obj))(op(obj)):
     else
        objOperands := op(obj):
        obj := op(0,obj):
     fi:
     #
     # now we know the name of this indexed object, but
     # we want to know if it has an operand object
     #
     operandSeq := grG_ObjDef[obj][grC_operandSeq]:
     if has ([operandSeq], object) then
       #
       # now need to find object entry in objOperands
       # either it's in the form of object= (rare) or
       # its position is based on default
       #
       newObject := NULL:
       for a in [objOperands] do
         if type(a, equation) then
           if lhs(a) = object then
              newObject := rhs(a):
           fi:
         fi:
       od:
       if newObject = NULL then
         #
         # so it wasn't an equation, so its position in
         # objOperands should correspond to it's position in
         # the operandSeq record
         #
         a := 1:
         while (op(a,[operandSeq]) <> object) and (a <= nops(operandSeq)) do
            print( op(a,[operandSeq]) <> object, a):
            a := a + 1
         od:
         newObject := op(a,[objOperands]):
       fi:
       obj := newObject:

     else
       ERROR(`grF_findBaseObject( `,obj,`) does not have operand <object>`):
     fi:
   od:
   RETURN(obj):
 fi:

end:


