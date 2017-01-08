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
grG_ObjDef[C(dn,dn)][grC_depends] := {N[gr_data[partner_,grG_metricName]](dn), 
			es[gr_data[partner_,grG_metricName]](bdn,up,cdn)}:

grF_calc_Cnull := proc(object, iList)
local s, a, b, c, s1, pname:
global gr_data, Ndim, grG_metricName:

 printf("Cnull a1_=%d a2_=%d\n", a1_, a2_);

 pname := gr_data[partner_,gname]:
 s := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
       s := s + gr_data[Ndn_,pname,a] *
		  gr_data[esbdnupcdn_,pname,a1_, a, b] *
		  gr_data[esbdnup_,pname, a2_, b ];
   od:
 od:

 juncF_project( -s,pname,gname);

end:

#----------------------------
# es(bdn,up)
# This object (in M) describes the basis vectors of the surface. 
# It will only have 3 bdn index values (with the fourth set to
# zero)
#
# The first vector is aliased to k{^a}
# 2 & 3 are the e{^a (2)} and e{^a (3)}
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

  RETURN(a);

end:

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
  RETURN(s):
end proc:

#----------------------------
# k(up)
# - defined for null shells only
# - calculation is side-effect of es(bdn,up)
#----------------------------
grG_ObjDef[k(up)][grC_header] := `Null vector on Surface`:
grG_ObjDef[k(up)][grC_root] := kup_:
grG_ObjDef[k(up)][grC_rootStr] := `k `:
grG_ObjDef[k(up)][grC_indexList] := [up]:
grG_ObjDef[k(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[k(up)][grC_calcFn] := grF_calc_sum0:
# Take first basis vector in es(dbn,up)
grG_ObjDef[k(up)][grC_calcFnParms] :=
   'gr_data[esbdnup_,grG_metricName, 1, a1_]':
grG_ObjDef[k(up)][grC_depends] := {es(bdn,up)}:


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
        s := gr_data[sigmaupup_, grG_metricName, a, b] * 
        	gr_data[Jump_,grG_metricName,C(dn,dn),gr_data[join_,gname],a,b]:
     od:
  od:
  gr_data[mu_null_, grG_metricName] := s:
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
  gr_data[p_null_, grG_metricName] := 
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
  local s:

   pname := gr_data[partner_,gname]:
   s := 0; 
   # first es vector is k{^a} - skip?
   # (could make 3x3 and have 2x2 sub-valid?)
   for a to Ndim[pname] do
      for b to Ndim[pname] do
         s := s + gr_data[gdndn_, pname, a, b] *
         	gr_data[esbdnup_, pname, a1_, a] *
         	gr_data[esbdnup_, pname, a2_, b]:
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

