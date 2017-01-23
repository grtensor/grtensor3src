#
# Gauss-Codazi Objects
# Defined on Sigma
#
#
# Not sure the full GC equations are used much 
# Seems to be mostly the contracted versions...

$define gname grG_metricName

(*
#----------------------------
# GCeqn1
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn1][grC_header] := `Gauss-Codazi Eqn (R e e e e) `:
grG_ObjDef[GGCeqn1][grC_root] := GCeqn1_:
grG_ObjDef[GGCeqn1][grC_rootStr] := `GC eqn 1 `:
grG_ObjDef[GGCeqn1][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[GGCeqn1][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[GGCeqn1][grC_calcFnParms] := 'gr_data[GCeqn1LHS_,grG_metricName,a1_,a2_,a3_,a4_]' = 
                    'gr_data[GCeqn1RHS_,grG_metricName,a1_,a2_,a3_,a4_]':
grG_ObjDef[GGCeqn1][grC_symmetry] := grF_sym_nosym4:
grG_ObjDef[GGCeqn1][grC_depends] := {GCeqn1LHS(dn,dn,dn),GCeqn1RHS(dn,dn,dn)}:

#----------------------------
# GCeqn1LHS (toolkit 3.39)
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn1LHS][grC_header] := `Gauss-Codazi Eqn (R e e e e) LHS`:
grG_ObjDef[GGCeqn1LHS][grC_root] := GCeqn1LHS_:
grG_ObjDef[GGCeqn1LHS][grC_rootStr] := `GC eqn 1 (LHS)`:
grG_ObjDef[GGCeqn1LHS][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[GGCeqn1LHS][grC_calcFn] := grF_calc_GCeqn1LHS:
grG_ObjDef[GGCeqn1LHS][grC_symmetry] := grF_sym_nosym4:
grG_ObjDef[GGCeqn1LHS][grC_depends] := {R[gr_data[partner_, grG_metricName]](dn,dn,dn,dn), 
								xform[gr_data[partner_, grG_metricName]](up)}:

grF_calc_GCeqn1LHS := proc(object, iList)
local s1, s2, s3, s4, s, M:
global gr_data, grG_metricName, Ndim:

	M := gr_data[partner_, grG_metricName]:
	for s1 to Ndim[M] do
		for s2 to Ndim[M] do
			for s3 to Ndim[M] do
				for s3 to Ndim[M] do
					s := gr_data[Rdndndndn_, M, s1, s2, s3, s4]*
						diff(gr_data[xformup_, M, s1], gr_data[xup_, grG_metricName, a1_]) *
						diff(gr_data[xformup_, M, s2], gr_data[xup_, grG_metricName, a2_]) *
						diff(gr_data[xformup_, M, s3], gr_data[xup_, grG_metricName, a3_]) *
						diff(gr_data[xformup_, M, s4], gr_data[xup_, grG_metricName, a4_]):
				od:
			od:
		od:
	od:

 	juncF_project( s, M, grG_metricName);

end proc:

#----------------------------
# GCeqn1RHS (toolkit 3.39)
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn1RHS][grC_header] := `Gauss-Codazi Eqn (R e e e e) RHS`:
grG_ObjDef[GGCeqn1RHS][grC_root] := GCeqn1RHS_:
grG_ObjDef[GGCeqn1RHS][grC_rootStr] := `GC eqn 1 (RHS)`:
grG_ObjDef[GGCeqn1RHS][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[GGCeqn1RHS][grC_calcFn] := grF_calc_GCeqn1RHS:
grG_ObjDef[GGCeqn1RHS][grC_symmetry] := grF_sym_nosym4:
grG_ObjDef[GGCeqn1RHS][grC_depends] := {R(dn,dn,dn,dn), 
								K(dn,dn)}:

grF_calc_GCeqn1RHS := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s:

s := gr_data[Rdndndndn_, gname, a1_, a2_, a3_, a4_] + 
     gr_data[nsign_, gname] * 
     (gr_data[Kdndn_, gname, a1_, a4_] * gr_data[Kdndn_, gname, a2_, a3_] -
      gr_data[Kdndn_, gname, a1_, a3_] * gr_data[Kdndn_, gname, a2_, a4_]):

RETURN(s):

end proc:
#----------------------------
# GCeqn2 (toolkit 3.40)
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn1][grC_header] := `Gauss-Codazi Eqn (R n e e e) `:
grG_ObjDef[GGCeqn1][grC_root] := GCeqn2_:
grG_ObjDef[GGCeqn1][grC_rootStr] := `GC eqn 2 `:
grG_ObjDef[GGCeqn1][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[GGCeqn1][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[GGCeqn1][grC_calcFnParms] := 'gr_data[GCeqn2LHS_,grG_metricName,a1_,a2_,a3_]' = 
                    'gr_data[GCeqn2RHS_,grG_metricName,a1_,a2_,a3_]':
grG_ObjDef[GGCeqn1][grC_symmetry] := grF_sym_nosym3:
grG_ObjDef[GGCeqn1][grC_depends] := {GCeqn2LHS(dn,dn,dn),GCeqn2RHS(dn,dn,dn)}:

#----------------------------
# GCeqn2LHS (toolkit 3.40)
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn2LHS][grC_header] := `Gauss-Codazi Eqn (R n e e e) LHS`:
grG_ObjDef[GGCeqn2LHS][grC_root] := GCeqn1LHS_:
grG_ObjDef[GGCeqn2LHS][grC_rootStr] := `GC eqn 2 (LHS)`:
grG_ObjDef[GGCeqn2LHS][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[GGCeqn2LHS][grC_calcFn] := grF_calc_GCeqn1LHS:
grG_ObjDef[GGCeqn2LHS][grC_symmetry] := grF_sym_nosym4:
grG_ObjDef[GGCeqn2LHS][grC_depends] := {R[gr_data[partner_, grG_metricName]](dn,dn,dn,dn), 
								xform[gr_data[partner_, grG_metricName]](up),
								n[gr_data[partner_, grG_metricName]](up)}:

grF_calc_GCeqn1LHS := proc(object, iList)
local s1, s2, s3, s4, s, M:
global gr_data, grG_metricName, Ndim:

	M := gr_data[partner_, grG_metricName]:
	for s1 to Ndim[M] do
		for s2 to Ndim[M] do
			for s3 to Ndim[M] do
				for s3 to Ndim[M] do
					s := gr_data[Rdndndndn_, M, s1, s2, s3, s4]*
						gr_data[nup_, M, a1_] *
						diff(gr_data[xformup_, M, s2], gr_data[xup_, grG_metricName, a2_]) *
						diff(gr_data[xformup_, M, s3], gr_data[xup_, grG_metricName, a3_]) *
						diff(gr_data[xformup_, M, s4], gr_data[xup_, grG_metricName, a4_]):
				od:
			od:
		od:
	od:

 	juncF_project( s, M, grG_metricName);

end proc:

#----------------------------
# GCeqn2RHS (toolkit 3.40)
#
# Defined for the manifold
#----------------------------
grG_ObjDef[GGCeqn2RHS][grC_header] := `Gauss-Codazi Eqn (R n e e e) RHS`:
grG_ObjDef[GGCeqn2RHS][grC_root] := GCeqn2RHS_:
grG_ObjDef[GGCeqn2RHS][grC_rootStr] := `GC eqn 2 (RHS)`:
grG_ObjDef[GGCeqn2RHS][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[GGCeqn2RHS][grC_calcFn] := grF_calc_GCeqn2RHS:
grG_ObjDef[GGCeqn2RHS][grC_symmetry] := grF_sym_nosym3:
grG_ObjDef[GGCeqn2RHS][grC_depends] := {K(dn,dn,cdn)}:

grF_calc_GCeqn2RHS := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s:

s := gr_data[Kdndncdn_, gname, a1_, a2_, a3_] - gr_data[Kdndncdn_, gname, a1_, a3_, a2_]:

RETURN(s):

end proc:
*)

#----------------------------
# Gnn
#
# Defined for the manifold
#----------------------------
grG_ObjDef[Gnn][grC_header] := `G{a b} n{^a} n{^b}`:
grG_ObjDef[Gnn][grC_root] := Gnn_:
grG_ObjDef[Gnn][grC_rootStr] := `Gnn `:
grG_ObjDef[Gnn][grC_indexList] := []:
grG_ObjDef[Gnn][grC_calcFn] := grF_calc_sum2_project:
grG_ObjDef[Gnn][grC_calcFnParms] := 'gr_data[Gdndn_,grG_metricName,s1_,s2_]'*
                       'gr_data[nup_,grG_metricName,s1_]' *
                       'gr_data[nup_,grG_metricName,s2_]':
grG_ObjDef[Gnn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Gnn][grC_depends] := {G(dn,dn),n(up)}:

#----------------------------
# Gxn(dn)
#
# Defined for the surface
#----------------------------
grG_ObjDef[Gxn(dn)][grC_header] := `G{a b} diff(x{^a},y{^i}) n{^b}`:
grG_ObjDef[Gxn(dn)][grC_root] := Gxndn_:
grG_ObjDef[Gxn(dn)][grC_rootStr] := `Gxn `:
grG_ObjDef[Gxn(dn)][grC_indexList] := [dn]:
grG_ObjDef[Gxn(dn)][grC_calcFn] := grF_calc_Gxn:
grG_ObjDef[Gxn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[Gxn(dn)][grC_depends] := { G[gr_data[partner_,gname]](dn,dn),
          n[gr_data[partner_,gname]](up)}:

grF_calc_Gxn := proc( object, iList)
local s, a, b, pname:
global gr_data, Ndim, grG_metricName:

 pname := gr_data[partner_,grG_metricName]:

 s := 0:
 for a to Ndim[gname] do
    for b to Ndim[gname] do
       s := s + gr_data[Gdndn_, pname,a,b] *
       diff( gr_data[xformup_,pname,a],
             gr_data[xup_,gname,a1_]) *
       gr_data[nup_, pname,b]:

    od:
 od:

 juncF_project( s, gname, pname);

end:

#----------------------------
# C1Geqn
#
# Hamiltonian constraint equation on Sigma (G version)
# Toolkit (3.41)
#----------------------------
grG_ObjDef[C1Geqn][grC_header] := `-2 nsign G{a b} n{^a} n{^b} = R + nsign(K^2 +K_{ij} K^{ij})`:
grG_ObjDef[C1Geqn][grC_root] := C1Geqn_:
grG_ObjDef[C1Geqn][grC_rootStr] := `C1Geqn `:
grG_ObjDef[C1Geqn][grC_indexList] := []:
grG_ObjDef[C1Geqn][grC_calcFn] := grF_calc_C1Geqn:
grG_ObjDef[C1Geqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C1Geqn][grC_depends] := {Gnn[gr_data[partner_,grG_metricName]], 
									C1eqnRHS}:

grF_calc_C1Geqn := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s, M:

 	M := gr_data[partner_,grG_metricName]:

	s := -2*gr_data[nsign_, M]*gr_data[Gnn_,M] = 
                    gr_data[C1eqnRHS_,grG_metricName]:

    RETURN(s):
end proc:

#----------------------------
# C1eqnRHS
#
# Hamiltonian constraint equation on Sigma (G version)
#----------------------------
grG_ObjDef[C1eqnRHS][grC_header] := `R + K^2 +K_{ij} K^{ij}`:
grG_ObjDef[C1eqnRHS][grC_root] := C1eqnRHS_:
grG_ObjDef[C1eqnRHS][grC_rootStr] := `C1eqnRHS `:
grG_ObjDef[C1eqnRHS][grC_indexList] := []:
grG_ObjDef[C1eqnRHS][grC_calcFn] := grF_calc_C1eqnRHS:
grG_ObjDef[C1eqnRHS][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[C1eqnRHS][grC_depends] := {Ricciscalar,trK,Ksq, Gnn[gr_data[partner_,gname]]}:

grF_calc_C1eqnRHS := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s, M:

	M := gr_data[partner_, grG_metricName]:

	s := gr_data[scalarR_,grG_metricName]+ gr_data[nsign_, M] *
                       (gr_data[trK_,grG_metricName]^2 -
                       gr_data[Ksq_,grG_metricName]) :

RETURN(s):

end proc:

#----------------------------
# C2Geqn(dn)
#
# Momentum constraint equation on Sigma
#----------------------------
grG_ObjDef[C2Geqn(dn)][grC_header] := `K_{,a} - K^{i}_{a;i} = G{i j} e{(a) ^i} n{^j}`:
grG_ObjDef[C2Geqn(dn)][grC_root] := C2Geqn_:
grG_ObjDef[C2Geqn(dn)][grC_rootStr] := `C2Geqn `:
grG_ObjDef[C2Geqn(dn)][grC_indexList] := [dn]:
grG_ObjDef[C2Geqn(dn)][grC_calcFn] := grF_calc_C2Geqn:
grG_ObjDef[C2Geqn(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[C2Geqn(dn)][grC_depends] := {trK(cdn),K(dn,up,cdn),
                 Gxn[gr_data[partner_,gname]](dn) }:

grF_calc_C2Geqn := proc(object, iList)

local s,b;
global gr_data, Ndim, grG_metricName:

  s := 0:

  for b to Ndim[gname] do
    s := s - gr_data[Kdnupcdn_,gname,a1_,b,b]:
  od:

  s := s + gr_data[trKcdn_,gname,a1_]:

 RETURN(s=gr_data[Gxndn_,gr_data[partner_,gname],a1_]);

end:

#----------------------------
# C2eqnRHS(dn)
#
# Momentum constraint equation on Sigma
#----------------------------
grG_ObjDef[C2eqnRHS(dn)][grC_header] := `K_{;a} - K^{i}_{a;i} = 0`:
grG_ObjDef[C2eqnRHS(dn)][grC_root] := C2eqnRHS_:
grG_ObjDef[C2eqnRHS(dn)][grC_rootStr] := `C2eqnRHS `:
grG_ObjDef[C2eqnRHS(dn)][grC_indexList] := [dn]:
grG_ObjDef[C2eqnRHS(dn)][grC_calcFn] := grF_calc_C2eqnRHS:
grG_ObjDef[C2eqnRHS(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[C2eqnRHS(dn)][grC_depends] := {trK(cdn),K(dn,up,cdn) }:

grF_calc_C2eqnRHS := proc(object, iList)

local s,b;
global gr_data, Ndim, grG_metricName:

  s := 0:

  for b to Ndim[gname] do
    s := s - gr_data[Kdnupcdn_,gname,a1_,b,b]:
  od:

  s := s + gr_data[trKcdn_,gname,a1_]:

 RETURN(s=8*Pi*gr_data[Txndn_,gr_data[partner_,gname],a1_]);

end:

$undef gname
