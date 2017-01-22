#
# Gauss-Codazi Objects
# Defined on Sigma
#

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
# HCGeqn
#
# Hamiltonian constraint equation on Sigma (G version)
# Toolkit (3.41)
#----------------------------
grG_ObjDef[HCeqn][grC_header] := `-2 nsign G{a b} n{^a} n{^b} = R + nsign(K^2 +K_{ij} K^{ij})`:
grG_ObjDef[HCeqn][grC_root] := HCeqn_:
grG_ObjDef[HCeqn][grC_rootStr] := `HCeqn `:
grG_ObjDef[HCeqn][grC_indexList] := []:
grG_ObjDef[HCeqn][grC_calcFn] := grF_calc_HGCeqn:
grG_ObjDef[HCeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[HCeqn][grC_depends] := {Gnn[gr_data[partner_,grG_metricName]], 
									HCGeqnRHS}:

grF_calc_HGCeqn := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s, M:

	s := -2*gr_data[nsign_, M]*gr_data[Gnn_,grG_metricName] = 
                    gr_data[HCGeqnRHS_,grG_metricName]:

    RETURN(s):
end proc:

#----------------------------
# HCGeqnRHS
#
# Hamiltonian constraint equation on Sigma (G version)
#----------------------------
grG_ObjDef[HCeqn][grC_header] := `R + K^2 +K_{ij} K^{ij}`:
grG_ObjDef[HCeqn][grC_root] := HCeqn_:
grG_ObjDef[HCeqn][grC_rootStr] := `HCeqn `:
grG_ObjDef[HCeqn][grC_indexList] := []:
grG_ObjDef[HCeqn][grC_calcFn] := grF_calc_HGCeqnRHS:
grG_ObjDef[HCeqn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[HCeqn][grC_depends] := {Ricciscalar,trK,Ksq, [gr_data[partner_,gname], Gnn]}:

grF_calc_HGCeqnRHS := proc(object, iList)
global gr_data, grG_metricName, Ndim:
local s, M:

	M := gr_data[partner_, grG_metricName]:

	s := grG_scalarR_[grG_metricName]+ gr_data[nsign_, M] *
                       (gr_data[trK_,grG_metricName]^2 -
                       gr_data[Ksq_,grG_metricName]) :

RETURN(s):

end proc:

