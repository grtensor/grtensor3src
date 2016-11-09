#==============================================================================
# dual.mpl
#
# Revisions
# Aug   3 94	Cstar(dn,dn,up,up) not based on C(up,up,up,up)
# Aug   3 94	LevC now explicit
# Sept  9 94	Fix LevC(dn,dn,dn) [explicit definition]
# June 10 96	Added Levi-Civita symbol [dp]
#
#==============================================================================

#------------------------------------------------------------------------------
# preCalc_LevCS3
#------------------------------------------------------------------------------
grF_preCalc_LevCS3 := proc(object)
local a, b, c, pset, root:
global gr_data, grG_metricName, Ndim:
  if Ndim[grG_metricName] <> 3 then
    ERROR(``||object||` may only be calculated for n=3`);
  fi:
  root := grG_ObjDef[object][grC_root]:
  pset := {op(combinat[permute](3))}:
  for a to 3 do
    for b to 3 do
      for c to 3 do
        if not member ( [a,b,c], pset ) then
          gr_data[root,grG_metricName,a,b,c] := 0:
        fi:
      od:
    od:
  od:
  gr_data[root,grG_metricName,1,3,2] :=
    -gr_data[root,grG_metricName,1,2,3]:
  gr_data[root,grG_metricName,2,1,3] :=
    -gr_data[root,grG_metricName,1,2,3]:
  gr_data[root,grG_metricName,2,3,1] :=
    gr_data[root,grG_metricName,1,2,3]:
  gr_data[root,grG_metricName,3,1,2] :=
    gr_data[root,grG_metricName,1,2,3]:
  gr_data[root,grG_metricName,3,2,1] :=
    -gr_data[root,grG_metricName,1,2,3]:

  gr_data[root,grG_metricName,1,2,3] :=
    grG_ObjDef[object][grC_calcFnParms]:
end:

#------------------------------------------------------------------------------
# LevCS - 3d, up
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(up,up,up)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(up,up,up)][grC_root] := LevCSupupup_:
grG_ObjDef[LevCS(up,up,up)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(up,up,up)][grC_indexList] := [up,up,up]:
grG_ObjDef[LevCS(up,up,up)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevCS(up,up,up)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(up,up,up)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevCS(up,up,up)][grC_depends] := {}:

#------------------------------------------------------------------------------
# LevCS - 3d, dn
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(dn,dn,dn)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(dn,dn,dn)][grC_root] := LevCSdndndn_:
grG_ObjDef[LevCS(dn,dn,dn)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(dn,dn,dn)][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[LevCS(dn,dn,dn)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevCS(dn,dn,dn)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(dn,dn,dn)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevCS(dn,dn,dn)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 3d, up, basis
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(bup,bup,bup)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(bup,bup,bup)][grC_root] := LevCSbupbupbup_:
grG_ObjDef[LevCS(bup,bup,bup)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(bup,bup,bup)][grC_indexList] := [bup,bup,bup]:
grG_ObjDef[LevCS(bup,bup,bup)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevCS(bup,bup,bup)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(bup,bup,bup)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevCS(bup,bup,bup)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 3d, dn, basis
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_root] := LevCSbdnbdnbdn_:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevCS(bdn,bdn,bdn)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(dn,dn,dn)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(dn,dn,dn)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(dn,dn,dn)][grC_root] := LevCdndndn_:
grG_ObjDef[LevC(dn,dn,dn)][grC_rootStr] := `e `:
grG_ObjDef[LevC(dn,dn,dn)][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[LevC(dn,dn,dn)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevC(dn,dn,dn)][grC_calcFnParms] := (-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(dn,dn,dn)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevC(dn,dn,dn)][grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(up,up,up)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(up,up,up)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(up,up,up)][grC_root] := LevCupupup_:
grG_ObjDef[LevC(up,up,up)][grC_rootStr] := `e `:
grG_ObjDef[LevC(up,up,up)][grC_indexList] := [up,up,up]:
grG_ObjDef[LevC(up,up,up)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevC(up,up,up)][grC_calcFnParms] := -1/(-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(up,up,up)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevC(up,up,up)][grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bdn,bdn,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_root] := LevCbdnbdnbdn_:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_rootStr] := `e `:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_calcFnParms] := (-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_symmetry] := grF_sym_LevC3:
grG_ObjDef[LevC(bdn,bdn,bdn)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(bup,bup,bup)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(bup,bup,bup)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(bup,bup,bup)][grC_root] := LevCbupbupbup_:
grG_ObjDef[LevC(bup,bup,bup)][grC_rootStr] := `e `:
grG_ObjDef[LevC(bup,bup,bup)][grC_indexList] := [bup,bup,bup]:
grG_ObjDef[LevC(bup,bup,bup)][grC_preCalcFn] := grF_preCalc_LevCS3:
grG_ObjDef[LevC(bup,bup,bup)][grC_calcFnParms] := -1/(-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(bup,bup,bup)][grC_symmetry] := grF_sym_LevCS3:
grG_ObjDef[LevC(bup,bup,bup)][grC_depends] := { }:

#==============================================================================
# Four dimensions
#==============================================================================

#------------------------------------------------------------------------------
# preCalc_LevCS4
#------------------------------------------------------------------------------
grF_preCalc_LevCS4 := proc(object, iList)
local a, b, c, d, pset:
global gr_data, grG_metricName, Ndim:
  if Ndim[grG_metricName] <> 4 then
    ERROR(``||object||` may only be calculated for n=4.`);
  fi:
  pset := {op(combinat[permute](4))}:
  root := grG_ObjDef[object][grC_root]:
  for a to 4 do
    for b to 4 do
      for c to 4 do
        for d to 4 do
          if not member ( [a,b,c,d], pset ) then
            gr_data[root,grG_metricName,a,b,c,d] := 0:
          fi:
        od:
      od:
    od:
  od:
  gr_data[root,grG_metricName,1,2,4,3] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,1,3,2,4] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,1,3,4,2] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,1,4,2,3] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,1,4,3,2] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,1,3,4] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,1,4,3] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,3,1,4] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,3,4,1] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,4,1,3] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,2,4,3,1] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,1,2,4] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,1,4,2] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,2,1,4] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,2,4,1] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,4,1,2] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,3,4,2,1] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,1,2,3] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,1,3,2] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,2,1,3] :=
    gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,2,3,1] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,3,1,2] :=
    -gr_data[root,grG_metricName,1,2,3,4]:
  gr_data[root,grG_metricName,4,3,2,1] :=
    gr_data[root,grG_metricName,1,2,3,4]:

  gr_data[root,grG_metricName,1,2,3,4] :=
    grG_ObjDef[object][grC_calcFnParms]:
end:

#------------------------------------------------------------------------------
# LevCS - 4d, up
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(up,up,up,up)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(up,up,up,up)][grC_root] := LevCSupupupup_:
grG_ObjDef[LevCS(up,up,up,up)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(up,up,up,up)][grC_indexList] := [up,up,up,up]:
grG_ObjDef[LevCS(up,up,up,up)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevCS(up,up,up,up)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(up,up,up,up)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevCS(up,up,up,up)][grC_depends] := {}:

#------------------------------------------------------------------------------
# LevCS - 4d, dn
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_root] := LevCSdndndndn_:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevCS(dn,dn,dn,dn)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 4d, up, basis
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_root] := LevCSbupbupbupbup_:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_indexList] := [bup,bup,bup,bup]:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevCS(bup,bup,bup,bup)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 4d, dn, basis
#------------------------------------------------------------------------------
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_header] := `Levi-Civita Symbol`:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_root] := LevCSbdnbdnbdnbdn_:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_rootStr] := `e `:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn,bdn]:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_calcFnParms] := 1:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)][grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(dn,dn,dn,dn)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_root] := LevCdndndndn_:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_rootStr] := `e `:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_calcFnParms] := (-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevC(dn,dn,dn,dn)][grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(up,up,up,up)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(up,up,up,up)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(up,up,up,up)][grC_root] := LevCupupupup_:
grG_ObjDef[LevC(up,up,up,up)][grC_rootStr] := `e `:
grG_ObjDef[LevC(up,up,up,up)][grC_indexList] := [up,up,up,up]:
grG_ObjDef[LevC(up,up,up,up)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevC(up,up,up,up)][grC_calcFnParms] := -1/(-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(up,up,up,up)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevC(up,up,up,up)][grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bdn,bdn,bdn,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_root] := LevCbdnbdnbdnbdn_:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_rootStr] := `e `:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn,bdn]:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_calcFnParms] := (-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevC(bdn,bdn,bdn,bdn)][grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bup,bup,bup,bup)
#------------------------------------------------------------------------------
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_header] := `Levi-Civita Tensor`:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_root] := LevCbupbupbupbup_:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_rootStr] := `e `:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_indexList] := [bup,bup,bup,bup]:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_preCalcFn] := grF_preCalc_LevCS4:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_calcFnParms] := -1/(-gr_data[detg_,grG_metricName])^(1/2):
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_symmetry] := grF_sym_LevC4:
grG_ObjDef[LevC(bup,bup,bup,bup)][grC_depends] := { detg }:

#==============================================================================
# Tensors
#==============================================================================
#                       ij
# Cstar     = 1/2 e    C      =  C *
#      abcd        ijab   cd       ab cd
#
# (note this is the same as:
#                          ij
#             1/2 e     C
#                  ijab  cd
#
#  if the identities in the manual are used)
#
#        cd              pqcd
# MCstar     = 1/2 e    C
#       ab          pqab
#
#       abcd        pqab   cd
#     C *    = 1/2 e    C
#                        pq
# (see GR notes vol II p85)
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Cstar(dn,dn,dn,dn)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_header] := `Dual Weyl (dual w.r.t first two indices)`:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_root] := Cstardndndndn_:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_calcFn] := grF_calc_dual:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_calcFnParms] := LevCdndndndn_, Cdndnupup_:
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(dn,dn,dn,dn)][grC_depends] := {LevC(dn,dn,dn,dn), C(dn,dn,up,up)}:

#------------------------------------------------------------------------------
# Cstar(bdn,bdn,bdn,bdn)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_header] := `Dual Weyl (dual w.r.t first two indices)`:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_root] := Cstarbdnbdnbdnbdn_:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn,bdn]:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_calcFn] := grF_calc_dual:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_calcFnParms] := LevCbdnbdnbdnbdn_, Cbdnbdnbupbup_:
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)][grC_depends] := {LevC(bdn,bdn,bdn,bdn), C(bdn,bdn,bup,bup)}:

grF_calc_dual := proc(object, iList)
local p,q, s, root1, root2:
global gr_data, grG_metricName, Ndim:
#
# Seems like we're out by a factor of 2, but recall
# the definition of C* has a factor of 1/2 so by summing
# over the upper half we have included this factor of 1/2.
#
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
  s := 0:
  for p to (Ndim[grG_metricName] - 1) do
    for q from p+1 to Ndim[grG_metricName] do
      s := s + gr_data[root1,grG_metricName,p,q,a1_,a2_] * gr_data[root2,grG_metricName,a3_,a4_,p,q]:
    od:
  od:
  RETURN(s);
end:

#------------------------------------------------------------------------------
# Cstar(dn,dn,up,up)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(dn,dn,up,up)][grC_header] := `Dual Weyl (dual w.r.t first two indices) `:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_root] := Cstardndnupup_:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_indexList] := [dn,dn,up,up]:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_calcFn] := grF_calc_Cstardndnupup:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_calcFnParms] := LevCdndndndn_, Cupupupup_:
grG_ObjDef[Cstar(dn,dn,up,up)][grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(dn,dn,up,up)][grC_depends] := { LevC(dn,dn,dn,dn), C(up,up,up,up) }:

#------------------------------------------------------------------------------
# Cstar(bdn,bdn,bup,bup)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_header] := `Dual Weyl (dual w.r.t first two indices) `:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_root] := Cstarbdnbdnbupbup_:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_indexList] := [bdn,bdn,bup,bup]:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_calcFn] := grF_calc_Cstardndnupup:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_calcFnParms] := LevCbdnbdnbdnbdn_, Cbupbupbupbup_:
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(bdn,bdn,bup,bup)][grC_depends] := { LevC(bdn,bdn,bdn,bdn), C(bup,bup,bup,bup) }:

grF_calc_Cstardndnupup := proc(object, iList)
local a, b, s, root1, root2:
global gr_data, grG_metricName, Ndim:
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
#
# Seems like we're out by a factor of 2, but recall
# the definition of C* has a factor of 1/2 so by summing
# over the upper half we have included this factor of 1/2.
#
  s := 0:
  for a to (Ndim[grG_metricName] - 1) do
    for b from a+1 to Ndim[grG_metricName] do
      s := s + gr_data[root1,grG_metricName,a,b,a1_,a2_] *
               gr_data[root2,grG_metricName,a,b,a3_,a4_]:
    od:
  od:
  RETURN(s);
end:

#------------------------------------------------------------------------------
# Cstar(up,up,up,up)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(up,up,up,up)][grC_header] := `Dual Weyl (dual w.r.t first two indices)  `:
grG_ObjDef[Cstar(up,up,up,up)][grC_root] := Cstarupupupup_:
grG_ObjDef[Cstar(up,up,up,up)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(up,up,up,up)][grC_indexList] := [up,up,up,up]:
grG_ObjDef[Cstar(up,up,up,up)][grC_calcFn] := grF_calc_dual_up:
grG_ObjDef[Cstar(up,up,up,up)][grC_calcFnParms] := LevCupupupup_, Cdndnupup_:
grG_ObjDef[Cstar(up,up,up,up)][grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(up,up,up,up)][grC_depends] := { C(dn,dn,up,up), LevC(up,up,up,up) }:

#------------------------------------------------------------------------------
# Cstar(bup,bup,bup,bup)
#------------------------------------------------------------------------------
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_header] := `Dual Weyl (dual w.r.t first two indices)  `:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_root] := Cstarbupbupbupbup_:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_rootStr] := `C* `:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_indexList] := [bup,bup,bup,bup]:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_calcFn] := grF_calc_dual_up:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_calcFnParms] := LevCupupupup_, Cbdnbdnbupbup_:
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[Cstar(bup,bup,bup,bup)][grC_depends] := { C(bdn,bdn,bup,bup), LevC(up,up,up,up) }:

grF_calc_dual_up := proc(object, iList)
local a, b, s, root1, root2:
global gr_data, grG_metricName, Ndim:
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
  s := 0:
  #
  # Seems like we're out by a factor of 2, but recall
  # the definition of C* has a factor of 1/2 so by summing
  # over the upper half we have included this factor of 1/2.
  #
  for a to (Ndim[grG_metricName] - 1) do
    for b from a to Ndim[grG_metricName] do
      s := s + gr_data[root1,grG_metricName,a,b,a1_,a2_] * gr_data[root2,grG_metricName,a,b,a3_,a4_]:
    od:
  od:
  RETURN(s);
end:

#==============================================================================









