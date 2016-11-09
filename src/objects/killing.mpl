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


#------------------------------------------------------------------------------
# KillingTest(vector)
#------------------------------------------------------------------------------
grG_ObjDef[KillingTest][grC_header] := ` Killing Test Result`:
grG_ObjDef[KillingTest][grC_root] := KillingTest_:
grG_ObjDef[KillingTest][grC_rootStr] := `Killing Test`:
grG_ObjDef[KillingTest][grC_indexList] := []:
grG_ObjDef[KillingTest][grC_calcFn] := grF_calc_KillingTest:
grG_ObjDef[KillingTest][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[KillingTest][grC_operandSeq] := kvector:
grG_ObjDef[KillingTest][grC_depends] := { ktest[grG_kvector](dn,dn) }:

grF_calc_KillingTest := proc( object, iList )
local a, b, kv:
global gr_data, grG_metricName;
  kv := true:
  for a to Ndim[grG_metricName] while kv = true do
    for b from a to Ndim[grG_metricName] while kv = true do
      if expand(gr_data[ktestdndn_,grG_metricName,grG_kvector,a,b]) <> 0 then
        kv := false:
      fi:
    od:
  od:
  if not kv then
    RETURN ( ` not a Killing vector.` ):
  else
    if gr_data[conf_,grG_metricName,grG_kvector] = 0 then
      RETURN ( ` a Killing vector.` ):
    else
      RETURN (
        ` a homothetic/conformal Killing vector with conformal factor` =
        gr_data[conf_,grG_metricName,grG_kvector] ):
    fi:
  fi:
end:

#------------------------------------------------------------------------------
# ktest(vector)
#------------------------------------------------------------------------------
grG_ObjDef[ktest(dn,dn)][grC_header] := `Killing equation`:
grG_ObjDef[ktest(dn,dn)][grC_root] := ktestdndn_:
grG_ObjDef[ktest(dn,dn)][grC_rootStr] := `keqn`:
grG_ObjDef[ktest(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[ktest(dn,dn)][grC_calcFn] := grF_calc_ktest:
grG_ObjDef[ktest(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[ktest(dn,dn)][grC_operandSeq] := kvector:
grG_ObjDef[ktest(dn,dn)][grC_depends] := { grG_kvector(dn,cdn), conf[grG_kvector] }:

grF_calc_ktest := proc ( object, iList )
local kroot:
global gr_data, grG_metricName;
  kroot := (grG_ObjDef[grG_kvector(dn,cdn)][grC_root]):
  RETURN ( gr_data[kroot,grG_metricName,a1_,a2_] + gr_data[kroot,grG_metricName,a2_,a1_] -
    2*gr_data[conf_,grG_metricName,grG_kvector]*gr_data[gdndn_,grG_metricName,a1_,a2_]
  ):
end:

#------------------------------------------------------------------------------
# conf(vector)
#------------------------------------------------------------------------------
grG_ObjDef[conf][grC_header] := `Killing conformal factor`:
grG_ObjDef[conf][grC_root] := conf_:
grG_ObjDef[conf][grC_rootStr] := `conf`:
grG_ObjDef[conf][grC_indexList] := []:
grG_ObjDef[conf][grC_calcFn] := grF_calc_conf:
grG_ObjDef[conf][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[conf][grC_operandSeq] := kvector:
grG_ObjDef[conf][grC_depends] := { expsc[grG_kvector] }:

grF_calc_conf := proc ( object, iList )
global gr_data, grG_metricName;
  RETURN( (1/Ndim[grG_metricName])*gr_data[expsc_,grG_metricName,grG_kvector]):
end:

#------------------------------------------------------------------------------
# coord1(up)
#------------------------------------------------------------------------------
grG_ObjDef[coord1(up)][grC_header] := ` Coordinate vector`:
grG_ObjDef[coord1(up)][grC_root] := coord1up_:
grG_ObjDef[coord1(up)][grC_rootStr] := `coord1 `:
grG_ObjDef[coord1(up)][grC_indexList] := [up]:
grG_ObjDef[coord1(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[coord1(up)][grC_depends] := {}:

#------------------------------------------------------------------------------
# coord2(up)
#------------------------------------------------------------------------------
grG_ObjDef[coord2(up)][grC_header] := ` Coordinate vector`:
grG_ObjDef[coord2(up)][grC_root] := coord2up_:
grG_ObjDef[coord2(up)][grC_rootStr] := `coord2 `:
grG_ObjDef[coord2(up)][grC_indexList] := [up]:
grG_ObjDef[coord2(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[coord2(up)][grC_depends] := {}:

#------------------------------------------------------------------------------
# coord3(up)
#------------------------------------------------------------------------------
grG_ObjDef[coord3(up)][grC_header] := ` Coordinate vector`:
grG_ObjDef[coord3(up)][grC_root] := coord3up_:
grG_ObjDef[coord3(up)][grC_rootStr] := `coord3 `:
grG_ObjDef[coord3(up)][grC_indexList] := [up]:
grG_ObjDef[coord3(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[coord3(up)][grC_depends] := {}:

#------------------------------------------------------------------------------
# coord4(up)
#------------------------------------------------------------------------------
grG_ObjDef[coord4(up)][grC_header] := ` Coordinate vector`:
grG_ObjDef[coord4(up)][grC_root] := coord4up_:
grG_ObjDef[coord4(up)][grC_rootStr] := `coord4 `:
grG_ObjDef[coord4(up)][grC_indexList] := [up]:
grG_ObjDef[coord4(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[coord4(up)][grC_depends] := {}:

#==============================================================================
