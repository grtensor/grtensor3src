#////////////////////////////
#////////////////////////////
#
# OBJECTS
#
# There are two ways to do shells
#
# A) Specify M+ M- and determine equations for sigma,P
#
# B) Specify either M+ or M- and sigma,P and solve
#    for M- or M+
#
# Those objects/equations with 1 appended to them correspond
# to case B.
#
# Oct 25 94  Corrected normalization of n(dn). Explicit u(up) calc.
#
# Oct 31 94  Fixed n(dn,cdn) u(up,cdn) test for static shells.
#
# Dec 12 94  Add do_unchain boolean for unleash calls. g(dn,dn) need
#            not do this -> saves a LOT of time for Voorhees
#
# Mar 29 95  New K(dn,dn) definition which does not need unchain!
#
# Apr 28, 95 Use udot(up) def'n which avoid unchain (unchain is no more)
#
# July 11, 95 Change the sign of sigma 
#
# Aug.  2, 95 Add divSTeqn and underlying objects
#
# Aug   8, 95 Remove n(dn,cdn). Add grF_enter_xform.
#
# Sept.21, 95 enter xform as a list.
#
# Oct.  1, 95 HCeqn -> HCTeqn, HCGeqn. PCeqn Likewise
#             add mass and evInt
#
# Oct. 24, 95 divS3 now projects to avoid D[1](u)(r,theta) type stuff.
#
# Nov.  9, 95 add explicit S3(dn,up,cdn) def
#
# Nov. 28, 95 Corrected missing 1/8Pi in SKGeqn, divSGeqn(dn)
#
# Apr 13, 96  Change n(dn) so that if ntype=0 doesn't normalize
#
# June 26, 96 Invoke grOptionDefaultSimp going into unleash (instead of
#             normal)
#
# June 30, 96 grOptionDefaultSimp -> grG_simpHow (with prefix etc.)
#
#
#
#////////////////////////////
#////////////////////////////

macro( gname = grG_metricName):

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#
# SUPPORT ROUTINE
#
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#
# grF_calc_sum2_project
#
# Like the standard calc_sum2, but use project at the end to
# ensure the result is converted to quantities which are
# defined *on* Sigma
#
#
grF_calc_sum2_project := proc(object, iList)

local s, surf, M;
global s1_, s2_:
  #
  # first determine if the metric is the surface or full manifold
  #
  if Ndim[gname] > Ndim[ grG_partner_[ gname]] then
    surf := grG_partner_[ gname] :
    M := gname:
  else
    surf := gname:
    M := grG_partner_[ gname]:
  fi:

  s := 0:
   for s1_ to Ndim[grG_metricName] do
     for s2_ to Ndim[grG_metricName]do
       s := s + grG_ObjDef[object][grC_calcFnParms]:
   od:
 od:

 juncF_project( s, M, surf);

end:

#----------------------------
# C1lhs
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[C1lhs]):
gr[grC_header] := `Conservation laws for the surface`:
gr[grC_root] := C1lhs_:
gr[grC_rootStr] := `C1lhs `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_sigma1dot_[gname] + (grG_sigma1_[gname] + grG_P1_[gname])
   * grG_u3div_[gname]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma1, sigma1dot, u3div, P1}:

#----------------------------
# C2lhs
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[C2lhs]):
gr[grC_header] := `Conservation laws for the surface`:
gr[grC_root] := C2lhs_:
gr[grC_rootStr] := `C2lhs `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_sigmadot_[gname] + (grG_sigma_[gname] + grG_P_[gname])
   * grG_u3div_[gname]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma, sigmadot, u3div, P}:

#----------------------------
# CGeqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[CGeqn]):
gr[grC_header] := `Conservation`:
gr[grC_root] := CGeqn_:
gr[grC_rootStr] := `CGeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_C1lhs_[gname]' =
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Gun,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {C1lhs, 
 [grG_partner_[gname], Jump[Gun, grG_partner_[grG_join_[gname]]]] }:


#----------------------------
# CTeqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[CTeqn]):
gr[grC_header] := `Conservation law (T(dn,dn) and sigma)`:
gr[grC_root] := CTeqn_:
gr[grC_rootStr] := `CTeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_C1lhs_[gname]' = 
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Tun,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {C1lhs, 
                    [grG_partner_[gname], Jump[Tun, grG_partner_[grG_join_[gname]]]] }:


#----------------------------
# C2Geqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[C1Geqn]):
gr[grC_header] := `Conservation law`:
gr[grC_root] := C1Geqn_:
gr[grC_rootStr] := `C1Geqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_C2lhs_[gname]' =
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Gun,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {C2lhs, 
                    [grG_partner_[gname], Jump[Gun, grG_partner_[grG_join_[gname]]]] }:

#----------------------------
# C1Teqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[C1Teqn]):
gr[grC_header] := `Conservation law`:
gr[grC_root] := C1Teqn_:
gr[grC_rootStr] := `C1Teqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_C2lhs_[gname]' =
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Tun,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {C2lhs,
                    [grG_partner_[gname], Jump[Tun, grG_partner_[grG_join_[gname]]]] }:

#----------------------------
# divS3(dn)
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[divS3(dn)]):
gr[grC_header] := ``:
gr[grC_root] := divS3dn_:
gr[grC_rootStr] := `divS3 `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_divS3:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {S3(dn,up,cdn) }:

grF_calc_divS3 := proc(object, iList)

local s, a;

 s := 0;
 for a to Ndim[gname] do
    s :=  s + grG_S3dnupcdn_[gname, a1_, a, a]: 
 od:
 
# juncF_project( s, grG_partner_[gname], gname);
  s;

end:

#----------------------------
# divSGeqn(dn)
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[divSGeqn(dn)]):
gr[grC_header] := ``:
gr[grC_root] := divSGeqndn_:
gr[grC_rootStr] := `divSGeqn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_utype_[grG_partner_[gname]]* grG_divS3dn_[gname, a1_]' =
  'grG_Jump_[gname,Gxn(dn),grG_join_[gname],a1_ ]/8/Pi':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {Gxn(dn), divS3(dn), Jump[Gxn(dn)]}:

#----------------------------
# divSTeqn(dn)
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[divSTeqn(dn)]):
gr[grC_header] := ``:
gr[grC_root] := divSTeqndn_:
gr[grC_rootStr] := `divSTeqn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_utype_[grG_partner_[gname]]* grG_divS3dn_[gname, a1_]' =
  'grG_Jump_[gname,Txn(dn),grG_join_[gname],a1_ ]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {Txn(dn), divS3(dn), Jump[Txn(dn)]}:


#----------------------------
# evInt
#
# Evolution integral
#----------------------------
macro( gr = grG_ObjDef[evInt]):
gr[grC_header] := ``:
gr[grC_root] := evInt_:
gr[grC_rootStr] := `evInt `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_evInt:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { sigma,
     [grG_partner_[gname], Jump[mass, grG_partner_[grG_join_[gname]]]],
     [grG_partner_[gname], Mean[mass, grG_partner_[grG_join_[gname]]]] }:


grF_calc_evInt := proc(object, iList)


local iSeq, M, s:

 iSeq := grG_partner_[gname], mass, grG_join_[grG_partner_[gname]]:
 M := 4*Pi*grG_sigma_[gname]*R(tau)^2:

 s := 
   diff(R(tau),tau)^2 =
   grG_utype_[grG_partner_[gname]] +
   ( grG_Jump_[iSeq]/M)^2
   - 2*grG_utype_[grG_partner_[gname]]*grG_Mean_[iSeq]/R(tau)
   + (M/2/R(tau))^2:

 juncF_project( s, grG_partner_[gname], gname);

end:

#----------------------------
# evInt1
#
# Evolution integral
#----------------------------
macro( gr = grG_ObjDef[evInt1]):
gr[grC_header] := ``:
gr[grC_root] := evInt1_:
gr[grC_rootStr] := `evInt1 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_evInt1:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { sigma1,
     [grG_partner_[gname], Jump[mass, grG_partner_[grG_join_[gname]]]],
     [grG_partner_[gname], Mean[mass, grG_partner_[grG_join_[gname]]]] }:


grF_calc_evInt1 := proc(object, iList)


local iSeq, M, s :

 iSeq := grG_partner_[gname], mass, grG_join_[grG_partner_[gname]]:
 M := 4*Pi*grG_sigma1_[gname]*R(tau)^2:

 s := 
   diff(R(tau),tau)^2 =
   grG_utype_[grG_partner_[gname]] +
   ( grG_Jump_[iSeq]/M)^2
   - 2*grG_utype_[grG_partner_[gname]]*grG_Mean_[iSeq]/R(tau)
   + (M/2/R(tau))^2:

 juncF_project( s, grG_partner_[gname], gname);

end:


#----------------------------
# g(dn,dn)
#
# Add a pre_calc function for the metric
# This is referenced from the grii g(dn,dn) code.
#----------------------------

grF_pre_calc_ff1 := proc()

 local a1, a2, s, a,b, pname;
 global grG_gdndn_, grG_xformup_, grG_xup_, grG_partner;

 pname := grG_partner_[gname]:
 for a1 to Ndim[gname] do
   for a2 from a1 to Ndim[gname] do
     s := 0:
     for a to Ndim[gname]+1 do
       for b to Ndim[gname]+1 do
         s := s + diff(grG_xformup_[pname,a], grG_xup_[grG_metricName,a1])
                * diff(grG_xformup_[pname,b], grG_xup_[grG_metricName,a2])
                * grG_gdndn_[pname,a,b]:
       od:
     od:
     grG_gdndn_[gname, a1, a2] := s:
     grG_gdndn_[gname, a2, a1] := s:
   od:
 od:
 juncF_project( grG_simpHow( grG_preSeq, s, grG_postSeq), pname, gname);

end:

#----------------------------
# Gnn
#
# Defined for the manifold
#----------------------------
macro( gr = grG_ObjDef[Gnn]):
gr[grC_header] := `G{a b} n{^a} n{^b}`:
gr[grC_root] := Gnn_:
gr[grC_rootStr] := `Gnn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2_project:
gr[grC_calcFnParms] := 'grG_Gdndn_[grG_metricName,s1_,s2_]'*
                       'grG_nup_[grG_metricName,s1_]' *
                       'grG_nup_[grG_metricName,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {G(dn,dn),n(up)}:

#----------------------------
# Gun
#
# Defined for the manifold
#----------------------------
macro( gr = grG_ObjDef[Gun]):
gr[grC_header] := `G{a b} u{^a} n{^b}`:
gr[grC_root] := Gun_:
gr[grC_rootStr] := `Gun `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2_project:
gr[grC_calcFnParms] := 'grG_Gdndn_[grG_metricName,s1_,s2_]'*
                       'grG_uup_[grG_metricName,s1_]' *
                       'grG_nup_[grG_metricName,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {G(dn,dn),u(up)}:

#----------------------------
# Gxn(dn)
#
# Defined for the surface
#----------------------------
macro( gr = grG_ObjDef[Gxn(dn)]):
gr[grC_header] := `G{a b} diff(x{^a},xi{^i}) n{^b}`:
gr[grC_root] := Gxndn_:
gr[grC_rootStr] := `Gxn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_Gxn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {[grG_partner_[gname], G(dn,dn)],
          [grG_partner_[gname], n(up)]}:

grF_calc_Gxn := proc( object, iList)
local s, a, b:
 s := 0:
 for a to Ndim[gname] do
    for b to Ndim[gname] do
       s := s + grG_Gdndn_[ grG_partner_[grG_metricName],a,b] *
       diff( grG_xformup_[grG_partner_[grG_metricName],a],
             grG_xup_[gname,a1_]) *
       grG_nup_[ grG_partner_[grG_metricName],b]:

    od:
 od:

 juncF_project( s, grG_partner_[gname], gname);

end:
#----------------------------
# HCGeqn
#
# Hamiltonian constraint equation on Sigma (G version)
#----------------------------
macro( gr = grG_ObjDef[HCeqn]):
gr[grC_header] := `R + K^2 +K_{ij} K^{ij} = 0`:
gr[grC_root] := HCeqn_:
gr[grC_rootStr] := `HCeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := 'grG_scalarR_[grG_metricName]'+
                       'grG_trK_[grG_metricName]'^2 -
                       'grG_Ksq_[grG_metricName]' =
                       'grG_Gnn_[grG_partner_[grG_metricName]]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {Ricciscalar,trK,Ksq, [grG_partner_[gname], Tnn]}:

#----------------------------
# HCTeqn
#
# Hamiltonian constraint equation on Sigma (T version)
#----------------------------
macro( gr = grG_ObjDef[HCeqn]):
gr[grC_header] := `R + K^2 +K_{ij} K^{ij} = 0`:
gr[grC_root] := HCeqn_:
gr[grC_rootStr] := `HCeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := 'grG_scalarR_[grG_metricName]'+
                       'grG_trK_[grG_metricName]'^2 -
                       'grG_Ksq_[grG_metricName]' = 0:
                       8*Pi* 'grG_Tnn_[grG_partner[grG_metricName]]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {Ricciscalar,trK,Ksq, [grG_partner_[gname], Tnn] }:

#----------------------------
# H2lhs
#
# History for the surface
#----------------------------
macro( gr = grG_ObjDef[Hlhs]):
gr[grC_header] := `History for the surface`:
gr[grC_root] := Hlhs_:
gr[grC_rootStr] := `Hlhs `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Hlhs:
gr[grC_symmetry] := grF_sym_scalar:
#
# rely on grG_default_Mint
#
gr[grC_depends] := {sigma, P,
     [grG_partner_[gname],Mean[ndotu, grG_partner_[grG_join_[gname]]] ],
     Mean[trK], ntype[grG_partner_[gname]]}:


grF_calc_Hlhs := proc(object, iList)


 grG_ntype_[grG_partner_[gname]] *
 ( grG_sigma_[gname] + grG_P_[gname]) *
 grG_Mean_[grG_partner_[gname],ndotu,grG_join_[grG_partner_[gname]]] +
 grG_P_[gname]* grG_Mean_[gname,trK,grG_join_[gname] ];

end:

#----------------------------
# H1lhs
#
# HIstory for the surface
#----------------------------
macro( gr = grG_ObjDef[H1lhs]):
gr[grC_header] := `History for the surface`:
gr[grC_root] := H1lhs_:
gr[grC_rootStr] := `H1lhs `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_H1lhs:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma1, P1, Mean[trK],
     [grG_partner_[gname],Mean[ndotu, grG_partner_[grG_join_[gname]]] ],
     ntype[grG_partner_[gname]]}:


grF_calc_H1lhs := proc(object, iList)


 grG_utype_[grG_partner_[gname]] *
 ( grG_sigma1_[gname] + grG_P1_[gname]) *
 grG_Mean_[grG_partner_[gname],ndotu,grG_join_[grG_partner_[gname]]] +
 grG_P1_[gname]* grG_Mean_[gname,trK,grG_default_Mint];

end:

#----------------------------
# HGeqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[HGeqn]):
gr[grC_header] := `History equation`:
gr[grC_root] := HGeqn_:
gr[grC_rootStr] := `HGeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_H1lhs_[gname]' =
 'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Gnn,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {H1lhs, 
                    [grG_partner_[gname], Jump[Gnn, grG_partner_[grG_join_[gname]]]] }:


#----------------------------
# HTeqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[HTeqn]):
gr[grC_header] := `History equation`:
gr[grC_root] := HTeqn_:
gr[grC_rootStr] := `HTeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_H1lhs_[gname]' =
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Tnn,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {H1lhs, 
                    [grG_partner_[gname], Jump[Tnn, grG_partner_[grG_join_[gname]]]] }:

#----------------------------
# H1Geqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[H1Geqn]):
gr[grC_header] := `History equation`:
gr[grC_root] := H1Geqn_:
gr[grC_rootStr] := `H1Geqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_H2lhs_[gname]' =
 'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Gnn,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {H2lhs, 
                    [grG_partner_[gname], Jump[Gnn, grG_partner_[grG_join_[gname]]]] }:

#----------------------------
# H2Teqn
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[H1Teqn]):
gr[grC_header] := `History equation`:
gr[grC_root] := H1Teqn_:
gr[grC_rootStr] := `H1Teqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  'grG_H2lhs_[gname]' =
  'grG_utype_[grG_partner_[gname]] *
   grG_Jump_[grG_partner_[gname], Tnn,grG_partner_[grG_join_[gname]] ]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {H2lhs, 
                    [grG_partner_[gname], Jump[Gnn, grG_partner_[grG_join_[gname]]]] }:

#----------------------------
# K(dn,dn)
#----------------------------
macro( gr = grG_ObjDef[K(dn,dn)]):
gr[grC_header] := `Extrinsic Curvature`:
gr[grC_root] := Kdndn_:
gr[grC_rootStr] := `K `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_ff2:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {n[grG_partner_[grG_metricName]](dn),
		Chr[grG_partner_[grG_metricName]](dn,dn,up)}:

grF_calc_ff2 := proc(object, iList)

local s, a, b, c, s1, pname:

 pname := grG_partner_[gname]:
 s := 0: 
 s1 := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s1 := s1 + grG_ndn_[pname,a] * 
		  diff(grG_xformup_[pname,b],grG_xup_[gname,a1_]) *
		  diff(grG_xformup_[pname,c],grG_xup_[gname,a2_]) *
		  grG_Chrdndnup_[pname,b,c,a];
     od:
   od:
   s := s + grG_ndn_[pname,a] *
	    diff(diff(grG_xformup_[pname,a],grG_xup_[gname,a1_]),
		grG_xup_[gname,a2_]);
 od:

 juncF_project( -s-s1,pname,gname); 

end:

#----------------------------
# Ksq
#----------------------------
macro( gr = grG_ObjDef[Ksq]):
gr[grC_header] := `K_{ij} K^{ij}`:
gr[grC_root] := Ksq_:
gr[grC_rootStr] := `Ksq `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 'grG_Kdnup_[gname,s1_,s2_] * grG_Kdnup_[gname,s2_,s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {K(dn,up)}:

#----------------------------
# trK
#----------------------------
macro( gr = grG_ObjDef[trK]):
gr[grC_header] := `Trace of Extrinsic Curvature`:
gr[grC_root] := trK_:
gr[grC_rootStr] := `trK `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 'grG_Kdndn_[gname,s1_,s2_] * grG_gupup_[gname,s1_,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {K(dn,dn),g(up,up)}:

#----------------------------
# mass (associated with 4-metric - so don't project it)
#----------------------------
macro( gr = grG_ObjDef[mass]):
gr[grC_header] := `mass`:
gr[grC_root] := mass_:
gr[grC_rootStr] := `mass `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_mass:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {R(dn,dn,up,up)}: # dependencies calculated explicitly in junction()

grF_calc_mass := proc(object, iList)

local thetaNum, phiNum, ok, coordList, xformList, i:

  #
  # first check that theta and phi are coordinates of M
  #
  coordList := [ seq(grG_xup_[gname,i], i=1..Ndim[gname])]:
  ok := false:
  if not has( coordList, theta) then
     printf(`mass definition requires coordinate: theta\n`):
  elif not has( coordList, phi) then
     printf(`mass definition requires coordinate: phi\n`):
  elif not has( [seq(grG_xformup_[gname,i],i=1..Ndim[gname])], R(tau) ) then
     printf(`mass definition requires xform: R(tau)\n`):
  else
     ok := true:
  fi:
  if not ok then
     ERROR(`mass calculation stopped.`);
  fi:
  #
  # now determine which coord is theta and phi
  #
  for i to Ndim[gname] do
   if coordList[i] = theta then
     thetaNum := i:
   fi:
   if coordList[i] = phi then
     phiNum := i:
   fi:
  od:
  RETURN( grG_gdndn_[gname,thetaNum,thetaNum]^(3/2) *
           grG_Rdndnupup_[gname,thetaNum,phiNum,thetaNum,phiNum]/2):

end:
#----------------------------
# ndiv
#----------------------------
macro( gr = grG_ObjDef[ndiv]):
gr[grC_header] := `n{^a ; a}`:
gr[grC_root] := ndiv_:
gr[grC_rootStr] := `ndiv `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_ndiv: # preCalc since we need to normalize
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {n(up,cdn)}: # dependencies calculated explicitly in junction()


grF_calc_ndiv := proc(object, iList)

local a, s, pname:

 pname := grG_partner_[gname]:

 s := 0:
 for a to Ndim[gname] do
   s := s + grG_nupcdn_[grG_metricName,a, a]:
 od:

 juncF_project( grG_simpHow( grG_preSeq, s, grG_postSeq), gname, pname):

end:

#----------------------------
# nsign
# assigned in junction()
#----------------------------
macro( gr = grG_ObjDef[nsign]):
gr[grC_header] := `n{a} n{^a}`:
gr[grC_root] := nsign_:
gr[grC_rootStr] := `nsign `:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# ntype
# assigned in junction()
#----------------------------
macro( gr = grG_ObjDef[ntype]):
gr[grC_header] := `n{a} n{^a}`:
gr[grC_root] := ntype_:
gr[grC_rootStr] := `ntype `:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}: # dependencies calculated explicitly in junction()


#----------------------------
# n(dn)
#
#----------------------------
macro( gr = grG_ObjDef[n(dn)]):
gr[grC_header] := `Normal Vector`:
gr[grC_root] := ndn_:
gr[grC_rootStr] := `n `:
gr[grC_indexList] := [dn]:
gr[grC_preCalcFn] := grF_calc_ndn: # preCalc since we need to normalize
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {g(up,up),surface, nsign}:

grF_calc_ndn := proc( object, iList)

local a,b,s, coordList:
global grG_ndn_, grJ_totalVar:

  #
  # if a surface was defined then use the definition n = grad(s)
  # otherwise get n(dn) by lowering n(up) (one of n(dn) or n(up)
  # is *always* defined by surf if surface = 0
  #
  if grG_surface_[gname] <> 0 then
    grJ_totalVar := grG_totalVar_[gname]: # need this for jdiff
    for a to Ndim[gname] do
      grG_ndn_[gname,a] := subs( diff=jdiff,
          diff( grG_surface_[gname], grG_xup_[gname,a])):
    od:
  else
     for a to Ndim[gname] do
        grG_ndn_[gname,a] := 0;
       for b to Ndim[gname] do
          grG_ndn_[gname, a] := grG_ndn_[gname,a] +
                    grG_gdndn_[gname, a, b] * grG_nup_[gname, b]:
       od:
     od:
  fi:
  #
  # want to normalize (if n is non-null), but ensure we don't take sqrt(-1)
  # so multiply normalization factor by ntype
  #
  
  if ( grG_ntype_[gname] <> 0) then
    #
    # calculate the normalization
    #
    s := 0:
    for a to Ndim[gname] do
      for b to Ndim[gname] do
        s := s + grG_gupup_[gname,a,b]
           * grG_ndn_[gname,a]* grG_ndn_[gname,b]:
      od:
    od:
    for a to Ndim[gname] do
       grG_ndn_[gname,a] :=  grG_nsign_[gname]*
           normal(grG_ndn_[gname,a]/
           sqrt( grG_ntype_[gname] * normal(s), symbolic)):
    od:
  fi:

end:

#----------------------------
# n(up)
# This object is assigned by surf or
# calculated by raising n(dn) 
#----------------------------
macro( gr = grG_ObjDef[n(up)]):
gr[grC_header] := `Normal Vector`:
gr[grC_root] := nup_:
gr[grC_rootStr] := `n `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] :=
   'grG_gupup_[grG_metricName, a1_, s1_] * grG_ndn_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#----------------------------
# ndotu
#
# (in the 4-space)
#----------------------------
macro( gr = grG_ObjDef[ndotu]):
gr[grC_header] := `n{a} udot{^a}`:
gr[grC_root] := ndotu_:
gr[grC_rootStr] := `ndotu `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_ndotu: 
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {n(dn),udot(up)}:

grF_calc_ndotu := proc(object, iList)

local a,s, pname:

 s := 0:
 for a to Ndim[gname] do
   s := s + grG_ndn_[gname,a] * grG_udotup_[gname,a]:
 od:
 pname := grG_partner_[gname]:
 juncF_project(s, gname, pname);

end:

#----------------------------
# nuJumpeqn
#
# (intrinsic eqn)
#----------------------------
macro( gr = grG_ObjDef[nuJumpeqn]):
gr[grC_header] := `Jump[n{a} udot{^a}] = - u{^i} u{^j} [K{i j}]`:
gr[grC_root] := nuJumpeqn_:
gr[grC_rootStr] := `nuJumpeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_nuJumpeqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { 
      [ grG_partner_[gname], Jump[ndotu, grG_join_[grG_partner_[gname]]] ], 
        Jump[K(dn,dn)], u3(up)}:


grF_calc_nuJumpeqn := proc(object, iList)

local s, i, j:

 s := 0:
 for i to Ndim[gname] do
   for j to Ndim[gname] do
   s := s + grG_u3up_[gname,i] * grG_u3up_[gname,j] *
            grG_Jump_[gname, K(dn,dn), grG_join_[gname],i,j]:
   od:
 od:

 RETURN(grG_Jump_[ grG_partner_[gname], ndotu, grG_join_[grG_partner_[gname]] ] = - s);

end:

#----------------------------
# nuMeaneqn
#
# (intrinsic eqn)
#----------------------------
macro( gr = grG_ObjDef[nuMeaneqn]):
gr[grC_header] := `Mean[n{a} udot{^a}] = - u{^i} u{^j} Mean[K{i j}]`:
gr[grC_root] := nuMeaneqn_:
gr[grC_rootStr] := `nuMeaneqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_nuMeaneqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { 
      [ grG_partner_[gname], Mean[ndotu, grG_join_[grG_partner_[gname]]] ], 
        Mean[K(dn,dn)], u3(up)}:


grF_calc_nuMeaneqn := proc(object, iList)

local s, i, j:

 s := 0:
 for i to Ndim[gname] do
   for j to Ndim[gname] do
   s := s + grG_u3up_[gname,i] * grG_u3up_[gname,j] *
            grG_Mean_[gname, K(dn,dn), grG_join_[gname],i,j]:
   od:
 od:

 RETURN(grG_Mean_[ grG_partner_[gname], ndotu, grG_join_[grG_partner_[gname]] ] = - s);

end:

#----------------------------
# nuPeqn
#
# (intrinsic eqn)
#----------------------------
macro( gr = grG_ObjDef[nuPeqn]):
gr[grC_header] := `Jump[n{a} udot{^a}] = 8 pi ( P + sigma/2)`:
gr[grC_root] := nuPeqn_:
gr[grC_rootStr] := `nuPeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_nuPeqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { 
      [ grG_partner_[gname], Jump[ndotu, grG_join_[grG_partner_[gname]]] ], 
        sigma, P}:


grF_calc_nuPeqn := proc(object, iList)

 RETURN(grG_Jump_[ grG_partner_[gname], ndotu, grG_join_[grG_partner_[gname]] ]
        =  8 * Pi * ( grG_P_[gname] + grG_sigma_[gname]/2) );

end:

#----------------------------
# nuP1eqn
#
# (intrinsic eqn)
#----------------------------
macro( gr = grG_ObjDef[nuP1eqn]):
gr[grC_header] := `Jump[n{a} udot{^a}] = 8 pi ( P1 + sigma1/2)`:
gr[grC_root] := nuP1eqn_:
gr[grC_rootStr] := `nuP1eqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_nuP1eqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { 
      [ grG_partner_[gname], Jump[ndotu, grG_join_[grG_partner_[gname]]] ], 
        sigma1, P1}:


grF_calc_nuP1eqn := proc(object, iList)

 RETURN(grG_Jump_[ grG_partner_[gname], ndotu, grG_join_[grG_partner_[gname]] ]
         =  8 * Pi * ( grG_P1_[gname] + grG_sigma1_[gname]/2) );

end:

#----------------------------
# P
#
# Pressure of a shell
#----------------------------
macro( gr = grG_ObjDef[P]):
gr[grC_header] := `P `:
gr[grC_root] := P_:
gr[grC_rootStr] := `P `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_P:
gr[grC_calcFnParms] := grG_S3dndn_,grG_sigma_:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma, S3(dn,dn),g(up,up)}:

grF_calc_P := proc(objects, iList)

local s, a, b, pname:

 #
 # find the trace of S
 #
 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + grG_S3dndn_[gname,a,b] * grG_gupup_[gname,a,b]:
   od:
 od:
 s := (s + grG_sigma_[gname])/2;

end:

#----------------------------
# P1
#
# Pressure of a shell
# (based on user supplied S1)
#----------------------------
macro( gr = grG_ObjDef[P1]):
gr[grC_header] := `P1 `:
gr[grC_root] := P1_:
gr[grC_rootStr] := `P1 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_P1:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}:

grF_calc_P1 := proc(object, iList)

local a;

 P(seq(grG_xup_[gname,a],a=1..Ndim[gname]));

end:

#----------------------------
# PCGeqn
#
# Momentum constraint equation on Sigma
#----------------------------
macro( gr = grG_ObjDef[PCeqn(dn)]):
gr[grC_header] := `R_{;a} - K^{i}_{a;i} = 0`:
gr[grC_root] := PCGeqn_:
gr[grC_rootStr] := `PCGeqn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_PCGeqn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {trK(cdn),K(dn,up,cdn),
                [ grG_partner_[gname], Gxn(dn)] }:

grF_calc_PCGeqn := proc(object, iList)

local s,b;

  s := 0:

  for b to Ndim[gname] do
    s := s - grG_Kdnupcdn_[gname,a1_,b,b]:
  od:

  s := s + grG_trKcdn_[gname,a1_]:

 RETURN(s=grG_Gxndn_[grG_partner_[gname],a1_]);

end:

#----------------------------
# PCTeqn
#
# Momentum constraint equation on Sigma
#----------------------------
macro( gr = grG_ObjDef[PCeqn(dn)]):
gr[grC_header] := `R_{;a} - K^{i}_{a;i} = 0`:
gr[grC_root] := PCTeqn_:
gr[grC_rootStr] := `PCTeqn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_PCTeqn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {trK(cdn),K(dn,up,cdn),
                [ grG_partner_[gname], Txn(dn)] }:

grF_calc_PCTeqn := proc(object, iList)

local s,b;

  s := 0:

  for b to Ndim[gname] do
    s := s - grG_Kdnupcdn_[gname,a1_,b,b]:
  od:

  s := s + grG_trKcdn_[gname,a1_]:

 RETURN(s=8*Pi*grG_Txndn_[grG_partner_[gname],a1_]);

end:

#----------------------------
# sigma
#
# Energy density of a shell
#----------------------------
macro( gr = grG_ObjDef[sigma]):
gr[grC_header] := `sigma `:
gr[grC_root] := sigma_:
gr[grC_rootStr] := `sigma `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sigma:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {S3(dn,dn), u3(up),ntype[grG_partner_[gname]]}:

grF_calc_sigma := proc(objects, iList)

local s, a, b:

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + grG_S3dndn_[gname,a,b] * grG_u3up_[gname,a]
            * grG_u3up_[gname,b]:
   od:
 od:
 s := s * grG_ntype_[grG_partner_[gname]];

end:

#----------------------------
# sigma1
#
# Energy density of a shell
#
#----------------------------
macro( gr = grG_ObjDef[sigma1]):
gr[grC_header] := `sigma1 `:
gr[grC_root] := sigma1_:
gr[grC_rootStr] := `sigma1 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sigma1:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}:


grF_calc_sigma1 := proc(object, iList)

local a;

 sigma(seq(grG_xup_[gname,a],a=1..Ndim[gname]));

end:

#----------------------------
# sigmadot
#
# Energy density of a shell
#----------------------------
macro( gr = grG_ObjDef[sigmadot]):
gr[grC_header] := `sigmadot `:
gr[grC_root] := sigmadot_:
gr[grC_rootStr] := `sigmadot `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := 'grG_u3up_[gname,s1_]*grG_sigmacdn_[gname,s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma(cdn), u3(up)}:

#----------------------------
# sigma1dot
#
# Energy density of a shell
#----------------------------
macro( gr = grG_ObjDef[sigma1dot]):
gr[grC_header] := `sigma1dot `:
gr[grC_root] := sigma1dot_:
gr[grC_rootStr] := `sigma1dot `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := 'grG_u3up_[gname,s1_]*grG_sigma1cdn_[gname,s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {sigma1(cdn), u3(up)}:


#----------------------------
# S3(dn,dn)
#----------------------------
macro( gr = grG_ObjDef[S3(dn,dn)]):
gr[grC_header] := `Intrinsic stress-energy`:
gr[grC_root] := S3dndn_:
gr[grC_rootStr] := `S `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
  ('grG_Jump_[gname,K(dn,dn),grG_join_[gname],a1_,a2_]'
    - 'grG_gdndn_[grG_metricName,a1_,a2_]'*
      'grG_Jump_[gname,trK,grG_join_[gname]]')/(8*Pi)
    *'grG_utype_[grG_partner_[grG_metricName]]':
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {Jump[K(dn,dn),grG_join_[gname] ],
                    Jump[trK,grG_join_[gname] ]}:


#----------------------------
# S3(dn,up)
#----------------------------
macro( gr = grG_ObjDef[S3(dn,up)]):
gr[grC_header] := `Intrinsic stress-energy`:
gr[grC_root] := S3dnup_:
gr[grC_rootStr] := `S `:
gr[grC_indexList] := [dn,up]:
gr[grC_calcFn] := grF_calc_S3dnup:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := {Jump[K(dn,up),grG_join_[gname] ],
                    Jump[trK,grG_join_[gname] ]}:

grF_calc_S3dnup := proc(object,iList)
local s;
 s := grG_Jump_[gname,K(dn,up),grG_join_[gname],a1_,a2_];
 if a1_ = a2_ then
    s := s - grG_Jump_[gname,trK,grG_join_[gname]]:
 fi:
 s := s/(8*Pi)
    *grG_utype_[grG_partner_[grG_metricName]]:

end:

#----------------------------
# S3(dn,up,cdn)
#
# (need this explicitly so we can evaluate on 
#  the surface after taking a derivative)
#----------------------------
macro( gr = grG_ObjDef[S3(dn,up,cdn)]):
gr[grC_header] := `Intrinsic stress-energy`:
gr[grC_root] := S3dnupcdn_:
gr[grC_rootStr] := `S `:
gr[grC_indexList] := [dn,up,cdn]:
gr[grC_calcFn] := grF_calc_S3dnupcdn:
gr[grC_symmetry] := grF_sym_nosym3:
gr[grC_depends] := {S3(dn,up), Chr(dn,dn,up) }:

grF_calc_S3dnupcdn := proc(object,iList)
local s, a;

 s := diff( grG_S3dnup_[gname, a1_,a2_], grG_xup_[gname, a3_]);
 for a to Ndim[gname] do
    s := s - grG_S3dnup_[gname, a,a2_] *
             grG_Chrdndnup_[gname, a1_,a3_, a]
           + grG_S3dnup_[gname, a1_,a] *
             grG_Chrdndnup_[gname, a, a3_, a2_ ]:
 od:

 juncF_project( s, grG_partner_[gname], gname);
 
end:

#----------------------------
# SKGeqn
#
# 
#----------------------------
macro( gr = grG_ObjDef[SKGeqn]):
gr[grC_header] := ` - S{i ^j} Mean[K{j ^i}] = usign Jump[ G{^a ^b} n{a} n{b}]`:
gr[grC_root] := SKGeqn_:
gr[grC_rootStr] := `SKGeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_SKGeqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {S3(dn,up), Mean[K(dn,up)], 
       [grG_partner_[gname], Jump[ Gnn, grG_join_[ grG_partner_[ gname]] ] ] }:

grF_calc_SKGeqn := proc( object, iList)
local a, b, s:

 s := 0;
 for a to Ndim[gname] do
   for b to Ndim[gname] do
      s := s + grG_S3dnup_[gname, a, b] * 
               grG_Mean_[gname, K(dn,up), grG_join_[gname], b, a ]:
   od:
 od:
 
 RETURN(- s =  grG_utype_[ grG_partner_[ gname]] *
    grG_Jump_[ grG_partner_[gname], Gnn, 
               grG_partner_[ grG_join_[gname]] ]/8/Pi):

end:

#----------------------------
# SKTeqn
#
# 
#----------------------------
macro( gr = grG_ObjDef[SKTeqn]):
gr[grC_header] := ` - S{i ^j} Mean[K{j ^i}] = usign Jump[ T{^a ^b} n{a} n{b}]`:
gr[grC_root] := SKTeqn_:
gr[grC_rootStr] := `SKTeqn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_SKTeqn:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {S3(dn,up), Mean[K(dn,up)], 
       [grG_partner_[gname], Jump[ Tnn, grG_join_[ grG_partner_[ gname]] ] ] }:

grF_calc_SKTeqn := proc( object, iList)
local a, b, s:

 s := 0;
 for a to Ndim[gname] do
   for b to Ndim[gname] do
      s := s + grG_S3dnup_[gname, a, b] * 
               grG_Mean_[gname, K(dn,up), grG_join_[gname], b, a ]:
   od:
 od:

 RETURN(- s =  grG_utype_[ grG_partner_[ gname]] *
    grG_Jump_[ grG_partner_[gname], Tnn, grG_partner_[ grG_join_[gname]] ]):

end:

#----------------------------
# surface
#----------------------------
macro( gr = grG_ObjDef[surface]):
gr[grC_header] := `The Equation of the surface`:
gr[grC_root] := surface_:
gr[grC_rootStr] := `surface `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_enterComp: # prompt the user for the surface
gr[grC_preCalcFn] := grF_preCalc_surface: # help info
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {g(up,up)}: # g(up,up) needed eventually for n(dn)
                               # [but n(dn) calc'd directly, so sneak in
                               # g(up,up) dependency here]

grF_preCalc_surface := proc( object)

printf(` SURFACE: Enter the expression for the surface.\n`):
printf(`   The surface will be defined by setting the \n`):
printf(`   expression you enter to zero.\n`):
printf(`   To enter the normal explicitly, enter 0 (zero)\n`):

end:

#----------------------------
# Tnn
#
# Defined for the manifold
#----------------------------
macro( gr = grG_ObjDef[Tnn]):
gr[grC_header] := `T{^a ^b} n{a} n{b}`:
gr[grC_root] := Tnn_:
gr[grC_rootStr] := `Tnn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2_project:
gr[grC_calcFnParms] := 'grG_Tupup_[grG_metricName,s1_,s2_]'*
                       'grG_ndn_[grG_metricName,s1_]' *
                       'grG_ndn_[grG_metricName,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {T(up,up),n(dn)}:

#----------------------------
# Tun
#
# Defined for the manifold
#----------------------------
macro( gr = grG_ObjDef[Tun]):
gr[grC_header] := `T{a b} u{^a} n{^b}`:
gr[grC_root] := Tun_:
gr[grC_rootStr] := `Tun `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum2_project:
gr[grC_calcFnParms] := 'grG_Tdndn_[grG_metricName,s1_,s2_]'*
                       'grG_uup_[grG_metricName,s1_]' *
                       'grG_nup_[grG_metricName,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {T(dn,dn),u(up)}:

#----------------------------
# Txn(dn)
#
# Defined for the 3 surface
#----------------------------
macro( gr = grG_ObjDef[Txn(dn)]):
gr[grC_header] := `T{a b} diff(x{^a},xi{^i}) n{^b}`:
gr[grC_root] := Txndn_:
gr[grC_rootStr] := `Txn `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {[grG_partner_[gname], n(up)]}:

grF_calc_Txn := proc( object, iList)
local s, a, b:
 s := 0:
 for a to Ndim[gname] do
    for b to Ndim[gname] do 
       s := s + grG_Tdndn_[ grG_partner_[grG_metricName],a,b] *
       diff( grG_xformup_[grG_partner_[grG_metricName],a],
             grG_xup_[gname,a1_]) *
       grG_nup_[ grG_partner_[grG_metricName],b]:

    od:
 od:

 juncF_project( s, grG_partner_[gname], gname);

end:

#----------------------------
# u3(dn)
# 
# We use u3(dn) since all the other transformations
# have their indices down and hence require the
# x^\alpha = f(\xi^i) instead of the inverse.
#
# Entered as part of junction()
#----------------------------
macro( gr = grG_ObjDef[u3(dn)]):
gr[grC_header] := `Intrinsic Tangent Vector`:
gr[grC_root] := u3dn_:
gr[grC_rootStr] := `u3 `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_u3dn:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { xform[grG_partner_[gname]](up),u[grG_partner_[gname]](dn)}:

grF_calc_u3dn := proc(object, iList)

local pname, a, s:
global grJ_totalVar;

 s := 0:
 grJ_totalVar := grG_totalVar_[gname]:

 pname := grG_partner_[gname]:
 for a to Ndim[pname] do
   s := s + diff(grG_xformup_[pname,a], grG_xup_[gname,a1_]) *
        grG_udn_[pname,a]:
 od:
 juncF_project(s,pname,gname); 

end:

#----------------------------
# u3div
#
# Entered as part of junction()
#----------------------------
macro( gr = grG_ObjDef[u3div]):
gr[grC_header] := `Intrinsic Tangent Vector`:
gr[grC_root] := u3div_:
gr[grC_rootStr] := `u3div `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_u3div:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { u3(up,cdn)}:

grF_calc_u3div := proc(object, iList)

local a, s:

 s := 0:
 for a to Ndim[gname] do
   s := s + grG_u3upcdn_[gname,a,a]:
 od:
 s;

end:

#----------------------------
# u(up)
#
# Entered as part of junction()
#----------------------------
macro( gr = grG_ObjDef[u(up)]):
gr[grC_header] := `Tangent Vector`:
gr[grC_root] := uup_:
gr[grC_rootStr] := `u `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_uup:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

grF_calc_uup := proc(object, iList)

  if not assigned( grG_totalVar_[grG_metricName] ) then 
     ERROR(`u(up) cannot be calculated. No parameter was given in surf()`):
  fi:
  diff( grG_xformup_[grG_metricName,a1_], grG_totalVar_[grG_metricName]);

end:

#----------------------------
# udot(up)
#
#----------------------------
macro( gr = grG_ObjDef[udot(up)]):
gr[grC_header] := `Accel. of Tangent`:
gr[grC_root] := udotup_:
gr[grC_rootStr] := `udot `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_udot:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {u(up),Chr(dn,dn,up)}:

grF_calc_udot := proc(object, iList)
local s, a,b, norm, N, pname:
global grG_udotup_,grJ_totalVar:
  
 grJ_totalVar := grG_totalVar_[gname]:
 N := Ndim[gname]:
 pname := grG_partner_[gname]:
 s := diff( grG_uup_[gname,a1_],grJ_totalVar):
   for a to N do
     for b to N do
       s := s + grG_uup_[gname,a] * grG_uup_[gname,b] 
                * grG_Chrdndnup_[gname,a,b,a1_]:
     od:
   od:
   juncF_project(s,gname,pname); # don't unchain

end:

#----------------------------
# udot_old(up)
#
#----------------------------
macro( gr = grG_ObjDef[udot_old(up)]):
gr[grC_header] := `Accel. of Tangent`:
gr[grC_root] := udotOldup_:
gr[grC_rootStr] := `udot `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := 'grG_uup_[grG_metricName,s1_] *
        grG_uupcdn_[grG_metricName,a1_,s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {u(up),u(up,cdn)}:

#----------------------------
# utype
# assigned in junction()
#----------------------------
macro( gr = grG_ObjDef[utype]):
gr[grC_header] := `u{a} u{^a}`:
gr[grC_root] := utype_:
gr[grC_rootStr] := `utype `:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# xform(up)
#----------------------------
macro( gr = grG_ObjDef[xform(up)]):
gr[grC_header] := `Coordinate transforms onto the surface`:
gr[grC_root] := xformup_:
gr[grC_rootStr] := `xform `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_enter_xform: # prompt the user for the surface
gr[grC_preCalcFn] := grF_preCalc_xform: # help info
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

grF_preCalc_xform := proc( object)

local result, okay, coords, a, b, s:

global grG_xformup_:
 
 s := sprintf(`\n SURFACE: Please enter the coordinate definition of the surface\n`):
 s := cat( s,sprintf(`   (the x{^a} = x(xi{^b})  ) as a LIST. \n`)):
 s := cat(s, sprintf(`   e.g. [ r=R(tau), theta=theta, phi=phi, t=T(tau)]\n`));
 coords := {seq( grG_xup_[gname,a], a=1..Ndim[gname])}:
 okay := false:

 while not okay do
   result := grF_input(s, [], `xform`);
  
   if not type(result, list) then
      printf(`Please enter a LIST\n`);

   elif nops(result) <> Ndim[gname] then
      printf(`List must have %d entries.\n`, Ndim[gname] );

   else
      # check all entries are equations
      okay := true:
      for a in result do
        okay := okay and type( a, equation):
      od:
      #
      # check to see that there are no functions using
      # coordinate names (e.g. r=r(t) ) since sub-ing in later for
      # these would cause grief
      #
      if okay then
         for a in indets(result) do
            if type(a, {function,indexed}) and member( op(0,a), coords) then
                printf(
`Invalid Input: a coordinate name cannot be used as a function or index name\n`);     printf(`e.g. if r is a coordinate, r(t) or r[0] is no good\n`);


                okay := false:
                break;
            fi:
         od:
      else
         printf(`Entries in list must be equations\n`);
      fi:

      if okay then
        #
        # now copy the equations into the xform internals
        # (don't assume that  they're in coordinate order)
        #
        for a to Ndim[gname] do
           #
           # find the equation with the lhs of this coordinate
           #
           b := 1;
           while  b <= Ndim[gname] and grG_xup_[gname,a] <> lhs(result[b]) do 
               b := b+1:
           od:
           if b > Ndim[gname] then 
              printf(`Coordinate %a does not appear in the list\n`,
			grG_xform_[gname,a]);
              okay := false;
	      break;
           else
              grG_xformup_[gname,a] := rhs(result[b]);
           fi:
        od:
      fi:       
    fi:
  od: # end while

end:
