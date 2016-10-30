#==============================================================================
# diffop.mpl - Differential operators
#
# File Created By: Peter Musgrave
#            Date: May 7, 1994
#
# [Parts of this file previously made up the independent diffop library.]
#
# Revisions:
# May   7, 94    Created. Define D[].
# May  10, 94    Added Box and LieD
# May  16, 94    Box -> CDsq. Added proper box.
# June  9, 94    Heirarchy
# July  2, 94    Fix typo in Dsq
# Oct  12, 94    Fix BOX error in depends
# June  5, 96    Incorporated in grii.m, added NP operators Dl,...,Dmbar. [dp]
# Sept 16, 96    Corrected LieD formula [dp]
#==============================================================================

macro( gname = grG_metricName):

#------------------------------------------------------------------------------
# LieD - Lie derivative
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LieD]):
gr[grC_header] := ` LieD{vector} <Object>`:
gr[grC_root] := LieD_:
gr[grC_rootStr] := `LieD `:
gr[grC_calcFn] := grF_calc_LieD:
gr[grC_operandSeq] := vector,object:
# take on the symmetry and index list of the operand#
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
gr[grC_depends] := {grG_object, grG_vector(up)}:

grF_calc_LieD := proc( object, iList)
local  a, b, c, s, vRoot, tRoot, newList, indexList, iSeq, vIndex, dIndex,
       i1, i2, i3, i4, i5, i6, tsign:

 tRoot := grG_||(grG_ObjDef[ grG_object][grC_root]):
 vRoot := grG_||(grG_ObjDef[ grG_vector(up)][grC_root]):
 indexList := grG_ObjDef[ grG_object][grC_indexList]:
 if nops(indexList) > 6 then
   ERROR(`LieD only allows up to six indices`):
 fi:

 # build a seq of listing indices
 iSeq := seq(i||a, a=1..nops(iList) ):

 # do the initial sum
 s := 0:
 for a to Ndim[gname] do
   s := s + diff( tRoot[gname,op(iList)], grG_xup_[gname,a]) *
            vRoot[gname,a]:
 od:

 # now do a term for each listing index
 for a to nops(iList) do
   # build a sequence with the loop variable b in the appropriate place
   b := 'b': # unassign from previous loop
   newList := subs( i||a = b, [iSeq]):
   # sub in the remaining listing indices
   for c to nops(iList) do
     newList := subs( i||c = iList[c], newList):
   od:
   # now determine which type of contraction to perform
   if has( indexList[a], {cup,up}) then
     vIndex := a||a||_:
     dIndex := b:
     tsign := -1:
   elif has( indexList[a], {cdn,dn}) then
     dIndex := a||a||_:
     vIndex := b:
     tsign := 1:
   else
     ERROR(`Unsupported index type in LieD`):
   fi:

   for b to Ndim[gname] do
     s := s + tsign*tRoot[gname, eval(op(newList))] *
          diff( vRoot[gname,eval(vIndex)], grG_xup_[gname,eval(dIndex)]):
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# Box
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Box]):
gr[grC_header] := ` CoD{a} CoD{^a} <Object>`:
gr[grC_root] := Box_:
gr[grC_rootStr] := `Box `:
gr[grC_calcFn] := grF_calc_Box:
gr[grC_operandSeq] := object:
# take on the symmetry and index list of the operand
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
gr[grC_depends] := grF_Box_depends:

grF_Box_depends := proc( object)
local dependsOn:
 if type(grG_object, function) then
   dependsOn := {op(0,grG_object)(op(grG_object),cdn,cdn) }:
 else
   dependsOn := {grG_object(cdn,cdn)}:
 fi:
 RETURN(dependsOn):
end:

grF_calc_Box := proc( object, iList)
local s, a, b, root, newObject:
 # object to operate on is kept in grG_object, but we
 # need to add a cdn index to it
 newObject := op(grF_Box_depends( object)):
 root := grG_||(grG_ObjDef[newObject][grC_root]):

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + grG_gupup_[gname,a,b] * root[gname,op(iList),a,b]:
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# Dl - NP operator: l^a grad_a
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Dl]):
gr[grC_header] := ` Dl[<object>]`:
gr[grC_root] := Dl_:
gr[grC_rootStr] := `Dl`:
gr[grC_calcFn] := grF_calc_NPD:
gr[grC_calcFnParms] := 1:
gr[grC_operandSeq] := object:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dn - NP operator: n^a grad_a
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Dn]):
gr[grC_header] := ` Dn[<object>]`:
gr[grC_root] := Dn_:
gr[grC_rootStr] := `Dn`:
gr[grC_calcFn] := grF_calc_NPD:
gr[grC_calcFnParms] := 2:
gr[grC_operandSeq] := object:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dm - NP operator: m^a grad_a
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Dm]):
gr[grC_header] := ` Dm[<object>]`:
gr[grC_root] := Dm_:
gr[grC_rootStr] := `Dm`:
gr[grC_calcFn] := grF_calc_NPD:
gr[grC_calcFnParms] := 3:
gr[grC_operandSeq] := object:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dmbar - NP operator: mbar^a grad_a
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Dmbar]):
gr[grC_header] := ` Dmbar[<object>]`:
gr[grC_root] := Dmbar_:
gr[grC_rootStr] := `Dmbar`:
gr[grC_calcFn] := grF_calc_NPD:
gr[grC_calcFnParms] := 4:
gr[grC_operandSeq] := object:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

# Returns the derivative of `object'. The type of derivative is specified
# by `dtype'. Thus:   grF_dObject ( R(dn,dn), cdn ) --->  R(dn,dn,cdn)
#
grF_dObject := proc ( object, dtype ) 
  if type ( object, function ) then
    RETURN( op(0,object)(op(object),dtype) ):
  else
    RETURN( object(dtype) ):
  fi:
end:

grF_calc_NPD := proc ( object, iList )
local Dobj, DobjRoot, idxList, Didx, ops:

  Dobj := grF_dObject ( grG_object, pbdn ):
  DobjRoot := grG_||(grG_ObjDef[Dobj][grC_root]):
  idxList := op(grG_ObjDef[grG_object][grC_indexList]):
  Didx := grG_ObjDef[object][grC_calcFnParms]:
  ops := grF_objectOperands ( grG_object ):

  RETURN( DobjRoot[grG_metricName,ops,idxList,Didx] ):
end:

#------------------------------------------------------------------------------
# Dsq
#                                    ab
# For a scalar operand X calculate  g  X,a X,b
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Dsq]):
gr[grC_header] := ` g{^a ^b} X{,a} X{,b}`:
gr[grC_root] := Dsq_:
gr[grC_rootStr] := `Dsq `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Dsq:
gr[grC_calcFnParms] := grG_Dsq_:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := object:
gr[grC_depends] := { grG_object}:

grF_calc_Dsq := proc( object, iList)
local s, a, b, root, operand:
 # object to operate on is kept in grG_object
 root := grG_||(grG_ObjDef[grF_objectName( grG_object)][grC_root]):
 operand := root[ grG_metricName, grF_objectOperands( grG_object )]:

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + grG_gupup_[gname,a,b] *
          diff( operand, grG_xup_[gname,a]) *
          diff( operand, grG_xup_[gname,b]):
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# CDsq
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[CDsq]):
gr[grC_header] := ` CoD{a} <Object> CoD{^a} <Object>`:
gr[grC_root] := CDsq_:
gr[grC_rootStr] := `CDsq `:
gr[grC_calcFn] := grF_calc_CDsq:
gr[grC_operandSeq] := object:
#
# take on the symmetry and index list of the operand
#
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
#
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
#
gr[grC_depends] := grF_CDsq_depends:

grF_CDsq_depends := proc( object)
local dependsOn:
 if type(grG_object, function) then
   dependsOn := {op(0,grG_object)(op(grG_object),cdn) }:
 else
   dependsOn := {grG_object(cdn)}:
 fi:
 RETURN(dependsOn):
end:

grF_calc_CDsq := proc( object, iList)
local s, a, b, root, newObject:
 # object to operate on is kept in grG_object, but we
 # need to add a cdn index to it
 newObject := op(grF_CDsq_depends( object)):
 root := grG_||(grG_ObjDef[newObject][grC_root]):

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + grG_gupup_[gname,a,b] *
            root[gname,op(iList),a] *
            root[gname,op(iList),b]:
   od:
 od:
 RETURN(s):
end:

#==============================================================================
