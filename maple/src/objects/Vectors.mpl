#*************************************************************************
#
# GRTENSOR II MODULE: Vectors.mpl
#
# (C) 1992-1994 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: March 10 1995
#
# Redundant definitions of basis vector names.
#
#*************************************************************************


#===================================================================
#
# Object definitions.
#
#===================================================================

macro( gname = grG_metricName ):

#-------------------------------------------------------------------
# NP tetrad vector, l(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPl(up)]):
gr[grC_header] := `Null tetrad (contravaraint components)`:
gr[grC_root] := NPlup_:
gr[grC_rootStr] := `l`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e1up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, n(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPn(up)]):
gr[grC_header] := `Null tetrad (contravaraint components)`:
gr[grC_root] := NPnup_:
gr[grC_rootStr] := `n`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e2up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, m(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPm(up)]):
gr[grC_header] := `Null tetrad (contravaraint components)`:
gr[grC_root] := NPmup_:
gr[grC_rootStr] := `m`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e3up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, mbar(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPmbar(up)]):
gr[grC_header] := `Null tetrad (contravaraint components)`:
gr[grC_root] := NPmbarup_:
gr[grC_rootStr] := `mbar`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e4up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, l(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPl(dn)]):
gr[grC_header] := `Null tetrad (covariant components)`:
gr[grC_root] := NPldn_:
gr[grC_rootStr] := `l`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e1dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, n(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPn(dn)]):
gr[grC_header] := `Null tetrad (covariant components)`:
gr[grC_root] := NPndn_:
gr[grC_rootStr] := `n`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e2dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, m(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPm(dn)]):
gr[grC_header] := `Null tetrad (covariant components)`:
gr[grC_root] := NPmdn_:
gr[grC_rootStr] := `m`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e3dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, mbar(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[NPmbar(dn)]):
gr[grC_header] := `Null tetrad (covariant components)`:
gr[grC_root] := NPmbardn_:
gr[grC_rootStr] := `mbar`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e4dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:




#-------------------------------------------------------------------
# Basis vector, e1(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[w1(dn)]):
gr[grC_header] := `Basis (covariant components)`:
gr[grC_root] := e1dn_:
gr[grC_rootStr] := `omega1`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e1dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

grF_calc_e1dn := proc( object, list)
local	s:
  s := grG_ebdndn_[gname,1,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e2(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[w2(dn)]):
gr[grC_header] := `Basis (covariant components)`:
gr[grC_root] := e2dn_:
gr[grC_rootStr] := `omega2`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e2dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

grF_calc_e2dn := proc( object, list)
local	s:
  s := grG_ebdndn_[gname,2,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e3(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[w3(dn)]):
gr[grC_header] := `Basis (covariant components)`:
gr[grC_root] := e3dn_:
gr[grC_rootStr] := `omega3`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e3dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

grF_calc_e3dn := proc( object, list)
local	s:
  s := grG_ebdndn_[gname,3,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e4(dn)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[w4(dn)]):
gr[grC_header] := `Basis (covariant components)`:
gr[grC_root] := e4dn_:
gr[grC_rootStr] := `omega4`:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_e4dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,dn) }:

grF_calc_e4dn := proc( object, list)
local	s:
  s := grG_ebdndn_[gname,4,a1_]:
  RETURN(s):
end:


#-------------------------------------------------------------------
# Basis vector, e1(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[e1(up)]):
gr[grC_header] := `Basis (contravariant components)`:
gr[grC_root] := e1up_:
gr[grC_rootStr] := `e1`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e1up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

grF_calc_e1up := proc( object, list)
local	s:
  s := grG_ebdnup_[gname,1,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e2(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[e2(up)]):
gr[grC_header] := `Basis (contravariant components)`:
gr[grC_root] := e2up_:
gr[grC_rootStr] := `e2`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e2up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

grF_calc_e2up := proc( object, list)
local	s:
  s := grG_ebdnup_[gname,2,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e3(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[e3(up)]):
gr[grC_header] := `Basis (contravariant components)`:
gr[grC_root] := e3up_:
gr[grC_rootStr] := `e3`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e3up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

grF_calc_e3up := proc( object, list)
local	s:
  s := grG_ebdnup_[gname,3,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e4(up)
#-------------------------------------------------------------------
macro( gr = grG_ObjDef[e4(up)]):
gr[grC_header] := `Basis (contravariant components)`:
gr[grC_root] := e4up_:
gr[grC_rootStr] := `e4`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_e4up:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { e(bdn,up) }:

grF_calc_e4up := proc( object, list)
local	s:
  s := grG_ebdnup_[gname,4,a1_]:
  RETURN(s):
end:

