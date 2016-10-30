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
macro(gname=grG_metricName):

#------------------------------------------------------------------------------
# preCalc_LevCS3
#------------------------------------------------------------------------------
grF_preCalc_LevCS3 := proc(object)
local a, b, c, pset:
  if Ndim||grG_metricName <> 3 then
    ERROR(``||object||` may only be calculated for n=3`);
  fi:
  pset := {op(combinat[permute](3))}:
  for a to 3 do
    for b to 3 do
      for c to 3 do
        if not member ( [a,b,c], pset ) then
          grG_||( grG_ObjDef[object][grC_root] )[gname,a,b,c] := 0:
        fi:
      od:
    od:
  od:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,3,2] := 
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,1,3] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,3,1] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,1,2] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,2,1] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3]:

  grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3] := 
    grG_ObjDef[object][grC_calcFnParms]:
end:

#------------------------------------------------------------------------------
# LevCS - 3d, up
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(up,up,up)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSupupup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [up,up,up]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := {}:

#------------------------------------------------------------------------------
# LevCS - 3d, dn
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(dn,dn,dn)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSdndndn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [dn,dn,dn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 3d, up, basis
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(bup,bup,bup)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSbupbupbup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,bup,bup]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 3d, dn, basis
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(bdn,bdn,bdn)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSbdnbdnbdn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,bdn,bdn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(dn,dn,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(dn,dn,dn)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCdndndn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [dn,dn,dn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := (-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(up,up,up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(up,up,up)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCupupup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [up,up,up]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := -1/(-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bdn,bdn,bdn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(bdn,bdn,bdn)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCbdnbdnbdn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,bdn,bdn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := (-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC3:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(bup,bup,bup)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(bup,bup,bup)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCbupbupbup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,bup,bup]:
gr[grC_preCalcFn] := grF_preCalc_LevCS3:
gr[grC_calcFnParms] := -1/(-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevCS3:
gr[grC_depends] := { }:

#==============================================================================
# Four dimensions
#==============================================================================

#------------------------------------------------------------------------------
# preCalc_LevCS4
#------------------------------------------------------------------------------
grF_preCalc_LevCS4 := proc(object, iList)
local a, b, c, d, pset:
  if Ndim||grG_metricName <> 4 then
    ERROR(``||object||` may only be calculated for n=4.`);
  fi:
  pset := {op(combinat[permute](4))}:
  for a to 4 do
    for b to 4 do
      for c to 4 do
        for d to 4 do
          if not member ( [a,b,c,d], pset ) then
            grG_||( grG_ObjDef[object][grC_root] )[gname,a,b,c,d] := 0:
          fi:
        od:
      od:
    od:
  od:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,4,3] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,3,2,4] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,3,4,2] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,4,2,3] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,1,4,3,2] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,1,3,4] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,1,4,3] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,3,1,4] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,3,4,1] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,4,1,3] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,2,4,3,1] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,1,2,4] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,1,4,2] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,2,1,4] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,2,4,1] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,4,1,2] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,3,4,2,1] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,1,2,3] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,1,3,2] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,2,1,3] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,2,3,1] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,3,1,2] :=
    -grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:
  grG_||( grG_ObjDef[object][grC_root] )[gname,4,3,2,1] :=
    grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4]:

  grG_||( grG_ObjDef[object][grC_root] )[gname,1,2,3,4] :=
    grG_ObjDef[object][grC_calcFnParms]:
end:

#------------------------------------------------------------------------------
# LevCS - 4d, up
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(up,up,up,up)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSupupupup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [up,up,up,up]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := {}:

#------------------------------------------------------------------------------
# LevCS - 4d, dn
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(dn,dn,dn,dn)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSdndndndn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [dn,dn,dn,dn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 4d, up, basis
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(bup,bup,bup,bup)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSbupbupbupbup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,bup,bup,bup]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevCS - 4d, dn, basis
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevCS(bdn,bdn,bdn,bdn)]):
gr[grC_header] := `Levi-Civita Symbol`:
gr[grC_root] := LevCSbdnbdnbdnbdn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,bdn,bdn,bdn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := 1:
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { }:

#------------------------------------------------------------------------------
# LevC(dn,dn,dn,dn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(dn,dn,dn,dn)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCdndndndn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [dn,dn,dn,dn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := (-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(up,up,up,up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(up,up,up,up)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCupupupup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [up,up,up,up]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := -1/(-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bdn,bdn,bdn,bdn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(bdn,bdn,bdn,bdn)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCbdnbdnbdnbdn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,bdn,bdn,bdn]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := (-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { detg }:

#------------------------------------------------------------------------------
# LevC(bup,bup,bup,bup)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[LevC(bup,bup,bup,bup)]):
gr[grC_header] := `Levi-Civita Tensor`:
gr[grC_root] := LevCbupbupbupbup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,bup,bup,bup]:
gr[grC_preCalcFn] := grF_preCalc_LevCS4:
gr[grC_calcFnParms] := -1/(-grG_detg_[gname])^(1/2):
gr[grC_symmetry] := grF_sym_LevC4:
gr[grC_depends] := { detg }:

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
macro( gr = grG_ObjDef[Cstar(dn,dn,dn,dn)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices)`:
gr[grC_root] := Cstardndndndn_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [dn,dn,dn,dn]:
gr[grC_calcFn] := grF_calc_dual:
gr[grC_calcFnParms] := LevCdndndndn_, Cdndnupup_:
gr[grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := {LevC(dn,dn,dn,dn), C(dn,dn,up,up)}:

#------------------------------------------------------------------------------
# Cstar(bdn,bdn,bdn,bdn)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Cstar(bdn,bdn,bdn,bdn)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices)`:
gr[grC_root] := Cstarbdnbdnbdnbdn_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [bdn,bdn,bdn,bdn]:
gr[grC_calcFn] := grF_calc_dual:
gr[grC_calcFnParms] := LevCbdnbdnbdnbdn_, Cbdnbdnbupbup_:
gr[grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := {LevC(bdn,bdn,bdn,bdn), C(bdn,bdn,bup,bup)}:

grF_calc_dual := proc(object, iList)
local p,q, s, root1, root2:
#
# Seems like we're out by a factor of 2, but recall
# the definition of C* has a factor of 1/2 so by summing
# over the upper half we have included this factor of 1/2.
#
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
  s := 0:
  for p to (Ndim||grG_metricName - 1) do
    for q from p+1 to Ndim||grG_metricName do
      s := s + grG_||root1[gname,p,q,a1_,a2_] * grG_||root2[gname,a3_,a4_,p,q]:
    od:
  od:
  RETURN(s);
end:

#------------------------------------------------------------------------------
# Cstar(dn,dn,up,up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Cstar(dn,dn,up,up)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices) `:
gr[grC_root] := Cstardndnupup_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [dn,dn,up,up]:
gr[grC_calcFn] := grF_calc_Cstardndnupup:
gr[grC_calcFnParms] := LevCdndndndn_, Cupupupup_:
gr[grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { LevC(dn,dn,dn,dn), C(up,up,up,up) }:

#------------------------------------------------------------------------------
# Cstar(bdn,bdn,bup,bup)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Cstar(bdn,bdn,bup,bup)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices) `:
gr[grC_root] := Cstarbdnbdnbupbup_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [bdn,bdn,bup,bup]:
gr[grC_calcFn] := grF_calc_Cstardndnupup:
gr[grC_calcFnParms] := LevCbdnbdnbdnbdn_, Cbupbupbupbup_:
gr[grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { LevC(bdn,bdn,bdn,bdn), C(bup,bup,bup,bup) }:

grF_calc_Cstardndnupup := proc(object, iList)
local a, b, s, root1, root2:
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
#
# Seems like we're out by a factor of 2, but recall
# the definition of C* has a factor of 1/2 so by summing
# over the upper half we have included this factor of 1/2.
#
  s := 0:
  for a to (Ndim||grG_metricName - 1) do
    for b from a+1 to Ndim||grG_metricName do
      s := s + grG_||root1[gname,a,b,a1_,a2_] *
               grG_||root2[gname,a,b,a3_,a4_]:
    od:
  od:
  RETURN(s);
end:

#------------------------------------------------------------------------------
# Cstar(up,up,up,up)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Cstar(up,up,up,up)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices)  `:
gr[grC_root] := Cstarupupupup_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [up,up,up,up]:
gr[grC_calcFn] := grF_calc_dual_up:
gr[grC_calcFnParms] := LevCupupupup_, Cdndnupup_:
gr[grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(dn,dn,up,up), LevC(up,up,up,up) }:

#------------------------------------------------------------------------------
# Cstar(bup,bup,bup,bup)
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Cstar(bup,bup,bup,bup)]):
gr[grC_header] := `Dual Weyl (dual w.r.t first two indices)  `:
gr[grC_root] := Cstarbupbupbupbup_:
gr[grC_rootStr] := `C* `:
gr[grC_indexList] := [bup,bup,bup,bup]:
gr[grC_calcFn] := grF_calc_dual_up:
gr[grC_calcFnParms] := LevCupupupup_, Cbdnbdnbupbup_:
gr[grC_symmetry] := grF_sym_Riem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(bdn,bdn,bup,bup), LevC(up,up,up,up) }:

grF_calc_dual_up := proc(object, iList)
local a, b, s, root1, root2:
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  root2 := grG_ObjDef[object][grC_calcFnParms][2]:
  s := 0:
  #
  # Seems like we're out by a factor of 2, but recall
  # the definition of C* has a factor of 1/2 so by summing
  # over the upper half we have included this factor of 1/2. 
  #
  for a to (Ndim||grG_metricName - 1) do
    for b from a to Ndim||grG_metricName do
      s := s + grG_||root1[gname,a,b,a1_,a2_] * grG_||root2[gname,a,b,a3_,a4_]:
    od:
  od:
  RETURN(s);
end:

#==============================================================================









