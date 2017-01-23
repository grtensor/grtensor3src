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

$define gname grG_metricName

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
global s1_, s2_, gr_data, Ndim, grG_metricName:

  #
  # first determine if the metric is the surface or full manifold
  #
  if Ndim[grG_metricName] > Ndim[ gr_data[partner_, grG_metricName]] then
    surf := gr_data[partner_, grG_metricName] :
    M := grG_metricName:
  else
    surf := grG_metricName:
    M := gr_data[partner_, grG_metricName]:
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
# Partner
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[partner][grC_header] := `Joined to spacetime`:
grG_ObjDef[partner][grC_root] := partner_:
grG_ObjDef[partner][grC_rootStr] := `partner `:
grG_ObjDef[partner][grC_indexList] := []:

#----------------------------
# C1lhs
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[C1lhs][grC_header] := `Conservation laws for the surface`:
grG_ObjDef[C1lhs][grC_root] := C1lhs_:
grG_ObjDef[C1lhs][grC_rootStr] := `C1lhs `:
grG_ObjDef[C1lhs][grC_indexList] := []:
grG_ObjDef[C1lhs][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[C1lhs][grC_calcFnParms] :=
  'gr_data[sigma1dot_,gname] + (gr_data[sigma1_,gname] + gr_data[P1_,gname])
   * gr_data[u3div_,gname]':
grG_ObjDef[C1lhs][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C1lhs][grC_depends] := {sigma1, sigma1dot, u3div, P1}:

#----------------------------
# C2lhs
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[C2lhs][grC_header] := `Conservation laws for the surface`:
grG_ObjDef[C2lhs][grC_root] := C2lhs_:
grG_ObjDef[C2lhs][grC_rootStr] := `C2lhs `:
grG_ObjDef[C2lhs][grC_indexList] := []:
grG_ObjDef[C2lhs][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[C2lhs][grC_calcFnParms] :=
  'gr_data[sigmadot_,gname] + (gr_data[sigma_,gname] + gr_data[P_,gname])
   * gr_data[u3div_,gname]':
grG_ObjDef[C2lhs][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C2lhs][grC_depends] := {sigma, sigmadot, u3div, P}:

#----------------------------
# CGeqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[CGeqn][grC_header] := `Conservation`:
grG_ObjDef[CGeqn][grC_root] := CGeqn_:
grG_ObjDef[CGeqn][grC_rootStr] := `CGeqn `:
grG_ObjDef[CGeqn][grC_indexList] := []:
grG_ObjDef[CGeqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[CGeqn][grC_calcFnParms] :=
  'gr_data[C1lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Gun,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[CGeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CGeqn][grC_depends] := {C1lhs,
 [gr_data[partner_,gname], Jump[Gun, gr_data[partner_,gr_data[join_,gname]]]] }:


#----------------------------
# CTeqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[CTeqn][grC_header] := `Conservation law (T(dn,dn) and sigma)`:
grG_ObjDef[CTeqn][grC_root] := CTeqn_:
grG_ObjDef[CTeqn][grC_rootStr] := `CTeqn `:
grG_ObjDef[CTeqn][grC_indexList] := []:
grG_ObjDef[CTeqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[CTeqn][grC_calcFnParms] :=
  'gr_data[C1lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Tun,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[CTeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CTeqn][grC_depends] := {C1lhs,
                    [gr_data[partner_,gname], Jump[Tun, gr_data[partner_,gr_data[join_,gname]]]] }:


#----------------------------
# C2Geqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[C1Geqn][grC_header] := `Conservation law`:
grG_ObjDef[C1Geqn][grC_root] := C1Geqn_:
grG_ObjDef[C1Geqn][grC_rootStr] := `C1Geqn `:
grG_ObjDef[C1Geqn][grC_indexList] := []:
grG_ObjDef[C1Geqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[C1Geqn][grC_calcFnParms] :=
  'gr_data[C2lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Gun,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[C1Geqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C1Geqn][grC_depends] := {C2lhs,
                    [gr_data[partner_,gname], Jump[Gun, gr_data[partner_,gr_data[join_,gname]]]] }:

#----------------------------
# C1Teqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[C1Teqn][grC_header] := `Conservation law`:
grG_ObjDef[C1Teqn][grC_root] := C1Teqn_:
grG_ObjDef[C1Teqn][grC_rootStr] := `C1Teqn `:
grG_ObjDef[C1Teqn][grC_indexList] := []:
grG_ObjDef[C1Teqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[C1Teqn][grC_calcFnParms] :=
  'gr_data[C2lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Tun,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[C1Teqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C1Teqn][grC_depends] := {C2lhs,
                    [gr_data[partner_,gname], Jump[Tun, gr_data[partner_,gr_data[join_,gname]]]] }:

#----------------------------
# divS3(dn)
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[divS3(dn)][grC_header] := ``:
grG_ObjDef[divS3(dn)][grC_root] := divS3dn_:
grG_ObjDef[divS3(dn)][grC_rootStr] := `divS3 `:
grG_ObjDef[divS3(dn)][grC_indexList] := [dn]:
grG_ObjDef[divS3(dn)][grC_calcFn] := grF_calc_divS3:
grG_ObjDef[divS3(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[divS3(dn)][grC_depends] := {S3(dn,up,cdn) }:

grF_calc_divS3 := proc(object, iList)

local s, a;

 s := 0;
 for a to Ndim[gname] do
    s :=  s + gr_data[S3dnupcdn_,gname, a1_, a, a]:
 od:

# juncF_project( s, gr_data[partner_,gname], gname);
  s;

end:

#----------------------------
# divSGeqn(dn)
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[divSGeqn(dn)][grC_header] := ``:
grG_ObjDef[divSGeqn(dn)][grC_root] := divSGeqndn_:
grG_ObjDef[divSGeqn(dn)][grC_rootStr] := `divSGeqn `:
grG_ObjDef[divSGeqn(dn)][grC_indexList] := [dn]:
grG_ObjDef[divSGeqn(dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[divSGeqn(dn)][grC_calcFnParms] :=
  'gr_data[utype_,gr_data[partner_,gname]]* gr_data[divS3dn_,gname, a1_]' =
  'gr_data[Jump_,gname,Gxn(dn),gr_data[join_,gname],a1_ ]/8/Pi':
grG_ObjDef[divSGeqn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[divSGeqn(dn)][grC_depends] := {Gxn(dn), divS3(dn), Jump[Gxn(dn)]}:

#----------------------------
# divSTeqn(dn)
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[divSTeqn(dn)][grC_header] := ``:
grG_ObjDef[divSTeqn(dn)][grC_root] := divSTeqndn_:
grG_ObjDef[divSTeqn(dn)][grC_rootStr] := `divSTeqn `:
grG_ObjDef[divSTeqn(dn)][grC_indexList] := [dn]:
grG_ObjDef[divSTeqn(dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[divSTeqn(dn)][grC_calcFnParms] :=
  'gr_data[utype_,gr_data[partner_,gname]]* gr_data[divS3dn_,gname, a1_]' =
  'gr_data[Jump_,gname,Txn(dn),gr_data[join_,gname],a1_ ]':
grG_ObjDef[divSTeqn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[divSTeqn(dn)][grC_depends] := {Txn(dn), divS3(dn), Jump[Txn(dn)]}:

#----------------------------
# es(bdn,up)
# This object (in M) describes the basis vectors of the surface. 
# It will only have 3 bdn index values (with the fourth set to
# zero)
#----------------------------
grG_ObjDef[es(bdn,up)][grC_header] := `Basis vector`:
grG_ObjDef[es(bdn,up)][grC_root] := esbdnup_:
grG_ObjDef[es(bdn,up)][grC_rootStr] := `e `:
grG_ObjDef[es(bdn,up)][grC_indexList] := [bdn,up]:
grG_ObjDef[es(bdn,up)][grC_preCalcFn] := grF_precalc_esupbdn_:
grG_ObjDef[es(bdn,up)][grC_symmetry] := grF_sym_esbdnup:
grG_ObjDef[es(bdn,up)][grC_depends] := {xform(up)}:

grF_precalc_esupbdn_ := proc(object, iList)
global Ndim, grG_metricName, gr_data;
local a, sname;

  for a to Ndim[gname]-1 do
    for b to Ndim[gname] do
       gr_data[esbdnup_, gname, a, b] := 
          diff( gr_data[xformup_,gname,b], gr_data[xup_, gr_data[partner_, gname], a]):
       gr_data[esbdnup_, gname, 4, b] := 0:
    od:
  od:
end proc:

#----------------------------
# evInt
#
# Evolution integral
#----------------------------
grG_ObjDef[evInt][grC_header] := ``:
grG_ObjDef[evInt][grC_root] := evInt_:
grG_ObjDef[evInt][grC_rootStr] := `evInt `:
grG_ObjDef[evInt][grC_indexList] := []:
grG_ObjDef[evInt][grC_calcFn] := grF_calc_evInt:
grG_ObjDef[evInt][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[evInt][grC_depends] := { sigma,
     [gr_data[partner_,gname], Jump[mass, gr_data[partner_,gr_data[join_,gname]]]],
     [gr_data[partner_,gname], Mean[mass, gr_data[partner_,gr_data[join_,gname]]]] }:


grF_calc_evInt := proc(object, iList)

local iSeq, M, s:
global gr_data, Ndim, grG_metricName:

 iSeq := gr_data[partner_,gname], mass, gr_data[join_,gr_data[partner_,gname]]:
 M := 4*Pi*gr_data[sigma_,gname]*R(tau)^2:

 s :=
   diff(R(tau),tau)^2 =
   gr_data[utype_,gr_data[partner_,gname]] +
   ( gr_data[Jump_,iSeq]/M)^2
   - 2*gr_data[utype_,gr_data[partner_,gname]]*gr_data[Mean_,iSeq]/R(tau)
   + (M/2/R(tau))^2:

 juncF_project( s, gr_data[partner_,gname], gname);

end:

#----------------------------
# evInt1
#
# Evolution integral
#----------------------------
grG_ObjDef[evInt1][grC_header] := ``:
grG_ObjDef[evInt1][grC_root] := evInt1_:
grG_ObjDef[evInt1][grC_rootStr] := `evInt1 `:
grG_ObjDef[evInt1][grC_indexList] := []:
grG_ObjDef[evInt1][grC_calcFn] := grF_calc_evInt1:
grG_ObjDef[evInt1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[evInt1][grC_depends] := { sigma1,
     [gr_data[partner_,gname], Jump[mass, gr_data[partner_,gr_data[join_,gname]]]],
     [gr_data[partner_,gname], Mean[mass, gr_data[partner_,gr_data[join_,gname]]]] }:


grF_calc_evInt1 := proc(object, iList)

local iSeq, M, s :
global gr_data, Ndim, grG_metricName:

 iSeq := gr_data[partner_,gname], mass, gr_data[join_,gr_data[partner_,gname]]:
 M := 4*Pi*gr_data[sigma1_,gname]*R(tau)^2:

 s :=
   diff(R(tau),tau)^2 =
   gr_data[utype_,gr_data[partner_,gname]] +
   ( gr_data[Jump_,iSeq]/M)^2
   - 2*gr_data[utype_,gr_data[partner_,gname]]*gr_data[Mean_,iSeq]/R(tau)
   + (M/2/R(tau))^2:

 juncF_project( s, gr_data[partner_,gname], gname);

end:


#----------------------------
# g(dn,dn)
#
# Add a pre_calc function for the metric
# This is referenced from the grii g(dn,dn) code.
#----------------------------

grF_pre_calc_ff1 := proc()
 local a1, a2, s, a,b, pname;
 global gr_data, Ndim, grG_metricName:

 pname := gr_data[partner_,gname]:
 for a1 to Ndim[gname] do
   for a2 from a1 to Ndim[gname] do
     s := 0:
     for a to Ndim[pname] do
       for b to Ndim[pname] do
         s := s + diff(gr_data[xformup_,pname,a], gr_data[xup_,gname,a1])
                * diff(gr_data[xformup_,pname,b], gr_data[xup_,gname,a2])
                * gr_data[gdndn_,pname,a,b]:
       od:
     od:
     gr_data[gdndn_,gname, a2, a1] := s:
     gr_data[gdndn_,gname, a1, a2] := s:
   od:
 od:
 juncF_project( grG_simpHow( grG_preSeq, s, grG_postSeq), pname, gname);

end:


#----------------------------
# Gun
#
# Defined for the manifold
#----------------------------
grG_ObjDef[Gun][grC_header] := `G{a b} u{^a} n{^b}`:
grG_ObjDef[Gun][grC_root] := Gun_:
grG_ObjDef[Gun][grC_rootStr] := `Gun `:
grG_ObjDef[Gun][grC_indexList] := []:
grG_ObjDef[Gun][grC_calcFn] := grF_calc_sum2_project:
grG_ObjDef[Gun][grC_calcFnParms] := 'gr_data[Gdndn_,grG_metricName,s1_,s2_]'*
                       'gr_data[uup_,grG_metricName,s1_]' *
                       'gr_data[nup_,grG_metricName,s2_]':
grG_ObjDef[Gun][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Gun][grC_depends] := {G(dn,dn),u(up)}:


#----------------------------
# HCTeqn
#
# Hamiltonian constraint equation on Sigma (T version)
#----------------------------
grG_ObjDef[HCeqn][grC_header] := `R + K^2 +K_{ij} K^{ij} = 0`:
grG_ObjDef[HCeqn][grC_root] := HCeqn_:
grG_ObjDef[HCeqn][grC_rootStr] := `HCeqn `:
grG_ObjDef[HCeqn][grC_indexList] := []:
grG_ObjDef[HCeqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[HCeqn][grC_calcFnParms] := 'grG_scalarR_[grG_metricName]'+
                       'gr_data[trK_,grG_metricName]'^2 -
                       'gr_data[Ksq_,grG_metricName]' = 0:
                       8*Pi* 'gr_data[Tnn_,gr_data[partner,grG_metricName]]':
grG_ObjDef[HCeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[HCeqn][grC_depends] := {Ricciscalar,trK,Ksq, [gr_data[partner_,gname], Tnn] }:

#----------------------------
# H2lhs
#
# History for the surface
#----------------------------
grG_ObjDef[Hlhs][grC_header] := `History for the surface`:
grG_ObjDef[Hlhs][grC_root] := Hlhs_:
grG_ObjDef[Hlhs][grC_rootStr] := `Hlhs `:
grG_ObjDef[Hlhs][grC_indexList] := []:
grG_ObjDef[Hlhs][grC_calcFn] := grF_calc_Hlhs:
grG_ObjDef[Hlhs][grC_symmetry] := grF_sym_scalar:
#
# rely on grG_default_Mint
#
grG_ObjDef[Hlhs][grC_depends] := {sigma, P,
     [gr_data[partner_,gname],Mean[ndotu, gr_data[partner_,gr_data[join_,gname]]] ],
     Mean[trK], ntype[gr_data[partner_,gname]]}:


grF_calc_Hlhs := proc(object, iList)
global gr_data, Ndim, grG_metricName:


 gr_data[ntype_,gr_data[partner_,gname]] *
 ( gr_data[sigma_,gname] + gr_data[P_,gname]) *
 gr_data[Mean_,gr_data[partner_,gname],ndotu,gr_data[join_,gr_data[partner_,gname]]] +
 gr_data[P_,gname]* gr_data[Mean_,gname,trK,gr_data[join_,gname] ];

end:

#----------------------------
# H1lhs
#
# HIstory for the surface
#----------------------------
grG_ObjDef[H1lhs][grC_header] := `History for the surface`:
grG_ObjDef[H1lhs][grC_root] := H1lhs_:
grG_ObjDef[H1lhs][grC_rootStr] := `H1lhs `:
grG_ObjDef[H1lhs][grC_indexList] := []:
grG_ObjDef[H1lhs][grC_calcFn] := grF_calc_H1lhs:
grG_ObjDef[H1lhs][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[H1lhs][grC_depends] := {sigma1, P1, Mean[trK],
     [gr_data[partner_,gname],Mean[ndotu, gr_data[partner_,gr_data[join_,gname]]] ],
     ntype[gr_data[partner_,gname]]}:


grF_calc_H1lhs := proc(object, iList)
global gr_data, Ndim, grG_metricName:


 gr_data[utype_,gr_data[partner_,gname]] *
 ( gr_data[sigma1_,gname] + gr_data[P1_,gname]) *
 gr_data[Mean_,gr_data[partner_,gname],ndotu,gr_data[join_,gr_data[partner_,gname]]] +
 gr_data[P1_,gname]* gr_data[Mean_,gname,trK,grG_default_Mint];

end:

#----------------------------
# HGeqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[HGeqn][grC_header] := `History equation`:
grG_ObjDef[HGeqn][grC_root] := HGeqn_:
grG_ObjDef[HGeqn][grC_rootStr] := `HGeqn `:
grG_ObjDef[HGeqn][grC_indexList] := []:
grG_ObjDef[HGeqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[HGeqn][grC_calcFnParms] :=
  'gr_data[H1lhs_,gname]' =
 'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Gnn,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[HGeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[HGeqn][grC_depends] := {H1lhs,
                    [gr_data[partner_,gname], Jump[Gnn, gr_data[partner_,gr_data[join_,gname]]]] }:


#----------------------------
# HTeqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[HTeqn][grC_header] := `History equation`:
grG_ObjDef[HTeqn][grC_root] := HTeqn_:
grG_ObjDef[HTeqn][grC_rootStr] := `HTeqn `:
grG_ObjDef[HTeqn][grC_indexList] := []:
grG_ObjDef[HTeqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[HTeqn][grC_calcFnParms] :=
  'gr_data[H1lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Tnn,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[HTeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[HTeqn][grC_depends] := {H1lhs,
                    [gr_data[partner_,gname], Jump[Tnn, gr_data[partner_,gr_data[join_,gname]]]] }:

#----------------------------
# H1Geqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[H1Geqn][grC_header] := `History equation`:
grG_ObjDef[H1Geqn][grC_root] := H1Geqn_:
grG_ObjDef[H1Geqn][grC_rootStr] := `H1Geqn `:
grG_ObjDef[H1Geqn][grC_indexList] := []:
grG_ObjDef[H1Geqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[H1Geqn][grC_calcFnParms] :=
  'gr_data[H2lhs_,gname]' =
 'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Gnn,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[H1Geqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[H1Geqn][grC_depends] := {H2lhs,
                    [gr_data[partner_,gname], Jump[Gnn, gr_data[partner_,gr_data[join_,gname]]]] }:

#----------------------------
# H2Teqn
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[H1Teqn][grC_header] := `History equation`:
grG_ObjDef[H1Teqn][grC_root] := H1Teqn_:
grG_ObjDef[H1Teqn][grC_rootStr] := `H1Teqn `:
grG_ObjDef[H1Teqn][grC_indexList] := []:
grG_ObjDef[H1Teqn][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[H1Teqn][grC_calcFnParms] :=
  'gr_data[H2lhs_,gname]' =
  'gr_data[utype_,gr_data[partner_,gname]] *
   gr_data[Jump_,gr_data[partner_,gname], Tnn,gr_data[partner_,gr_data[join_,gname]] ]':
grG_ObjDef[H1Teqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[H1Teqn][grC_depends] := {H2lhs,
                    [gr_data[partner_,gname], Jump[Gnn, gr_data[partner_,gr_data[join_,gname]]]] }:


#----------------------------
# K(dn,dn)
#----------------------------
grG_ObjDef[K(dn,dn)][grC_header] := `Extrinsic Curvature`:
grG_ObjDef[K(dn,dn)][grC_root] := Kdndn_:
grG_ObjDef[K(dn,dn)][grC_rootStr] := `K `:
grG_ObjDef[K(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[K(dn,dn)][grC_calcFn] := grF_calc_ff2:
grG_ObjDef[K(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[K(dn,dn)][grC_depends] := {n[gr_data[partner_,grG_metricName]](dn),
		Chr[gr_data[partner_,grG_metricName]](dn,dn,up)}:

grF_calc_ff2 := proc(object, iList)
local s, a, b, c, s1, pname:
global gr_data, Ndim, grG_metricName:

 pname := gr_data[partner_,gname]:
 s := 0:
 s1 := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s1 := s1 + gr_data[ndn_,pname,a] *
		  diff(gr_data[xformup_,pname,b],gr_data[xup_,gname,a1_]) *
		  diff(gr_data[xformup_,pname,c],gr_data[xup_,gname,a2_]) *
		  gr_data[Chrdndnup_,pname,b,c,a];
     od:
   od:
   s := s + gr_data[ndn_,pname,a] *
	    diff(diff(gr_data[xformup_,pname,a],gr_data[xup_,gname,a1_]),
		gr_data[xup_,gname,a2_]);
 od:

 juncF_project( -s-s1,pname,gname);

end:

#----------------------------
# Ksq
#----------------------------
grG_ObjDef[Ksq][grC_header] := `K_{ij} K^{ij}`:
grG_ObjDef[Ksq][grC_root] := Ksq_:
grG_ObjDef[Ksq][grC_rootStr] := `Ksq `:
grG_ObjDef[Ksq][grC_indexList] := []:
grG_ObjDef[Ksq][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[Ksq][grC_calcFnParms] := 'gr_data[Kdnup_,gname,s1_,s2_] * gr_data[Kdnup_,gname,s2_,s1_]':
grG_ObjDef[Ksq][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ksq][grC_depends] := {K(dn,up)}:

#----------------------------
# trK
#----------------------------
grG_ObjDef[trK][grC_header] := `Trace of Extrinsic Curvature`:
grG_ObjDef[trK][grC_root] := trK_:
grG_ObjDef[trK][grC_rootStr] := `trK `:
grG_ObjDef[trK][grC_indexList] := []:
grG_ObjDef[trK][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[trK][grC_calcFnParms] := 'gr_data[Kdndn_,gname,s1_,s2_] * gr_data[gupup_,gname,s1_,s2_]':
grG_ObjDef[trK][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[trK][grC_depends] := {K(dn,dn),g(up,up)}:

#----------------------------
# mass (associated with 4-metric - so don't project it)
#----------------------------
grG_ObjDef[mass][grC_header] := `mass`:
grG_ObjDef[mass][grC_root] := mass_:
grG_ObjDef[mass][grC_rootStr] := `mass `:
grG_ObjDef[mass][grC_indexList] := []:
grG_ObjDef[mass][grC_calcFn] := grF_calc_mass:
grG_ObjDef[mass][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[mass][grC_depends] := {R(dn,dn,up,up)}: # dependencies calculated explicitly in junction()

grF_calc_mass := proc(object, iList)

local thetaNum, phiNum, ok, coordList, xformList, i:
global gr_data, Ndim, grG_metricName:

  #
  # first check that theta and phi are coordinates of M
  #
  coordList := [ seq(gr_data[xup_,gname,i], i=1..Ndim[gname])]:
  ok := false:
  if not has( coordList, theta) then
     printf(`mass definition requires coordinate: theta\n`):
  elif not has( coordList, phi) then
     printf(`mass definition requires coordinate: phi\n`):
  elif not has( [seq(gr_data[xformup_,gname,i],i=1..Ndim[gname])], R(tau) ) then
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
  RETURN( gr_data[gdndn_,gname,thetaNum,thetaNum]^(3/2) *
           gr_data[Rdndnupup_,gname,thetaNum,phiNum,thetaNum,phiNum]/2):

end:

#----------------------------
# ndiv
#----------------------------
grG_ObjDef[ndiv][grC_header] := `n{^a ; a}`:
grG_ObjDef[ndiv][grC_root] := ndiv_:
grG_ObjDef[ndiv][grC_rootStr] := `ndiv `:
grG_ObjDef[ndiv][grC_indexList] := []:
grG_ObjDef[ndiv][grC_calcFn] := grF_calc_ndiv: # preCalc since we need to normalize
grG_ObjDef[ndiv][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[ndiv][grC_depends] := {n(up,cdn)}: # dependencies calculated explicitly in junction()


grF_calc_ndiv := proc(object, iList)

local a, s, pname:
global gr_data, Ndim, grG_metricName:

 pname := gr_data[partner_,gname]:

 s := 0:
 for a to Ndim[gname] do
   s := s + gr_data[nupcdn_,grG_metricName,a, a]:
 od:

 juncF_project( grG_simpHow( grG_preSeq, s, grG_postSeq), gname, pname):

end:

#----------------------------
# nsign
# assigned in junction()
#----------------------------
grG_ObjDef[nsign][grC_header] := `n{a} n{^a}`:
grG_ObjDef[nsign][grC_root] := nsign_:
grG_ObjDef[nsign][grC_rootStr] := `nsign `:
grG_ObjDef[nsign][grC_indexList] := []:
grG_ObjDef[nsign][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nsign][grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# ntype
# assigned in junction()
#----------------------------
grG_ObjDef[ntype][grC_header] := `n{a} n{^a}`:
grG_ObjDef[ntype][grC_root] := ntype_:
grG_ObjDef[ntype][grC_rootStr] := `ntype `:
grG_ObjDef[ntype][grC_indexList] := []:
grG_ObjDef[ntype][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[ntype][grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# n(dn)
#
#----------------------------
grG_ObjDef[n(dn)][grC_header] := `Normal Vector`:
grG_ObjDef[n(dn)][grC_root] := ndn_:
grG_ObjDef[n(dn)][grC_rootStr] := `n `:
grG_ObjDef[n(dn)][grC_indexList] := [dn]:
grG_ObjDef[n(dn)][grC_preCalcFn] := grF_calc_ndn: # preCalc since we need to normalize
grG_ObjDef[n(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[n(dn)][grC_depends] := {g(up,up),surface, nsign}:

grF_calc_ndn_new := proc( object)

local a,b,s, coordList:
global gr_data, Ndim, grG_metricName:

  for a to Ndim[gname] do
    gr_data[ndn_,gname,a] := subs( diff=jdiff,
        diff( gr_data[surface_,gname], gr_data[xup_,gname,a])):
  od:
  #
  # want to normalize, but ensure we don't take sqrt(-1)
  # so multiply normalization factor by ntype
  #
  for a to Ndim[gname] do
    gr_data[ndn_,gname,a] :=  gr_data[ntype_,gname]*
           gr_data[ndn_,gname,a];
  od:

end:

grF_calc_ndn := proc( object)

local a,b,s, coordList:
global gr_data, Ndim, grG_metricName:


  #
  # if a surface was defined then use the definition n = grad(s)
  # otherwise get n(dn) by lowering n(up) (one of n(dn) or n(up)
  # is *always* defined by surf if surface = 0
  #
  if gr_data[surface_,gname] <> 0 then
    for a to Ndim[gname] do
      gr_data[ndn_,gname,a] := subs( diff=jdiff,
          diff( gr_data[surface_,gname], gr_data[xup_,gname,a])):
    od:
  else
     for a to Ndim[gname] do
        gr_data[ndn_,gname,a] := 0;
       for b to Ndim[gname] do
          gr_data[ndn_,gname, a] := gr_data[ndn_,gname,a] +
                    gr_data[gdndn_,gname, a, b] * gr_data[nup_,gname, b]:
       od:
     od:
  fi:
  #
  # want to normalize (if n is non-null), but ensure we don't take sqrt(-1)
  # so multiply normalization factor by ntype
  #

  if ( gr_data[ntype_,gname] <> 0) then
    #
    # calculate the normalization
    #
    s := 0:
    for a to Ndim[gname] do
      for b to Ndim[gname] do
        s := s + gr_data[gupup_,gname,a,b]
           * gr_data[ndn_,gname,a]* gr_data[ndn_,gname,b]:
      od:
    od:
    for a to Ndim[gname] do
       gr_data[ndn_,gname,a] :=  normal(gr_data[ndn_,gname,a]/
           sqrt( gr_data[ntype_,gname] * normal(s), symbolic)):
    od:
  fi:

end:

#----------------------------
# n(up)
# This object is assigned by surf or
# calculated by raising n(dn)
#----------------------------
grG_ObjDef[n(up)][grC_header] := `Normal Vector`:
grG_ObjDef[n(up)][grC_root] := nup_:
grG_ObjDef[n(up)][grC_rootStr] := `n `:
grG_ObjDef[n(up)][grC_indexList] := [up]:
grG_ObjDef[n(up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[n(up)][grC_calcFnParms] :=
   'gr_data[gupup_,grG_metricName, a1_, s1_] * gr_data[ndn_,grG_metricName, s1_]':
grG_ObjDef[n(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[n(up)][grC_depends] := {}:

#----------------------------
# ndotu
#
# (in the 4-space)
#----------------------------
grG_ObjDef[ndotu][grC_header] := `n{a} udot{^a}`:
grG_ObjDef[ndotu][grC_root] := ndotu_:
grG_ObjDef[ndotu][grC_rootStr] := `ndotu `:
grG_ObjDef[ndotu][grC_indexList] := []:
grG_ObjDef[ndotu][grC_calcFn] := grF_calc_ndotu:
grG_ObjDef[ndotu][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[ndotu][grC_depends] := {n(dn),udot(up)}:

grF_calc_ndotu := proc(object, iList)

local a,s, pname:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for a to Ndim[gname] do
   s := s + gr_data[ndn_,gname,a] * gr_data[udotup_,gname,a]:
 od:
 pname := gr_data[partner_,gname]:
 juncF_project(s, gname, pname);

end:

#----------------------------
# nuJumpeqn
#
# (intrinsic eqn)
#----------------------------
grG_ObjDef[nuJumpeqn][grC_header] := `Jump[n{a} udot{^a}] = - u{^i} u{^j} [K{i j}]`:
grG_ObjDef[nuJumpeqn][grC_root] := nuJumpeqn_:
grG_ObjDef[nuJumpeqn][grC_rootStr] := `nuJumpeqn `:
grG_ObjDef[nuJumpeqn][grC_indexList] := []:
grG_ObjDef[nuJumpeqn][grC_calcFn] := grF_calc_nuJumpeqn:
grG_ObjDef[nuJumpeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nuJumpeqn][grC_depends] := {
      [ gr_data[partner_,gname], Jump[ndotu, gr_data[join_,gr_data[partner_,gname]]] ],
        Jump[K(dn,dn)], u3(up)}:


grF_calc_nuJumpeqn := proc(object, iList)

local s, i, j:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for i to Ndim[gname] do
   for j to Ndim[gname] do
   s := s + gr_data[u3up_,gname,i] * gr_data[u3up_,gname,j] *
            gr_data[Jump_,gname, K(dn,dn), gr_data[join_,gname],i,j]:
   od:
 od:

 RETURN(gr_data[Jump_, gr_data[partner_,gname], ndotu, gr_data[join_,gr_data[partner_,gname]] ] = - s);

end:

#----------------------------
# nuMeaneqn
#
# (intrinsic eqn)
#----------------------------
grG_ObjDef[nuMeaneqn][grC_header] := `Mean[n{a} udot{^a}] = - u{^i} u{^j} Mean[K{i j}]`:
grG_ObjDef[nuMeaneqn][grC_root] := nuMeaneqn_:
grG_ObjDef[nuMeaneqn][grC_rootStr] := `nuMeaneqn `:
grG_ObjDef[nuMeaneqn][grC_indexList] := []:
grG_ObjDef[nuMeaneqn][grC_calcFn] := grF_calc_nuMeaneqn:
grG_ObjDef[nuMeaneqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nuMeaneqn][grC_depends] := {
      [ gr_data[partner_,gname], Mean[ndotu, gr_data[join_,gr_data[partner_,gname]]] ],
        Mean[K(dn,dn)], u3(up)}:


grF_calc_nuMeaneqn := proc(object, iList)

local s, i, j:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for i to Ndim[gname] do
   for j to Ndim[gname] do
   s := s + gr_data[u3up_,gname,i] * gr_data[u3up_,gname,j] *
            gr_data[Mean_,gname, K(dn,dn), gr_data[join_,gname],i,j]:
   od:
 od:

 RETURN(gr_data[Mean_, gr_data[partner_,gname], ndotu, gr_data[join_,gr_data[partner_,gname]] ] = - s);

end:

#----------------------------
# nuPeqn
#
# (intrinsic eqn)
#----------------------------
grG_ObjDef[nuPeqn][grC_header] := `Jump[n{a} udot{^a}] = 8 pi ( P + sigma/2)`:
grG_ObjDef[nuPeqn][grC_root] := nuPeqn_:
grG_ObjDef[nuPeqn][grC_rootStr] := `nuPeqn `:
grG_ObjDef[nuPeqn][grC_indexList] := []:
grG_ObjDef[nuPeqn][grC_calcFn] := grF_calc_nuPeqn:
grG_ObjDef[nuPeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nuPeqn][grC_depends] := {
      [ gr_data[partner_,gname], Jump[ndotu, gr_data[join_,gr_data[partner_,gname]]] ],
        sigma, P}:


grF_calc_nuPeqn := proc(object, iList)
global gr_data, Ndim, grG_metricName:

 RETURN(gr_data[Jump_, gr_data[partner_,gname], ndotu, gr_data[join_,gr_data[partner_,gname]] ]
        =  8 * Pi * ( gr_data[P_,gname] + gr_data[sigma_,gname]/2) );

end:

#----------------------------
# nuP1eqn
#
# (intrinsic eqn)
#----------------------------
grG_ObjDef[nuP1eqn][grC_header] := `Jump[n{a} udot{^a}] = 8 pi ( P1 + sigma1/2)`:
grG_ObjDef[nuP1eqn][grC_root] := nuP1eqn_:
grG_ObjDef[nuP1eqn][grC_rootStr] := `nuP1eqn `:
grG_ObjDef[nuP1eqn][grC_indexList] := []:
grG_ObjDef[nuP1eqn][grC_calcFn] := grF_calc_nuP1eqn:
grG_ObjDef[nuP1eqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[nuP1eqn][grC_depends] := {
      [ gr_data[partner_,gname], Jump[ndotu, gr_data[join_,gr_data[partner_,gname]]] ],
        sigma1, P1}:


grF_calc_nuP1eqn := proc(object, iList)
global gr_data, Ndim, grG_metricName:

 RETURN(gr_data[Jump_, gr_data[partner_,gname], ndotu, gr_data[join_,gr_data[partner_,gname]] ]
         =  8 * Pi * ( gr_data[P1_,gname] + gr_data[sigma1_,gname]/2) );

end:

#----------------------------
# P
#
# Pressure of a shell
#----------------------------
grG_ObjDef[P][grC_header] := `P `:
grG_ObjDef[P][grC_root] := P_:
grG_ObjDef[P][grC_rootStr] := `P `:
grG_ObjDef[P][grC_indexList] := []:
grG_ObjDef[P][grC_calcFn] := grF_calc_P:
grG_ObjDef[P][grC_calcFnParms] := grG_S3dndn_,grG_sigma_:
grG_ObjDef[P][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[P][grC_depends] := {sigma, S3(dn,dn),g(up,up)}:

grF_calc_P := proc(objects, iList)

local s, a, b, pname:
global gr_data, Ndim, grG_metricName:

 #
 # find the trace of S
 #
 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + gr_data[S3dndn_,gname,a,b] * gr_data[gupup_,gname,a,b]:
   od:
 od:
 s := (s + gr_data[sigma_,gname])/2;

end:

#----------------------------
# P1
#
# Pressure of a shell
# (based on user supplied S1)
#----------------------------
grG_ObjDef[P1][grC_header] := `P1 `:
grG_ObjDef[P1][grC_root] := P1_:
grG_ObjDef[P1][grC_rootStr] := `P1 `:
grG_ObjDef[P1][grC_indexList] := []:
grG_ObjDef[P1][grC_calcFn] := grF_calc_P1:
grG_ObjDef[P1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[P1][grC_depends] := {}:

grF_calc_P1 := proc(object, iList)

local a;
global gr_data, Ndim, grG_metricName:

 P(seq(gr_data[xup_,gname,a],a=1..Ndim[gname]));

end:



#----------------------------
# sigma
#
# Energy density of a shell
#----------------------------
grG_ObjDef[sigma][grC_header] := `sigma `:
grG_ObjDef[sigma][grC_root] := sigma_:
grG_ObjDef[sigma][grC_rootStr] := `sigma `:
grG_ObjDef[sigma][grC_indexList] := []:
grG_ObjDef[sigma][grC_calcFn] := grF_calc_sigma:
grG_ObjDef[sigma][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[sigma][grC_depends] := {S3(dn,dn), u3(up),ntype[gr_data[partner_,gname]]}:

grF_calc_sigma := proc(objects, iList)

local s, a, b:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for a to Ndim[gname] do
   for b to Ndim[gname] do
     s := s + gr_data[S3dndn_,gname,a,b] * gr_data[u3up_,gname,a]
            * gr_data[u3up_,gname,b]:
   od:
 od:
 s := s * gr_data[ntype_,gr_data[partner_,gname]];

end:

#----------------------------
# sigma1
#
# Energy density of a shell
#
#----------------------------
grG_ObjDef[sigma1][grC_header] := `sigma1 `:
grG_ObjDef[sigma1][grC_root] := sigma1_:
grG_ObjDef[sigma1][grC_rootStr] := `sigma1 `:
grG_ObjDef[sigma1][grC_indexList] := []:
grG_ObjDef[sigma1][grC_calcFn] := grF_calc_sigma1:
grG_ObjDef[sigma1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[sigma1][grC_depends] := {}:


grF_calc_sigma1 := proc(object, iList)

local a;
global gr_data, Ndim, grG_metricName:

 sigma(seq(gr_data[xup_,gname,a],a=1..Ndim[gname]));

end:

#----------------------------
# sigmadot
#
# Energy density of a shell
#----------------------------
grG_ObjDef[sigmadot][grC_header] := `sigmadot `:
grG_ObjDef[sigmadot][grC_root] := sigmadot_:
grG_ObjDef[sigmadot][grC_rootStr] := `sigmadot `:
grG_ObjDef[sigmadot][grC_indexList] := []:
grG_ObjDef[sigmadot][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[sigmadot][grC_calcFnParms] := 'grG_u3up_[gname,s1_]*grG_sigmacdn_[gname,s1_]':
grG_ObjDef[sigmadot][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[sigmadot][grC_depends] := {sigma(cdn), u3(up)}:

#----------------------------
# sigma1dot
#
# Energy density of a shell
#----------------------------
grG_ObjDef[sigma1dot][grC_header] := `sigma1dot `:
grG_ObjDef[sigma1dot][grC_root] := sigma1dot_:
grG_ObjDef[sigma1dot][grC_rootStr] := `sigma1dot `:
grG_ObjDef[sigma1dot][grC_indexList] := []:
grG_ObjDef[sigma1dot][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[sigma1dot][grC_calcFnParms] := 'grG_u3up_[gname,s1_]*grG_sigma1cdn_[gname,s1_]':
grG_ObjDef[sigma1dot][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[sigma1dot][grC_depends] := {sigma1(cdn), u3(up)}:


#----------------------------
# S3(dn,dn)
#----------------------------
grG_ObjDef[S3(dn,dn)][grC_header] := `Intrinsic stress-energy`:
grG_ObjDef[S3(dn,dn)][grC_root] := S3dndn_:
grG_ObjDef[S3(dn,dn)][grC_rootStr] := `S `:
grG_ObjDef[S3(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[S3(dn,dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[S3(dn,dn)][grC_calcFnParms] :=
  ('gr_data[Jump_,gname,K(dn,dn),gr_data[join_,gname],a1_,a2_]'
    - 'gr_data[gdndn_,grG_metricName,a1_,a2_]'*
      'gr_data[Jump_,gname,trK,gr_data[join_,gname]]')/(8*Pi)
    *'gr_data[utype_,gr_data[partner_,grG_metricName]]':
grG_ObjDef[S3(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[S3(dn,dn)][grC_depends] := {Jump[K(dn,dn) ],
                    Jump[trK] }:


#----------------------------
# S3(dn,up)
#----------------------------
grG_ObjDef[S3(dn,up)][grC_header] := `Intrinsic stress-energy`:
grG_ObjDef[S3(dn,up)][grC_root] := S3dnup_:
grG_ObjDef[S3(dn,up)][grC_rootStr] := `S `:
grG_ObjDef[S3(dn,up)][grC_indexList] := [dn,up]:
grG_ObjDef[S3(dn,up)][grC_calcFn] := grF_calc_S3dnup:
grG_ObjDef[S3(dn,up)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[S3(dn,up)][grC_depends] := {Jump[K(dn,up)],
                    Jump[trK]}:

grF_calc_S3dnup := proc(object,iList)
local s;
global gr_data, Ndim, grG_metricName:

 s := gr_data[Jump_,gname,K(dn,up),gr_data[join_,gname],a1_,a2_];
 if a1_ = a2_ then
    s := s - gr_data[Jump_,gname,trK,gr_data[join_,gname]]:
 fi:
 s := s/(8*Pi)
    *gr_data[utype_,gr_data[partner_,grG_metricName]]:

end:

#----------------------------
# S3(dn,up,cdn)
#
# (need this explicitly so we can evaluate on
#  the surface after taking a derivative)
#----------------------------
grG_ObjDef[S3(dn,up,cdn)][grC_header] := `Intrinsic stress-energy`:
grG_ObjDef[S3(dn,up,cdn)][grC_root] := S3dnupcdn_:
grG_ObjDef[S3(dn,up,cdn)][grC_rootStr] := `S `:
grG_ObjDef[S3(dn,up,cdn)][grC_indexList] := [dn,up,cdn]:
grG_ObjDef[S3(dn,up,cdn)][grC_calcFn] := grF_calc_S3dnupcdn:
grG_ObjDef[S3(dn,up,cdn)][grC_symmetry] := grF_sym_nosym3:
grG_ObjDef[S3(dn,up,cdn)][grC_depends] := {S3(dn,up), Chr(dn,dn,up) }:

grF_calc_S3dnupcdn := proc(object,iList)
local s, a;
global gr_data, Ndim, grG_metricName:

 s := diff( gr_data[S3dnup_,gname, a1_,a2_], gr_data[xup_,gname, a3_]);
 for a to Ndim[gname] do
    s := s - gr_data[S3dnup_,gname, a,a2_] *
             gr_data[Chrdndnup_,gname, a1_,a3_, a]
           + gr_data[S3dnup_,gname, a1_,a] *
             gr_data[Chrdndnup_,gname, a, a3_, a2_ ]:
 od:

 juncF_project( s, gr_data[partner_,gname], gname);

end:

#----------------------------
# SKGeqn
#
#
#----------------------------
grG_ObjDef[SKGeqn][grC_header] := ` - S{i ^j} Mean[K{j ^i}] = usign Jump[ G{^a ^b} n{a} n{b}]`:
grG_ObjDef[SKGeqn][grC_root] := SKGeqn_:
grG_ObjDef[SKGeqn][grC_rootStr] := `SKGeqn `:
grG_ObjDef[SKGeqn][grC_indexList] := []:
grG_ObjDef[SKGeqn][grC_calcFn] := grF_calc_SKGeqn:
grG_ObjDef[SKGeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[SKGeqn][grC_depends] := {S3(dn,up), Mean[K(dn,up)],
       [gr_data[partner_,gname], Jump[ Gnn, gr_data[join_, gr_data[partner_, gname]] ] ] }:

grF_calc_SKGeqn := proc( object, iList)
local a, b, s:
global gr_data, Ndim, grG_metricName:

 s := 0;
 for a to Ndim[gname] do
   for b to Ndim[gname] do
      s := s + gr_data[S3dnup_,gname, a, b] *
               gr_data[Mean_,gname, K(dn,up), gr_data[join_,gname], b, a ]:
   od:
 od:

 RETURN(- s =  gr_data[utype_, gr_data[partner_, gname]] *
    gr_data[Jump_, gr_data[partner_,gname], Gnn,
               gr_data[partner_, gr_data[join_,gname]] ]/8/Pi):

end:

#----------------------------
# SKTeqn
#
#
#----------------------------
grG_ObjDef[SKTeqn][grC_header] := ` - S{i ^j} Mean[K{j ^i}] = usign Jump[ T{^a ^b} n{a} n{b}]`:
grG_ObjDef[SKTeqn][grC_root] := SKTeqn_:
grG_ObjDef[SKTeqn][grC_rootStr] := `SKTeqn `:
grG_ObjDef[SKTeqn][grC_indexList] := []:
grG_ObjDef[SKTeqn][grC_calcFn] := grF_calc_SKTeqn:
grG_ObjDef[SKTeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[SKTeqn][grC_depends] := {S3(dn,up), Mean[K(dn,up)],
       [gr_data[partner_,gname], Jump[ Tnn, gr_data[join_, gr_data[partner_, gname]] ] ] }:

grF_calc_SKTeqn := proc( object, iList)
local a, b, s:
global gr_data, Ndim, grG_metricName:

 s := 0;
 for a to Ndim[gname] do
   for b to Ndim[gname] do
      s := s + gr_data[S3dnup_,gname, a, b] *
               gr_data[Mean_,gname, K(dn,up), gr_data[join_,gname], b, a ]:
   od:
 od:

 RETURN(- s =  gr_data[utype_, gr_data[partner_, gname]] *
    gr_data[Jump_, gr_data[partner_,gname], Tnn, gr_data[partner_, gr_data[join_,gname]] ]):

end:

#----------------------------
# surface
#----------------------------
grG_ObjDef[surface][grC_header] := `The Equation of the surface`:
grG_ObjDef[surface][grC_root] := surface_:
grG_ObjDef[surface][grC_rootStr] := `surface `:
grG_ObjDef[surface][grC_indexList] := []:
grG_ObjDef[surface][grC_calcFn] := grF_enterComp: # prompt the user for the surface
grG_ObjDef[surface][grC_preCalcFn] := grF_preCalc_surface: # help info
grG_ObjDef[surface][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[surface][grC_depends] := {g(up,up)}: # g(up,up) needed eventually for n(dn)
                               # [but n(dn) calc'd directly, so sneak in
                               # g(up,up) dependency here]

grF_preCalc_surface := proc( object)

printf(` SURFACE: Enter the expression for the surface in %a.\n`, grG_metricName):
printf(`   The surface will be defined by setting the \n`):
printf(`   expression you enter to zero.\n`):
printf(`   To enter the normal explicitly, enter 0 (zero)\n`):

end:

#----------------------------
# Tnn
#
# Defined for the manifold
#----------------------------
grG_ObjDef[Tnn][grC_header] := `T{^a ^b} n{a} n{b}`:
grG_ObjDef[Tnn][grC_root] := Tnn_:
grG_ObjDef[Tnn][grC_rootStr] := `Tnn `:
grG_ObjDef[Tnn][grC_indexList] := []:
grG_ObjDef[Tnn][grC_calcFn] := grF_calc_sum2_project:
grG_ObjDef[Tnn][grC_calcFnParms] := 'grG_Tupup_[grG_metricName,s1_,s2_]'*
                       'gr_data[ndn_,grG_metricName,s1_]' *
                       'gr_data[ndn_,grG_metricName,s2_]':
grG_ObjDef[Tnn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Tnn][grC_depends] := {T(up,up),n(dn)}:

#----------------------------
# Tun
#
# Defined for the manifold
#----------------------------
grG_ObjDef[Tun][grC_header] := `T{a b} u{^a} n{^b}`:
grG_ObjDef[Tun][grC_root] := Tun_:
grG_ObjDef[Tun][grC_rootStr] := `Tun `:
grG_ObjDef[Tun][grC_indexList] := [dn]:
grG_ObjDef[Tun][grC_calcFn] := grF_calc_sum2_project:
grG_ObjDef[Tun][grC_calcFnParms] := 'grG_Tdndn_[grG_metricName,s1_,s2_]'*
                       'gr_data[uup_,grG_metricName,s1_]' *
                       'gr_data[nup_,grG_metricName,s2_]':
grG_ObjDef[Tun][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Tun][grC_depends] := {T(dn,dn),u(up)}:

#----------------------------
# Txn(dn)
#
# Defined for the 3 surface
#----------------------------
grG_ObjDef[Txn(dn)][grC_header] := `T{a b} diff(x{^a},xi{^i}) n{^b}`:
grG_ObjDef[Txn(dn)][grC_root] := Txndn_:
grG_ObjDef[Txn(dn)][grC_rootStr] := `Txn `:
grG_ObjDef[Txn(dn)][grC_indexList] := [dn]:
grG_ObjDef[Txn(dn)][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[Txn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[Txn(dn)][grC_depends] := {[gr_data[partner_,gname], n(up)]}:

grF_calc_Txn := proc( object, iList)
local s, a, b:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for a to Ndim[gname] do
    for b to Ndim[gname] do
       s := s + gr_data[Tdndn_, gr_data[partner_,grG_metricName],a,b] *
       diff( gr_data[xformup_,gr_data[partner_,grG_metricName],a],
             gr_data[xup_,gname,a1_]) *
       gr_data[nup_, gr_data[partner_,grG_metricName],b]:

    od:
 od:

 juncF_project( s, gr_data[partner_,gname], gname);

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
grG_ObjDef[u3(dn)][grC_header] := `Intrinsic Tangent Vector`:
grG_ObjDef[u3(dn)][grC_root] := u3dn_:
grG_ObjDef[u3(dn)][grC_rootStr] := `u3 `:
grG_ObjDef[u3(dn)][grC_indexList] := [dn]:
grG_ObjDef[u3(dn)][grC_calcFn] := grF_calc_u3dn:
grG_ObjDef[u3(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[u3(dn)][grC_depends] := { xform[gr_data[partner_,gname]](up),u[gr_data[partner_,gname]](dn)}:

grF_calc_u3dn := proc(object, iList)

local pname, a, s:
global gr_data, Ndim, grG_metricName:

 s := 0:

 pname := gr_data[partner_,gname]:
 for a to Ndim[pname] do
   s := s + diff(gr_data[xformup_,pname,a], gr_data[xup_,gname,a1_]) *
        gr_data[udn_,pname,a]:
 od:
 juncF_project(s,pname,gname);

end:

#----------------------------
# u3div
#
# Entered as part of junction()
#----------------------------
grG_ObjDef[u3div][grC_header] := `Intrinsic Tangent Vector`:
grG_ObjDef[u3div][grC_root] := u3div_:
grG_ObjDef[u3div][grC_rootStr] := `u3div `:
grG_ObjDef[u3div][grC_indexList] := []:
grG_ObjDef[u3div][grC_calcFn] := grF_calc_u3div:
grG_ObjDef[u3div][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[u3div][grC_depends] := { u3(up,cdn)}:

grF_calc_u3div := proc(object, iList)

local a, s:
global gr_data, Ndim, grG_metricName:

 s := 0:
 for a to Ndim[gname] do
   s := s + gr_data[u3upcdn_,gname,a,a]:
 od:
 s;

end:

#----------------------------
# u(up)
#
# Entered as part of junction()
#----------------------------
grG_ObjDef[u(up)][grC_header] := `Tangent Vector`:
grG_ObjDef[u(up)][grC_root] := uup_:
grG_ObjDef[u(up)][grC_rootStr] := `u `:
grG_ObjDef[u(up)][grC_indexList] := [up]:
grG_ObjDef[u(up)][grC_calcFn] := grF_calc_uup:
grG_ObjDef[u(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[u(up)][grC_depends] := {}:

grF_calc_uup := proc(object, iList)
global gr_data, Ndim, grG_metricName:

  if not assigned( gr_data[totalVar_,grG_metricName] ) or
    (gr_data[totalVar_,grG_metricName] = 0) then
     ERROR(`u(up) cannot be calculated. Require a param= argument in hypersurf()`):
  fi:
  diff( gr_data[xformup_,grG_metricName,a1_], gr_data[totalVar_,grG_metricName]);

end:

#----------------------------
# udot(up)
#
#----------------------------
grG_ObjDef[udot(up)][grC_header] := `Accel. of Tangent`:
grG_ObjDef[udot(up)][grC_root] := udotup_:
grG_ObjDef[udot(up)][grC_rootStr] := `udot `:
grG_ObjDef[udot(up)][grC_indexList] := [up]:
grG_ObjDef[udot(up)][grC_calcFn] := grF_calc_udot:
grG_ObjDef[udot(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[udot(up)][grC_depends] := {u(up),Chr(dn,dn,up)}:

grF_calc_udot := proc(object, iList)
local s, a,b, norm, N, pname, totalVar:
global gr_data, Ndim, grG_metricName:

 totalVar := gr_data[totalVar_,gname]:
 N := Ndim[gname]:
 pname := gr_data[partner_,gname]:
 s := diff( gr_data[uup_,gname,a1_],totalVar):
   for a to N do
     for b to N do
       s := s + gr_data[uup_,gname,a] * gr_data[uup_,gname,b]
                * gr_data[Chrdndnup_,gname,a,b,a1_]:
     od:
   od:
   juncF_project(s,gname,pname); # don't unchain

end:

#----------------------------
# udot_old(up)
#
#----------------------------
grG_ObjDef[udot_old(up)][grC_header] := `Accel. of Tangent`:
grG_ObjDef[udot_old(up)][grC_root] := udotOldup_:
grG_ObjDef[udot_old(up)][grC_rootStr] := `udot `:
grG_ObjDef[udot_old(up)][grC_indexList] := [up]:
grG_ObjDef[udot_old(up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[udot_old(up)][grC_calcFnParms] := 'grG_uup_[grG_metricName,s1_] *
        gr_data[uupcdn_,grG_metricName,a1_,s1_]':
grG_ObjDef[udot_old(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[udot_old(up)][grC_depends] := {u(up),u(up,cdn)}:

#----------------------------
# utype
# assigned in junction()
#----------------------------
grG_ObjDef[utype][grC_header] := `u{a} u{^a}`:
grG_ObjDef[utype][grC_root] := utype_:
grG_ObjDef[utype][grC_rootStr] := `utype `:
grG_ObjDef[utype][grC_indexList] := []:
grG_ObjDef[utype][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[utype][grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# xform(up)
# Assigned directly in hypersurf 
#----------------------------
grG_ObjDef[xform(up)][grC_header] := `Coordinate transforms onto the surface`:
grG_ObjDef[xform(up)][grC_root] := xformup_:
grG_ObjDef[xform(up)][grC_rootStr] := `xform `:
grG_ObjDef[xform(up)][grC_indexList] := [up]:
grG_ObjDef[xform(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[xform(up)][grC_depends] := {}:

$undef gname
