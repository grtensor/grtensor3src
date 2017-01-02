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

macro(gname = grG_metricName);

#----------------------------
# es(bdn,up)
# This object (in M) describes the basis
# vectors of the surface. It should have only
# 3 bdn index values but has to have 4 to keep
# GRT happy (since we always assume the dimension
# of each index is the same). Hence we set the
# fourth basis component to zero. 
#----------------------------
macro( gr = grG_ObjDef[es(bdn,up)]):
gr[grC_header] := `Basis vector`:
gr[grC_root] := esbdnup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,up]:
gr[grC_calcFn] := grF_calc_eupbdn_:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := {}:

grF_calc_eupbdn_ := proc(object, iList)

local a, sname;

  sname := grG_partner_[gname]: # get the name of the surface
  if a1_ < Ndim[gname] then
     a := diff( grG_xformup_[gname, a2_], grG_xup_[sname, a1_] );
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
macro( gr = grG_ObjDef[l(up)]):
gr[grC_header] := `Null generator`:
gr[grC_root] := lup_:
gr[grC_rootStr] := `l `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] :=
   'grG_gupup_[grG_metricName, a1_, s1_] * grG_ldn_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#----------------------------
# l(dn)
# This object is assigned by surf or
# calculated by lowering l(up) 
#----------------------------
macro( gr = grG_ObjDef[l(dn)]):
gr[grC_header] := `Null generator`:
gr[grC_root] := ldn_:
gr[grC_rootStr] := `l `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] :=
   'grG_gdndn_[grG_metricName, a1_, s1_] * grG_lup_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

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
macro( gr = grG_ObjDef[gamma4(dn,dn)]):
gr[grC_header] := `Jump[ nullK] projected up`:
gr[grC_root] := gamma4dndn_:
gr[grC_rootStr] := `gamma4 `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_enterComp:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { }:



#----------------------------
# gamma4n(up)
#
#----------------------------
macro( gr = grG_ObjDef[gamma4n(up)]):
gr[grC_header] := `gamma4{^a ^b} n{b}`:
gr[grC_root] := gamma4nup_:
gr[grC_rootStr] := `gamma4n `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := 
 'grG_gamma4upup_[grG_metricName, a1_, s1_] * grG_ndn_[grG_metricName,s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := { n(dn), gamma4(up,up) }:

#----------------------------
# gamma4nn
#
#----------------------------
macro( gr = grG_ObjDef[gamma4nn]):
gr[grC_header] := `gamma4{^a ^b} n{a} n{b}`:
gr[grC_root] := gamma4nn_:
gr[grC_rootStr] := `gamma4nn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := 
 'grG_gamma4nup_[grG_metricName,s1_]*grG_ndn_[grG_metricName,s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { n(dn), gamma4n(up) }:

#----------------------------
# gamma4tr
#
#----------------------------
macro( gr = grG_ObjDef[gamma4tr]):
gr[grC_header] := `gamma4{^a ^b} g{a b}`:
gr[grC_root] := gamma4tr_:
gr[grC_rootStr] := `gamma4tr `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 
'grG_gamma4upup_[grG_metricName,s1_,s2_]*grG_gdndn_[grG_metricName,s1_,s2_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { gamma4(up,up) }:

#----------------------------
# gammaTest(dn,dn)
#----------------------------
macro( gr = grG_ObjDef[gammaTest(dn,dn)]):
gr[grC_header] := `gamma4{a b} e{^a (i)} e{^b (j)} - 2 [ nullK{i j} ]`:
gr[grC_root] := gammaTestdndn_:
gr[grC_rootStr] := `gammaTest `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_gammaTest:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {Jump[nullK(dn,dn),grG_join_[gname] ], 
                    nullS4[grG_partner_[gname]](dn,dn) };

grF_calc_gammaTest := proc(object, iList)

local c,d, s, pname:

   pname := grG_partner_[gname]:

   s := 0:
   for c to Ndim[gname] do 
     for d to Ndim[gname] do
       s := s + grG_nullS4dndn_[ pname, c, d] *
            diff( grG_xformup_[pname, c], grG_xup_[gname, a1_] ) *  
            diff( grG_xformup_[pname, d], grG_xup_[gname, a2_] );
     od:
   od:
   s := s - 2 * grG_Jump_[gname,nullK(dn,dn),grG_join_[gname],a1_,a2_]:

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
macro( gr = grG_ObjDef[nullgx(up,up)]):
gr[grC_header] := `alias for g(up,up)`:
gr[grC_root] := gupup_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_nullgx:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:

# explicit caqlc routine since we need to assign to gupup_

grF_calc_nullgx := proc(object, iList)

  local a,b,s;

  global grG_gupup_;

  grG_gupup_[grG_metricName, 0,0] := true:

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
macro( gr = grG_ObjDef[nullg(up,up)]):
gr[grC_header] := `alias for g(up,up)`:
gr[grC_root] := gupup_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [up,up]:
gr[grC_preCalcFn] := grF_calc_nullg:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:

grF_calc_nullg := proc( object, iList)

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
     if grG_xup_[grG_metricName, a] = 
        grG_totalVar_[grG_partner_[grG_metricName] ] then
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
         s := s, grG_gdndn_[grG_metricName, a, b]:
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
         grG_gupup_[grG_metricName, a, b] := 0:
      od:
   od:
   # Brute force
   metricName := grG_metricName:

   if nullg = 1 then 
      grG_gupup_[metricName, 2,2] := guparray[1,1]:
      grG_gupup_[metricName, 2,3] := guparray[1,2]:
      grG_gupup_[metricName, 3,2] := guparray[2,1]:
      grG_gupup_[metricName, 3,3] := guparray[2,2]:
   elif nullg = 2 then
      grG_gupup_[metricName, 1,1] := guparray[1,1]:
      grG_gupup_[metricName, 1,3] := guparray[1,2]:
      grG_gupup_[metricName, 3,1] := guparray[2,1]:
      grG_gupup_[metricName, 3,3] := guparray[2,2]:

   else
      grG_gupup_[metricName, 1,1] := guparray[1,1]:
      grG_gupup_[metricName, 1,2] := guparray[1,2]:
      grG_gupup_[metricName, 2,1] := guparray[2,1]:
      grG_gupup_[metricName, 2,2] := guparray[2,2]:

   fi:

   grG_gupup_[metricName, 0, 0] := true:

end:

#----------------------------
# gtest(dn,up)
#
#----------------------------
macro( gr = grG_ObjDef[gtest(dn,up)]):
gr[grC_header] := `g{a c} g{^b ^c} - ( kdelta{a ^b} - l{^b} N{(a)})`:
gr[grC_root] := gtestdnup_:
gr[grC_rootStr] := `gtest `:
gr[grC_indexList] := [dn,up]:
gr[grC_calcFn] := grF_calc_gtest:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := {N(bdn),l(up), Ndotn[grG_partner_[gname]]}:

grF_calc_gtest := proc(object, iList)

local r, l, a;

  r := 0;
  l := 0;
  if a1_ = a2_ then 
     l := 1;
  fi:
  l := l - grG_lup_[gname,a2_] *grG_Nbdn_[gname,a1_]/
       grG_Ndotn_[ grG_partner_[gname]] ;
  for a to Ndim[gname] do
     r := r + grG_gdndn_[gname,a1_,a] * grG_gupup_[gname, a2_, a];
  od;

  RETURN(r-l);

end:

#----------------------------
# nullK(dn,dn)
#----------------------------
macro( gr = grG_ObjDef[nullK(dn,dn)]):
gr[grC_header] := `Extrinsic Curvature (for null shell)`:
gr[grC_root] := nullKdndn_:
gr[grC_rootStr] := `K `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_nullff2:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {N[grG_partner_[grG_metricName]](dn),
		Chr[grG_partner_[grG_metricName]](dn,dn,up)}:


grF_calc_nullff2 := proc(object, iList)

local s, a, b, c, s1, pname:

 pname := grG_partner_[gname]:
 s := 0: 
 s1 := 0:
 for a to Ndim[gname]+1 do
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s1 := s1 + grG_Ndn_[pname,a] * 
		  diff(grG_xformup_[pname,b],grG_xup_[gname,a1_]) *
		  diff(grG_xformup_[pname,c],grG_xup_[gname,a2_]) *
		  grG_Chrdndnup_[pname,b,c,a];
     od:
   od:
   s := s + grG_Ndn_[pname,a] *
	    diff(diff(grG_xformup_[pname,a],grG_xup_[gname,a1_]),
		grG_xup_[gname,a2_]);
 od:

 unleash( -s-s1,pname,gname,false);

end:

#----------------------------
# nullGamma(dn)
#
# BI equation (25)
#----------------------------
macro( gr = grG_ObjDef[nullGamma(dn)]):
gr[grC_header] := `Null formalism Gamma`:
gr[grC_root] := nullGammadn_:
gr[grC_rootStr] := `nullGamma `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_nullGamma:
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {nullalpha}:

grF_calc_nullGamma := proc(object, iList)

local alpha, b, s, pname:

  alpha := grG_nullalpha_[gname]:
  pname := grG_partner_[gname]:

  # take the divergence of alpha * e^\alpha_{(a)}

end:


#----------------------------
# nullS3(up,up)
#----------------------------
macro( gr = grG_ObjDef[nullS3(up,up)]):
gr[grC_header] := `Intrinsic stress-energy`:
gr[grC_root] := nullS3upup_:
gr[grC_rootStr] := `nullS3 `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_nullS3:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {Jump[nullK(dn,dn),grG_join_[gname] ], 
                    ndotn[grG_partner_[gname]], Ndotn[grG_partner_[gname]]}:

grF_calc_nullS3 := proc(object, iList)

local c,d, s:

   s := 0:
   for c to 3 do 
     for d to 3 do
       s := s +
       (grG_gupup_[gname, a1_, c] * grG_lup_[gname, a2_] * grG_lup_[gname, d] +
        grG_gupup_[gname, a2_, d] * grG_lup_[gname, a1_] * grG_lup_[gname, c] -
        grG_gupup_[gname, a1_,a2_ ] * grG_lup_[gname, c] * grG_lup_[gname, d] -
        grG_gupup_[gname,  c,d] * grG_lup_[gname, a1_] * grG_lup_[gname, a2_] -
       grG_ndotn_[grG_partner_[gname]] *
         ( grG_gupup_[gname, a1_,c] * grG_gupup_[gname,a2_,d] -
           grG_gupup_[gname, a1_,a2_] * grG_gupup_[gname,c,d] )
       ) * 2 *grG_Jump_[gname,nullK(dn,dn),grG_join_[gname],c,d]:
     od:
   od:

   RETURN(s/16/Pi/grG_Ndotn_[grG_partner_[gname]] );

end:

#----------------------------
# nullS4a(up,up)
#
# project up nullS3(up,up) using basis vectors 
#
#  S{^alpha ^beta} = S3{^a ^b} e{^alpha (a)} e{^beta (b)}
#
#----------------------------
macro( gr = grG_ObjDef[nullS4a(up,up)]):
gr[grC_header] := `Extrinsic stress-energy`:
gr[grC_root] := nullS4aupup_:
gr[grC_rootStr] := `nullS4a `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_nullS4a:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { nullS3[ grG_partner_[gname]](up,up)}:


grF_calc_nullS4a := proc(object, iList)

local s, a, b, pname:

   pname := grG_partner_[gname]:
   s := 0;

   for a to Ndim[gname] - 1 do
     for b to Ndim[gname] - 1 do
       s := s + grG_nullS3upup_[pname, a, b] *
            diff( grG_xformup_[gname, a1_], grG_xup_[ pname, a]) *
            diff( grG_xformup_[gname, a2_], grG_xup_[ pname, b]);
     od:
   od:
   RETURN(s):

end:

    
#----------------------------
# nullS4(up,up)
#
# project up gamma then use (17)
#----------------------------
macro( gr = grG_ObjDef[nullS4(up,up)]):
gr[grC_header] := `Extrinsic stress-energy`:
gr[grC_root] := nullS4upup_:
gr[grC_rootStr] := `nullS4 `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_nullS4:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { n(up), g(up,up), Ndotn,
                     gamma4(up,up), gamma4n(up), gamma4nn, gamma4tr}:

grF_calc_nullS4 := proc(object, iList)

local s, a, b;

  s :=   grG_gamma4nup_[gname, a1_] * grG_nup_[gname, a2_] 
       + grG_gamma4nup_[gname, a2_] * grG_nup_[gname, a1_]
       - grG_gamma4tr_[gname] * grG_nup_[gname, a1_] * grG_nup_[gname, a2_]
       - grG_gamma4nn_[gname] * grG_gupup_[gname, a1_, a2_]:

 RETURN(s* grG_Ndotn_[gname]/16/pi):

 end: 
 
#----------------------------
# N(dn)
# This object is assigned by surf or
# calculated by lowering N(up)
#----------------------------
macro( gr = grG_ObjDef[N(dn)]):
gr[grC_header] := `Lapse Vector`:
gr[grC_root] := Ndn_:
gr[grC_rootStr] := `N `:
gr[grC_indexList] := [dn]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] :=
   'grG_gdndn_[grG_metricName, a1_, s1_] * grG_Nup_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#----------------------------
# N(up)
# This object is assigned by surf or
# calculated by raising N(dn) 
#----------------------------
macro( gr = grG_ObjDef[N(up)]):
gr[grC_header] := `Lapse Vector`:
gr[grC_root] := Nup_:
gr[grC_rootStr] := `N `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] :=
   'grG_gupup_[grG_metricName, a1_, s1_] * grG_Ndn_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:

#----------------------------
# n(bdn)
#
# (in the 3-space)
#----------------------------
macro( gr = grG_ObjDef[n(bdn)]):
gr[grC_header] := `n{b} e(a)^b`:
gr[grC_root] := nbdn_:
gr[grC_rootStr] := `nbdn `:
gr[grC_indexList] := [bdn]:
gr[grC_calcFn] := grF_calc_ndote :
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {n[grG_partner_[grG_metricName]](dn)}:

grF_calc_ndote := proc(object, iList)
local pname, s, a;

  s := 0;
  pname := grG_partner_[gname];
  for a to Ndim[gname]+1 do
     s := s + diff( grG_xformup_[pname, a], grG_xup_[gname, a1_]) *
          grG_ndn_[pname, a];
  od;

  juncF_project( s, pname, gname);

end:

#----------------------------
# N(bdn)
#
# (in the 3-space)
#----------------------------
macro( gr = grG_ObjDef[N(bdn)]):
gr[grC_header] := `N{b} e(a)^b`:
gr[grC_root] := Nbdn_:
gr[grC_rootStr] := `Nbdn `:
gr[grC_indexList] := [bdn]:
gr[grC_calcFn] := grF_calc_Ndote :
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {N[grG_partner_[grG_metricName]](dn)}:

grF_calc_Ndote := proc(object, iList)
local pname, s, a;

  s := 0;
  pname := grG_partner_[gname];
  for a to Ndim[gname]+1 do
     s := s + diff( grG_xformup_[pname, a], grG_xup_[gname, a1_]) *
          grG_Ndn_[pname, a];
  od;

  juncF_project( s, pname, gname);

end:

#----------------------------
# ndotn
#
# (in the 4-space)
#----------------------------
macro( gr = grG_ObjDef[ndotn]):
gr[grC_header] := `n{a} n{^a}`:
gr[grC_root] := ndotn_:
gr[grC_rootStr] := `ndotn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1: 
gr[grC_calcFnParms] := 
   'grG_ndn_[grG_metricName,s1_]*grG_nup_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {n(dn),n(up)}:

#----------------------------
# Ndotn
#
# (in the 4-space)
#----------------------------
macro( gr = grG_ObjDef[Ndotn]):
gr[grC_header] := `n{a} N{^a}`:
gr[grC_root] := Ndotn_:
gr[grC_rootStr] := `Ndotn `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1: 
gr[grC_calcFnParms] := 
   'grG_ndn_[grG_metricName,s1_]*grG_Nup_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {n(dn),N(up)}:

#----------------------------
# NdotN
#
# (in the 4-space)
#----------------------------
macro( gr = grG_ObjDef[NdotN]):
gr[grC_header] := `N{a} N{^a}`:
gr[grC_root] := NdotN_:
gr[grC_rootStr] := `NdotN `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum1: 
gr[grC_calcFnParms] := 
   'grG_Ndn_[grG_metricName,s1_]*grG_Nup_[grG_metricName, s1_]':
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {N(dn),N(up)}:

#----------------------------
# projS4(up,up)
#----------------------------
macro( gr = grG_ObjDef[projS4(up,up)]):
gr[grC_header] := `Intrinsic stress-energy`:
gr[grC_root] := projS4upup_:
gr[grC_rootStr] := `projS4 `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_projS4:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { nullS4[ grG_partner_[grG_metricName]](up,up)}:


grF_projS4 := proc(object, iList)

local b,c,s, pname:

   pname := grG_partner_[gname]:

   s := 0;
   for b to Ndim[gname]+1 do
     for c to Ndim[gname]+1 do
       s := s + grG_nullS4upup_[ pname, b, c] * 
		  diff(grG_xformup_[pname,b],grG_xup_[gname,a1_]) *
		  diff(grG_xformup_[pname,c],grG_xup_[gname,a2_]);
     od:
   od:

   unleash( s,pname,gname,false);

end:
