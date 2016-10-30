#==============================================================================
# Tensors needed by the invariant library
#
# 31 May 1996	Created. [dp]
#==============================================================================

macro(gname = grG_metricName):

#------------------------------------------------------------------------------
# CS(dn,dn)
#------------------------------------------------------------------------------
macro(gr=grG_ObjDef[CS(dn,dn)]):
gr[grC_header] := `CS(dn,dn)`:
gr[grC_root] := CSdndn_:
gr[grC_rootStr] := `CS `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_CSdndn:
gr[grC_symmetry] := grF_sym_sym2:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(dn,dn,dn,dn), S(up,up) }:

grF_calc_CSdndn := proc ( object, iList )
local a, b, s, Cdndndndn, Supup:

  # check for tensor/basis mode
  if object = CS(dn,dn) then 
    Cdndndndn := grG_Cdndndndn_:
    Supup := grG_Supup_:
  else
    Cdndndndn := grG_Cbdnbdnbdnbdn_:
    Supup := grG_Sbupbup_:
  fi:

  s := 0:
  for a to Ndim||grG_metricName do
    for b to Ndim||grG_metricName do
      s := s + Cdndndndn[gname,a,a1_,a2_,b]*Supup[gname,a,b]:
    od:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# CSstar(dn,dn)
#------------------------------------------------------------------------------
macro(gr=grG_ObjDef[CSstar(dn,dn)]):
gr[grC_header] := `CSstar(dn,dn)`:
gr[grC_root] := CSstardndn_:
gr[grC_rootStr] := `CSstar `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_CSstardndn:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { Cstar(dn,dn,dn,dn), S(up,up) }:

grF_calc_CSstardndn := proc ( object, iList )
local a, b, s, Cstardndndndn, Supup:

  # check for tensor/basis mode
  if object = CSstar(dn,dn) then 
    Cstardndndndn := grG_Cstardndndndn_:
    Supup := grG_Supup_:
  else
    Cstardndndndn := grG_Cstarbdnbdnbdnbdn_:
    Supup := grG_Sbupbup_:
  fi:

  s := 0:
  for a to Ndim||grG_metricName do
    for b to Ndim||grG_metricName do
      s := s + Cstardndndndn[gname,a,a1_,a2_,b]*Supup[gname,a,b]:
    od:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S2(up,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S2(up,dn)]):
gr[grC_header] := `Squared trace-free Ricci, S2(up,dn)`:
gr[grC_root] := S2updn_:
gr[grC_rootStr] := `S2 `:
gr[grC_indexList] := [up,dn]:
gr[grC_calcFn] := grF_calc_S2updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(up,dn) }:

grF_calc_S2updn := proc ( object, iList )
local a, s, Supdn:

  # check for tensor/basis mode
  if object = S2(up,dn) then 
    Supdn := grG_Supdn_:
  else
    Supdn := grG_Sbupbdn_:
  fi:

  s := 0:
  for a to Ndim||grG_metricName do
    s := s + Supdn[gname,a1_,a]*Supdn[gname,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S3(up,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S3(up,dn)]):
gr[grC_header] := `Cubed trace-free Ricci, S3(up,dn)`:
gr[grC_root] := S3updn_:
gr[grC_rootStr] := `S3 `:
gr[grC_indexList] := [up,dn]:
gr[grC_calcFn] := grF_calc_S3updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(up,dn), S2(up,dn) }:

grF_calc_S3updn := proc ( object, iList )
local a, s, Supdn, S2updn:

  # check for tensor/basis mode
  if object = S3(up,dn) then 
    Supdn := grG_Supdn_:
    S2updn := grG_S2updn_:
  else
    Supdn := grG_Sbupbdn_:
    S2updn := grG_S2bupbdn_:
  fi:

  s := 0:
  for a to Ndim||grG_metricName do
    s := s + Supdn[gname,a1_,a]*S2updn[gname,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S4(up,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S4(up,dn)]):
gr[grC_header] := `Four trace-free Riccis, S4(up,dn)`:
gr[grC_root] := S4updn_:
gr[grC_rootStr] := `S4 `:
gr[grC_indexList] := [up,dn]:
gr[grC_calcFn] := grF_calc_S4updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(up,dn), S3(up,dn) }:

grF_calc_S4updn := proc ( object, iList )
local a, s, Supdn, S3updn:

  # check for tensor/basis mode
  if object = S4(up,dn) then
    Supdn := grG_Supdn_:
    S3updn := grG_S3updn_:
  else
    Supdn := grG_Sbupbdn_:
    S3updn := grG_S3bupbdn_:
  fi:

  s := 0:
  for a to Ndim||grG_metricName do
    s := s + Supdn[gname,a1_,a]*S3updn[gname,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# C2(dn,dn,up,up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[C2(dn,dn,up,up)]):
gr[grC_header] := `Squared Weyl tensor, C2`:
gr[grC_root] := C2dndnupup_:
gr[grC_rootStr] := `C2 `:
gr[grC_indexList] := [dn,dn,up,up]:
gr[grC_calcFn] := grF_calc_C2:
gr[grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(dn,dn,up,up) }:

grF_calc_C2 := proc(object, iList)
local a, b, s, Cdndnupup:
  # check for tensor/basis mode
  if object = C2(dn,dn,up,up) then
    Cdndnupup := grG_Cdndnupup_:
  else
    Cdndnupup := grG_Cbdnbdnbupbup_:
  fi:

  s := 0:
  # sum over the upper half and return 2*
  for a to Ndim[grG_metricName] - 1 do
    for b from a+1 to Ndim[grG_metricName] do
      s := s + Cdndnupup[gname,a1_,a2_,a,b] * Cdndnupup[gname,a,b,a3_,a4_]:
    od:
  od:
  RETURN(2*s):
end:

#------------------------------------------------------------------------------
# S2(bup,bdn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S2(bup,bdn)]):
gr[grC_header] := `Squared trace-free Ricci, S2(up,dn)`:
gr[grC_root] := S2bupbdn_:
gr[grC_rootStr] := `S2 `:
gr[grC_indexList] := [bup,bdn]:
gr[grC_calcFn] := grF_calc_S2updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(bup,bdn) }:

#------------------------------------------------------------------------------
# S3(bup,bdn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S3(bup,bdn)]):
gr[grC_header] := `Cubed trace-free Ricci, S3(up,dn)`:
gr[grC_root] := S3bupbdn_:
gr[grC_rootStr] := `S3 `:
gr[grC_indexList] := [bup,bdn]:
gr[grC_calcFn] := grF_calc_S3updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(bup,bdn), S2(bup,bdn) }:

#------------------------------------------------------------------------------
# S4(up,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[S4(bup,bdn)]):
gr[grC_header] := `Four trace-free Riccis, S4(up,dn)`:
gr[grC_root] := S4bupbdn_:
gr[grC_rootStr] := `S4 `:
gr[grC_indexList] := [bup,bdn]:
gr[grC_calcFn] := grF_calc_S4updn:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { S(bup,bdn), S3(bup,bdn) }:

#------------------------------------------------------------------------------
# CS(bdn,bdn)
#------------------------------------------------------------------------------
macro(gr=grG_ObjDef[CS(bdn,bdn)]):
gr[grC_header] := `CS(bdn,bdn)`:
gr[grC_root] := CSbdnbdn_:
gr[grC_rootStr] := `CS `:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_CSdndn:
gr[grC_symmetry] := grF_sym_sym2:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(bdn,bdn,bdn,bdn), S(bup,bup) }:

#------------------------------------------------------------------------------
# CSstar(bdn,bdn)
#------------------------------------------------------------------------------
macro(gr=grG_ObjDef[CSstar(bdn,bdn)]):
gr[grC_header] := `CSstar(bdn,bdn)`:
gr[grC_root] := CSstarbdnbdn_:
gr[grC_rootStr] := `CSstar `:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_CSstardndn:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { Cstar(bdn,bdn,bdn,bdn), S(bup,bup) }:

#------------------------------------------------------------------------------
# C2(bdn,bdn,bup,bup)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[C2(bdn,bdn,bup,bup)]):
gr[grC_header] := `Squared Weyl tensor, C2`:
gr[grC_root] := C2bdnbdnbupbup_:
gr[grC_rootStr] := `C2 `:
gr[grC_indexList] := [bdn,bdn,bup,bup]:
gr[grC_calcFn] := grF_calc_C2:
gr[grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(bdn,bdn,bup,bup) }:

#==============================================================================