#*************************************************************************
#
# GRTENSOR II MODULE: JMspin.mpl
#
# (C) 1992-1994 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: March 10, 1995
#
#  4 Feb 97  Replace 0,0 checks with checkIfAssigned.
#  5 Feb 97  Use conj() to calculate complex conjugates [dp]
#
#*************************************************************************

#===================================================================
#
# Object definitions.
#
#===================================================================

#----------------------------
# Determinant of the basis matrix.
#----------------------------
grG_ObjDef[detb][grC_header] := `Determinant of the basis`:
grG_ObjDef[detb][grC_root] := detb_:
grG_ObjDef[detb][grC_rootStr] := `b `:
grG_ObjDef[detb][grC_indexList] := []:
grG_ObjDef[detb][grC_preCalcFn] := grF_calc_detb:
grG_ObjDef[detb][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[detb][grC_depends] := { }:

grF_calc_detb := proc(object)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local	a, b, A, root:
global grG_MetricName, gr_data;

	if grF_checkIfAssigned(e(bdn,up), grG_metricName) then
		root := ebdnup_:
	elif grF_checkIfAssigned(e(bup,dn), grG_metricName) then
		root := ebupdn_:
	elif grF_checkIfAssigned(e(bdn,dn), grG_metricName) then
		grF_core ( e(bup,dn), true ):
		root := ebupdn_:
	elif grF_checkIfAssigned(e(bup,up), grG_metricName) then
		grF_core ( e(bdn,up), true ):
		root := ebdnup_:
	else
		ERROR ( `A basis must be defined in order to calculate this object.` ):
	fi:
	A := linalg[matrix] ( Ndim[grG_metricName], Ndim[grG_metricName] ):
	for a to Ndim[grG_metricName] do
		for b to Ndim[grG_metricName] do
			A[a,b] := gr_data[root,grG_metricName,a,b]:
		od:
	od:
	gr_data[detb_,grG_metricName] := linalg[det] ( A ):
	if root = ebupdn_ then
		gr_data[detb_,grG_metricName] := 1/gr_data[detb_,grG_metricName]:
	fi:
end:

#-------------------------------------------------------------------
# Jacobi-McLenaghan algorithm for lambda(bdn,bdn,bdn).
#-------------------------------------------------------------------
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_header] := `pre-Rotation Coefficients`:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_root] := lambdabdnbdnbdn_:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_rootStr] := `lambda`:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_calcFn] := grF_calc_Clambdabdnbdnbdn:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a13:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_attributes] := {use_diff_constraint_}:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_calcFn] := grF_calc_Clambdabdnbdnbdn:
grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_depends] := { e(bup,dn), e(bdn,dn,pdn), LevCS(up,up,up,up), detb }:
#grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_displayName] := lambda(bdn,bdn,bdn):
#grG_ObjDef[Clambda(bdn,bdn,bdn)][grC_useWhen] := grF_when_Clambdabdnbdnbdn:

grF_when_Clambdabdnbdnbdn := proc()
	if grF_checkIfAssigned ( e(bdn,dn) ) then
		true:
	else
		false:
	fi:
end:

grF_calc_Clambdabdnbdnbdn := proc( object, list)
local	a, b, c, d, e, f, s:
global grG_MetricName, gr_data;
  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      if b<>a then for c to Ndim[grG_metricName] do
        if c<>a and c<>b then for d to Ndim[grG_metricName] do
          if d<>a and d<>b and d<>c then for e to Ndim[grG_metricName] do
            if e<>a1_ and e<>a3_ then for f to Ndim[grG_metricName] do
              if f<>e and f<>a1_ and f<>a3_ then
                s := s + gr_data[ebdndnpdn_,grG_metricName,a2_,a,b]*
		  gr_data[LevCSupupupup_,grG_metricName,a,b,c,d]*
		  gr_data[LevCSupupupup_,grG_metricName,a1_,a3_,e,f]*
		  gr_data[ebupdn_,grG_metricName,e,c]*gr_data[ebupdn_,grG_metricName,f,d]:
              fi:
            od fi:
          od fi:
        od fi:
      od fi:
    od:
  od:
 RETURN(s*gr_data[detb_,grG_metricName]/2):
end:

#-------------------------------------------------------------------
# Alternate definition for rotation coefficients in terms of Clambda.
#-------------------------------------------------------------------
grG_ObjDef[Crot(bdn,bdn,bdn)][grC_displayName] := rot(bdn,bdn,bdn):
grG_ObjDef[Crot(bdn,bdn,bdn)][grC_calcFn] := grF_calc_Crotbdnbdnbdn:
grG_ObjDef[Crot(bdn,bdn,bdn)][grC_useWhen] := grF_when_Crotbdnbdnbdn:
grG_ObjDef[Crot(bdn,bdn,bdn)][grC_depends] := { Clambda(bdn,bdn,bdn) }:

grF_when_Crotbdnbdnbdn := proc()
	if grF_checkIfAssigned ( Clambda(bdn,bdn,bdn) ) then
		true:
	else
		false:
	fi:
end:

grF_calc_Crotbdnbdnbdn := proc(object, index)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global grG_MetricName, gr_data;
local s:
	s := (gr_data[Clambdabdnbdnbdn_,grG_metricName,a1_,a2_,a3_]
            + gr_data[Clambdabdnbdnbdn_,grG_metricName,a3_,a1_,a2_]
            - gr_data[Clambdabdnbdnbdn_,grG_metricName,a2_,a3_,a1_])/2:
RETURN(s):
end:

