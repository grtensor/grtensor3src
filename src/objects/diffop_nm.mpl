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


#------------------------------------------------------------------------------
# LieD - Lie derivative
#------------------------------------------------------------------------------
grG_ObjDef[LieD][grC_header] := ` LieD{vector} <Object>`:
grG_ObjDef[LieD][grC_root] := LieD_:
grG_ObjDef[LieD][grC_rootStr] := `LieD `:
grG_ObjDef[LieD][grC_calcFn] := grF_calc_LieD:
grG_ObjDef[LieD][grC_operandSeq] := vector,object:
# take on the symmetry and index list of the operand#
grG_ObjDef[LieD][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[LieD][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
grG_ObjDef[LieD][grC_depends] := {grG_object, grG_vector(up)}:

grF_calc_LieD := proc( object, iList)
local  a, b, c, s, vRoot, tRoot, newList, indexList, iSeq, vIndex, dIndex,
       i1, i2, i3, i4, i5, i6, tsign, gname:
global grG_ObjDef, gr_data, grG_metricName, Ndim:

 tRoot := (grG_ObjDef[ grG_object][grC_root]):
 vRoot := (grG_ObjDef[ grG_vector(up)][grC_root]):
 indexList := grG_ObjDef[ grG_object][grC_indexList]:
 gname := grG_metricName:
 if nops(indexList) > 6 then
   ERROR(`LieD only allows up to six indices`):
 fi:

 # build a seq of listing indices
 iSeq := seq(i||a, a=1..nops(iList) ):

 # do the initial sum
 s := 0:
 for a to Ndim[gname] do
   s := s + diff( gr_data[tRoot,gname,op(iList)], gr_data[xup_,gname,a]) *
            gr_data[vRoot,gname,a]:
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
     s := s + tsign*gr_data[tRoot,gname, eval(op(newList))] *
          diff( gr_data[vRoot,gname,eval(vIndex)], gr_data[xup_,gname,eval(dIndex)]):
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# Box
#------------------------------------------------------------------------------
grG_ObjDef[Box][grC_header] := ` CoD{a} CoD{^a} <Object>`:
grG_ObjDef[Box][grC_root] := Box_:
grG_ObjDef[Box][grC_rootStr] := `Box `:
grG_ObjDef[Box][grC_calcFn] := grF_calc_Box:
grG_ObjDef[Box][grC_operandSeq] := object:
# take on the symmetry and index list of the operand
grG_ObjDef[Box][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[Box][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
grG_ObjDef[Box][grC_depends] := grF_Box_depends:

grF_Box_depends := proc( object)
local dependsOn:
global grG_ObjDef, gr_data, grG_metricName, Ndim:
 if type(grG_object, function) then
   dependsOn := {op(0,grG_object)(op(grG_object),cdn,cdn) }:
 else
   dependsOn := {grG_object(cdn,cdn)}:
 fi:
 RETURN(dependsOn):
end:

grF_calc_Box := proc( object, iList)
local s, a, b, root, gname, newObject:
 # object to operate on is kept in grG_object, but we
 # need to add a cdn index to it
 gname := grG_metricName:
 newObject := op(grF_Box_depends( object)):
 root := (grG_ObjDef[newObject][grC_root]):

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + gr_data[gupup_,gname,a,b] * gr_data[root,gname,op(iList),a,b]:
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# Dl - NP operator: l^a grad_a
#------------------------------------------------------------------------------
grG_ObjDef[Dl][grC_header] := ` Dl[<object>]`:
grG_ObjDef[Dl][grC_root] := Dl_:
grG_ObjDef[Dl][grC_rootStr] := `Dl`:
grG_ObjDef[Dl][grC_calcFn] := grF_calc_NPD:
grG_ObjDef[Dl][grC_calcFnParms] := 1:
grG_ObjDef[Dl][grC_operandSeq] := object:
grG_ObjDef[Dl][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[Dl][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Dl][grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dn - NP operator: n^a grad_a
#------------------------------------------------------------------------------
grG_ObjDef[Dn][grC_header] := ` Dn[<object>]`:
grG_ObjDef[Dn][grC_root] := Dn_:
grG_ObjDef[Dn][grC_rootStr] := `Dn`:
grG_ObjDef[Dn][grC_calcFn] := grF_calc_NPD:
grG_ObjDef[Dn][grC_calcFnParms] := 2:
grG_ObjDef[Dn][grC_operandSeq] := object:
grG_ObjDef[Dn][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[Dn][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Dn][grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dm - NP operator: m^a grad_a
#------------------------------------------------------------------------------
grG_ObjDef[Dm][grC_header] := ` Dm[<object>]`:
grG_ObjDef[Dm][grC_root] := Dm_:
grG_ObjDef[Dm][grC_rootStr] := `Dm`:
grG_ObjDef[Dm][grC_calcFn] := grF_calc_NPD:
grG_ObjDef[Dm][grC_calcFnParms] := 3:
grG_ObjDef[Dm][grC_operandSeq] := object:
grG_ObjDef[Dm][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[Dm][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Dm][grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

#------------------------------------------------------------------------------
# Dmbar - NP operator: mbar^a grad_a
#------------------------------------------------------------------------------
grG_ObjDef[Dmbar][grC_header] := ` Dmbar[<object>]`:
grG_ObjDef[Dmbar][grC_root] := Dmbar_:
grG_ObjDef[Dmbar][grC_rootStr] := `Dmbar`:
grG_ObjDef[Dmbar][grC_calcFn] := grF_calc_NPD:
grG_ObjDef[Dmbar][grC_calcFnParms] := 4:
grG_ObjDef[Dmbar][grC_operandSeq] := object:
grG_ObjDef[Dmbar][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[Dmbar][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Dmbar][grC_depends] := { grF_dObject ( grG_object, pbdn ) }:

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
global grG_ObjDef, gr_data, grG_metricName, Ndim:

  Dobj := grF_dObject ( grG_object, pbdn ):
  DobjRoot := (grG_ObjDef[Dobj][grC_root]):
  idxList := op(grG_ObjDef[grG_object][grC_indexList]):
  Didx := grG_ObjDef[object][grC_calcFnParms]:
  ops := grF_objectOperands ( grG_object ):

  RETURN( gr_data[DobjRoot,grG_metricName,ops,idxList,Didx] ):
end:

#------------------------------------------------------------------------------
# Dsq
#                                    ab
# For a scalar operand X calculate  g  X,a X,b
#------------------------------------------------------------------------------
grG_ObjDef[Dsq][grC_header] := ` g{^a ^b} X{,a} X{,b}`:
grG_ObjDef[Dsq][grC_root] := Dsq_:
grG_ObjDef[Dsq][grC_rootStr] := `Dsq `:
grG_ObjDef[Dsq][grC_indexList] := []:
grG_ObjDef[Dsq][grC_calcFn] := grF_calc_Dsq:
grG_ObjDef[Dsq][grC_calcFnParms] := grG_Dsq_:
grG_ObjDef[Dsq][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Dsq][grC_operandSeq] := object:
grG_ObjDef[Dsq][grC_depends] := { grG_object}:

grF_calc_Dsq := proc( object, iList)
local s, a, b, root, operand:
global grG_ObjDef, gr_data, grG_metricName, Ndim:
 # object to operate on is kept in grG_object
 root := (grG_ObjDef[grF_objectName( grG_object)][grC_root]):
 operand := gr_data[root, grG_metricName, grF_objectOperands( grG_object )]:

 s := 0:
 for a to Ndim[grG_metricName] do
   for b to Ndim[grG_metricName] do
     s := s + gr_data[gupup_,grG_metricName,a,b] *
          diff( operand, gr_data[xup_,grG_metricName,a]) *
          diff( operand, gr_data[xup_,grG_metricName,b]):
   od:
 od:
 RETURN(s):
end:

#------------------------------------------------------------------------------
# CDsq
#------------------------------------------------------------------------------
grG_ObjDef[CDsq][grC_header] := ` CoD{a} <Object> CoD{^a} <Object>`:
grG_ObjDef[CDsq][grC_root] := CDsq_:
grG_ObjDef[CDsq][grC_rootStr] := `CDsq `:
grG_ObjDef[CDsq][grC_calcFn] := grF_calc_CDsq:
grG_ObjDef[CDsq][grC_operandSeq] := object:
#
# take on the symmetry and index list of the operand
#
grG_ObjDef[CDsq][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:
grG_ObjDef[CDsq][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
#
# depends on Cod of the object. Need a function for this
# since scalars and tensors are a bit different.
#
grG_ObjDef[CDsq][grC_depends] := grF_CDsq_depends:

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
global grG_ObjDef, gr_data, grG_metricName, Ndim:
 # object to operate on is kept in grG_object, but we
 # need to add a cdn index to it
 newObject := op(grF_CDsq_depends( object)):
 root := (grG_ObjDef[newObject][grC_root]):

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + gr_data[gupup_,grG_metricName,a,b] *
            gr_data[root,grG_metricName,op(iList),a] *
            gr_data[root,grG_metricName,op(iList),b]:
   od:
 od:
 RETURN(s):
end:

#==============================================================================
