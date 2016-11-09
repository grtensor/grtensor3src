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


#-------------------------------------------------------------------
# NP tetrad vector, l(up)
#-------------------------------------------------------------------
grG_ObjDef[NPl(up)][grC_header] := `Null tetrad (contravaraint components)`:
grG_ObjDef[NPl(up)][grC_root] := NPlup_:
grG_ObjDef[NPl(up)][grC_rootStr] := `l`:
grG_ObjDef[NPl(up)][grC_indexList] := [up]:
grG_ObjDef[NPl(up)][grC_calcFn] := grF_calc_e1up:
grG_ObjDef[NPl(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPl(up)][grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, n(up)
#-------------------------------------------------------------------
grG_ObjDef[NPn(up)][grC_header] := `Null tetrad (contravaraint components)`:
grG_ObjDef[NPn(up)][grC_root] := NPnup_:
grG_ObjDef[NPn(up)][grC_rootStr] := `n`:
grG_ObjDef[NPn(up)][grC_indexList] := [up]:
grG_ObjDef[NPn(up)][grC_calcFn] := grF_calc_e2up:
grG_ObjDef[NPn(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPn(up)][grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, m(up)
#-------------------------------------------------------------------
grG_ObjDef[NPm(up)][grC_header] := `Null tetrad (contravaraint components)`:
grG_ObjDef[NPm(up)][grC_root] := NPmup_:
grG_ObjDef[NPm(up)][grC_rootStr] := `m`:
grG_ObjDef[NPm(up)][grC_indexList] := [up]:
grG_ObjDef[NPm(up)][grC_calcFn] := grF_calc_e3up:
grG_ObjDef[NPm(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPm(up)][grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, mbar(up)
#-------------------------------------------------------------------
grG_ObjDef[NPmbar(up)][grC_header] := `Null tetrad (contravaraint components)`:
grG_ObjDef[NPmbar(up)][grC_root] := NPmbarup_:
grG_ObjDef[NPmbar(up)][grC_rootStr] := `mbar`:
grG_ObjDef[NPmbar(up)][grC_indexList] := [up]:
grG_ObjDef[NPmbar(up)][grC_calcFn] := grF_calc_e4up:
grG_ObjDef[NPmbar(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPmbar(up)][grC_depends] := { e(bdn,up) }:

#-------------------------------------------------------------------
# NP tetrad vector, l(dn)
#-------------------------------------------------------------------
grG_ObjDef[NPl(dn)][grC_header] := `Null tetrad (covariant components)`:
grG_ObjDef[NPl(dn)][grC_root] := NPldn_:
grG_ObjDef[NPl(dn)][grC_rootStr] := `l`:
grG_ObjDef[NPl(dn)][grC_indexList] := [dn]:
grG_ObjDef[NPl(dn)][grC_calcFn] := grF_calc_e1dn:
grG_ObjDef[NPl(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPl(dn)][grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, n(dn)
#-------------------------------------------------------------------
grG_ObjDef[NPn(dn)][grC_header] := `Null tetrad (covariant components)`:
grG_ObjDef[NPn(dn)][grC_root] := NPndn_:
grG_ObjDef[NPn(dn)][grC_rootStr] := `n`:
grG_ObjDef[NPn(dn)][grC_indexList] := [dn]:
grG_ObjDef[NPn(dn)][grC_calcFn] := grF_calc_e2dn:
grG_ObjDef[NPn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPn(dn)][grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, m(dn)
#-------------------------------------------------------------------
grG_ObjDef[NPm(dn)][grC_header] := `Null tetrad (covariant components)`:
grG_ObjDef[NPm(dn)][grC_root] := NPmdn_:
grG_ObjDef[NPm(dn)][grC_rootStr] := `m`:
grG_ObjDef[NPm(dn)][grC_indexList] := [dn]:
grG_ObjDef[NPm(dn)][grC_calcFn] := grF_calc_e3dn:
grG_ObjDef[NPm(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPm(dn)][grC_depends] := { e(bdn,dn) }:

#-------------------------------------------------------------------
# NP tetrad vector, mbar(dn)
#-------------------------------------------------------------------
grG_ObjDef[NPmbar(dn)][grC_header] := `Null tetrad (covariant components)`:
grG_ObjDef[NPmbar(dn)][grC_root] := NPmbardn_:
grG_ObjDef[NPmbar(dn)][grC_rootStr] := `mbar`:
grG_ObjDef[NPmbar(dn)][grC_indexList] := [dn]:
grG_ObjDef[NPmbar(dn)][grC_calcFn] := grF_calc_e4dn:
grG_ObjDef[NPmbar(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[NPmbar(dn)][grC_depends] := { e(bdn,dn) }:




#-------------------------------------------------------------------
# Basis vector, e1(dn)
#-------------------------------------------------------------------
grG_ObjDef[w1(dn)][grC_header] := `Basis (covariant components)`:
grG_ObjDef[w1(dn)][grC_root] := e1dn_:
grG_ObjDef[w1(dn)][grC_rootStr] := `omega1`:
grG_ObjDef[w1(dn)][grC_indexList] := [dn]:
grG_ObjDef[w1(dn)][grC_calcFn] := grF_calc_e1dn:
grG_ObjDef[w1(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[w1(dn)][grC_depends] := { e(bdn,dn) }:

grF_calc_e1dn := proc( object, list)
local	s:
global gr_data, grG_metricName;
  s := gr_data[ebdndn_,grG_metricName,1,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e2(dn)
#-------------------------------------------------------------------
grG_ObjDef[w2(dn)][grC_header] := `Basis (covariant components)`:
grG_ObjDef[w2(dn)][grC_root] := e2dn_:
grG_ObjDef[w2(dn)][grC_rootStr] := `omega2`:
grG_ObjDef[w2(dn)][grC_indexList] := [dn]:
grG_ObjDef[w2(dn)][grC_calcFn] := grF_calc_e2dn:
grG_ObjDef[w2(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[w2(dn)][grC_depends] := { e(bdn,dn) }:

grF_calc_e2dn := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdndn_,grG_metricName,2,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e3(dn)
#-------------------------------------------------------------------
grG_ObjDef[w3(dn)][grC_header] := `Basis (covariant components)`:
grG_ObjDef[w3(dn)][grC_root] := e3dn_:
grG_ObjDef[w3(dn)][grC_rootStr] := `omega3`:
grG_ObjDef[w3(dn)][grC_indexList] := [dn]:
grG_ObjDef[w3(dn)][grC_calcFn] := grF_calc_e3dn:
grG_ObjDef[w3(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[w3(dn)][grC_depends] := { e(bdn,dn) }:

grF_calc_e3dn := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdndn_,grG_metricName,3,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e4(dn)
#-------------------------------------------------------------------
grG_ObjDef[w4(dn)][grC_header] := `Basis (covariant components)`:
grG_ObjDef[w4(dn)][grC_root] := e4dn_:
grG_ObjDef[w4(dn)][grC_rootStr] := `omega4`:
grG_ObjDef[w4(dn)][grC_indexList] := [dn]:
grG_ObjDef[w4(dn)][grC_calcFn] := grF_calc_e4dn:
grG_ObjDef[w4(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[w4(dn)][grC_depends] := { e(bdn,dn) }:

grF_calc_e4dn := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdndn_,grG_metricName,4,a1_]:
  RETURN(s):
end:


#-------------------------------------------------------------------
# Basis vector, e1(up)
#-------------------------------------------------------------------
grG_ObjDef[e1(up)][grC_header] := `Basis (contravariant components)`:
grG_ObjDef[e1(up)][grC_root] := e1up_:
grG_ObjDef[e1(up)][grC_rootStr] := `e1`:
grG_ObjDef[e1(up)][grC_indexList] := [up]:
grG_ObjDef[e1(up)][grC_calcFn] := grF_calc_e1up:
grG_ObjDef[e1(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[e1(up)][grC_depends] := { e(bdn,up) }:

grF_calc_e1up := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdnup_,grG_metricName,1,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e2(up)
#-------------------------------------------------------------------
grG_ObjDef[e2(up)][grC_header] := `Basis (contravariant components)`:
grG_ObjDef[e2(up)][grC_root] := e2up_:
grG_ObjDef[e2(up)][grC_rootStr] := `e2`:
grG_ObjDef[e2(up)][grC_indexList] := [up]:
grG_ObjDef[e2(up)][grC_calcFn] := grF_calc_e2up:
grG_ObjDef[e2(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[e2(up)][grC_depends] := { e(bdn,up) }:

grF_calc_e2up := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdnup_,grG_metricName,2,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e3(up)
#-------------------------------------------------------------------
grG_ObjDef[e3(up)][grC_header] := `Basis (contravariant components)`:
grG_ObjDef[e3(up)][grC_root] := e3up_:
grG_ObjDef[e3(up)][grC_rootStr] := `e3`:
grG_ObjDef[e3(up)][grC_indexList] := [up]:
grG_ObjDef[e3(up)][grC_calcFn] := grF_calc_e3up:
grG_ObjDef[e3(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[e3(up)][grC_depends] := { e(bdn,up) }:

grF_calc_e3up := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdnup_,grG_metricName,3,a1_]:
  RETURN(s):
end:

#-------------------------------------------------------------------
# Basis vector, e4(up)
#-------------------------------------------------------------------
grG_ObjDef[e4(up)][grC_header] := `Basis (contravariant components)`:
grG_ObjDef[e4(up)][grC_root] := e4up_:
grG_ObjDef[e4(up)][grC_rootStr] := `e4`:
grG_ObjDef[e4(up)][grC_indexList] := [up]:
grG_ObjDef[e4(up)][grC_calcFn] := grF_calc_e4up:
grG_ObjDef[e4(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[e4(up)][grC_depends] := { e(bdn,up) }:

grF_calc_e4up := proc( object, list)
global gr_data, grG_metricName;
local	s:
  s := gr_data[ebdnup_,grG_metricName,4,a1_]:
  RETURN(s):
end:

