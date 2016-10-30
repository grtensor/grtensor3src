#==============================================================================
#
# killing.mpl - objects and functions for studying killing vectors
#
# (C) 1992-1994 Peter Musgrave, Denis Pollney and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: June 22, 1994
#
# Revisions:
# June 22, 94   Created
# June 23, 94   Added KillingCoords
# June  6, 96	Fixed KillingTest object and incorporated into grii.m. [dp]
# June 25, 96	Removed factor of 2 from conf to conform with prev. alg. [dp]
#==============================================================================

macro( gname = grG_metricName):

#------------------------------------------------------------------------------
# KillingTest(vector)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[KillingTest]):
gr[grC_header] := ` Killing Test Result`:
gr[grC_root] := KillingTest_:
gr[grC_rootStr] := `Killing Test`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_KillingTest:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := kvector:
gr[grC_depends] := { ktest[grG_kvector](dn,dn) }:

grF_calc_KillingTest := proc( object, iList )
local a, b, kv:
  kv := true:
  for a to Ndim||grG_metricName while kv = true do
    for b from a to Ndim||grG_metricName while kv = true do
      if expand(grG_ktestdndn_[grG_metricName,grG_kvector,a,b]) <> 0 then
        kv := false:
      fi:
    od:
  od:
  if not kv then
    RETURN ( ` not a Killing vector.` ):
  else
    if grG_conf_[grG_metricName,grG_kvector] = 0 then
      RETURN ( ` a Killing vector.` ):
    else
      RETURN ( 
        ` a homothetic/conformal Killing vector with conformal factor` = 
        grG_conf_[grG_metricName,grG_kvector] ):
    fi:
  fi:
end:

#------------------------------------------------------------------------------
# ktest(vector)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[ktest(dn,dn)]):
gr[grC_header] := `Killing equation`:
gr[grC_root] := ktestdndn_:
gr[grC_rootStr] := `keqn`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_ktest:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_operandSeq] := kvector:
gr[grC_depends] := { grG_kvector(dn,cdn), conf[grG_kvector] }:

grF_calc_ktest := proc ( object, iList )
local kroot:
  kroot := grG_||(grG_ObjDef[grG_kvector(dn,cdn)][grC_root]):
  RETURN ( kroot[grG_metricName,a1_,a2_] + kroot[grG_metricName,a2_,a1_] -
    2*grG_conf_[grG_metricName,grG_kvector]*grG_gdndn_[grG_metricName,a1_,a2_]
  ):
end:

#------------------------------------------------------------------------------
# conf(vector)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[conf]):
gr[grC_header] := `Killing conformal factor`:
gr[grC_root] := conf_:
gr[grC_rootStr] := `conf`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_conf:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := kvector:
gr[grC_depends] := { expsc[grG_kvector] }:

grF_calc_conf := proc ( object, iList )
  RETURN( (1/Ndim||grG_metricName)*grG_expsc_[grG_metricName,grG_kvector]):
end:

#------------------------------------------------------------------------------
# coord1(up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[coord1(up)]):
gr[grC_header] := ` Coordinate vector`:
gr[grC_root] := coord1up_:
gr[grC_rootStr] := `coord1 `:
gr[grC_indexList] := [up]:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#------------------------------------------------------------------------------
# coord2(up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[coord2(up)]):
gr[grC_header] := ` Coordinate vector`:
gr[grC_root] := coord2up_:
gr[grC_rootStr] := `coord2 `:
gr[grC_indexList] := [up]:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#------------------------------------------------------------------------------
# coord3(up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[coord3(up)]):
gr[grC_header] := ` Coordinate vector`:
gr[grC_root] := coord3up_:
gr[grC_rootStr] := `coord3 `:
gr[grC_indexList] := [up]:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#------------------------------------------------------------------------------
# coord4(up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[coord4(up)]):
gr[grC_header] := ` Coordinate vector`:
gr[grC_root] := coord4up_:
gr[grC_rootStr] := `coord4 `:
gr[grC_indexList] := [up]:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#==============================================================================
