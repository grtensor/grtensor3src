###########################
# objects\RICCI.MPL
###
# Converted from 5.2 to 5.3
###########################
#----------------------------
# R2(dn,dn)  (via Riemann)
# - often faster to calcuate this than to contract Riemann (but not always)
#----------------------------
grG_ObjDef[R2(dn,dn)][grC_header] := `Covariant Ricci (via Riemann)`:
grG_ObjDef[R2(dn,dn)][grC_root] := R2dndn_:
grG_ObjDef[R2(dn,dn)][grC_rootStr] := `R2 `:
grG_ObjDef[R2(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[R2(dn,dn)][grC_calcFn] := grF_calc_Ricci2:
grG_ObjDef[R2(dn,dn)][grC_calcFnParms] := []:
grG_ObjDef[R2(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[R2(dn,dn)][grC_depends] := {g(up,up), R(dn,dn,dn,dn)}:

grF_calc_Ricci2 := proc(object,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
global gr_data, grG_metricName;
 s := 0:
 for a to Ndim[grG_metricName] do
   for b to Ndim[grG_metricName] do
      s := s + gr_data[gupup_,grG_metricName, a, b]
	     * gr_data[Rdndndndn_, grG_metricName, a, a1_, b, a2_];
   od:
 od:
end:


#----------------------------
# R3(dn,dn)  (via ln(Sqrt()) formulae)
# - often faster to calcuate this than to contract Riemann (but not always)
#----------------------------
grG_ObjDef[R3(dn,dn)][grC_header] := `Covariant Ricci [via ln(Sqrt()) ]`:
grG_ObjDef[R3(dn,dn)][grC_root] := R3dndn_:
grG_ObjDef[R3(dn,dn)][grC_rootStr] := `R3 `:
grG_ObjDef[R3(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[R3(dn,dn)][grC_calcFn] := grF_calc_Ricci3:
grG_ObjDef[R3(dn,dn)][grC_calcFnParms] := []:
grG_ObjDef[R3(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[R3(dn,dn)][grC_depends] := {Chr(dn,dn,up)}:

grF_calc_Ricci3 := proc(object,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s, gname:
global gr_data, grG_metricName, Ndim;
 gname := grG_metricName:
 s := - diff( diff( ln(sqrt(-gr_data[detg_,gname])),gr_data[xup_,gname,a2_]), gr_data[xup_,gname,a1_]):
 for a to Ndim[grG_metricName] do
      s := s + diff(gr_data[Chrdndnup_,gname,a1_,a2_,a],gr_data[xup_,gname,a])
	   + gr_data[Chrdndnup_,gname,a1_,a2_,a] *
	     diff( ln(sqrt(-gr_data[detg_,gname])),gr_data[xup_,gname,a]);
   for b to Ndim[grG_metricName] do
      s := s - gr_data[Chrdndnup_,gname,a1_,a,b] * gr_data[Chrdndnup_,gname,b,a2_,a]:
   od:
 od:
end:

##############################
#
# Riemann
#
##############################

#----------------------------
# R2(dn,dn,dn,dn)
#
# This defintion of Riemann takes advantage
# of the cyclic relation to reduce the number
# of terms we need to calculate.
#----------------------------
grG_ObjDef[R2(dn,dn,dn,dn)][grC_header] := `Covariant Riemann (using cyclic sym)`:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_root] := R2dndndndn_:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_rootStr] := `R2 `:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_calcFn] := grF_calc_Riem:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_calcFnParms] := []:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_symmetry] := grF_sym_RiemCycle:
grG_ObjDef[R2(dn,dn,dn,dn)][grC_depends] := {g(dn,dn,dn), Chr(dn,dn,dn), g(up,up)}:

#*** four index - symmetry like the Riemann tensor ***
grG_symmetry[grF_sym_RiemCycle] := { [[2,1,3,4],-1], [[1,2,4,3],-1], [[3,4,1,2],1] }:

grF_sym_RiemCycle := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  a1_, a2_, a3_, a4_, gr_data, grG_metricName;
local x, gname:
    gname := grG_metricName;
    if grG_calc and assigned(calcFn) then
    # by symmetry we know a number of terms are zero
      for a1_ to Ndim[grG_metricName] do
	for a2_ to Ndim[grG_metricName] do
	  for a3_ to Ndim[grG_metricName] do
	       gr_data[root,grG_metricName,a1_,a1_,a2_,a3_] := 0;
	       gr_data[root,grG_metricName,a1_,a2_,a3_,a3_] := 0;
	  od;
	od;
      od;
    fi:
    for a1_ to Ndim[grG_metricName]-1 do
      for a2_ from a1_ + 1 to Ndim[grG_metricName] do
	for a3_ from a1_ to Ndim[grG_metricName]-1 do
	  if a3_ = a1_ then x := a2_ else x := a3_+1 fi;
	    for a4_ from x to Ndim[grG_metricName] do
	      if grG_calc and assigned(calcFn)  then
		 # assignments here reflect symmetries
		 gr_data[root,gname,a2_,a1_,a3_,a4_] := -gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 gr_data[root,gname,a1_,a2_,a4_,a3_] := -gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 gr_data[root,gname,a2_,a1_,a4_,a3_] := gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 # now with first & second pair exchanged
		 gr_data[root,gname,a3_,a4_,a1_,a2_] := gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 gr_data[root,gname,a3_,a4_,a2_,a1_] := -gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 gr_data[root,gname,a4_,a3_,a1_,a2_] := -gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 gr_data[root,gname,a4_,a3_,a2_,a1_] := gr_data[root,gname,a1_,a2_,a3_,a4_]:
		 #
		 # put assigment AFTER sym ,so when simplification occurs
		 # the symmetrized objects don't need reassigment
		 #

		 #
		 # use the identity R     = - R     - R
		 #                   1423      1234    1342
		 #
		 if Ndim[grG_metricName] = 4 and a1_ = 1 and a2_ = 4
		    and a3_ = 2 and a4_ = 3 then
		    gr_data[root,gname,a1_,a2_,a3_,a4_] :=
			  - gr_data[root,gname,1,2,3,4]
			  - gr_data[root,gname,1,3,4,2]:
		 else
		    gr_data[root,gname,a1_,a2_,a3_,a4_] := calcFn(objectName,[a1_,a2_,a3_,a4_]):
		 fi:
	      fi:
	      if grG_simp then
		 gr_data[root,gname,a1_,a2_,a3_,a4_] :=
		     grG_simpHow(grG_preSeq, gr_data[root,gname,a1_,a2_,a3_,a4_] ,grG_postSeq):
	      fi:
	      if grG_callComp then
		 grF_component(objectName,[a1_,a2_,a3_,a4_], gr_data[root,gname,a1_,a2_,a3_,a4_]);
	      fi:
	   od;
	 od;
      od;
    od;
 NULL;
end: # return NULL
