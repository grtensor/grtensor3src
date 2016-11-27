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
grG_ObjDef[claw(dn)][grC_header] := `Conservation Law Operator`:
grG_ObjDef[claw(dn)][grC_root] := claw_:
grG_ObjDef[claw(dn)][grC_rootStr] := `claw `:
grG_ObjDef[claw(dn)][grC_indexList] := [dn]:
grG_ObjDef[claw(dn)][grC_operandSeq] := intrinsicSE, extrinsicSE:
grG_ObjDef[claw(dn)][grC_calcFn] := grF_calc_claw:
grG_ObjDef[claw(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[claw(dn)][grC_depends] := { grG_intrinsicSE(dn,up,cdn),
                     gr_data[extrinsicSE,gr_data[partner_,gname]](dn,dn),
                     n[gr_data[partner_,gname]](up) }:

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
       r := r + grG_.grG_extrinsicSE.dndn_[ gr_data[partner_,grG_metricName],a,b] *
       diff( gr_data[xformup_,gr_data[partner_,grG_metricName],a],
             gr_data[xup_,gname,a1_]) *
       gr_data[nup_, gr_data[partner_,grG_metricName],b]:

    od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, gr_data[partner_,gname], gname);

   RETURN( gr_data[utype_, gr_data[partner_, gname]] * div = r);

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
grG_ObjDef[hist][grC_header] := `History Equation Operator`:
grG_ObjDef[hist][grC_root] := hist_:
grG_ObjDef[hist][grC_rootStr] := `hist `:
grG_ObjDef[hist][grC_indexList] := []:
grG_ObjDef[hist][grC_operandSeq] := intrinsicSE, extrinsicSE:
grG_ObjDef[hist][grC_calcFn] := grF_calc_hist:
grG_ObjDef[hist][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[hist][grC_depends] := { grG_intrinsicSE(up,up),
                     Mean[K(dn,dn)],
                     gr_data[extrinsicSE,gr_data[partner_,gname]](dn,dn),
                     n[gr_data[partner_,gname]](up) }:

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
              gr_data[Mean_,gname, K(dn,dn), gr_data[join_,gname], a,b ]:
      od:
   od:

   #
   # resulting eqn is *intrinsic* so we want to project the
   # rhs once we've built it up
   #

   r := 0:
   for a to Ndim[gname]+1 do
     for b to Ndim[gname]+1 do
       r := r + grG_.grG_extrinsicSE.dndn_[ gr_data[partner_,grG_metricName],a,b] *
            gr_data[nup_, gr_data[partner_,grG_metricName],a]*
            gr_data[nup_, gr_data[partner_,grG_metricName],b]:
     od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, gr_data[partner_,gname], gname);

   RETURN( -left = gr_data[utype_, gr_data[partner_, gname]] * r);

end:

#--------------------------------------
# pf(dn,dn)
#
# Perfect fluid
#--------------------------------------
grG_ObjDef[pf(dn,dn)][grC_header] := `Perfect fluid`:
grG_ObjDef[pf(dn,dn)][grC_root] := pfdndn_:
grG_ObjDef[pf(dn,dn)][grC_rootStr] := `pf `:
grG_ObjDef[pf(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[pf(dn,dn)][grC_calcFn] := grF_calc_pfdndn:
grG_ObjDef[pf(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[pf(dn,dn)][grC_depends] := { u3(dn), sigma1, P1 }:

grF_calc_pfdndn := proc( object, iList)

  (gr_data[sigma1_,gname] + gr_data[P1_,gname])*
  gr_data[u3dn_,gname,a1_] * gr_data[u3dn_,gname,a2_]
  + gr_data[P1_,gname] * gr_data[gdndn_,gname,a1_, a2_]:

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
grG_ObjDef[nullclaw][grC_header] := `Null Conservation Law Operator`:
grG_ObjDef[nullclaw][grC_root] := nullclaw_:
grG_ObjDef[nullclaw][grC_rootStr] := `nullclaw `:
grG_ObjDef[nullclaw][grC_indexList] := []:
grG_ObjDef[nullclaw][grC_operandSeq] := intrinsicSE, extrinsicSE:
grG_ObjDef[nullclaw][grC_calcFn] := grF_calc_nullclaw:
grG_ObjDef[nullclaw][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nullclaw][grC_depends] := { grG_intrinsicSE(up,up),
                     gr_data[extrinsicSE,gr_data[partner_,gname]](dn,dn),
                     N[gr_data[partner_,gname]](up),
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
       r := r + grG_.grG_extrinsicSE.dndn_[ gr_data[partner_,grG_metricName],a,b] *
       diff( gr_data[xformup_,gr_data[partner_,grG_metricName],a],
             gr_data[xup_,gname,a1_]) *
       gr_data[nup_, gr_data[partner_,grG_metricName],b]:

    od:
   od:

   # G_ab = 8 Pi T_ab and so....
   if grG_extrinsicSE = G then
     r := r/8/Pi:
   fi:

   r := juncF_project( r, gr_data[partner_,gname], gname);

   RETURN( gr_data[utype_, gr_data[partner_, gname]] * div = r);

end:
