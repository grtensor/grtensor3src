###########################
# objects\TENSORS1.MPL
###
# Converted from 5.2 to 5.3
###########################
#**********************************************************
# tensors1
# definitions for tensor objects (part 1)
#
# This file contains the definitions for (not necessarily in order shown):
#  Aconstraint
#  C(dn,dn,dn,dn)        C(up,up,dn,dn)
#  Chr(dn,dn,dn)        Chr(dn,dn,up)
#  Dconstraint
#  x(up) [coordinates]
#  ds
#  g(dn,dn)            g(up,up)         detg
#  gd1(dn,dn,dn)        gd2(dn,dn,dn,dn)
#  G(dn,dn)            G(dn,up)         G(up,up)
#  Ndim
#  R(dn,dn)
#  S(dn,dn) [trace-free Ricci tensor]
#  R(dn,dn,dn,dn)        R(up,dn,dn,dn)     R(dn,dn,up,up)
#  Ricciscalar       RiemSq         RicciSq
#  x(up)
#
# Definitions consist of a grG_ObjDef record which is indexed by the
# object name. In many cases a specific function is required for the
# calculation of the components of an object. This is also specifed in
# this file.
#
# grG_ObjDef fields are described in globals.mpl
#
# Revisions:
#
# June 11,  94   Added Aconstraint and DConstraint
# July 07,  94 	 Revise definitions of detg, g(dn,dn), g(up,up) calculation
#                  from basis vectors. [dp]
# Aug  03,  94   Fix S(dn,dn) for N != 4. [pm]
# Sep  19,  94   Unify constraints [pm]
# Mar  10,  95   Alter definitions of g(dn,dn), g(up,up) to accomodate
#                  covariant bases in makeg.
# June 26,  95   Correct symmetry assignments and dimension in calculation
#	         of g(dn,dn) and g(up,up)
# Dec   8,  95   Make G, C, S use tRicciscalar [pm]
# Aug  22,  96   Add sig object [dp]
# Oct   4,  96   Fix hard-coded n=4 stmt in g(dn,dn) & g(up,up) calc
#                from bases [pm]
# Feb   4,  97   Replace 0,0 checks with checkIfAssigned [dp]
# May   6,  98   Added definitions of kdelta as standard objects [dp]
#--------------------------------------------------------------------
macro(gname = grG_metricName):

#----------------------------
# Info - metric text descriptions.
#----------------------------
macro( gr = grG_ObjDef[Info]):
gr[grC_header] := ``:
gr[grC_root] := Info_:
gr[grC_rootStr] := `Text description `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_Info:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { }:

grF_calc_Info := proc(object,iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local	s:
	lprint ( `Enter text information:` ):
	s := readline():
RETURN(s):
end:

#----------------------------
# signature
#----------------------------
macro( gr = grG_ObjDef[sig] ):
gr[grC_header] := `Spacetime signature`:
gr[grC_root] := sig_:
gr[grC_rootStr] := `Signature `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_enterComp:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}:

#----------------------------
# kdelta(up,dn) - standard definition.
#----------------------------

macro( gr = grG_ObjDef[kdelta(up,dn)]):
gr[grC_header] := `Kronecker delta`:
gr[grC_root] := kdeltaupdn_:
gr[grC_rootStr] := `delta`:
gr[grC_indexList] := [up,dn]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:
gr[grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(dn,dn) - standard definition.
#----------------------------

macro( gr = grG_ObjDef[kdelta(dn,dn)]):
gr[grC_header] := `Kronecker delta`:
gr[grC_root] := kdeltadndn_:
gr[grC_rootStr] := `delta`:
gr[grC_indexList] := [dn,dn]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:
gr[grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(dn,up) - standard definition.
#----------------------------

macro( gr = grG_ObjDef[kdelta(dn,up)]):
gr[grC_header] := `Kronecker delta`:
gr[grC_root] := kdeltadnup_:
gr[grC_rootStr] := `delta`:
gr[grC_indexList] := [dn,up]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:
gr[grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(up,up) - standard definition.
#----------------------------

macro( gr = grG_ObjDef[kdelta(up,up)]):
gr[grC_header] := `Kronecker delta`:
gr[grC_root] := kdeltaupup_:
gr[grC_rootStr] := `delta`:
gr[grC_indexList] := [up,up]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:
gr[grC_calcFn] := grF_calc_kdelta:

grF_calc_kdelta := proc (object, iList)
local s:
  if a1_=a2_ then
    RETURN(1):
  else
    RETURN(0):
  fi:
end:

#----------------------------
# Chr(dn,dn,dn)
#----------------------------
macro( gr = grG_ObjDef[Chr(dn,dn,dn)]):
gr[grC_header] := `Christoffel symbol of the first kind (symmetric in first two indices)`:
gr[grC_root] := Chrdndndn_:
gr[grC_rootStr] := `Gamma`:
gr[grC_indexList] := [dn,dn,dn]:
gr[grC_calcFn] := grF_calc_Chr1:
gr[grC_symmetry] := grF_sym_Chr1:
gr[grC_symPerm] := [ [2,1],1 ]:
gr[grC_depends] := {g(dn,dn,pdn)}:

grF_calc_Chr1 := proc(object,iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 1/2*grG_gdndnpdn_[gname,a1_,a3_,a2_] + 1/2*grG_gdndnpdn_[gname,a2_,a3_,a1_] -
 1/2*grG_gdndnpdn_[gname,a1_,a2_,a3_]:
end:

#----------------------------
# Chr(dn,dn,up)
#----------------------------
macro( gr = grG_ObjDef[Chr(dn,dn,up)]):
gr[grC_header] := `Christoffel symbol of the second kind (symmetric in first two indices)`:
gr[grC_root] := Chrdndnup_:
gr[grC_rootStr] := `Gamma`:
gr[grC_indexList] := [dn,dn,up]:
gr[grC_calcFn] := grF_calc_sum1:
gr[grC_calcFnParms] := # raise last index
  'grG_gupup_[gname,a3_,s1_]' * 'grG_Chrdndndn_[gname, a1_,a2_,s1_]':
gr[grC_symmetry] := grF_sym_Chr1:
gr[grC_depends] := {g(up,up), Chr(dn,dn,dn)}:

#----------------------------
# C(dn,dn,dn,dn)
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
macro( gr = grG_ObjDef[C(dn,dn,dn,dn)]):
gr[grC_header] := `Covariant Weyl`:
gr[grC_root] := Cdndndndn_:
gr[grC_rootStr] := `C `:
gr[grC_indexList] := [dn,dn,dn,dn]:
gr[grC_calcFn] := grF_calc_Weyl:
gr[grC_symmetry] := grF_sym_Riem:
gr[grC_depends] := {tRicciscalar, R(dn,dn), g(dn,dn), R(dn,dn,dn,dn)}:

grF_calc_Weyl := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s;
 s := grG_Rdndndndn_[gname,a1_,a2_,a3_,a4_]
     -1/(Ndim||grG_metricName-2)*
		 (grG_gdndn_[gname,a1_,a3_]*grG_Rdndn_[gname,a4_,a2_] -
		  grG_gdndn_[gname,a1_,a4_]*grG_Rdndn_[gname,a3_,a2_] -
		  grG_gdndn_[gname,a2_,a3_]*grG_Rdndn_[gname,a4_,a1_] +
		  grG_gdndn_[gname,a2_,a4_]*grG_Rdndn_[gname,a3_,a1_]) +
	    1/(Ndim||grG_metricName - 1)/(Ndim||grG_metricName - 2)*
	    grG_scalarR_[gname]*
	    (grG_gdndn_[gname,a1_,a3_]*grG_gdndn_[gname,a4_,a2_] -
	     grG_gdndn_[gname,a1_,a4_]*grG_gdndn_[gname,a3_,a2_] ):
 RETURN(s):
end:

#----------------------------
# C(dn,dn,up,up)
# since this is used explicitly in invars,
# define it explicitly
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
macro( gr = grG_ObjDef[C(dn,dn,up,up)]):
gr[grC_header] := `Mixed Weyl`:
gr[grC_root] := Cdndnupup_:
gr[grC_rootStr] := `C `:
gr[grC_indexList] := [dn,dn,up,up]:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 'grG_gupup_[gname,s1_,a3_]' * 'grG_gupup_[gname,s2_,a4_]' *
  'grG_Cdndndndn_[gname,a1_,a2_,s1_,s2_]':
gr[grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := {g(up,up), C(dn,dn,dn,dn)}:

#----------------------------
# constraint
#----------------------------
macro( gr = grG_ObjDef[constraint]):
gr[grC_header] := `constraints`:
gr[grC_root] := constraint:
gr[grC_rootStr] := `constraint `:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_symPerm] := []:
gr[grC_depends] := {}:

#----------------------------
# detmetric  detg
#----------------------------
macro( gr = grG_ObjDef[detg]):
gr[grC_header] := `Determinant of the metric tensor`:
gr[grC_root] := detg_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := []:
gr[grC_preCalcFn] := grF_preCalc_detg:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}:

grF_preCalc_detg := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  if grF_checkIfAssigned(g(dn,dn)) then
    grF_calcDetg(gdndn_):
  elif grF_checkIfAssigned(eta(bup,bup)) then
    if not grF_checkIfAssigned(g(up,up)) then
      grF_core(g(up,up),true):
    fi:
    grF_calcDetg(gupup_):
  else
    ERROR(`Load a metric first using grload().`):  
  fi:
end:

#----------------------------
# dimension
#----------------------------
macro( gr = grG_ObjDef[dimension]):
gr[grC_header] := `Line element`:
gr[grC_root] := Ndim: # if change this must also change in grF_initMetric()
gr[grC_rootStr] := ` N`:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {}:

#----------------------------
# ds
#----------------------------
macro( gr = grG_ObjDef[ds]):
gr[grC_header] := `Line element`:
gr[grC_root] := ds_: # if change this must also change in grF_initMetric()
gr[grC_rootStr] := ` ds`^2:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_ds:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {g(dn,dn)}:

grF_calc_ds := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s,i,j;
  s := 0;
  for i to Ndim||gname do
     s := s + grG_gdndn_[gname,i,i] * (` d` * grG_xup_[gname,i]^`2 `);
     for j from i+1 to Ndim||gname  do
     #
     # need a `d ` and ` d` to avoid e.g. d^2 u v
     #
	 s := s + 2 * grG_gdndn_[gname,i,j] * ( ` d`*(grG_xup_[gname,i])^` `)
		    * (`d `*(grG_xup_[gname,j])^` `);
     od:
  od:
  RETURN(s):
end:


#----------------------------
# g(dn,dn) - standard definition.
#----------------------------

macro( gr = grG_ObjDef[g(dn,dn)]):
gr[grC_header] := `Covariant metric tensor`:
gr[grC_root] := gdndn_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [dn,dn]:
gr[grC_preCalcFn] := grF_precalcgdd:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:

grF_precalcgdd := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global	grG_gdndn_, grG_partner_:
local	i, j, a:
	if grF_checkIfAssigned ( e(bdn,dn) ) then
		if not grF_checkIfAssigned ( e(bup,dn) ) then
			grF_core(e(bup,dn),true):
		fi:
		for i to Ndim[gname] do
		  for j from i to Ndim[gname] do
		  if i <> j then
		     grG_gdndn_[gname,j,i] := grG_gdndn_[gname,i,j]:
	          fi:
			grG_gdndn_[gname,i,j] := 0:
			for a to Ndim[gname] do 
				grG_gdndn_[gname,i,j] := grG_gdndn_[gname,i,j] 
				    + grG_ebdndn_[gname,a,i]*grG_ebupdn_[gname,a,j]:
				od:
			od:
		od:
	elif grF_checkIfAssigned ( e(bdn,up) ) or grF_checkIfAssigned
( g(up,up) ) then
		if not grF_checkIfAssigned(g(up,up)) then
        		grF_core(g(up,up),true):
      		fi:
      		if not grF_checkIfAssigned(detg) then
        		grF_core(detg,true):
      		fi:
      		grF_invMetric(gdndn_, gupup_):
		grF_assignedFlag ( g(dn,dn), set ):
	elif assigned(grG_partner_[gname]) and Ndim[gname] = 3 then
		# this is the intrinsic metric of a surface
		grF_pre_calc_ff1()
	else
		ERROR(`Unable to calculate g(dn,dn). Load a spacetime first using grload().`):  
	fi:
end:

#----------------------------
# g(up,up)
#----------------------------
macro( gr = grG_ObjDef[g(up,up)]):
gr[grC_header] := `Contravariant metric tensor`:
gr[grC_root] := gupup_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [up,up]:
gr[grC_preCalcFn] := grF_preCalc_guu:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { }:

grF_preCalc_guu := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_gupup_;
local	i, j, a:
	if grF_checkIfAssigned ( e(bdn,up) ) then
		if not grF_checkIfAssigned ( e(bup,up) ) then
			grF_core(e(bup,up),true):
		fi:
		for i to Ndim[gname] do 
		  for j from i to Ndim[gname] do
		  if i <> j then
		     grG_gupup_[gname,j,i] := grG_gupup_[gname,i,j]:
	          fi:
				grG_gupup_[gname,i,j] := 0:
				for a to Ndim[gname] do 
					grG_gupup_[gname,i,j] := grG_gupup_[gname,i,j] + grG_ebdnup_[gname,a,i]*grG_ebupup_[gname,a,j]:
				od:
			od:
		od:
	elif grF_checkIfAssigned ( e(bdn,dn) ) or grF_checkIfAssigned
( g(dn,dn) ) then
		if not grF_checkIfAssigned(g(dn,dn)) then
        		grF_core(g(dn,dn),true):
      		fi:
      		if not grF_checkIfAssigned(detg) then
        		grF_core(detg,true):
      		fi:
      		grF_invMetric(gupup_, gdndn_):
		grF_assignedFlag ( g(up,up), set ):
	else
		ERROR(`Unable to calculate g(up,up). Load a spacetime first using grload().`):  
	fi:
end:

#----------------------------
# g(dn,dn,pdn) (partial w.r.t last)
#----------------------------
macro( gr = grG_ObjDef[g(dn,dn,pdn)]):
gr[grC_header] := `First derivitive of the metric (diff w.r.t last index)`:
gr[grC_root] := gdndnpdn_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [dn,dn,pdn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
'diff(grG_gdndn_[gname, a1_, a2_], grG_xup_[gname, a3_ ])':
gr[grC_symmetry] := grF_sym_Chr1:
gr[grC_depends] := {g(dn,dn)}:

#----------------------------
# g(dn,dn,pdn,pdn) partial w.r.t last two
# - is this required anymore ?
#----------------------------
macro( gr = grG_ObjDef[g(dn,dn,pdn,pdn)]):
gr[grC_header] := `Second derivitive of the metric (diff w.r.t last two indices)`:
gr[grC_root] := gdndnpdnpdn_:
gr[grC_rootStr] := `g `:
gr[grC_indexList] := [dn,dn,pdn,pdn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
    'diff(grG_gdndnpdn_[gname, a1_,a2_,a3_ ], grG_xup_[gname, a4_ ])':
gr[grC_symmetry] := grF_sym_d2:
gr[grC_depends] := {g(dn,dn,pdn)}:
gr[grC_attributes] := {use_diff_constraint_}:

#----------------------------
# G(dn,dn)
#----------------------------
macro( gr = grG_ObjDef[G(dn,dn)]):
gr[grC_header] := `Covariant Einstein`:
gr[grC_root] := Gdndn_:
gr[grC_rootStr] := `G `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := grG_Rdndn_[gname,a1_,a2_]
	- 1/2*(grG_gdndn_[gname,a1_,a2_] * grG_scalarR_[gname]):
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {g(dn,dn), tRicciscalar, R(dn,dn)}:


#----------------------------
# R(dn,dn)  (DIRECT)
# - often faster to calcuate this than to contract Riemann (but not always)
#----------------------------
macro( gr = grG_ObjDef[R(dn,dn)]):
gr[grC_header] := `Covariant Ricci`:
gr[grC_root] := Rdndn_:
gr[grC_rootStr] := `R `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_RicciD:
gr[grC_calcFnParms] := []:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {Chr(dn,dn,up)}:
gr[grC_attributes] := {use_diff_constraint_}:

grF_calc_RicciD := proc(object,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:

 s := 0: 
 for a to Ndim||grG_metricName do
   if not a2_ = a then
      s := s + diff(grG_Chrdndnup_[gname,a1_,a2_,a],grG_xup_[gname,a])
	     - diff(grG_Chrdndnup_[gname,a,a1_,a],grG_xup_[gname,a2_]):
   fi:
   for b to Ndim||grG_metricName do
      s := s + grG_Chrdndnup_[gname,a1_,a2_,b] * grG_Chrdndnup_[gname,a,b,a]
	     - grG_Chrdndnup_[gname,a1_,a,b] * grG_Chrdndnup_[gname,b,a2_,a]:
   od:
 od:
end:

#----------------------------
# R(dn,dn,dn,dn)
#----------------------------
macro( gr = grG_ObjDef[R(dn,dn,dn,dn)]):
gr[grC_header] := `Covariant Riemann`:
gr[grC_root] := Rdndndndn_:
gr[grC_rootStr] := `R `:
gr[grC_indexList] := [dn,dn,dn,dn]:
gr[grC_calcFn] := grF_calc_Riem:
gr[grC_calcFnParms] := []:
gr[grC_symmetry] := grF_sym_Riem:
gr[grC_depends] := {g(dn,dn,pdn), Chr(dn,dn,dn), g(up,up)}:
gr[grC_attributes] := {use_diff_constraint_}:


grF_calc_Riem := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local m,n,s:
 # can save total of 12 diff calls here (n=4)
 if (a1_ = a3_ and a2_ = a4_) then
    s := diff( grG_gdndnpdn_[gname,a1_,a2_,a2_], grG_xup_[gname,a1_]):
 else
    s := 1/2*(diff(grG_gdndnpdn_[gname,a1_,a4_,a2_] , grG_xup_[gname,a3_])
	  +  diff(grG_gdndnpdn_[gname,a2_,a3_,a1_] , grG_xup_[gname,a4_]) ):
 fi:
 if (a1_ = a4_ and a3_ = a2_) then
     s := s - diff(grG_gdndnpdn_[gname,a1_,a3_,a3_] , grG_xup_[gname,a1_] ):
 else
     s := s - 1/2*(diff(grG_gdndnpdn_[gname,a1_,a3_,a2_], grG_xup_[gname,a4_])
	    + diff(grG_gdndnpdn_[gname,a2_,a4_,a1_], grG_xup_[gname,a3_]) ):
 fi:
 for m to Ndim||grG_metricName do
   for n to Ndim||grG_metricName do
     s := s + grG_gupup_[gname,m,n]*
	  (grG_Chrdndndn_[gname,a1_,a4_,m] * grG_Chrdndndn_[gname,a2_,a3_,n]
	  - grG_Chrdndndn_[gname,a1_,a3_,m] * grG_Chrdndndn_[gname,a2_,a4_,n])
   od:
 od:
 s;
end:

#----------------------------
# R(up,up,dn,dn)
# since this is used explicitly in invars, define
# it explicitly
#----------------------------
macro( gr = grG_ObjDef[R(up,up,dn,dn)]):
gr[grC_header] := `Mixed Riemann`:
gr[grC_root] := Rupupdndn_:
gr[grC_rootStr] := `R `:
gr[grC_indexList] := [up,up,dn,dn]:
gr[grC_calcFn] := grF_calc_sum2:
# raise indices
gr[grC_calcFnParms] := 'grG_gupup_[gname,s1_,a1_]' * 'grG_gupup_[gname,s2_,a2_]' *
  'grG_Rdndndndn_[gname,s1_,s2_,a3_,a4_]':
gr[grC_symmetry] := grF_sym_MRiem:
gr[grC_depends] := {g(up,up), R(dn,dn,dn,dn)}:


#----------------------------
# Ricciscalar
#----------------------------
# temporarily leave a Ricciscalar record floating around so 
# refs in spinors work - track these down and make them
# point to tRicciscalar later
macro( gr = grG_ObjDef[Ricciscalar]):
gr[grC_header] := `Ricci scalar`:
gr[grC_root] := scalarR_:
gr[grC_rootStr] := `R `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_scalarR:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {g(dn,dn), R(dn,dn)}:

macro( gr = grG_ObjDef[tRicciscalar]):
gr[grC_header] := `Ricci scalar`:
gr[grC_root] := scalarR_:
gr[grC_rootStr] := `R `:
gr[grC_displayName] := Ricciscalar:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_scalarR:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {g(dn,dn), R(dn,dn)}:

grF_calc_scalarR := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s;
  s := 0;
  for a to Ndim||gname do
    s := s + grG_gupup_[gname, a, a] * grG_Rdndn_[gname, a, a]:
    for b from a+1 to Ndim||grG_metricName do
       s := s + 2 * grG_gupup_[gname, a, b] * grG_Rdndn_[gname, a, b]:
    od:
  od:
  RETURN( s):
end:



#----------------------------
# RicciSq
#----------------------------
macro( gr = grG_ObjDef[RicciSq]):
gr[grC_header] := `Full Contraction of Ricci`:
gr[grC_root] := RicciSq_:
gr[grC_rootStr] := `RicciSq `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_RicciSq: # uses objectName to do WeylSq also!
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {R(up,dn)}:

grF_calc_RicciSq := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local i,j,s;
   s := 0:
   for i to Ndim||grG_metricName do
      s := s + grG_Rupdn_[gname,i,i] * grG_Rupdn_[gname,i,i]:
      for j from i+1 to Ndim||grG_metricName do
	   s := s + 2 * grG_Rupdn_[gname,i,j] * grG_Rupdn_[gname,j,i]:
      od;
   od;
   RETURN(s):
end:

#----------------------------
# RiemSq
#----------------------------
macro( gr = grG_ObjDef[RiemSq]):
gr[grC_header] := `Full Contraction of Riemann`:
gr[grC_root] := RiemSq_:
gr[grC_rootStr] := `K `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_RiemSq:
gr[grC_calcFnParms] := Rdndnupup_,Rdndnupup_:
gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := {R(dn,dn,up,up)}:

grF_calc_RiemSq := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,c,d,s,root1, root2;
#
# use two seperate roots to allow for the cmscalars W1R and W1I
#
 root1 := grG_ObjDef[object][grC_calcFnParms][1]:
 root2 := grG_ObjDef[object][grC_calcFnParms][2]:
    if Ndim||gname = 4 and grG_fnCode = grC_CALC then

# explicit formula for N=4 & calc
 s :=
4*(grG_||root1[gname,1,2,1,2]*grG_||root2[gname,1,2,1,2]+
grG_||root1[gname,1,2,1,3]*grG_||root2[gname,1,3,1,2] +
grG_||root1[gname,1,2,1,4]*grG_||root2[gname,1,4,1,2] +
grG_||root1[gname,1,2,2,3]*grG_||root2[gname,2,3,1,2] +
grG_||root1[gname,1,2,2,4]*grG_||root2[gname,2,4,1,2] +
grG_||root1[gname,1,2,3,4]*grG_||root2[gname,3,4,1,2] +
grG_||root1[gname,1,3,1,2]*grG_||root2[gname,1,2,1,3] +
grG_||root1[gname,1,3,1,3]*grG_||root2[gname,1,3,1,3] +
grG_||root1[gname,1,3,1,4]*grG_||root2[gname,1,4,1,3] +
grG_||root1[gname,2,4,1,2]*grG_||root2[gname,1,2,2,4] +
grG_||root1[gname,2,4,1,3]*grG_||root2[gname,1,3,2,4] +
grG_||root1[gname,2,4,1,4]*grG_||root2[gname,1,4,2,4] +
grG_||root1[gname,2,4,2,3]*grG_||root2[gname,2,3,2,4] +
grG_||root1[gname,2,4,2,4]*grG_||root2[gname,2,4,2,4] +
grG_||root1[gname,1,3,2,3]*grG_||root2[gname,2,3,1,3] +
grG_||root1[gname,1,3,2,4]*grG_||root2[gname,2,4,1,3] +
grG_||root1[gname,1,3,3,4]*grG_||root2[gname,3,4,1,3] +
grG_||root1[gname,1,4,1,2]*grG_||root2[gname,1,2,1,4] +
grG_||root1[gname,1,4,1,3]*grG_||root2[gname,1,3,1,4] +
grG_||root1[gname,1,4,1,4]*grG_||root2[gname,1,4,1,4] +
grG_||root1[gname,1,4,2,3]*grG_||root2[gname,2,3,1,4] +
grG_||root1[gname,1,4,2,4]*grG_||root2[gname,2,4,1,4] +
grG_||root1[gname,1,4,3,4]*grG_||root2[gname,3,4,1,4] +
grG_||root1[gname,2,3,1,2]*grG_||root2[gname,1,2,2,3] +
grG_||root1[gname,2,3,1,3]*grG_||root2[gname,1,3,2,3] +
grG_||root1[gname,2,3,1,4]*grG_||root2[gname,1,4,2,3] +
grG_||root1[gname,2,3,2,3]*grG_||root2[gname,2,3,2,3] +
grG_||root1[gname,2,3,2,4]*grG_||root2[gname,2,4,2,3] +
grG_||root1[gname,2,3,3,4]*grG_||root2[gname,3,4,2,3] +
grG_||root1[gname,2,4,3,4]*grG_||root2[gname,3,4,2,4] +
grG_||root1[gname,3,4,1,2]*grG_||root2[gname,1,2,3,4] +
grG_||root1[gname,3,4,1,3]*grG_||root2[gname,1,3,3,4] +
grG_||root1[gname,3,4,1,4]*grG_||root2[gname,1,4,3,4] +
grG_||root1[gname,3,4,2,3]*grG_||root2[gname,2,3,3,4] +
grG_||root1[gname,3,4,2,4]*grG_||root2[gname,2,4,3,4] +
grG_||root1[gname,3,4,3,4]*grG_||root2[gname,3,4,3,4]):

    else
    # use this for calcAlter or Ndim != 4
        lprint(`Debug-using the long definition`):
	s := 0;
	for a to Ndim||gname - 1 do
	  for b from a+1 to Ndim||gname do
	    for c to Ndim||gname - 1 do
	      for d from c+1 to Ndim||gname do
		s := s + 4 * grG_||root1[gname,a,b,c,d]* grG_||root2[gname,c,d,a,b];
	      od:
	    od:
	    if grG_fnCode = gr_CALCALTER then
		s := grG_simpHow( grG_preSeq, s, grG_postSeq);  fi:
	  od:
	od:
    fi:
    # W1I requires a division of the result
    if nops([ grG_ObjDef[object][grC_calcFnParms] ]) = 3 then
       RETURN(s/grG_ObjDef[object][grC_calcFnParms][3]):
    else
       RETURN(s):
    fi:
end:

#----------------------------
# S(dn,dn)
# - trace free Ricci
#----------------------------
macro( gr = grG_ObjDef[S(dn,dn)]):
gr[grC_header] := `Covariant trace-free Ricci`:
gr[grC_root] := Sdndn_:
gr[grC_rootStr] := `S `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
	'grG_Rdndn_[gname,a1_,a2_]' -
	(1/Ndim[gname])*'grG_gdndn_[gname,a1_,a2_] * grG_scalarR_[gname]':
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {R(dn,dn), g(dn,dn), tRicciscalar}:

#----------------------------
# WeylSq
#----------------------------
macro( gr = grG_ObjDef[WeylSq]):
gr[grC_header] := `Full Contraction of Weyl`:
gr[grC_root] := WeylSq_:
gr[grC_rootStr] := `WeylSq `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_RiemSq: # uses parms to do WeylSq also
gr[grC_calcFnParms] := Cdndnupup_,Cdndnupup_:
gr[grC_symmetry] := grF_sym_scalar:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := {C(dn,dn,up,up)}:

#----------------------------
# x(up)
#----------------------------
macro( gr = grG_ObjDef[x(up)]):
gr[grC_header] := `Coordinates`:
gr[grC_root] := xup_:
gr[grC_rootStr] := `x `:
gr[grC_indexList] := [up]:
gr[grC_calcFn] := grF_calc_NULL: # assigned by grload
gr[grC_symmetry] := grF_sym_vector:
gr[grC_depends] := {}:


