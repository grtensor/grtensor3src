#////////////////////////////////////////////////////////
#
# nullObjects.mpl
#
# Objects defintions for null shells.
#
# Apr 13, 96   Created [pm]
# May 16, 96   Added l(up) [pm]
# June 4, 96   Added N(bdn), gtest(dn,up) [pm]
#
#////////////////////////////////////////////////////////

$define gname grG_metricName
#----------------------------
# es(bdn,up)
# This object (in M) describes the basis
# vectors of the surface. It should have only
# 3 bdn index values but has to have 4 to keep
# GRT happy (since we always assume the dimension
# of each index is the same). Hence we set the
# fourth basis component to zero.
#
# The first vector is aliased to k{^a}
# 2 & 3 are the e{^a (2)} and e{^a (3)}
#----------------------------
grG_ObjDef[es(bdn,up)][grC_header] := `Basis vector`:
grG_ObjDef[es(bdn,up)][grC_root] := esbdnup_:
grG_ObjDef[es(bdn,up)][grC_rootStr] := `e `:
grG_ObjDef[es(bdn,up)][grC_indexList] := [bdn,up]:
grG_ObjDef[es(bdn,up)][grC_calcFn] := grF_calc_eupbdn_:
grG_ObjDef[es(bdn,up)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[es(bdn,up)][grC_depends] := {}:

grF_calc_eupbdn_ := proc(object, iList)
global Ndim, grG_metricName, gr_data;
local a, sname;

  sname := gr_data[partner_,gname]: # get the name of the surface
  if a1_ < Ndim[gname] then
     a := diff( gr_data[xformup_,gname, a2_], gr_data[xup_,sname, a1_] );
  else
     a := 0;
  fi;

  RETURN(a);

end:

#----------------------------
# l(up)
# This object is assigned by surf or
# calculated by raising l(dn)
#----------------------------
grG_ObjDef[l(up)][grC_header] := `Null generator`:
grG_ObjDef[l(up)][grC_root] := lup_:
grG_ObjDef[l(up)][grC_rootStr] := `l `:
grG_ObjDef[l(up)][grC_indexList] := [up]:
grG_ObjDef[l(up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[l(up)][grC_calcFnParms] :=
   'gr_data[gupup_,grG_metricName, a1_, s1_] * gr_data[ldn_,grG_metricName, s1_]':
grG_ObjDef[l(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[l(up)][grC_depends] := {}:

#----------------------------
# l(dn)
# This object is assigned by surf or
# calculated by lowering l(up)
#----------------------------
grG_ObjDef[l(dn)][grC_header] := `Null generator`:
grG_ObjDef[l(dn)][grC_root] := ldn_:
grG_ObjDef[l(dn)][grC_rootStr] := `l `:
grG_ObjDef[l(dn)][grC_indexList] := [dn]:
grG_ObjDef[l(dn)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[l(dn)][grC_calcFnParms] :=
   'gr_data[gdndn_,grG_metricName, a1_, s1_] * gr_data[lup_,grG_metricName, s1_]':
grG_ObjDef[l(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[l(dn)][grC_depends] := {}:

#----------------------------
# gamma4(dn,dn)
#
# project up Jump[ nullK(up,up)] using basis vectors
#
# MUST first project nullK(dn,dn) and then raise
# indices since raising is not well defined in degenerate
# three-space
#
#----------------------------
grG_ObjDef[gamma4(dn,dn)][grC_header] := `Jump[ nullK] projected up`:
grG_ObjDef[gamma4(dn,dn)][grC_root] := gamma4dndn_:
grG_ObjDef[gamma4(dn,dn)][grC_rootStr] := `gamma4 `:
grG_ObjDef[gamma4(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[gamma4(dn,dn)][grC_calcFn] := grF_enterComp:
grG_ObjDef[gamma4(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[gamma4(dn,dn)][grC_depends] := { }:



#----------------------------
# gamma4n(up)
#
#----------------------------
grG_ObjDef[gamma4n(up)][grC_header] := `gamma4{^a ^b} n{b}`:
grG_ObjDef[gamma4n(up)][grC_root] := gamma4nup_:
grG_ObjDef[gamma4n(up)][grC_rootStr] := `gamma4n `:
grG_ObjDef[gamma4n(up)][grC_indexList] := [up]:
grG_ObjDef[gamma4n(up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[gamma4n(up)][grC_calcFnParms] :=
 'gr_data[gamma4upup_,grG_metricName, a1_, s1_] * gr_data[ndn_,grG_metricName,s1_]':
grG_ObjDef[gamma4n(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[gamma4n(up)][grC_depends] := { n(dn), gamma4(up,up) }:

#----------------------------
# gamma4nn
#
#----------------------------
grG_ObjDef[gamma4nn][grC_header] := `gamma4{^a ^b} n{a} n{b}`:
grG_ObjDef[gamma4nn][grC_root] := gamma4nn_:
grG_ObjDef[gamma4nn][grC_rootStr] := `gamma4nn `:
grG_ObjDef[gamma4nn][grC_indexList] := []:
grG_ObjDef[gamma4nn][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[gamma4nn][grC_calcFnParms] :=
 'gr_data[gamma4nup_,grG_metricName,s1_]*gr_data[ndn_,grG_metricName,s1_]':
grG_ObjDef[gamma4nn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[gamma4nn][grC_depends] := { n(dn), gamma4n(up) }:

#----------------------------
# gamma4tr
#
#----------------------------
grG_ObjDef[gamma4tr][grC_header] := `gamma4{^a ^b} g{a b}`:
grG_ObjDef[gamma4tr][grC_root] := gamma4tr_:
grG_ObjDef[gamma4tr][grC_rootStr] := `gamma4tr `:
grG_ObjDef[gamma4tr][grC_indexList] := []:
grG_ObjDef[gamma4tr][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[gamma4tr][grC_calcFnParms] :=
'gr_data[gamma4upup_,grG_metricName,s1_,s2_]*gr_data[gdndn_,grG_metricName,s1_,s2_]':
grG_ObjDef[gamma4tr][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[gamma4tr][grC_depends] := { gamma4(up,up) }:

#----------------------------
# gammaTest(dn,dn)
#----------------------------
grG_ObjDef[gammaTest(dn,dn)][grC_header] := `gamma4{a b} e{^a (i)} e{^b (j)} - 2 [ nullK{i j} ]`:
grG_ObjDef[gammaTest(dn,dn)][grC_root] := gammaTestdndn_:
grG_ObjDef[gammaTest(dn,dn)][grC_rootStr] := `gammaTest `:
grG_ObjDef[gammaTest(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[gammaTest(dn,dn)][grC_calcFn] := grF_calc_gammaTest:
grG_ObjDef[gammaTest(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[gammaTest(dn,dn)][grC_depends] := {Jump[nullK(dn,dn),grG_join_[gname] ],
                    nullS4[gr_data[partner_,gname]](dn,dn) };

grF_calc_gammaTest := proc(object, iList)
global Ndim, grG_metricName, gr_data;

local c,d, s, pname:

   pname := gr_data[partner_,gname]:

   s := 0:
   for c to Ndim[gname] do
     for d to Ndim[gname] do
       s := s + gr_data[nullS4dndn_, pname, c, d] *
            diff( gr_data[xformup_,pname, c], gr_data[xup_,gname, a1_] ) *
            diff( gr_data[xformup_,pname, d], gr_data[xup_,gname, a2_] );
     od:
   od:
   s := s - 2 * gr_data[Jump_,gname,nullK(dn,dn),gr_data[join_,gname],a1_,a2_]:

   RETURN(s );

end:

#----------------------------
# nullgx(up,up)
#
# Allow user to enter g(up,up) explicitly
# (appalling kludge)
#
# this should really be multiple def'd as another form of nullg
#----------------------------
grG_ObjDef[nullgx(up,up)][grC_header] := `alias for g(up,up)`:
grG_ObjDef[nullgx(up,up)][grC_root] := gupup_:
grG_ObjDef[nullgx(up,up)][grC_rootStr] := `g `:
grG_ObjDef[nullgx(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[nullgx(up,up)][grC_calcFn] := grF_calc_nullgx:
grG_ObjDef[nullgx(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullgx(up,up)][grC_depends] := {}:

# explicit caqlc routine since we need to assign to gupup_

grF_calc_nullgx := proc(object, iList)

  global Ndim, grG_metricName, gr_data;
  local a,b,s;

  global grG_gupup_;

  gr_data[gupup_,grG_metricName, 0,0] := true:

  a := iList[1]:
  b := iList[2]:
  s := grF_input(`Enter g`.a.b.` > `, 0, `Null G`):

  RETURN(s);

end:


#----------------------------
# nullg(up,up)
#
# this should really be multiple def'd
#----------------------------
grG_ObjDef[nullg(up,up)][grC_header] := `alias for g(up,up)`:
grG_ObjDef[nullg(up,up)][grC_root] := gupup_:
grG_ObjDef[nullg(up,up)][grC_rootStr] := `g `:
grG_ObjDef[nullg(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[nullg(up,up)][grC_preCalcFn] := grF_calc_nullg:
grG_ObjDef[nullg(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullg(up,up)][grC_depends] := {}:

grF_calc_nullg := proc( object, iList)

 global Ndim, grG_metricName, gr_data;
 local nullg,  # null generator coordinate number
       gdnarray, # array for the covariant 2 metric
       guparray, # array for the contra 2 metric
       ivalue,   # init values for array
       s, 	 # some sequence
       metricName,
       a,b:

 global grG_gupup_:

   #
   # get the coordinate number of the null generator
   #
   nullg := NULL:
   for a to 3 do
     if gr_data[xup_,grG_metricName, a] =
        gr_data[totalVar_,gr_data[partner_,grG_metricName] ] then
           nullg := a:
           break:
     fi:
   od:
   if nullg = NULL then
     ERROR(`Could not find null generator coord`);
   fi:

   #
   # copy metric into 2 x 2 array
   #
   ivalue := [];
   for a to 3 do
     s := NULL:
     for b to 3 do
       if not (a = nullg or b = nullg) then
         s := s, gr_data[gdndn_,grG_metricName, a, b]:
       fi:
     od:
     if s <> NULL then
       ivalue := [ op(ivalue), [s] ];
     fi:
   od:

   gdnarray := array(1..2, 1..2, ivalue):
   guparray := linalg[inverse](gdnarray):

   #
   # copy into 3 x 3 array with zeros bordering
   #
   for a to 3 do
      for b to 3 do
         gr_data[gupup_,grG_metricName, a, b] := 0:
      od:
   od:
   # Brute force
   metricName := grG_metricName:

   if nullg = 1 then
      gr_data[gupup_,metricName, 2,2] := guparray[1,1]:
      gr_data[gupup_,metricName, 2,3] := guparray[1,2]:
      gr_data[gupup_,metricName, 3,2] := guparray[2,1]:
      gr_data[gupup_,metricName, 3,3] := guparray[2,2]:
   elif nullg = 2 then
      gr_data[gupup_,metricName, 1,1] := guparray[1,1]:
      gr_data[gupup_,metricName, 1,3] := guparray[1,2]:
      gr_data[gupup_,metricName, 3,1] := guparray[2,1]:
      gr_data[gupup_,metricName, 3,3] := guparray[2,2]:

   else
      gr_data[gupup_,metricName, 1,1] := guparray[1,1]:
      gr_data[gupup_,metricName, 1,2] := guparray[1,2]:
      gr_data[gupup_,metricName, 2,1] := guparray[2,1]:
      gr_data[gupup_,metricName, 2,2] := guparray[2,2]:

   fi:

   gr_data[gupup_,metricName, 0, 0] := true:

end:

#----------------------------
# gtest(dn,up)
#
#----------------------------
grG_ObjDef[gtest(dn,up)][grC_header] := `g{a c} g{^b ^c} - ( kdelta{a ^b} - l{^b} N{(a)})`:
grG_ObjDef[gtest(dn,up)][grC_root] := gtestdnup_:
grG_ObjDef[gtest(dn,up)][grC_rootStr] := `gtest `:
grG_ObjDef[gtest(dn,up)][grC_indexList] := [dn,up]:
grG_ObjDef[gtest(dn,up)][grC_calcFn] := grF_calc_gtest:
grG_ObjDef[gtest(dn,up)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[gtest(dn,up)][grC_depends] := {N(bdn),l(up), Ndotn[grG_partner_[gname]]}:

grF_calc_gtest := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local r, l, a;

  r := 0;
  l := 0;
  if a1_ = a2_ then
     l := 1;
  fi:
  l := l - gr_data[lup_,gname,a2_] *gr_data[Nbdn_,gname,a1_]/
       gr_data[Ndotn_, gr_data[partner_,gname]] ;
  for a to Ndim[gname] do
     r := r + gr_data[gdndn_,gname,a1_,a] * gr_data[gupup_,gname, a2_, a];
  od;

  RETURN(r-l);

end:

#----------------------------
# k(up)
# - defined for null shells only
#----------------------------
grG_ObjDef[k(up)][grC_header] := `Null vector on Surface`:
grG_ObjDef[k(up)][grC_root] := kup_:
grG_ObjDef[k(up)][grC_rootStr] := `k `:
grG_ObjDef[k(up)][grC_indexList] := [up]:
grG_ObjDef[k(up)][grC_preCalcFn] := grF_calc_kup: # preCalc since we need to normalize
grG_ObjDef[k(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[k(up)][grC_depends] := {xform(up)}:

grF_calc_kup := proc(object)

  global gr_data, grG_metricName, Ndim;

  for i to Ndim[grG_metricName] do
    gr_data[kup_, grG_metricName, i] := diff( gr_data[xformup_, grG_metricName], gr_data[null_param_, grG_metricName])
  od:
end proc:

#----------------------------
# nullK(dn,dn)
#----------------------------
grG_ObjDef[nullK(dn,dn)][grC_header] := `Extrinsic Curvature (for null shell)`:
grG_ObjDef[nullK(dn,dn)][grC_root] := nullKdndn_:
grG_ObjDef[nullK(dn,dn)][grC_rootStr] := `K `:
grG_ObjDef[nullK(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[nullK(dn,dn)][grC_calcFn] := grF_calc_nullff2:
grG_ObjDef[nullK(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullK(dn,dn)][grC_depends] := {N[grG_partner_[grG_metricName]](dn),
		Chr[gr_data[partner_,grG_metricName]](dn,dn,up)}:


grF_calc_nullff2 := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local s, a, b, c, s1, pname:

 pname := gr_data[partner_,gname]:
 s := 0:
 s1 := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s1 := s1 + gr_data[Ndn_,pname,a] *
		  diff(gr_data[xformup_,pname,b],gr_data[xup_,gname,a1_]) *
		  diff(gr_data[xformup_,pname,c],gr_data[xup_,gname,a2_]) *
		  gr_data[Chrdndnup_,pname,b,c,a];
     od:
   od:
   s := s + gr_data[Ndn_,pname,a] *
	    diff(diff(gr_data[xformup_,pname,a],gr_data[xup_,gname,a1_]),
		gr_data[xup_,gname,a2_]);
 od:

 unleash( -s-s1,pname,gname,false);

end:

#----------------------------
# null_param
# assigned in hypersurf()
#----------------------------
grG_ObjDef[null_param][grC_header] := `Null parameter on Surface`:
grG_ObjDef[null_param][grC_root] := null_param_:
grG_ObjDef[null_param][grC_rootStr] := `Null Parameter `:
grG_ObjDef[null_param][grC_indexList] := []:
grG_ObjDef[null_param][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[null_param][grC_depends] := {}: # dependencies calculated explicitly in junction()


#----------------------------
# nullGamma(dn)
#
# BI equation (25)
#----------------------------
grG_ObjDef[nullGamma(dn)][grC_header] := `Null formalism Gamma`:
grG_ObjDef[nullGamma(dn)][grC_root] := nullGammadn_:
grG_ObjDef[nullGamma(dn)][grC_rootStr] := `nullGamma `:
grG_ObjDef[nullGamma(dn)][grC_indexList] := [dn]:
grG_ObjDef[nullGamma(dn)][grC_calcFn] := grF_calc_nullGamma:
grG_ObjDef[nullGamma(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[nullGamma(dn)][grC_depends] := {nullalpha}:

grF_calc_nullGamma := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local alpha, b, s, pname:

  alpha := gr_data[nullalpha_,gname]:
  pname := gr_data[partner_,gname]:

  # take the divergence of alpha * e^\alpha_{(a)}

end:


#----------------------------
# nullS3(up,up)
#----------------------------
grG_ObjDef[nullS3(up,up)][grC_header] := `Intrinsic stress-energy`:
grG_ObjDef[nullS3(up,up)][grC_root] := nullS3upup_:
grG_ObjDef[nullS3(up,up)][grC_rootStr] := `nullS3 `:
grG_ObjDef[nullS3(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[nullS3(up,up)][grC_calcFn] := grF_calc_nullS3:
grG_ObjDef[nullS3(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullS3(up,up)][grC_depends] := {Jump[nullK(dn,dn),grG_join_[gname] ],
                    ndotn[gr_data[partner_,gname]], Ndotn[gr_data[partner_,gname]]}:

grF_calc_nullS3 := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local c,d, s:

   s := 0:
   for c to 3 do
     for d to 3 do
       s := s +
       (gr_data[gupup_,gname, a1_, c] * gr_data[lup_,gname, a2_] * gr_data[lup_,gname, d] +
        gr_data[gupup_,gname, a2_, d] * gr_data[lup_,gname, a1_] * gr_data[lup_,gname, c] -
        gr_data[gupup_,gname, a1_,a2_ ] * gr_data[lup_,gname, c] * gr_data[lup_,gname, d] -
        gr_data[gupup_,gname,  c,d] * gr_data[lup_,gname, a1_] * gr_data[lup_,gname, a2_] -
       gr_data[ndotn_,gr_data[partner_,gname]] *
         ( gr_data[gupup_,gname, a1_,c] * gr_data[gupup_,gname,a2_,d] -
           gr_data[gupup_,gname, a1_,a2_] * gr_data[gupup_,gname,c,d] )
       ) * 2 *gr_data[Jump_,gname,nullK(dn,dn),gr_data[join_,gname],c,d]:
     od:
   od:

   RETURN(s/16/Pi/gr_data[Ndotn_,gr_data[partner_,gname]] );

end:

#----------------------------
# nullS4a(up,up)
#
# project up nullS3(up,up) using basis vectors
#
#  S{^alpha ^beta} = S3{^a ^b} e{^alpha (a)} e{^beta (b)}
#
#----------------------------
grG_ObjDef[nullS4a(up,up)][grC_header] := `Extrinsic stress-energy`:
grG_ObjDef[nullS4a(up,up)][grC_root] := nullS4aupup_:
grG_ObjDef[nullS4a(up,up)][grC_rootStr] := `nullS4a `:
grG_ObjDef[nullS4a(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[nullS4a(up,up)][grC_calcFn] := grF_calc_nullS4a:
grG_ObjDef[nullS4a(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullS4a(up,up)][grC_depends] := { nullS3[ grG_partner_[gname]](up,up)}:


grF_calc_nullS4a := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local s, a, b, pname:

   pname := gr_data[partner_,gname]:
   s := 0;

   for a to Ndim[gname] - 1 do
     for b to Ndim[gname] - 1 do
       s := s + gr_data[nullS3upup_,pname, a, b] *
            diff( gr_data[xformup_,gname, a1_], gr_data[xup_, pname, a]) *
            diff( gr_data[xformup_,gname, a2_], gr_data[xup_, pname, b]);
     od:
   od:
   RETURN(s):

end:


#----------------------------
# nullS4(up,up)
#
# project up gamma then use (17)
#----------------------------
grG_ObjDef[nullS4(up,up)][grC_header] := `Extrinsic stress-energy`:
grG_ObjDef[nullS4(up,up)][grC_root] := nullS4upup_:
grG_ObjDef[nullS4(up,up)][grC_rootStr] := `nullS4 `:
grG_ObjDef[nullS4(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[nullS4(up,up)][grC_calcFn] := grF_calc_nullS4:
grG_ObjDef[nullS4(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[nullS4(up,up)][grC_depends] := { n(up), g(up,up), Ndotn,
                     gamma4(up,up), gamma4n(up), gamma4nn, gamma4tr}:

grF_calc_nullS4 := proc(object, iList)

global Ndim, grG_metricName, gr_data;
local s, a, b;

  s :=   gr_data[gamma4nup_,gname, a1_] * gr_data[nup_,gname, a2_]
       + gr_data[gamma4nup_,gname, a2_] * gr_data[nup_,gname, a1_]
       - gr_data[gamma4tr_,gname] * gr_data[nup_,gname, a1_] * gr_data[nup_,gname, a2_]
       - gr_data[gamma4nn_,gname] * gr_data[gupup_,gname, a1_, a2_]:

 RETURN(s* gr_data[Ndotn_,gname]/16/pi):

 end:

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
# n(bdn)
#
# (in the 3-space)
#----------------------------
grG_ObjDef[n(bdn)][grC_header] := `n{b} e(a)^b`:
grG_ObjDef[n(bdn)][grC_root] := nbdn_:
grG_ObjDef[n(bdn)][grC_rootStr] := `nbdn `:
grG_ObjDef[n(bdn)][grC_indexList] := [bdn]:
grG_ObjDef[n(bdn)][grC_calcFn] := grF_calc_ndote :
grG_ObjDef[n(bdn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[n(bdn)][grC_depends] := {n[grG_partner_[grG_metricName]](dn)}:

grF_calc_ndote := proc(object, iList)
local pname, s, a;

  s := 0;
  pname := gr_data[partner_,gname];
  for a to Ndim[gname]+1 do
     s := s + diff( gr_data[xformup_,pname, a], gr_data[xup_,gname, a1_]) *
          gr_data[ndn_,pname, a];
  od;

  juncF_project( s, pname, gname);

end:

#----------------------------
# N(bdn)
#
# (in the 3-space)
#----------------------------
grG_ObjDef[N(bdn)][grC_header] := `N{b} e(a)^b`:
grG_ObjDef[N(bdn)][grC_root] := Nbdn_:
grG_ObjDef[N(bdn)][grC_rootStr] := `Nbdn `:
grG_ObjDef[N(bdn)][grC_indexList] := [bdn]:
grG_ObjDef[N(bdn)][grC_calcFn] := grF_calc_Ndote :
grG_ObjDef[N(bdn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[N(bdn)][grC_depends] := {N[grG_partner_[grG_metricName]](dn)}:

grF_calc_Ndote := proc(object, iList)
local pname, s, a;

global Ndim, grG_metricName, gr_data;
  s := 0;
  pname := gr_data[partner_,gname];
  for a to Ndim[gname]+1 do
     s := s + diff( gr_data[xformup_,pname, a], gr_data[xup_,gname, a1_]) *
          gr_data[Ndn_,pname, a];
  od;

  juncF_project( s, pname, gname);

end:

#----------------------------
# ndotn
#
# (in the 4-space)
#----------------------------
grG_ObjDef[ndotn][grC_header] := `n{a} n{^a}`:
grG_ObjDef[ndotn][grC_root] := ndotn_:
grG_ObjDef[ndotn][grC_rootStr] := `ndotn `:
grG_ObjDef[ndotn][grC_indexList] := []:
grG_ObjDef[ndotn][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[ndotn][grC_calcFnParms] :=
   'gr_data[ndn_,grG_metricName,s1_]*gr_data[nup_,grG_metricName, s1_]':
grG_ObjDef[ndotn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[ndotn][grC_depends] := {n(dn),n(up)}:

#----------------------------
# Ndotn
#
# (in the 4-space)
#----------------------------
grG_ObjDef[Ndotn][grC_header] := `n{a} N{^a}`:
grG_ObjDef[Ndotn][grC_root] := Ndotn_:
grG_ObjDef[Ndotn][grC_rootStr] := `Ndotn `:
grG_ObjDef[Ndotn][grC_indexList] := []:
grG_ObjDef[Ndotn][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[Ndotn][grC_calcFnParms] :=
   'gr_data[ndn_,grG_metricName,s1_]*gr_data[Nup_,grG_metricName, s1_]':
grG_ObjDef[Ndotn][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ndotn][grC_depends] := {n(dn),N(up)}:

#----------------------------
# NdotN
#
# (in the 4-space)
#----------------------------
grG_ObjDef[NdotN][grC_header] := `N{a} N{^a}`:
grG_ObjDef[NdotN][grC_root] := NdotN_:
grG_ObjDef[NdotN][grC_rootStr] := `NdotN `:
grG_ObjDef[NdotN][grC_indexList] := []:
grG_ObjDef[NdotN][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[NdotN][grC_calcFnParms] :=
   'gr_data[Ndn_,grG_metricName,s1_]*gr_data[Nup_,grG_metricName, s1_]':
grG_ObjDef[NdotN][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NdotN][grC_depends] := {N(dn),N(up)}:

#----------------------------
# projS4(up,up)
#----------------------------
grG_ObjDef[projS4(up,up)][grC_header] := `Intrinsic stress-energy`:
grG_ObjDef[projS4(up,up)][grC_root] := projS4upup_:
grG_ObjDef[projS4(up,up)][grC_rootStr] := `projS4 `:
grG_ObjDef[projS4(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[projS4(up,up)][grC_calcFn] := grF_projS4:
grG_ObjDef[projS4(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[projS4(up,up)][grC_depends] := { nullS4[ grG_partner_[grG_metricName]](up,up)}:


grF_projS4 := proc(object, iList)

local b,c,s, pname:

   pname := gr_data[partner_,gname]:

   s := 0;
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s := s + gr_data[nullS4upup_, pname, b, c] *
		  diff(gr_data[xformup_,pname,b],gr_data[xup_,gname,a1_]) *
		  diff(gr_data[xformup_,pname,c],gr_data[xup_,gname,a2_]);
     od:
   od:

   unleash( s,pname,gname,false);

end:

$undef gname

