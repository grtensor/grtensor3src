#==============================================================================
#
# grvector.mpl - objects used to operate on vector fields
#
# (C) 1992-1994 Peter Musgrave, Denis Pollney, Kayll Lake
#
# File Created By: Denis Pollney
#            Date: 3 September 1994
#
# Revisions
# Sept. 28, 1995	Corrected vor(up). [pm]
# June   5, 1996	Moved grnormalize to grii.m (see normalize.mpl). [dp]
#==============================================================================
macro( gname = grG_metricName ):

#------------------------------------------------------------------------------
# vnorm = sqrt( v_a v^a )
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[vnorm]):
gr[grC_header] := `Vector norm`:
gr[grC_root] := vnorm_:
gr[grC_rootStr] := `norm`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_vnorm:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(up), grG_grVector(dn) }:

grF_calc_vnorm := proc( object, list)
local	a, s, v, vupRoot, vdnRoot:

  v := grG_grVector:
  vupRoot := grG_ObjDef[v(up)][grC_root]:
  vdnRoot := grG_ObjDef[v(dn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    s := s + grG_||vupRoot[gname, a]*grG_||vdnRoot[gname, a];
  od: 
  
  RETURN(s):
end:

#------------------------------------------------------------------------------
# orthogonal subspace metric, h_ab
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[h(dn,dn)]):
gr[grC_header] := `Projection tensor`:
gr[grC_root] := hdndn_:
gr[grC_rootStr] := `h`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_hdndn:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { g(dn,dn), grG_grVector(dn), vnorm[grG_grVector] }:

grF_calc_hdndn := proc( object, list)
local	s, v, vRoot, epsilon:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  epsilon := grG_vnorm_[gname, v]:

  s := grG_gdndn_[gname, a1_, a2_] - epsilon*grG_||vRoot[gname, a1_]*
       grG_||vRoot[gname,a2_]:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# acc(up) = v{^a} v{^b ; a}
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[acc(up)]):
gr[grC_header] := `Acceleration vector`:
gr[grC_root] := accup_:
gr[grC_rootStr] := `a`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_acc:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(up), grG_grVector(up,cdn) }:

grF_calc_acc := proc( object, list)
local	a, s, v, vRoot, dvRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    s := s + grG_||vRoot[gname, a]*grG_||dvRoot[gname, a1_, a];
  od: 
  
  RETURN(s):
end:

#------------------------------------------------------------------------------
# expansion = v^a_;a 
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[expsc]):
gr[grC_header] := `Expansion scalar`:
gr[grC_root] := expsc_:
gr[grC_rootStr] := `Theta`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_expsc:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(up,cdn) }:

grF_calc_expsc := proc( object, list)
local	a, s, v, dvRoot:

  v := grG_grVector:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    s := s + grG_||dvRoot[gname, a, a];
  od:
  
  RETURN(s):
end:

#------------------------------------------------------------------------------
# vorticity tensor, w_ab
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[vor(dn,dn)]):
gr[grC_header] := `Vorticity tensor`:
gr[grC_root] := vordndn_:
gr[grC_rootStr] := `omega`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_vordndn:
gr[grC_symmetry] := grF_sym_asym2:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(dn), grG_grVector(dn,cdn),
                     acc[grG_grVector](dn) }:

grF_calc_vordndn := proc( object, list)
local	s, v, vRoot, dvRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  dvRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := ( grG_||dvRoot[gname, a1_, a2_] - grG_||dvRoot[gname, a2_, a1_]
       + grG_accdn_[gname, grG_grVector, a1_]*grG_||vRoot[gname, a2_]
       - grG_accdn_[gname, grG_grVector, a2_]*grG_||vRoot[gname, a1_] )/2:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# vorticity vector, w^a
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[vor(up)]):
gr[grC_header] := `Vorticity vector`:
gr[grC_root] := vorup_:
gr[grC_rootStr] := `omega`:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_vorup:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(dn), vor[grG_grVector](dn,dn),
                     LevC(up,up,up,up) }:

grF_calc_vorup := proc( object, list)
local	a, b, c, s, v, vRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      for c to Ndim[gname] do
        s := s + grG_LevCupupupup_[gname,a1_,a,b,c]*
             grG_||vRoot[gname, a]*grG_vordndn_[gname, grG_grVector, b, c]:
      od:
    od:
  od:  
  RETURN(s/2):
end:

#-------------------------------------------------------------------
# vorticity scalar, w
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[vor]):
gr[grC_header] := `Vorticity scalar`:
gr[grC_root] := vor_:
gr[grC_rootStr] := `omega`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_vor:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { vor[grG_grVector](up,dn) }:

grF_calc_vor := proc( object, list)
local	a, b, s:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s - grG_vorupdn_[gname, grG_grVector, a, b]*
               grG_vorupdn_[gname, grG_grVector, b, a]:
    od:
  od:
  RETURN(sqrt(s)):
end:

#------------------------------------------------------------------------------
# shear tensor, sigma_ab
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[shear(dn,dn)]):
gr[grC_header] := `Shear tensor`:
gr[grC_root] := sheardndn_:
gr[grC_rootStr] := `sigma`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_sheardndn:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(dn), grG_grVector(dn,cdn),
                     acc[grG_grVector](dn), expsc[grG_grVector],
                     h[grG_grVector](dn,dn) }:

grF_calc_sheardndn := proc( object, list)
local	s, v, vRoot, dvRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  dvRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := ( 
         grG_||dvRoot[gname, a1_, a2_]
       + grG_||dvRoot[gname, a2_, a1_]
       + grG_accdn_[gname, v, a1_]*grG_||vRoot[gname, a2_]
       + grG_accdn_[gname, v, a2_]*grG_||vRoot[gname, a1_] 
       )/2
       - grG_expsc_[gname, v]*grG_hdndn_[gname,v,a1_,a2_]/3:
  
  RETURN(s):
end:

#------------------------------------------------------------------------------
# shear scalar, sigma
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[shear]):
gr[grC_header] := `Shear scalar`:
gr[grC_root] := shear_:
gr[grC_rootStr] := `sigma`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sigma:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { shear[grG_grVector](up,dn) }:

grF_calc_sigma := proc( object, list)
local	a, b, s, v:

  v := grG_grVector:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s + grG_shearupdn_[gname, v, a, b]*
               grG_shearupdn_[gname, v, b, a]:
    od:
  od:  
  RETURN(sqrt(s)):
end:

#------------------------------------------------------------------------------
# Raychaudhuri's equation
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[RayEqn]):
gr[grC_header] := `Raychaudhuri Equation`:
gr[grC_root] := RayEqn_:
gr[grC_rootStr] := `RayEqn`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_RayEqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { R(dn,dn), grG_grVector(up), grG_grVector(up,cdn),
                     expsc[grG_grVector], acc[grG_grVector](up,cdn), 
                     shear[grG_grVector], vor[grG_grVector] }:

grF_calc_RayEqn := proc( object, list)
local	a, b, ls, rs, v, vRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:
 
  ls := 0:
  rs := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      ls := ls - grG_Rdndn_[gname,a,b]*grG_||vRoot[gname,a]*
            grG_||vRoot[gname,b]:
    od:
    rs := rs + diff( grG_expsc_[gname,v], grG_xup_[gname,a] )*
          grG_||vRoot[gname,a] - grG_accupcdn_[gname,grG_grVector,a,a]:
  od:
  rs := rs + (grG_expsc_[gname, v]^2) + (grG_shear_[gname, v]^2 -
        grG_vor_[gname, v]^2):
  RETURN ( ls = rs ):
end:

#------------------------------------------------------------------------------
# optical shear scalar, sigma*sigmabar
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Opshear]):
gr[grC_header] := `Optical shear scalar`:
gr[grC_root] := Opshear_:
gr[grC_rootStr] := `|sigma|^2`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Opsigma:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(up,cup), grG_grVector(dn,cdn),
                     Opexpsc[grG_grVector] }:

grF_calc_Opsigma := proc( object, list)
local	a, b, s, v, dvupRoot, dvdnRoot:

  v := grG_grVector:
  dvupRoot := grG_ObjDef[v(up,cup)][grC_root]:
  dvdnRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := -grG_Opexpsc_[gname,v]^2:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s + (grG_||dvdnRoot[gname, a, b] + grG_||dvdnRoot[gname, b, a])
               *grG_||dvupRoot[gname,a,b]/4:
    od:
  od:  

  RETURN(s):
end:

#------------------------------------------------------------------------------
# optical vorticity scalar, omega^2
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Opvor]):
gr[grC_header] := `Optical vorticity scalar`:
gr[grC_root] := Opvor_:
gr[grC_rootStr] := `omega^2`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Opvor:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { g(up,up), grG_grVector(up,cup), grG_grVector(dn,cdn) }:

grF_calc_Opvor := proc( object, list)
local	a, b, s, v, dvupRoot, dvdnRoot:

  v := grG_grVector:
  dvupRoot := grG_ObjDef[v(up,cup)][grC_root]:
  dvdnRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s + (grG_||dvdnRoot[gname, a, b] - grG_||dvdnRoot[gname, b, a])
               *grG_||dvupRoot[gname, a, b]:
    od:
  od:  
  RETURN(s/4):
end:

#------------------------------------------------------------------------------
# optical expscansion scalar, Theta
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[Opexpsc]):
gr[grC_header] := `Optical expansion scalar`:
gr[grC_root] := Opexpsc_:
gr[grC_rootStr] := `Theta`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Optheta:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { grG_grVector(up,cdn) }:

grF_calc_Optheta := proc( object, list)
local	a, s, v, dvRoot:

  v := grG_grVector:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    s := s + grG_||dvRoot[gname, a, a]:
  od:  
  RETURN(s/2):
end:

#------------------------------------------------------------------------------
# optical Raychaudhuri's equation
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[OpRayEqn]):
gr[grC_header] := `Optical Raychaudhuri equation`:
gr[grC_root] := OpRayEqn_:
gr[grC_rootStr] := `OpRayEqn`:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_OpRayEqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { Opexpsc[grG_grVector], Opvor[grG_grvector],
                     Opshear[grG_grVector] }:

grF_calc_OpRayEqn := proc( object, list)
local	a, b, ls, rs, v, vRoot:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  ls := 0:
  rs := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      ls := ls + grG_Rdndn_[gname,a,b]*grG_||vRoot[gname,a]*grG_||vRoot[gname,b]:
    od:
    rs := rs + diff( grG_Opexpsc_[gname,v], grG_xup_[gname,a] )*
          grG_||vRoot[gname,a]:
  od:  
  rs := rs + grG_Opexpsc_[gname,v]^2 + grG_Opshear_[gname,v] -
             grG_Opvor_[gname,v]:
  ls := -ls/2:

  RETURN( ls = rs ):
end:

#------------------------------------------------------------------------------
# Electric part of Weyl
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[E(dn,dn)]):
gr[grC_header] := `Electric part of Weyl`:
gr[grC_root] := Edndn_:
gr[grC_rootStr] := `E`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_E:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_operandSeq] := grVector:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := { C(dn,dn,dn,dn), grG_grVector(up) }:

grF_calc_E := proc( object, list)
local	a, b, v, vRoot, s:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s + grG_Cdndndndn_[gname,a1_,a,a2_,b]*grG_||vRoot[gname,a]*
           grG_||vRoot[gname,b]:
    od:
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# Magnetic part of Weyl
#------------------------------------------------------------------------------
macro( gr = grG_ObjDef[H(dn,dn)]):
gr[grC_header] := `Magnetic part of Weyl`:
gr[grC_root] := Hdndn_:
gr[grC_rootStr] := `H`:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_H:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_operandSeq] := grVector:
gr[grC_depends] := { Cstar(dn,dn,dn,dn), grG_grVector(up) }:

grF_calc_H := proc( object, list)
local	a, b, v, vRoot, s:

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  s := 0:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s + grG_Cstardndndndn_[gname,a1_,a,a2_,b]*grG_||vRoot[gname,a]*
               grG_||vRoot[gname,b]:
    od:
  od:

  RETURN(s):
end:

#==============================================================================
