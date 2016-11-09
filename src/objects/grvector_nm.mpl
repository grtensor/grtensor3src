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

#------------------------------------------------------------------------------
# vnorm = sqrt( v_a v^a )
#------------------------------------------------------------------------------
grG_ObjDef[vnorm][grC_header] := `Vector norm`:
grG_ObjDef[vnorm][grC_root] := vnorm_:
grG_ObjDef[vnorm][grC_rootStr] := `norm`:
grG_ObjDef[vnorm][grC_indexList] := []:
grG_ObjDef[vnorm][grC_calcFn] := grF_calc_vnorm:
grG_ObjDef[vnorm][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[vnorm][grC_operandSeq] := grVector:
grG_ObjDef[vnorm][grC_depends] := { grG_grVector(up), grG_grVector(dn) }:

grF_calc_vnorm := proc( object, list)
local	a, s, v, vupRoot, vdnRoot:
global gr_data, grG_ObjDef, grG_metricName;
  v := grG_grVector:
  vupRoot := grG_ObjDef[v(up)][grC_root]:
  vdnRoot := grG_ObjDef[v(dn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[vupRoot,grG_metricName, a]*gr_data[vdnRoot,grG_metricName, a];
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# orthogonal subspace metric, h_ab
#------------------------------------------------------------------------------
grG_ObjDef[h(dn,dn)][grC_header] := `Projection tensor`:
grG_ObjDef[h(dn,dn)][grC_root] := hdndn_:
grG_ObjDef[h(dn,dn)][grC_rootStr] := `h`:
grG_ObjDef[h(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[h(dn,dn)][grC_calcFn] := grF_calc_hdndn:
grG_ObjDef[h(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[h(dn,dn)][grC_operandSeq] := grVector:
grG_ObjDef[h(dn,dn)][grC_depends] := { g(dn,dn), grG_grVector(dn), vnorm[grG_grVector] }:

grF_calc_hdndn := proc( object, list)
local	s, v, vRoot, epsilon:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  epsilon := gr_data[vnorm_,grG_metricName, v]:

  s := gr_data[gdndn_,grG_metricName, a1_, a2_] - epsilon*gr_data[vRoot,grG_metricName, a1_]*
       gr_data[vRoot,grG_metricName,a2_]:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# acc(up) = v{^a} v{^b ; a}
#------------------------------------------------------------------------------
grG_ObjDef[acc(up)][grC_header] := `Acceleration vector`:
grG_ObjDef[acc(up)][grC_root] := accup_:
grG_ObjDef[acc(up)][grC_rootStr] := `a`:
grG_ObjDef[acc(up)][grC_indexList] := [up]:
grG_ObjDef[acc(up)][grC_calcFn] := grF_calc_acc:
grG_ObjDef[acc(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[acc(up)][grC_operandSeq] := grVector:
grG_ObjDef[acc(up)][grC_depends] := { grG_grVector(up), grG_grVector(up,cdn) }:

grF_calc_acc := proc( object, list)
local	a, s, v, vRoot, dvRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[vRoot,grG_metricName, a]*gr_data[dvRoot,grG_metricName, a1_, a];
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# expansion = v^a_;a
#------------------------------------------------------------------------------
grG_ObjDef[expsc][grC_header] := `Expansion scalar`:
grG_ObjDef[expsc][grC_root] := expsc_:
grG_ObjDef[expsc][grC_rootStr] := `Theta`:
grG_ObjDef[expsc][grC_indexList] := []:
grG_ObjDef[expsc][grC_calcFn] := grF_calc_expsc:
grG_ObjDef[expsc][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[expsc][grC_operandSeq] := grVector:
grG_ObjDef[expsc][grC_depends] := { grG_grVector(up,cdn) }:

grF_calc_expsc := proc( object, list)
local	a, s, v, dvRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[dvRoot,grG_metricName, a, a];
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# vorticity tensor, w_ab
#------------------------------------------------------------------------------
grG_ObjDef[vor(dn,dn)][grC_header] := `Vorticity tensor`:
grG_ObjDef[vor(dn,dn)][grC_root] := vordndn_:
grG_ObjDef[vor(dn,dn)][grC_rootStr] := `omega`:
grG_ObjDef[vor(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[vor(dn,dn)][grC_calcFn] := grF_calc_vordndn:
grG_ObjDef[vor(dn,dn)][grC_symmetry] := grF_sym_asym2:
grG_ObjDef[vor(dn,dn)][grC_operandSeq] := grVector:
grG_ObjDef[vor(dn,dn)][grC_depends] := { grG_grVector(dn), grG_grVector(dn,cdn),
                     acc[grG_grVector](dn) }:

grF_calc_vordndn := proc( object, list)
local	s, v, vRoot, dvRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  dvRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := ( gr_data[dvRoot,grG_metricName, a1_, a2_] - gr_data[dvRoot,grG_metricName, a2_, a1_]
       + gr_data[accdn_,grG_metricName, grG_grVector, a1_]*gr_data[vRoot,grG_metricName, a2_]
       - gr_data[accdn_,grG_metricName, grG_grVector, a2_]*gr_data[vRoot,grG_metricName, a1_] )/2:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# vorticity vector, w^a
#------------------------------------------------------------------------------
grG_ObjDef[vor(up)][grC_header] := `Vorticity vector`:
grG_ObjDef[vor(up)][grC_root] := vorup_:
grG_ObjDef[vor(up)][grC_rootStr] := `omega`:
grG_ObjDef[vor(up)][grC_indexList] := [up]:
grG_ObjDef[vor(up)][grC_calcFn] := grF_calc_vorup:
grG_ObjDef[vor(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[vor(up)][grC_operandSeq] := grVector:
grG_ObjDef[vor(up)][grC_depends] := { grG_grVector(dn), vor[grG_grVector](dn,dn),
                     LevC(up,up,up,up) }:

grF_calc_vorup := proc( object, list)
local	a, b, c, s, v, vRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        s := s + gr_data[LevCupupupup_,grG_metricName,a1_,a,b,c]*
             gr_data[vRoot,grG_metricName, a]*gr_data[vordndn_,grG_metricName, grG_grVector, b, c]:
      od:
    od:
  od:
  RETURN(s/2):
end:

#-------------------------------------------------------------------
# vorticity scalar, w
#------------------------------------------------------------------------------
grG_ObjDef[vor][grC_header] := `Vorticity scalar`:
grG_ObjDef[vor][grC_root] := vor_:
grG_ObjDef[vor][grC_rootStr] := `omega`:
grG_ObjDef[vor][grC_indexList] := []:
grG_ObjDef[vor][grC_calcFn] := grF_calc_vor:
grG_ObjDef[vor][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[vor][grC_operandSeq] := grVector:
grG_ObjDef[vor][grC_depends] := { vor[grG_grVector](up,dn) }:

grF_calc_vor := proc( object, list)
local	a, b, s:
global gr_data, grG_ObjDef, grG_metricName;

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s - gr_data[vorupdn_,grG_metricName, grG_grVector, a, b]*
               gr_data[vorupdn_,grG_metricName, grG_grVector, b, a]:
    od:
  od:
  RETURN(sqrt(s)):
end:

#------------------------------------------------------------------------------
# shear tensor, sigma_ab
#------------------------------------------------------------------------------
grG_ObjDef[shear(dn,dn)][grC_header] := `Shear tensor`:
grG_ObjDef[shear(dn,dn)][grC_root] := sheardndn_:
grG_ObjDef[shear(dn,dn)][grC_rootStr] := `sigma`:
grG_ObjDef[shear(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[shear(dn,dn)][grC_calcFn] := grF_calc_sheardndn:
grG_ObjDef[shear(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[shear(dn,dn)][grC_operandSeq] := grVector:
grG_ObjDef[shear(dn,dn)][grC_depends] := { grG_grVector(dn), grG_grVector(dn,cdn),
                     acc[grG_grVector](dn), expsc[grG_grVector],
                     h[grG_grVector](dn,dn) }:

grF_calc_sheardndn := proc( object, list)
local	s, v, vRoot, dvRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(dn)][grC_root]:
  dvRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := (
         gr_data[dvRoot,grG_metricName, a1_, a2_]
       + gr_data[dvRoot,grG_metricName, a2_, a1_]
       + gr_data[accdn_,grG_metricName, v, a1_]*gr_data[vRoot,grG_metricName, a2_]
       + gr_data[accdn_,grG_metricName, v, a2_]*gr_data[vRoot,grG_metricName, a1_]
       )/2
       - gr_data[expsc_,grG_metricName, v]*gr_data[hdndn_,grG_metricName,v,a1_,a2_]/3:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# shear scalar, sigma
#------------------------------------------------------------------------------
grG_ObjDef[shear][grC_header] := `Shear scalar`:
grG_ObjDef[shear][grC_root] := shear_:
grG_ObjDef[shear][grC_rootStr] := `sigma`:
grG_ObjDef[shear][grC_indexList] := []:
grG_ObjDef[shear][grC_calcFn] := grF_calc_sigma:
grG_ObjDef[shear][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[shear][grC_operandSeq] := grVector:
grG_ObjDef[shear][grC_depends] := { shear[grG_grVector](up,dn) }:

grF_calc_sigma := proc( object, list)
local	a, b, s, v:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[shearupdn_,grG_metricName, v, a, b]*
               gr_data[shearupdn_,grG_metricName, v, b, a]:
    od:
  od:
  RETURN(sqrt(s)):
end:

#------------------------------------------------------------------------------
# Raychaudhuri's equation
#------------------------------------------------------------------------------
grG_ObjDef[RayEqn][grC_header] := `Raychaudhuri Equation`:
grG_ObjDef[RayEqn][grC_root] := RayEqn_:
grG_ObjDef[RayEqn][grC_rootStr] := `RayEqn`:
grG_ObjDef[RayEqn][grC_indexList] := []:
grG_ObjDef[RayEqn][grC_calcFn] := grF_calc_RayEqn:
grG_ObjDef[RayEqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[RayEqn][grC_operandSeq] := grVector:
grG_ObjDef[RayEqn][grC_depends] := { R(dn,dn), grG_grVector(up), grG_grVector(up,cdn),
                     expsc[grG_grVector], acc[grG_grVector](up,cdn),
                     shear[grG_grVector], vor[grG_grVector] }:

grF_calc_RayEqn := proc( object, list)
local	a, b, ls, rs, v, vRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  ls := 0:
  rs := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      ls := ls - gr_data[Rdndn_,grG_metricName,a,b]*gr_data[vRoot,grG_metricName,a]*
            gr_data[vRoot,grG_metricName,b]:
    od:
    rs := rs + diff( gr_data[expsc_,grG_metricName,v], gr_data[xup_,grG_metricName,a] )*
          gr_data[vRoot,grG_metricName,a] - gr_data[accupcdn_,grG_metricName,grG_grVector,a,a]:
  od:
  rs := rs + (gr_data[expsc_,grG_metricName, v]^2) + (gr_data[shear_,grG_metricName, v]^2 -
        gr_data[vor_,grG_metricName, v]^2):
  RETURN ( ls = rs ):
end:

#------------------------------------------------------------------------------
# optical shear scalar, sigma*sigmabar
#------------------------------------------------------------------------------
grG_ObjDef[Opshear][grC_header] := `Optical shear scalar`:
grG_ObjDef[Opshear][grC_root] := Opshear_:
grG_ObjDef[Opshear][grC_rootStr] := `|sigma|^2`:
grG_ObjDef[Opshear][grC_indexList] := []:
grG_ObjDef[Opshear][grC_calcFn] := grF_calc_Opsigma:
grG_ObjDef[Opshear][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Opshear][grC_operandSeq] := grVector:
grG_ObjDef[Opshear][grC_depends] := { grG_grVector(up,cup), grG_grVector(dn,cdn),
                     Opexpsc[grG_grVector] }:

grF_calc_Opsigma := proc( object, list)
local	a, b, s, v, dvupRoot, dvdnRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  dvupRoot := grG_ObjDef[v(up,cup)][grC_root]:
  dvdnRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := -gr_data[Opexpsc_,grG_metricName,v]^2:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + (gr_data[dvdnRoot,grG_metricName, a, b] + gr_data[dvdnRoot,grG_metricName, b, a])
               *gr_data[dvupRoot,grG_metricName,a,b]/4:
    od:
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# optical vorticity scalar, omega^2
#------------------------------------------------------------------------------
grG_ObjDef[Opvor][grC_header] := `Optical vorticity scalar`:
grG_ObjDef[Opvor][grC_root] := Opvor_:
grG_ObjDef[Opvor][grC_rootStr] := `omega^2`:
grG_ObjDef[Opvor][grC_indexList] := []:
grG_ObjDef[Opvor][grC_calcFn] := grF_calc_Opvor:
grG_ObjDef[Opvor][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Opvor][grC_operandSeq] := grVector:
grG_ObjDef[Opvor][grC_depends] := { g(up,up), grG_grVector(up,cup), grG_grVector(dn,cdn) }:

grF_calc_Opvor := proc( object, list)
local	a, b, s, v, dvupRoot, dvdnRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  dvupRoot := grG_ObjDef[v(up,cup)][grC_root]:
  dvdnRoot := grG_ObjDef[v(dn,cdn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + (gr_data[dvdnRoot,grG_metricName, a, b] - gr_data[dvdnRoot,grG_metricName, b, a])
               *gr_data[dvupRoot,grG_metricName, a, b]:
    od:
  od:
  RETURN(s/4):
end:

#------------------------------------------------------------------------------
# optical expscansion scalar, Theta
#------------------------------------------------------------------------------
grG_ObjDef[Opexpsc][grC_header] := `Optical expansion scalar`:
grG_ObjDef[Opexpsc][grC_root] := Opexpsc_:
grG_ObjDef[Opexpsc][grC_rootStr] := `Theta`:
grG_ObjDef[Opexpsc][grC_indexList] := []:
grG_ObjDef[Opexpsc][grC_calcFn] := grF_calc_Optheta:
grG_ObjDef[Opexpsc][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Opexpsc][grC_operandSeq] := grVector:
grG_ObjDef[Opexpsc][grC_depends] := { grG_grVector(up,cdn) }:

grF_calc_Optheta := proc( object, list)
local	a, s, v, dvRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  dvRoot := grG_ObjDef[v(up,cdn)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[dvRoot,grG_metricName, a, a]:
  od:
  RETURN(s/2):
end:

#------------------------------------------------------------------------------
# optical Raychaudhuri's equation
#------------------------------------------------------------------------------
grG_ObjDef[OpRayEqn][grC_header] := `Optical Raychaudhuri equation`:
grG_ObjDef[OpRayEqn][grC_root] := OpRayEqn_:
grG_ObjDef[OpRayEqn][grC_rootStr] := `OpRayEqn`:
grG_ObjDef[OpRayEqn][grC_indexList] := []:
grG_ObjDef[OpRayEqn][grC_calcFn] := grF_calc_OpRayEqn:
grG_ObjDef[OpRayEqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[OpRayEqn][grC_operandSeq] := grVector:
grG_ObjDef[OpRayEqn][grC_depends] := { Opexpsc[grG_grVector], Opvor[grG_grvector],
                     Opshear[grG_grVector] }:

grF_calc_OpRayEqn := proc( object, list)
local	a, b, ls, rs, v, vRoot:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  ls := 0:
  rs := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      ls := ls + gr_data[Rdndn_,grG_metricName,a,b]*gr_data[vRoot,grG_metricName,a]*gr_data[vRoot,grG_metricName,b]:
    od:
    rs := rs + diff( gr_data[Opexpsc_,grG_metricName,v], gr_data[xup_,grG_metricName,a] )*
          gr_data[vRoot,grG_metricName,a]:
  od:
  rs := rs + gr_data[Opexpsc_,grG_metricName,v]^2 + gr_data[Opshear_,grG_metricName,v] -
             gr_data[Opvor_,grG_metricName,v]:
  ls := -ls/2:

  RETURN( ls = rs ):
end:

#------------------------------------------------------------------------------
# Electric part of Weyl
#------------------------------------------------------------------------------
grG_ObjDef[E(dn,dn)][grC_header] := `Electric part of Weyl`:
grG_ObjDef[E(dn,dn)][grC_root] := Edndn_:
grG_ObjDef[E(dn,dn)][grC_rootStr] := `E`:
grG_ObjDef[E(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[E(dn,dn)][grC_calcFn] := grF_calc_E:
grG_ObjDef[E(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[E(dn,dn)][grC_operandSeq] := grVector:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[E(dn,dn)][grC_depends] := { C(dn,dn,dn,dn), grG_grVector(up) }:

grF_calc_E := proc( object, list)
local	a, b, v, vRoot, s:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[Cdndndndn_,grG_metricName,a1_,a,a2_,b]*gr_data[vRoot,grG_metricName,a]*
           gr_data[vRoot,grG_metricName,b]:
    od:
  od:

  RETURN(s):
end:

#------------------------------------------------------------------------------
# Magnetic part of Weyl
#------------------------------------------------------------------------------
grG_ObjDef[H(dn,dn)][grC_header] := `Magnetic part of Weyl`:
grG_ObjDef[H(dn,dn)][grC_root] := Hdndn_:
grG_ObjDef[H(dn,dn)][grC_rootStr] := `H`:
grG_ObjDef[H(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[H(dn,dn)][grC_calcFn] := grF_calc_H:
grG_ObjDef[H(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[H(dn,dn)][grC_operandSeq] := grVector:
grG_ObjDef[H(dn,dn)][grC_depends] := { Cstar(dn,dn,dn,dn), grG_grVector(up) }:

grF_calc_H := proc( object, list)
local	a, b, v, vRoot, s:
global gr_data, grG_ObjDef, grG_metricName;

  v := grG_grVector:
  vRoot := grG_ObjDef[v(up)][grC_root]:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[Cstardndndndn_,grG_metricName,a1_,a,a2_,b]*gr_data[vRoot,grG_metricName,a]*
               gr_data[vRoot,grG_metricName,b]:
    od:
  od:

  RETURN(s):
end:

#==============================================================================
