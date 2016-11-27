########################################################
#
# clawHist.mpl
#
# Definitions for the conservation law (claw) and history
# equations for shell dynamics.
#
# These are defined as operators.
#
# Also defined is pf(dn,dn), the defintion of a perfect
# fluid.
#
# July  3, 1996   Created [pm]
#
########################################################

#----------------------------
# claw[ S, G](dn)
#
# The two parameters are the intrinsic and
# extrinsic stress-energy tensors. 
#
# e.g could be refered to as S3, T and
#     we'd use S3(dn,up) and T(dn,dn)
#
# If the second parm is omitted then the
# default value is G(dn,dn)/8/Pi
#
# When used as claw[ S3](dn) the resulting
# equation is always *identically* true.
#
# Conservation Law for the surface
#
# DEFINED FOR THE SURFACE
#----------------------------
macro( gr = grG_ObjDef[claw(dn)]):
gr[grC_header] := `Conservation Law Operator`:
gr[grC_root] := claw_:
gr[grC_rootStr] := `claw `:
gr[grC_indexList] := [dn]:
gr[grC_operandSeq] := intrinsicSE, extrinsicSE:
gr[grC_calcFn] := grF_calc_claw:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { grG_intrinsicSE(dn,up,cdn), 
                     grG_extrinsicSE[grG_partner_[gname]](dn,dn),
                     n[grG_partner_[gname]](up) }:

grG_default_extrinsicSE := G:

grF_calc_claw := proc( object, iList)

local r, a, b, div:

   #
   # first take the divergence of the intrinsic SE
   #
   div := 0:
   for a to Ndim[gname] do
      div := div + grG_.grG_intrinsicSE.dnupcdn_[gname, a1_, a, a]:
   od:
   div := grG_simpHow( grG_preSeq, div, grG_postSeq):

   #
   # resulting eqn is *intrinsic* so we want to project the
   # rhs once we've built it up
   #

   r := 0:
   for a to Ndim[gname]+1 do
    for b to Ndim[gname]+1 do 
       r := r + grG_.grG_extrinsicSE.dndn_[ grG_partner_[grG_metricName],a,b] *
       diff( grG_xformup_[grG_partner_[grG_metricName],a],
             grG_xup_[gname,a1_]) *
       grG_nup_[ grG_partner_[grG_metricName],b]:

    od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, grG_partner_[gname], gname);

   RETURN( grG_utype_[ grG_partner_[ gname]] * div = r);

end:

#----------------------------
# hist[ S, G]
#
# The two parameters are the intrinsic and
# extrinsic stress-energy tensors. 
#
# e.g could be refered to as S3, T and
#     we'd use S3(dn,up) and T(dn,dn)
#
# If the second parm is omitted then the
# default value is G(dn,dn)/8/Pi
#
# When used as claw[ S3](dn) the resulting
# equation is always *identically* true.
#
# Conservation Law for the surface
#
# DEFINED FOR THE SURFACE
#----------------------------
macro( gr = grG_ObjDef[hist]):
gr[grC_header] := `History Equation Operator`:
gr[grC_root] := hist_:
gr[grC_rootStr] := `hist `:
gr[grC_indexList] := []:
gr[grC_operandSeq] := intrinsicSE, extrinsicSE:
gr[grC_calcFn] := grF_calc_hist:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { grG_intrinsicSE(up,up), 
                     Mean[K(dn,dn)],
                     grG_extrinsicSE[grG_partner_[gname]](dn,dn),
                     n[grG_partner_[gname]](up) }:

grF_calc_hist := proc( object, iList)

local r, a, b, left:

   #
   # first contract S with Mean[K] (this is lhs of eqn)
   #
   left := 0:
   for a to Ndim[gname] do
     for b to Ndim[gname] do
      left := left + 
              grG_.grG_intrinsicSE.upup_[gname, a, b] *
              grG_Mean_[gname, K(dn,dn), grG_join_[gname], a,b ]:
      od:
   od:

   #
   # resulting eqn is *intrinsic* so we want to project the
   # rhs once we've built it up
   #

   r := 0:
   for a to Ndim[gname]+1 do
     for b to Ndim[gname]+1 do 
       r := r + grG_.grG_extrinsicSE.dndn_[ grG_partner_[grG_metricName],a,b] *
            grG_nup_[ grG_partner_[grG_metricName],a]*
            grG_nup_[ grG_partner_[grG_metricName],b]:
     od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, grG_partner_[gname], gname);

   RETURN( -left = grG_utype_[ grG_partner_[ gname]] * r);

end:

#--------------------------------------
# pf(dn,dn)
#
# Perfect fluid 
#--------------------------------------
macro( gr = grG_ObjDef[pf(dn,dn)]):
gr[grC_header] := `Perfect fluid`:
gr[grC_root] := pfdndn_:
gr[grC_rootStr] := `pf `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_pfdndn:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { u3(dn), sigma1, P1 }:

grF_calc_pfdndn := proc( object, iList)

  (grG_sigma1_[gname] + grG_P1_[gname])* 
  grG_u3dn_[gname,a1_] * grG_u3dn_[gname,a2_]
  + grG_P1_[gname] * grG_gdndn_[gname,a1_, a2_]:

end:

#----------------------------
# nullclaw[ S, G](dn)
#
# The two parameters are the intrinsic and
# extrinsic stress-energy tensors. 
#
# e.g could be refered to as S3, T and
#     we'd use S3(dn,up) and T(dn,dn)
#
# If the second parm is omitted then the
# default value is G(dn,dn)/8/Pi
#
# When used as claw[ S3](dn) the resulting
# equation is always *identically* true.
#
# Conservation Law for the surface
#
# DEFINED FOR THE SURFACE
#----------------------------
macro( gr = grG_ObjDef[nullclaw]):
gr[grC_header] := `Null Conservation Law Operator`:
gr[grC_root] := nullclaw_:
gr[grC_rootStr] := `nullclaw `:
gr[grC_indexList] := []:
gr[grC_operandSeq] := intrinsicSE, extrinsicSE:
gr[grC_calcFn] := grF_calc_nullclaw:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { grG_intrinsicSE(up,up), 
                     grG_extrinsicSE[grG_partner_[gname]](dn,dn),
                     N[grG_partner_[gname]](up),
                     nullK(dn,dn),
                     Mean[ nullGamma(dn) ] }:

grG_default_extrinsicSE := G:

grF_calc_claw := proc( object, iList)

local r, a, b, div:

   #
   # first take the divergence of the intrinsic SE
   #
   div := 0:
   for a to Ndim[gname] do
      div := div + grG_.grG_intrinsicSE.dnupcdn_[gname, a1_, a, a]:
   od:
   div := grG_simpHow( grG_preSeq, div, grG_postSeq):

   #
   # resulting eqn is *intrinsic* so we want to project the
   # rhs once we've built it up
   #

   r := 0:
   for a to Ndim[gname]+1 do
    for b to Ndim[gname]+1 do 
       r := r + grG_.grG_extrinsicSE.dndn_[ grG_partner_[grG_metricName],a,b] *
       diff( grG_xformup_[grG_partner_[grG_metricName],a],
             grG_xup_[gname,a1_]) *
       grG_nup_[ grG_partner_[grG_metricName],b]:

    od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, grG_partner_[gname], gname);

   RETURN( grG_utype_[ grG_partner_[ gname]] * div = r);

end:
