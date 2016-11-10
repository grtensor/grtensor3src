#==============================================================================
# Tensors needed by the invariant library
#
# 31 May 1996	Created. [dp]
#==============================================================================


#------------------------------------------------------------------------------
# CS(dn,dn)
#------------------------------------------------------------------------------
grG_ObjDef[CS(dn,dn)][grC_header] := `CS(dn,dn)`:
grG_ObjDef[CS(dn,dn)][grC_root] := CSdndn_:
grG_ObjDef[CS(dn,dn)][grC_rootStr] := `CS `:
grG_ObjDef[CS(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[CS(dn,dn)][grC_calcFn] := grF_calc_CSdndn:
grG_ObjDef[CS(dn,dn)][grC_symmetry] := grF_sym_sym2:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[CS(dn,dn)][grC_depends] := { C(dn,dn,dn,dn), S(up,up) }:

grF_calc_CSdndn := proc ( object, iList )
local a, b, s, Cdndndndn, Supup:
global gr_data, grG_metricName, Ndim;
  # check for tensor/basis mode
  if object = CS(dn,dn) then
    Cdndndndn := Cdndndndn_:
    Supup := Supup_:
  else
    Cdndndndn := Cbdnbdnbdnbdn_:
    Supup := Sbupbup_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[Cdndndndn,grG_metricName,a,a1_,a2_,b]*gr_data[Supup,grG_metricName,a,b]:
    od:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# CSstar(dn,dn)
#------------------------------------------------------------------------------
grG_ObjDef[CSstar(dn,dn)][grC_header] := `CSstar(dn,dn)`:
grG_ObjDef[CSstar(dn,dn)][grC_root] := CSstardndn_:
grG_ObjDef[CSstar(dn,dn)][grC_rootStr] := `CSstar `:
grG_ObjDef[CSstar(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[CSstar(dn,dn)][grC_calcFn] := grF_calc_CSstardndn:
grG_ObjDef[CSstar(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[CSstar(dn,dn)][grC_depends] := { Cstar(dn,dn,dn,dn), S(up,up) }:

grF_calc_CSstardndn := proc ( object, iList )
local a, b, s, Cstardndndndn, Supup:
global gr_data, grG_metricName, Ndim;

  # check for tensor/basis mode
  if object = CSstar(dn,dn) then
    Cstardndndndn := Cstardndndndn_:
    Supup := Supup_:
  else
    Cstardndndndn := Cstarbdnbdnbdnbdn_:
    Supup := Sbupbup_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[Cstardndndndn,grG_metricName,a,a1_,a2_,b]*gr_data[Supup,grG_metricName,a,b]:
    od:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S2(up,dn)
#------------------------------------------------------------------------------
grG_ObjDef[S2(up,dn)][grC_header] := `Squared trace-free Ricci, S2(up,dn)`:
grG_ObjDef[S2(up,dn)][grC_root] := S2updn_:
grG_ObjDef[S2(up,dn)][grC_rootStr] := `S2 `:
grG_ObjDef[S2(up,dn)][grC_indexList] := [up,dn]:
grG_ObjDef[S2(up,dn)][grC_calcFn] := grF_calc_S2updn:
grG_ObjDef[S2(up,dn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S2(up,dn)][grC_depends] := { S(up,dn) }:

grF_calc_S2updn := proc ( object, iList )
local a, s, Supdn:
global gr_data, grG_metricName, Ndim;

  # check for tensor/basis mode
  if object = S2(up,dn) then
    Supdn := Supdn_:
  else
    Supdn := Sbupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[Supdn,grG_metricName,a1_,a]*gr_data[Supdn,grG_metricName,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S3(up,dn)
#------------------------------------------------------------------------------
grG_ObjDef[S3(up,dn)][grC_header] := `Cubed trace-free Ricci, S3(up,dn)`:
grG_ObjDef[S3(up,dn)][grC_root] := S3updn_:
grG_ObjDef[S3(up,dn)][grC_rootStr] := `S3 `:
grG_ObjDef[S3(up,dn)][grC_indexList] := [up,dn]:
grG_ObjDef[S3(up,dn)][grC_calcFn] := grF_calc_S3updn:
grG_ObjDef[S3(up,dn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S3(up,dn)][grC_depends] := { S(up,dn), S2(up,dn) }:

grF_calc_S3updn := proc ( object, iList )
local a, s, Supdn, S2updn:
global gr_data, grG_metricName, Ndim;

  # check for tensor/basis mode
  if object = S3(up,dn) then
    Supdn := Supdn_:
    S2updn := S2updn_:
  else
    Supdn := Sbupbdn_:
    S2updn := S2bupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[Supdn,grG_metricName,a1_,a]*gr_data[S2updn,grG_metricName,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# S4(up,dn)
#------------------------------------------------------------------------------
grG_ObjDef[S4(up,dn)][grC_header] := `Four trace-free Riccis, S4(up,dn)`:
grG_ObjDef[S4(up,dn)][grC_root] := S4updn_:
grG_ObjDef[S4(up,dn)][grC_rootStr] := `S4 `:
grG_ObjDef[S4(up,dn)][grC_indexList] := [up,dn]:
grG_ObjDef[S4(up,dn)][grC_calcFn] := grF_calc_S4updn:
grG_ObjDef[S4(up,dn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S4(up,dn)][grC_depends] := { S(up,dn), S3(up,dn) }:

grF_calc_S4updn := proc ( object, iList )
local a, s, Supdn, S3updn:
global gr_data, grG_metricName, Ndim;

  # check for tensor/basis mode
  if object = S4(up,dn) then
    Supdn := Supdn_:
    S3updn := S3updn_:
  else
    Supdn := Sbupbdn_:
    S3updn := S3bupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[Supdn,grG_metricName,a1_,a]*gr_data[S3updn,grG_metricName,a,a2_]:
  od:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# C2(dn,dn,up,up)
#------------------------------------------------------------------------------
grG_ObjDef[C2(dn,dn,up,up)][grC_header] := `Squared Weyl tensor, C2`:
grG_ObjDef[C2(dn,dn,up,up)][grC_root] := C2dndnupup_:
grG_ObjDef[C2(dn,dn,up,up)][grC_rootStr] := `C2 `:
grG_ObjDef[C2(dn,dn,up,up)][grC_indexList] := [dn,dn,up,up]:
grG_ObjDef[C2(dn,dn,up,up)][grC_calcFn] := grF_calc_C2:
grG_ObjDef[C2(dn,dn,up,up)][grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C2(dn,dn,up,up)][grC_depends] := { C(dn,dn,up,up) }:

grF_calc_C2 := proc(object, iList)
global gr_data, grG_metricName, Ndim;
local a, b, s, Cdndnupup:
  # check for tensor/basis mode
  if object = C2(dn,dn,up,up) then
    Cdndnupup := Cdndnupup_:
  else
    Cdndnupup := Cbdnbdnbupbup_:
  fi:

  s := 0:
  # sum over the upper half and return 2*
  for a to Ndim[grG_metricName] - 1 do
    for b from a+1 to Ndim[grG_metricName] do
      s := s + gr_data[Cdndnupup,grG_metricName,a1_,a2_,a,b] * gr_data[Cdndnupup,grG_metricName,a,b,a3_,a4_]:
    od:
  od:
  RETURN(2*s):
end:

#------------------------------------------------------------------------------
# S2(bup,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[S2(bup,bdn)][grC_header] := `Squared trace-free Ricci, S2(up,dn)`:
grG_ObjDef[S2(bup,bdn)][grC_root] := S2bupbdn_:
grG_ObjDef[S2(bup,bdn)][grC_rootStr] := `S2 `:
grG_ObjDef[S2(bup,bdn)][grC_indexList] := [bup,bdn]:
grG_ObjDef[S2(bup,bdn)][grC_calcFn] := grF_calc_S2updn:
grG_ObjDef[S2(bup,bdn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S2(bup,bdn)][grC_depends] := { S(bup,bdn) }:

#------------------------------------------------------------------------------
# S3(bup,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[S3(bup,bdn)][grC_header] := `Cubed trace-free Ricci, S3(up,dn)`:
grG_ObjDef[S3(bup,bdn)][grC_root] := S3bupbdn_:
grG_ObjDef[S3(bup,bdn)][grC_rootStr] := `S3 `:
grG_ObjDef[S3(bup,bdn)][grC_indexList] := [bup,bdn]:
grG_ObjDef[S3(bup,bdn)][grC_calcFn] := grF_calc_S3updn:
grG_ObjDef[S3(bup,bdn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S3(bup,bdn)][grC_depends] := { S(bup,bdn), S2(bup,bdn) }:

#------------------------------------------------------------------------------
# S4(up,dn)
#------------------------------------------------------------------------------
grG_ObjDef[S4(bup,bdn)][grC_header] := `Four trace-free Riccis, S4(up,dn)`:
grG_ObjDef[S4(bup,bdn)][grC_root] := S4bupbdn_:
grG_ObjDef[S4(bup,bdn)][grC_rootStr] := `S4 `:
grG_ObjDef[S4(bup,bdn)][grC_indexList] := [bup,bdn]:
grG_ObjDef[S4(bup,bdn)][grC_calcFn] := grF_calc_S4updn:
grG_ObjDef[S4(bup,bdn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S4(bup,bdn)][grC_depends] := { S(bup,bdn), S3(bup,bdn) }:

#------------------------------------------------------------------------------
# CS(bdn,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[CS(bdn,bdn)][grC_header] := `CS(bdn,bdn)`:
grG_ObjDef[CS(bdn,bdn)][grC_root] := CSbdnbdn_:
grG_ObjDef[CS(bdn,bdn)][grC_rootStr] := `CS `:
grG_ObjDef[CS(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[CS(bdn,bdn)][grC_calcFn] := grF_calc_CSdndn:
grG_ObjDef[CS(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[CS(bdn,bdn)][grC_depends] := { C(bdn,bdn,bdn,bdn), S(bup,bup) }:

#------------------------------------------------------------------------------
# CSstar(bdn,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[CSstar(bdn,bdn)][grC_header] := `CSstar(bdn,bdn)`:
grG_ObjDef[CSstar(bdn,bdn)][grC_root] := CSstarbdnbdn_:
grG_ObjDef[CSstar(bdn,bdn)][grC_rootStr] := `CSstar `:
grG_ObjDef[CSstar(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[CSstar(bdn,bdn)][grC_calcFn] := grF_calc_CSstardndn:
grG_ObjDef[CSstar(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[CSstar(bdn,bdn)][grC_depends] := { Cstar(bdn,bdn,bdn,bdn), S(bup,bup) }:

#------------------------------------------------------------------------------
# C2(bdn,bdn,bup,bup)
#------------------------------------------------------------------------------
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_header] := `Squared Weyl tensor, C2`:
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_root] := C2bdnbdnbupbup_:
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_rootStr] := `C2 `:
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_indexList] := [bdn,bdn,bup,bup]:
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_calcFn] := grF_calc_C2:
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C2(bdn,bdn,bup,bup)][grC_depends] := { C(bdn,bdn,bup,bup) }:

#==============================================================================
