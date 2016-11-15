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


#----------------------------
# Info - metric text descriptions.
#----------------------------
grG_ObjDef[Info][grC_header] := ``:
grG_ObjDef[Info][grC_root] := Text_:
grG_ObjDef[Info][grC_rootStr] := `Text description `:
grG_ObjDef[Info][grC_indexList] := []:
grG_ObjDef[Info][grC_calcFn] := grF_calc_Info:
grG_ObjDef[Info][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Info][grC_depends] := { }:

grF_calc_Info := proc(object,iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local	s:
	s := grF_input ( "Enter text information (in quotes):", 0, "Info>" ):
RETURN(s):
end:

#----------------------------
# signature
#----------------------------
grG_ObjDef[sig][grC_header] := `Spacetime signature`:
grG_ObjDef[sig][grC_root] := sig_:
grG_ObjDef[sig][grC_rootStr] := `Signature `:
grG_ObjDef[sig][grC_indexList] := []:
grG_ObjDef[sig][grC_calcFn] := grF_enterComp:
grG_ObjDef[sig][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[sig][grC_depends] := {}:

#----------------------------
# kdelta(up,dn) - standard definition.
#----------------------------

grG_ObjDef[kdelta(up,dn)][grC_header] := `Kronecker delta`:
grG_ObjDef[kdelta(up,dn)][grC_root] := kdeltaupdn_:
grG_ObjDef[kdelta(up,dn)][grC_rootStr] := `delta`:
grG_ObjDef[kdelta(up,dn)][grC_indexList] := [up,dn]:
grG_ObjDef[kdelta(up,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[kdelta(up,dn)][grC_depends] := {}:
grG_ObjDef[kdelta(up,dn)][grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(dn,dn) - standard definition.
#----------------------------

grG_ObjDef[kdelta(dn,dn)][grC_header] := `Kronecker delta`:
grG_ObjDef[kdelta(dn,dn)][grC_root] := kdeltadndn_:
grG_ObjDef[kdelta(dn,dn)][grC_rootStr] := `delta`:
grG_ObjDef[kdelta(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[kdelta(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[kdelta(dn,dn)][grC_depends] := {}:
grG_ObjDef[kdelta(dn,dn)][grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(dn,up) - standard definition.
#----------------------------

grG_ObjDef[kdelta(dn,up)][grC_header] := `Kronecker delta`:
grG_ObjDef[kdelta(dn,up)][grC_root] := kdeltadnup_:
grG_ObjDef[kdelta(dn,up)][grC_rootStr] := `delta`:
grG_ObjDef[kdelta(dn,up)][grC_indexList] := [dn,up]:
grG_ObjDef[kdelta(dn,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[kdelta(dn,up)][grC_depends] := {}:
grG_ObjDef[kdelta(dn,up)][grC_calcFn] := grF_calc_kdelta:

#----------------------------
# kdelta(up,up) - standard definition.
#----------------------------

grG_ObjDef[kdelta(up,up)][grC_header] := `Kronecker delta`:
grG_ObjDef[kdelta(up,up)][grC_root] := kdeltaupup_:
grG_ObjDef[kdelta(up,up)][grC_rootStr] := `delta`:
grG_ObjDef[kdelta(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[kdelta(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[kdelta(up,up)][grC_depends] := {}:
grG_ObjDef[kdelta(up,up)][grC_calcFn] := grF_calc_kdelta:


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
grG_ObjDef[Chr(dn,dn,dn)][grC_header] := `Christoffel symbol of the first kind (symmetric in first two indices)`:
grG_ObjDef[Chr(dn,dn,dn)][grC_root] := Chrdndndn_:
grG_ObjDef[Chr(dn,dn,dn)][grC_rootStr] := `Gamma`:
grG_ObjDef[Chr(dn,dn,dn)][grC_indexList] := [dn,dn,dn]:
grG_ObjDef[Chr(dn,dn,dn)][grC_calcFn] := grF_calc_Chr1:
grG_ObjDef[Chr(dn,dn,dn)][grC_symmetry] := grF_sym_Chr1:
grG_ObjDef[Chr(dn,dn,dn)][grC_symPerm] := [ [2,1],1 ]:
grG_ObjDef[Chr(dn,dn,dn)][grC_depends] := {g(dn,dn,pdn)}:

grF_calc_Chr1 := proc(object,iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global grG_metricName, gr_data;
 1/2*gr_data[gdndnpdn_,grG_metricName,a1_,a3_,a2_] + 
 1/2*gr_data[gdndnpdn_,grG_metricName,a2_,a3_,a1_] -
 1/2*gr_data[gdndnpdn_,grG_metricName,a1_,a2_,a3_]:
end proc:

#----------------------------
# Chr(dn,dn,up)
#----------------------------
grG_ObjDef[Chr(dn,dn,up)][grC_header] := `Christoffel symbol of the second kind (symmetric in first two indices)`:
grG_ObjDef[Chr(dn,dn,up)][grC_root] := Chrdndnup_:
grG_ObjDef[Chr(dn,dn,up)][grC_rootStr] := `Gamma`:
grG_ObjDef[Chr(dn,dn,up)][grC_indexList] := [dn,dn,up]:
grG_ObjDef[Chr(dn,dn,up)][grC_calcFn] := grF_calc_sum1:
grG_ObjDef[Chr(dn,dn,up)][grC_calcFnParms] := # raise last index
  'gr_data[gupup_,grG_metricName,a3_,s1_]' * 'gr_data[Chrdndndn_,grG_metricName, a1_,a2_,s1_]':
grG_ObjDef[Chr(dn,dn,up)][grC_symmetry] := grF_sym_Chr1:
grG_ObjDef[Chr(dn,dn,up)][grC_depends] := {g(up,up), Chr(dn,dn,dn)}:

#----------------------------
# C(dn,dn,dn,dn)
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C(dn,dn,dn,dn)][grC_header] := `Covariant Weyl`:
grG_ObjDef[C(dn,dn,dn,dn)][grC_root] := Cdndndndn_:
grG_ObjDef[C(dn,dn,dn,dn)][grC_rootStr] := `C `:
grG_ObjDef[C(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[C(dn,dn,dn,dn)][grC_calcFn] := grF_calc_Weyl:
grG_ObjDef[C(dn,dn,dn,dn)][grC_symmetry] := grF_sym_Riem:
grG_ObjDef[C(dn,dn,dn,dn)][grC_depends] := {tRicciscalar, R(dn,dn), g(dn,dn), R(dn,dn,dn,dn)}:

grF_calc_Weyl := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s;
global grG_metricName, Ndim, gr_data;
 s := gr_data[Rdndndndn_,grG_metricName,a1_,a2_,a3_,a4_]
     -1/(Ndim[grG_metricName]-2)*
		 (gr_data[gdndn_,grG_metricName,a1_,a3_]*gr_data[Rdndn_,grG_metricName,a4_,a2_] -
		  gr_data[gdndn_,grG_metricName,a1_,a4_]*gr_data[Rdndn_,grG_metricName,a3_,a2_] -
		  gr_data[gdndn_,grG_metricName,a2_,a3_]*gr_data[Rdndn_,grG_metricName,a4_,a1_] +
		  gr_data[gdndn_,grG_metricName,a2_,a4_]*gr_data[Rdndn_,grG_metricName,a3_,a1_]) +
	    1/(Ndim[grG_metricName] - 1)/(Ndim[grG_metricName] - 2)*
	    gr_data[scalarR_,grG_metricName]*
	    (gr_data[gdndn_,grG_metricName,a1_,a3_]*gr_data[gdndn_,grG_metricName,a4_,a2_] -
	     gr_data[gdndn_,grG_metricName,a1_,a4_]*gr_data[gdndn_,grG_metricName,a3_,a2_] ):
 RETURN(s):
end:

#----------------------------
# C(dn,dn,up,up)
# since this is used explicitly in invars,
# define it explicitly
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C(dn,dn,up,up)][grC_header] := `Mixed Weyl`:
grG_ObjDef[C(dn,dn,up,up)][grC_root] := Cdndnupup_:
grG_ObjDef[C(dn,dn,up,up)][grC_rootStr] := `C `:
grG_ObjDef[C(dn,dn,up,up)][grC_indexList] := [dn,dn,up,up]:
grG_ObjDef[C(dn,dn,up,up)][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[C(dn,dn,up,up)][grC_calcFnParms] := 'gr_data[gupup_,grG_metricName,s1_,a3_]' * 'gr_data[gupup_,grG_metricName,s2_,a4_]' *
  'gr_data[Cdndndndn_,grG_metricName,a1_,a2_,s1_,s2_]':
grG_ObjDef[C(dn,dn,up,up)][grC_symmetry] := grF_sym_MRiem:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C(dn,dn,up,up)][grC_depends] := {g(up,up), C(dn,dn,dn,dn)}:

#----------------------------
# constraint
#----------------------------
grG_ObjDef[constraint][grC_header] := `constraints`:
grG_ObjDef[constraint][grC_root] := constraint:
grG_ObjDef[constraint][grC_rootStr] := `constraint `:
grG_ObjDef[constraint][grC_indexList] := []:
grG_ObjDef[constraint][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[constraint][grC_symPerm] := []:
grG_ObjDef[constraint][grC_depends] := {}:

#----------------------------
# detmetric  detg
#----------------------------
grG_ObjDef[detg][grC_header] := `Determinant of the metric tensor`:
grG_ObjDef[detg][grC_root] := detg_:
grG_ObjDef[detg][grC_rootStr] := `g `:
grG_ObjDef[detg][grC_indexList] := []:
grG_ObjDef[detg][grC_preCalcFn] := grF_preCalc_detg:
grG_ObjDef[detg][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[detg][grC_depends] := {}:

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
grG_ObjDef[dimension][grC_header] := `Line element`:
grG_ObjDef[dimension][grC_root] := Ndim: # if change this must also change in grF_initMetric()
grG_ObjDef[dimension][grC_rootStr] := ` N`:
grG_ObjDef[dimension][grC_indexList] := []:
grG_ObjDef[dimension][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[dimension][grC_depends] := {}:

#----------------------------
# ds
#----------------------------
grG_ObjDef[ds][grC_header] := `Line element`:
grG_ObjDef[ds][grC_root] := ds_: # if change this must also change in grF_initMetric()
grG_ObjDef[ds][grC_rootStr] := ` ds`^2:
grG_ObjDef[ds][grC_indexList] := []:
grG_ObjDef[ds][grC_calcFn] := grF_calc_ds:
grG_ObjDef[ds][grC_calcFnParms] := [NULL]:
grG_ObjDef[ds][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[ds][grC_depends] := {g(dn,dn)}:

grF_calc_ds := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s,i,j;
global grG_metricName, gr_data, Ndim;
  s := 0;
  for i to Ndim[grG_metricName] do
     s := s + gr_data[gdndn_,grG_metricName,i,i] * (` d` * gr_data[xup_,grG_metricName,i]^`2 `);
     for j from i+1 to Ndim[grG_metricName]  do
     #
     # need a `d ` and ` d` to avoid e.g. d^2 u v
     #
	 s := s + 2 * gr_data[gdndn_,grG_metricName,i,j] * ( ` d`*(gr_data[xup_,grG_metricName,i])^` `)
		    * (`d `*(gr_data[xup_,grG_metricName,j])^` `);
     od:
  od:
  RETURN(s):
end:


#----------------------------
# g(dn,dn) - standard definition.
#----------------------------

grG_ObjDef[g(dn,dn)][grC_header] := `Covariant metric tensor`:
grG_ObjDef[g(dn,dn)][grC_root] := gdndn_:
grG_ObjDef[g(dn,dn)][grC_rootStr] := `g `:
grG_ObjDef[g(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[g(dn,dn)][grC_preCalcFn] := grF_precalcgdd:
grG_ObjDef[g(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[g(dn,dn)][grC_depends] := {}:

grF_precalcgdd := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global	grG_partner_, gr_data, Ndim, grG_metricName:
local	i, j, a:
	if grF_checkIfAssigned ( e(bdn,dn) ) then
		if not grF_checkIfAssigned ( e(bup,dn) ) then
			grF_core(e(bup,dn),true):
		fi:
		for i to Ndim[grG_metricName] do
		  for j from i to Ndim[grG_metricName] do
		  if i <> j then
		     gr_data[gdndn_,grG_metricName,j,i] := gr_data[gdndn_,grG_metricName,i,j]:
	          fi:
			gr_data[gdndn_,grG_metricName,i,j] := 0:
			for a to Ndim[grG_metricName] do
				gr_data[gdndn_,grG_metricName,i,j] := gr_data[gdndn_,grG_metricName,i,j]
				    + gr_data[ebdndn_,grG_metricName,a,i]*gr_data[ebupdn_,grG_metricName,a,j]:
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
	elif assigned(grG_partner_[grG_metricName]) and Ndim[grG_metricName] = 3 then
		# this is the intrinsic metric of a surface
		grF_pre_calc_ff1()
	else
		ERROR(`Unable to calculate g(dn,dn). Load a spacetime first using grload().`):
	fi:
end:

#----------------------------
# g(up,up)
#----------------------------
grG_ObjDef[g(up,up)][grC_header] := `Contravariant metric tensor`:
grG_ObjDef[g(up,up)][grC_root] := gupup_:
grG_ObjDef[g(up,up)][grC_rootStr] := `g `:
grG_ObjDef[g(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[g(up,up)][grC_preCalcFn] := grF_preCalc_guu:
grG_ObjDef[g(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[g(up,up)][grC_depends] := { }:

grF_preCalc_guu := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_metricName, gr_data, Ndim;
local	i, j, a:
	if grF_checkIfAssigned ( e(bdn,up) ) then
		if not grF_checkIfAssigned ( e(bup,up) ) then
			grF_core(e(bup,up),true):
		fi:
		for i to Ndim[grG_metricName] do
		  for j from i to Ndim[grG_metricName] do
		  if i <> j then
		     gr_data[gupup_,grG_metricName,j,i] := gr_data[gupup_,grG_metricName,i,j]:
	          fi:
				gr_data[gupup_,grG_metricName,i,j] := 0:
				for a to Ndim[grG_metricName] do
					gr_data[gupup_,grG_metricName,i,j] := gr_data[gupup_,grG_metricName,i,j] + 
						gr_data[ebdnup_,grG_metricName,a,i]*gr_data[ebupup_,grG_metricName,a,j]:
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
      		printf("precalc\n");
      		grF_invMetric(gupup_, gdndn_):
		grF_assignedFlag ( g(up,up), set ):
	else
		ERROR(`Unable to calculate g(up,up). Load a spacetime first using grload().`):
	fi:
end:

#----------------------------
# g(dn,dn,pdn) (partial w.r.t last)
#----------------------------
grG_ObjDef[g(dn,dn,pdn)][grC_header] := `First derivitive of the metric (diff w.r.t last index)`:
grG_ObjDef[g(dn,dn,pdn)][grC_root] := gdndnpdn_:
grG_ObjDef[g(dn,dn,pdn)][grC_rootStr] := `g `:
grG_ObjDef[g(dn,dn,pdn)][grC_indexList] := [dn,dn,pdn]:
grG_ObjDef[g(dn,dn,pdn)][grC_calcFn] := grF_calc_gdndnpdn:
grG_ObjDef[g(dn,dn,pdn)][grC_calcFnParms] := []:
grG_ObjDef[g(dn,dn,pdn)][grC_symmetry] := grF_sym_Chr1:
grG_ObjDef[g(dn,dn,pdn)][grC_depends] := {g(dn,dn)}:

grF_calc_gdndnpdn := proc(object, index)
global gr_data, grG_metricName:
    diff(gr_data[gdndn_,grG_metricName, a1_, a2_], gr_data[xup_,grG_metricName, a3_ ]):
end proc:


#----------------------------
# g(dn,dn,pdn,pdn) partial w.r.t last two
# - is this required anymore ?
#----------------------------
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_header] := `Second derivitive of the metric (diff w.r.t last two indices)`:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_root] := gdndnpdnpdn_:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_rootStr] := `g `:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_indexList] := [dn,dn,pdn,pdn]:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_calcFn] := grF_calc_gdndnpdnpdn:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_symmetry] := grF_sym_d2:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_depends] := {g(dn,dn,pdn)}:
grG_ObjDef[g(dn,dn,pdn,pdn)][grC_attributes] := {use_diff_constraint_}:

grF_calc_gdndnpdnpdn := proc(object, index)
global gr_data, grG_metricName:
    diff(gr_data[gdndnpdn_,grG_metricName, a1_, a2_, a3_], gr_data[xup_,grG_metricName, a4_ ]):
end proc:

#----------------------------
# G(dn,dn)
#----------------------------
grG_ObjDef[G(dn,dn)][grC_header] := `Covariant Einstein`:
grG_ObjDef[G(dn,dn)][grC_root] := Gdndn_:
grG_ObjDef[G(dn,dn)][grC_rootStr] := `G `:
grG_ObjDef[G(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[G(dn,dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[G(dn,dn)][grC_calcFnParms] := gr_data[Rdndn_,grG_metricName,a1_,a2_]
	- 1/2*(gr_data[gdndn_,grG_metricName,a1_,a2_] * gr_data[scalarR_, grG_metricName]):
grG_ObjDef[G(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[G(dn,dn)][grC_depends] := {g(dn,dn), tRicciscalar, R(dn,dn)}:


#----------------------------
# R(dn,dn)  (DIRECT)
# - often faster to calcuate this than to contract Riemann (but not always)
#----------------------------
grG_ObjDef[R(dn,dn)][grC_header] := `Covariant Ricci`:
grG_ObjDef[R(dn,dn)][grC_root] := Rdndn_:
grG_ObjDef[R(dn,dn)][grC_rootStr] := `R `:
grG_ObjDef[R(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[R(dn,dn)][grC_calcFn] := grF_calc_RicciD:
grG_ObjDef[R(dn,dn)][grC_calcFnParms] := []:
grG_ObjDef[R(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[R(dn,dn)][grC_depends] := {Chr(dn,dn,up)}:
grG_ObjDef[R(dn,dn)][grC_attributes] := {use_diff_constraint_}:

grF_calc_RicciD := proc(object,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
global grG_metricName, Ndim, gr_data;

 s := 0:
 for a to Ndim[grG_metricName] do
   if not a2_ = a then
      s := s + diff(gr_data[Chrdndnup_,grG_metricName,a1_,a2_,a],gr_data[xup_,grG_metricName,a])
	     - diff(gr_data[Chrdndnup_,grG_metricName,a,a1_,a],gr_data[xup_,grG_metricName,a2_]):
   fi:
   for b to Ndim[grG_metricName] do
      s := s + gr_data[Chrdndnup_,grG_metricName,a1_,a2_,b] * gr_data[Chrdndnup_,grG_metricName,a,b,a]
	     - gr_data[Chrdndnup_,grG_metricName,a1_,a,b] * gr_data[Chrdndnup_,grG_metricName,b,a2_,a]:
   od:
 od:
end:

#----------------------------
# R(dn,dn,dn,dn)
#----------------------------
grG_ObjDef[R(dn,dn,dn,dn)][grC_header] := `Covariant Riemann`:
grG_ObjDef[R(dn,dn,dn,dn)][grC_root] := Rdndndndn_:
grG_ObjDef[R(dn,dn,dn,dn)][grC_rootStr] := `R `:
grG_ObjDef[R(dn,dn,dn,dn)][grC_indexList] := [dn,dn,dn,dn]:
grG_ObjDef[R(dn,dn,dn,dn)][grC_calcFn] := grF_calc_Riem:
grG_ObjDef[R(dn,dn,dn,dn)][grC_calcFnParms] := []:
grG_ObjDef[R(dn,dn,dn,dn)][grC_symmetry] := grF_sym_Riem:
grG_ObjDef[R(dn,dn,dn,dn)][grC_depends] := {g(dn,dn,pdn), Chr(dn,dn,dn), g(up,up)}:
grG_ObjDef[R(dn,dn,dn,dn)][grC_attributes] := {use_diff_constraint_}:


grF_calc_Riem := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local m,n,s:
global grG_metricName, gr_data;
 # can save total of 12 diff calls here (n=4)
 if (a1_ = a3_ and a2_ = a4_) then
    s := diff( gr_data[gdndnpdn_,grG_metricName,a1_,a2_,a2_], gr_data[xup_,grG_metricName,a1_]):
 else
    s := 1/2*(diff(gr_data[gdndnpdn_,grG_metricName,a1_,a4_,a2_] , gr_data[xup_,grG_metricName,a3_])
	  +  diff(gr_data[gdndnpdn_,grG_metricName,a2_,a3_,a1_] , gr_data[xup_,grG_metricName,a4_]) ):
 fi:
 if (a1_ = a4_ and a3_ = a2_) then
     s := s - diff(gr_data[gdndnpdn_,grG_metricName,a1_,a3_,a3_] , gr_data[xup_,grG_metricName,a1_] ):
 else
     s := s - 1/2*(diff(gr_data[gdndnpdn_,grG_metricName,a1_,a3_,a2_], gr_data[xup_,grG_metricName,a4_])
	    + diff(gr_data[gdndnpdn_,grG_metricName,a2_,a4_,a1_], gr_data[xup_,grG_metricName,a3_]) ):
 fi:
 for m to Ndim[grG_metricName] do
   for n to Ndim[grG_metricName] do
     s := s + gr_data[gupup_,grG_metricName,m,n]*
	  (gr_data[Chrdndndn_,grG_metricName,a1_,a4_,m] * gr_data[Chrdndndn_,grG_metricName,a2_,a3_,n]
	  - gr_data[Chrdndndn_,grG_metricName,a1_,a3_,m] * gr_data[Chrdndndn_,grG_metricName,a2_,a4_,n])
   od:
 od:
 s;
end:

#----------------------------
# R(up,up,dn,dn)
# since this is used explicitly in invars, define
# it explicitly
#----------------------------
grG_ObjDef[R(up,up,dn,dn)][grC_header] := `Mixed Riemann`:
grG_ObjDef[R(up,up,dn,dn)][grC_root] := Rupupdndn_:
grG_ObjDef[R(up,up,dn,dn)][grC_rootStr] := `R `:
grG_ObjDef[R(up,up,dn,dn)][grC_indexList] := [up,up,dn,dn]:
grG_ObjDef[R(up,up,dn,dn)][grC_calcFn] := grF_calc_sum2:
# raise indices
grG_ObjDef[R(up,up,dn,dn)][grC_calcFnParms] := 'gr_data[gupup_,grG_metricName,s1_,a1_]' * 'gr_data[gupup_,grG_metricName,s2_,a2_]' *
  'gr_data[Rdndndndn_,grG_metricName,s1_,s2_,a3_,a4_]':
grG_ObjDef[R(up,up,dn,dn)][grC_symmetry] := grF_sym_MRiem:
grG_ObjDef[R(up,up,dn,dn)][grC_depends] := {g(up,up), R(dn,dn,dn,dn)}:


#----------------------------
# Ricciscalar
#----------------------------
# temporarily leave a Ricciscalar record floating around so
# refs in spinors work - track these down and make them
# point to tRicciscalar later
grG_ObjDef[Ricciscalar][grC_header] := `Ricci scalar`:
grG_ObjDef[Ricciscalar][grC_root] := scalarR_:
grG_ObjDef[Ricciscalar][grC_rootStr] := `R `:
grG_ObjDef[Ricciscalar][grC_indexList] := []:
grG_ObjDef[Ricciscalar][grC_calcFn] := grF_calc_scalarR:
grG_ObjDef[Ricciscalar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ricciscalar][grC_depends] := {g(dn,dn), R(dn,dn)}:

grG_ObjDef[tRicciscalar][grC_header] := `Ricci scalar`:
grG_ObjDef[tRicciscalar][grC_root] := scalarR_:
grG_ObjDef[tRicciscalar][grC_rootStr] := `R `:
grG_ObjDef[tRicciscalar][grC_displayName] := Ricciscalar:
grG_ObjDef[tRicciscalar][grC_indexList] := []:
grG_ObjDef[tRicciscalar][grC_calcFn] := grF_calc_scalarR:
grG_ObjDef[tRicciscalar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[tRicciscalar][grC_depends] := {g(dn,dn), R(dn,dn)}:

grF_calc_scalarR := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s;
global grG_metricName, gr_data;
  s := 0;
  for a to Ndim[grG_metricName] do
    s := s + gr_data[gupup_,grG_metricName, a, a] * gr_data[Rdndn_,grG_metricName, a, a]:
    for b from a+1 to Ndim[grG_metricName] do
       s := s + 2 * gr_data[gupup_,grG_metricName, a, b] * gr_data[Rdndn_,grG_metricName, a, b]:
    od:
  od:
  RETURN( s):
end:



#----------------------------
# RicciSq
#----------------------------
grG_ObjDef[RicciSq][grC_header] := `Full Contraction of Ricci`:
grG_ObjDef[RicciSq][grC_root] := RicciSq_:
grG_ObjDef[RicciSq][grC_rootStr] := `RicciSq `:
grG_ObjDef[RicciSq][grC_indexList] := []:
grG_ObjDef[RicciSq][grC_calcFn] := grF_calc_RicciSq: # uses objectName to do WeylSq also!
grG_ObjDef[RicciSq][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[RicciSq][grC_depends] := {R(up,dn)}:

grF_calc_RicciSq := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local i,j,s;
global grG_metricName, gr_data;
   s := 0:
   for i to Ndim[grG_metricName] do
      s := s + gr_data[Rupdn_,grG_metricName,i,i] * gr_data[Rupdn_,grG_metricName,i,i]:
      for j from i+1 to Ndim[grG_metricName] do
	   s := s + 2 * gr_data[Rupdn_,grG_metricName,i,j] * gr_data[Rupdn_,grG_metricName,j,i]:
      od;
   od;
   RETURN(s):
end:

#----------------------------
# RiemSq
#----------------------------
grG_ObjDef[RiemSq][grC_header] := `Full Contraction of Riemann`:
grG_ObjDef[RiemSq][grC_root] := RiemSq_:
grG_ObjDef[RiemSq][grC_rootStr] := `K `:
grG_ObjDef[RiemSq][grC_indexList] := []:
grG_ObjDef[RiemSq][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[RiemSq][grC_calcFnParms] := Rdndnupup_,Rdndnupup_:
grG_ObjDef[RiemSq][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[RiemSq][grC_depends] := {R(dn,dn,up,up)}:

grF_calc_RiemSq := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,c,d,s,root1, root2;
global grG_metricName, gr_data;
#
# use two seperate roots to allow for the cmscalars W1R and W1I
#
 root1 := grG_ObjDef[object][grC_calcFnParms][1]:
 root2 := grG_ObjDef[object][grC_calcFnParms][2]:
    if Ndim[grG_metricName] = 4 and grG_fnCode = grC_CALC then

# explicit formula for N=4 & calc
 s :=
4*(gr_data[root1,grG_metricName,1,2,1,2]*gr_data[root2,grG_metricName,1,2,1,2]+
gr_data[root1,grG_metricName,1,2,1,3]*gr_data[root2,grG_metricName,1,3,1,2] +
gr_data[root1,grG_metricName,1,2,1,4]*gr_data[root2,grG_metricName,1,4,1,2] +
gr_data[root1,grG_metricName,1,2,2,3]*gr_data[root2,grG_metricName,2,3,1,2] +
gr_data[root1,grG_metricName,1,2,2,4]*gr_data[root2,grG_metricName,2,4,1,2] +
gr_data[root1,grG_metricName,1,2,3,4]*gr_data[root2,grG_metricName,3,4,1,2] +
gr_data[root1,grG_metricName,1,3,1,2]*gr_data[root2,grG_metricName,1,2,1,3] +
gr_data[root1,grG_metricName,1,3,1,3]*gr_data[root2,grG_metricName,1,3,1,3] +
gr_data[root1,grG_metricName,1,3,1,4]*gr_data[root2,grG_metricName,1,4,1,3] +
gr_data[root1,grG_metricName,2,4,1,2]*gr_data[root2,grG_metricName,1,2,2,4] +
gr_data[root1,grG_metricName,2,4,1,3]*gr_data[root2,grG_metricName,1,3,2,4] +
gr_data[root1,grG_metricName,2,4,1,4]*gr_data[root2,grG_metricName,1,4,2,4] +
gr_data[root1,grG_metricName,2,4,2,3]*gr_data[root2,grG_metricName,2,3,2,4] +
gr_data[root1,grG_metricName,2,4,2,4]*gr_data[root2,grG_metricName,2,4,2,4] +
gr_data[root1,grG_metricName,1,3,2,3]*gr_data[root2,grG_metricName,2,3,1,3] +
gr_data[root1,grG_metricName,1,3,2,4]*gr_data[root2,grG_metricName,2,4,1,3] +
gr_data[root1,grG_metricName,1,3,3,4]*gr_data[root2,grG_metricName,3,4,1,3] +
gr_data[root1,grG_metricName,1,4,1,2]*gr_data[root2,grG_metricName,1,2,1,4] +
gr_data[root1,grG_metricName,1,4,1,3]*gr_data[root2,grG_metricName,1,3,1,4] +
gr_data[root1,grG_metricName,1,4,1,4]*gr_data[root2,grG_metricName,1,4,1,4] +
gr_data[root1,grG_metricName,1,4,2,3]*gr_data[root2,grG_metricName,2,3,1,4] +
gr_data[root1,grG_metricName,1,4,2,4]*gr_data[root2,grG_metricName,2,4,1,4] +
gr_data[root1,grG_metricName,1,4,3,4]*gr_data[root2,grG_metricName,3,4,1,4] +
gr_data[root1,grG_metricName,2,3,1,2]*gr_data[root2,grG_metricName,1,2,2,3] +
gr_data[root1,grG_metricName,2,3,1,3]*gr_data[root2,grG_metricName,1,3,2,3] +
gr_data[root1,grG_metricName,2,3,1,4]*gr_data[root2,grG_metricName,1,4,2,3] +
gr_data[root1,grG_metricName,2,3,2,3]*gr_data[root2,grG_metricName,2,3,2,3] +
gr_data[root1,grG_metricName,2,3,2,4]*gr_data[root2,grG_metricName,2,4,2,3] +
gr_data[root1,grG_metricName,2,3,3,4]*gr_data[root2,grG_metricName,3,4,2,3] +
gr_data[root1,grG_metricName,2,4,3,4]*gr_data[root2,grG_metricName,3,4,2,4] +
gr_data[root1,grG_metricName,3,4,1,2]*gr_data[root2,grG_metricName,1,2,3,4] +
gr_data[root1,grG_metricName,3,4,1,3]*gr_data[root2,grG_metricName,1,3,3,4] +
gr_data[root1,grG_metricName,3,4,1,4]*gr_data[root2,grG_metricName,1,4,3,4] +
gr_data[root1,grG_metricName,3,4,2,3]*gr_data[root2,grG_metricName,2,3,3,4] +
gr_data[root1,grG_metricName,3,4,2,4]*gr_data[root2,grG_metricName,2,4,3,4] +
gr_data[root1,grG_metricName,3,4,3,4]*gr_data[root2,grG_metricName,3,4,3,4]):

    else
    # use this for calcAlter or Ndim != 4
        lprint(`Debug-using the long definition`):
	s := 0;
	for a to Ndim[grG_metricName] - 1 do
	  for b from a+1 to Ndim[grG_metricName] do
	    for c to Ndim[grG_metricName] - 1 do
	      for d from c+1 to Ndim[grG_metricName] do
		s := s + 4 * gr_data[root1,grG_metricName,a,b,c,d]* gr_data[root2,grG_metricName,c,d,a,b];
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
grG_ObjDef[S(dn,dn)][grC_header] := `Covariant trace-free Ricci`:
grG_ObjDef[S(dn,dn)][grC_root] := Sdndn_:
grG_ObjDef[S(dn,dn)][grC_rootStr] := `S `:
grG_ObjDef[S(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[S(dn,dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[S(dn,dn)][grC_calcFnParms] :=
	'gr_data[Rdndn_,grG_metricName,a1_,a2_]' -
	(1/Ndim[grG_metricName])*'gr_data[gdndn_,grG_metricName,a1_,a2_] * gr_data[scalarR_,grG_metricName]':
grG_ObjDef[S(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[S(dn,dn)][grC_depends] := {R(dn,dn), g(dn,dn), tRicciscalar}:

#----------------------------
# WeylSq
#----------------------------
grG_ObjDef[WeylSq][grC_header] := `Full Contraction of Weyl`:
grG_ObjDef[WeylSq][grC_root] := WeylSq_:
grG_ObjDef[WeylSq][grC_rootStr] := `WeylSq `:
grG_ObjDef[WeylSq][grC_indexList] := []:
grG_ObjDef[WeylSq][grC_calcFn] := grF_calc_RiemSq: # uses parms to do WeylSq also
grG_ObjDef[WeylSq][grC_calcFnParms] := Cdndnupup_,Cdndnupup_:
grG_ObjDef[WeylSq][grC_symmetry] := grF_sym_scalar:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[WeylSq][grC_depends] := {C(dn,dn,up,up)}:

#----------------------------
# x(up)
#----------------------------
grG_ObjDef[x(up)][grC_header] := `Coordinates`:
grG_ObjDef[x(up)][grC_root] := xup_:
grG_ObjDef[x(up)][grC_rootStr] := `x `:
grG_ObjDef[x(up)][grC_indexList] := [up]:
grG_ObjDef[x(up)][grC_calcFn] := grF_calc_NULL: # assigned by grload
grG_ObjDef[x(up)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[x(up)][grC_depends] := {}:


