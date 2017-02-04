# objects_null.mpl

$define gname grG_metricName

#----------------------------
# C(dn,dn)
# Curvature of null surface
#----------------------------
grG_ObjDef[C(dn,dn)][grC_header] := `Curvature of null surface`:
grG_ObjDef[C(dn,dn)][grC_root] := Cdndn_:
grG_ObjDef[C(dn,dn)][grC_rootStr] := `C `:
grG_ObjDef[C(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[C(dn,dn)][grC_calcFn] := grF_calc_Cnull:
grG_ObjDef[C(dn,dn)][grC_symmetry] := grF_sym_sym2:

grG_ObjDef[C(dn,dn)][grC_depends] := {
			N[gr_data[partner_,grG_metricName]](dn,cdn), 
			k[gr_data[partner_,grG_metricName]](up),
			eA[gr_data[partner_,grG_metricName]](up),
			eB[gr_data[partner_,grG_metricName]](up)
			}:
# Use this form (not 3.100) since cdn wants vector in 
# the co-ordinates of M and k, eA, eB have a been 
# converted already into Sigma

grF_calc_Cnull := proc(object, iList)
local s, a, b, c, s1, pname, basis_root, basis_rootcdn:
global gr_data, Ndim, grG_metricName:

 pname := gr_data[partner_,gname]:
 basis_root := [kup_, eAup_, eBup_]:
 s := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
       s := s + (1/2)*(gr_data[Ndncdn_,pname,a, b] + gr_data[Ndncdn_,pname,b,a]) *
		  gr_data[basis_root[a1_],pname, a] *
		  gr_data[basis_root[a2_],pname, b ];
   od:
 od:
 #juncF_project( s,pname,gname);

end:

#----------------------------
# eA(up)
# This object (in M) describes a basis vectors of the surface. 
#
# The first vector is aliased to k{^a}
# 2 & 3 are the e{^a (2)} and e{^a (3)}
#----------------------------
grG_ObjDef[eA(up)][grC_header] := `Basis vector`:
grG_ObjDef[eA(up)][grC_root] := eAup_:
grG_ObjDef[eA(up)][grC_rootStr] := `eA `:
grG_ObjDef[eA(up)][grC_indexList] := [up]:
grG_ObjDef[eA(up)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[eA(up)][grC_calcFnParms] :=
	'diff( gr_data[xformup_,gname,a1_], gr_data[xup_, gr_data[partner_, gname], 2])':
grG_ObjDef[eA(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[eA(up)][grC_depends] := {xform(up)}:

#----------------------------
# eB(up)
# This object (in M) describes a basis vectors of the surface. 
#
# The first vector is aliased to k{^a}
# 2 & 3 are the e{^a (2)} and e{^a (3)}
#----------------------------
grG_ObjDef[eB(up)][grC_header] := `Basis vector`:
grG_ObjDef[eB(up)][grC_root] := eBup_:
grG_ObjDef[eB(up)][grC_rootStr] := `eB `:
grG_ObjDef[eB(up)][grC_indexList] := [up]:
grG_ObjDef[eB(up)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[eB(up)][grC_calcFnParms] :=
	'diff( gr_data[xformup_,gname,a1_], gr_data[xup_, gr_data[partner_, gname], 3])':
grG_ObjDef[eB(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[eB(up)][grC_depends] := {xform(up)}:


#----------------------------
# j_null(up)
# - defined for null shells only
#----------------------------
grG_ObjDef[j_null(up)][grC_header] := `Null mass density`:
grG_ObjDef[j_null(up)][grC_root] := jup_:
grG_ObjDef[j_null(up)][grC_rootStr] := `j null `:
grG_ObjDef[j_null(up)][grC_indexList] := [up]:
grG_ObjDef[j_null(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[j_null(up)][grC_calcFn] := grF_calc_j_null:
grG_ObjDef[j_null(up)][grC_depends] := {Jump[C(dn,dn)],sigma(up,up)}:

grF_calc_j_null := proc(object, iList)
  global gr_data, Ndim, grG_metricName;
  local s, a, b:

  s := 0;
  if a1_ > 1 then
     for b from 2 to 3 do 
        # select Jump[C(1,dn)]
        s := gr_data[sigmaupup_, grG_metricName, a1_, b] * 
        	gr_data[Jump_,grG_metricName,C(dn,dn),gr_data[join_,gname],1,b]:
     od:
  fi:
  s := 1/(8*pi)*s;
  RETURN(s):
end proc:

#----------------------------
# k(up)
# - defined for null shells only
#----------------------------
grG_ObjDef[k(up)][grC_header] := `Null vector on Surface`:
grG_ObjDef[k(up)][grC_root] := kup_:
grG_ObjDef[k(up)][grC_rootStr] := `k `:
grG_ObjDef[k(up)][grC_indexList] := [up]:
grG_ObjDef[k(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[k(up)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[k(up)][grC_calcFnParms] :=
	'diff( gr_data[xformup_,gname,a1_], gr_data[xup_, gr_data[partner_, gname], 1])':
grG_ObjDef[k(up)][grC_depends] := {xform(up)}:

#----------------------------
# kdotk
# - defined for null shells only
#----------------------------
grG_ObjDef[kdotk][grC_header] := `k{a} k{^a}`:
grG_ObjDef[kdotk][grC_root] := kdotk_:
grG_ObjDef[kdotk][grC_rootStr] := `kdotk `:
grG_ObjDef[kdotk][grC_indexList] := []:
grG_ObjDef[kdotk][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[kdotk][grC_calcFn] := grF_calc_sum2:
# Take first basis vector in es(dbn,up)
grG_ObjDef[kdotk][grC_calcFnParms] :=
   gr_data[gdndn_,grG_metricName, s1_, s2_]* 
   gr_data[kup_,grG_metricName, s1_]*
   gr_data[kup_,grG_metricName, s2_]:
grG_ObjDef[kdotk][grC_depends] := {k(up)}:

#----------------------------
# kdotN
# - defined for null shells only
#----------------------------
grG_ObjDef[kdotN][grC_header] := `k{^a} N{a}`:
grG_ObjDef[kdotN][grC_root] := kdotN_:
grG_ObjDef[kdotN][grC_rootStr] := `kdotN `:
grG_ObjDef[kdotN][grC_indexList] := []:
grG_ObjDef[kdotN][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[kdotN][grC_calcFn] := grF_calc_sum1:
# Take first basis vector in es(dbn,up)
grG_ObjDef[kdotN][grC_calcFnParms] :=
   gr_data[kup_,grG_metricName, s1_]*
   gr_data[Ndn_,grG_metricName, s1_]:
grG_ObjDef[kdotN][grC_depends] := {k(up), N(dn)}:

#----------------------------
# Do we need this?
# null_param
# assigned in hypersurf()
# Also specified in xup_[1] for the null surface
#----------------------------
grG_ObjDef[null_param][grC_header] := `Null parameter on Surface`:
grG_ObjDef[null_param][grC_root] := null_param_:
grG_ObjDef[null_param][grC_rootStr] := `Null Parameter `:
grG_ObjDef[null_param][grC_indexList] := []:
grG_ObjDef[null_param][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[null_param][grC_depends] := {}: # dependencies calculated explicitly in junction()

#----------------------------
# mu_null
# - defined for null shells only
#----------------------------
grG_ObjDef[mu_null][grC_header] := `Null mass density`:
grG_ObjDef[mu_null][grC_root] := mu_null_:
grG_ObjDef[mu_null][grC_rootStr] := `mu (null) `:
grG_ObjDef[mu_null][grC_indexList] := []:
grG_ObjDef[mu_null][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[mu_null][grC_preCalcFn] := grF_calc_mu_null:
grG_ObjDef[mu_null][grC_depends] := {Jump[C(dn,dn)],sigma(up,up)}:

grF_calc_mu_null := proc(object)
  global gr_data, Ndim, grG_metricName;
  local s, a, b:

  s := 0;
  for a from 2 to 3 do
     for b from 2 to 3 do 
        s := s + gr_data[sigmaupup_, grG_metricName, a, b] * 
        	gr_data[Jump_,grG_metricName,C(dn,dn),gr_data[join_,gname],a,b]:
     od:
  od:
  gr_data[mu_null_, grG_metricName] := -1/(8*pi)*s:
end proc:


#----------------------------
# N(dn)
# This object is assigned by surf or
# calculated by lowering N(up)
#----------------------------
grG_ObjDef[N(dn)][grC_header] := `Transverse Vector`:
grG_ObjDef[N(dn)][grC_root] := Ndn_:
grG_ObjDef[N(dn)][grC_rootStr] := `N `:
grG_ObjDef[N(dn)][grC_indexList] := [dn]:
grG_ObjDef[N(dn)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[N(dn)][grC_calcFnParms] :=
   'gr_data[gdndn_,grG_metricName, a1_, s1_] * gr_data[Nup_,grG_metricName, s1_]':
grG_ObjDef[N(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[N(dn)][grC_depends] := {}:

#----------------------------
# N(up)
# This object is assigned by surf or
# calculated by raising N(dn)
#----------------------------
grG_ObjDef[N(up)][grC_header] := `Transverse Vector`:
grG_ObjDef[N(up)][grC_root] := Nup_:
grG_ObjDef[N(up)][grC_rootStr] := `N `:
grG_ObjDef[N(up)][grC_indexList] := [up]:
grG_ObjDef[N(up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[N(up)][grC_calcFnParms] :=
   'gr_data[gupup_,grG_metricName, a1_, s1_] * gr_data[Ndn_,grG_metricName, s1_]':
grG_ObjDef[N(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[N(up)][grC_depends] := {}:

#----------------------------
# NdotN
# - defined for null shells only
#----------------------------
grG_ObjDef[NdotN][grC_header] := `N{^a} N{a}`:
grG_ObjDef[NdotN][grC_root] := NdotN_:
grG_ObjDef[NdotN][grC_rootStr] := `NdotN `:
grG_ObjDef[NdotN][grC_indexList] := []:
grG_ObjDef[NdotN][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NdotN][grC_calcFn] := grF_calc_sum1:
# Take first basis vector in es(dbn,up)
grG_ObjDef[NdotN][grC_calcFnParms] :=
   gr_data[Nup_,grG_metricName, s1_]*
   gr_data[Ndn_,grG_metricName, s1_]:
grG_ObjDef[NdotN][grC_depends] := {N(up), N(dn), g(up,up)}:

#----------------------------
# p_null
# - defined for null shells only
#----------------------------
grG_ObjDef[p_null][grC_header] := `Null mass density`:
grG_ObjDef[p_null][grC_root] := p_null_:
grG_ObjDef[p_null][grC_rootStr] := `p null `:
grG_ObjDef[p_null][grC_indexList] := []:
grG_ObjDef[p_null][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[p_null][grC_preCalcFn] := grF_calc_p_null:
grG_ObjDef[p_null][grC_depends] := {Jump[C(dn,dn)]}:

grF_calc_p_null := proc(object)
  global gr_data, Ndim, grG_metricName;

  # lambda, lambda component of the jump
  gr_data[p_null_, grG_metricName] := -1/(8*pi)*
  	    gr_data[Jump_,grG_metricName,C(dn,dn),gr_data[join_,gname],1,1]:

end proc:

#----------------------------
# sigma(dn,dn)
# 2-metric of null surface
#----------------------------
grG_ObjDef[sigma(dn,dn)][grC_header] := `Metric of null surface`:
grG_ObjDef[sigma(dn,dn)][grC_root] := sigmadndn_:
grG_ObjDef[sigma(dn,dn)][grC_rootStr] := `sigma `:
grG_ObjDef[sigma(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[sigma(dn,dn)][grC_calcFn] := grF_calc_sigmadndn:
grG_ObjDef[sigma(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[sigma(dn,dn)][grC_depends] := {}:

grF_calc_sigmadndn := proc(object, iList)
  global gr_data, Ndim, grG_metricName;
  local s, basis_root:

   pname := gr_data[partner_,gname]:
   s := 0; 
   basis_root := [kup_, eAup_, eBup_]:
   for a to Ndim[pname] do
      for b to Ndim[pname] do
         s := s + gr_data[gdndn_, pname, a, b] *
         	gr_data[basis_root[a1_], pname, a] *
         	gr_data[basis_root[a2_], pname, b]:
      od:
   od:

   juncF_project( grG_simpHow( grG_preSeq, s, grG_postSeq), pname, gname);
   RETURN(s):

end proc:

#----------------------------
# sigma(up,up)
# 2-metric of null surface
#----------------------------
grG_ObjDef[sigma(up,up)][grC_header] := `Metric of null surface`:
grG_ObjDef[sigma(up,up)][grC_root] := sigmaupup_:
grG_ObjDef[sigma(up,up)][grC_rootStr] := `sigma `:
grG_ObjDef[sigma(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[sigma(up,up)][grC_preCalcFn] := grF_precalc_sigmaupup:
grG_ObjDef[sigma(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[sigma(up,up)][grC_depends] := {sigma(dn,dn)}:

grF_precalc_sigmaupup := proc(object)
  global gr_data, Ndim, grG_metricName;
  local s, twoD, twoDinv, i, j, a, b:

   # Take the 2x2 matrix from row/col 2 & 3 and invert
  twoD := array(1 .. 2,1 .. 2):
  for i from 2 to 3 do
	for j from 2 to 3 do
	  twoD[i-1,j-1] := gr_data[sigmadndn_,grG_metricName,i,j]:
	od:
  od:
  twoDinv := array(1 .. 2,1 .. 2):
  twoDinv := linalg[inverse](twoD):

   for a to Ndim[gname] do
      for b to Ndim[gname] do
         gr_data[sigmaupup_, grG_metricName, a, b] := 0:
      od:
   od:

   for i from 2 to 3 do
	 for j from 2 to 3 do
        gr_data[sigmaupup_, grG_metricName, i, j] := twoDinv[i-1, j-1]:
	 od:
   od:

end proc:


$undef gname

