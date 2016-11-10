#*********************************************************
#
# GRTENSOR II MODULE: Dcurve.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: March 10 , 1995
#
# Curvature coefficients as calculated via the Debever
# formalism. See McLenaghan's Brazilian School notes.
#
# Created: March 10, 1995.
#
#  4 Feb 97  Change 0,0 check to checkIfAssigned [dp]
#  5 Feb 97  Use conj() to calculate complex conjugates [dp]
#
#*********************************************************


$define v    ebdndn_ 
$define dv   ebdndnpdn_ 
$define cp   DCFpdn_ 
$define cq   DCFqdn_ 
$define cr   DCFrdn_ 
$define dcp  DCFpdnpdn_ 
$define dcq  DCFqdnpdn_ 
$define dcr  DCFrdnpdn_ 
$define LCS  LevCSupupupup_ 
$define Detb gr_data[detb_,grG_metricName] 

$define ld  1 
$define nd  2 
$define md  3 
$define bd  4 
$define n1  1 
$define n2  3 
$define n3  4 
$define n4  2 

$define  Sk  gr_data[NPkappa_,grG_metricName] 
$define  Ss  gr_data[NPsigma_,grG_metricName] 
$define  Sr  gr_data[NPrho_,grG_metricName] 
$define  Sm  gr_data[NPmu_,grG_metricName] 
$define  St  gr_data[NPtau_,grG_metricName] 
$define  Sp  gr_data[NPpi_,grG_metricName] 
$define  Sn  gr_data[NPnu_,grG_metricName] 
$define  Sl  gr_data[NPlambda_,grG_metricName] 
$define  Sg  gr_data[NPgamma_,grG_metricName] 
$define  Sa  gr_data[NPalpha_,grG_metricName] 
$define  Sb  gr_data[NPbeta_,grG_metricName] 
$define  Se  gr_data[NPepsilon_,grG_metricName] 



Dcurve := proc()
	lprint ( `Curvature coefficients via Debever's formalism.` ):
	lprint ( `Last modified: March 9, 1995` ):
end:

#-----------------------------
# Debever connection forms, sigma.
#-----------------------------
grG_ObjDef[DCF(bup,bup)][grC_header] := `Debever connection forms, sigma(a,b)`:
grG_ObjDef[DCF(bup,bup)][grC_root] := DCFbupbup_:
grG_ObjDef[DCF(bup,bup)][grC_rootStr] := `sigma`:
grG_ObjDef[DCF(bup,bup)][grC_indexList] := [bup,bup]:
grG_ObjDef[DCF(bup,bup)][grC_calcFn] := grF_calc_DCF:
grG_ObjDef[DCF(bup,bup)][grC_preCalcFn] := grF_precalc_DCF:
grG_ObjDef[DCF(bup,bup)][grC_calcFnParms] := [NULL]:
grG_ObjDef[DCF(bup,bup)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[DCF(bup,bup)][grC_depends] := { Cnu,Ctau,Cgamma,Clambda,Crho,Calpha,Cmu,Csigma,
			Cbeta,Cpi,Ckappa,Cepsilon }:

grF_precalc_DCF := proc(object)
global 	gr_data, grG_metricName, Ndim:
local	a:
	gr_data[DCFbupbup_,grG_metricName, 1, n1] := -2*gr_data[NPnu_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 2, n1] := -2*gr_data[NPtau_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 3, n1] := -2*gr_data[NPgamma_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 1, n2] :=  2*gr_data[NPlambda_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 2, n2] :=  2*gr_data[NPrho_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 3, n2] :=  2*gr_data[NPalpha_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 1, n3] :=  2*gr_data[NPmu_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 2, n3] :=  2*gr_data[NPsigma_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 3, n3] :=  2*gr_data[NPbeta_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 1, n4] := -2*gr_data[NPpi_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 2, n4] := -2*gr_data[NPkappa_,grG_metricName]:
	gr_data[DCFbupbup_,grG_metricName, 3, n4] := -2*gr_data[NPepsilon_,grG_metricName]:
	for a to 4 do
		gr_data[DCFbupbup_,grG_metricName,4,a] := 0:
	od:
	grF_assignedFlag ( DCF(bup,bup), set ):
end:

grF_calc_DCF := proc(object,index)
local	s:
	s := gr_data[DCFbupbup_,grG_metricName,a1_,a2_]:
RETURN(s):
end:

#-----------------------------
# Basis projection of Debever connection form 1.
#-----------------------------
grG_ObjDef[DCFp(dn)][grC_header] := `Debever connection form, p`:
grG_ObjDef[DCFp(dn)][grC_root] := DCFpdn_:
grG_ObjDef[DCFp(dn)][grC_rootStr] := `p `:
grG_ObjDef[DCFp(dn)][grC_indexList] := [dn]:
grG_ObjDef[DCFp(dn)][grC_calcFn] := grF_calc_DCFpdn:
grG_ObjDef[DCFp(dn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[DCFp(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[DCFp(dn)][grC_depends] := { e(bdn,dn), DCF(bup,bup) }:

grF_calc_DCFpdn := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local	a, s:
	s := 0:
	for a to Ndim[grG_metricName] do
		s := s + gr_data[DCFbupbup_,grG_metricName,1,a]*gr_data[ebdndn_,grG_metricName,a,a1_]:
	od:
RETURN(s):
end:

#-----------------------------
# Basis projection of Debever connection form 2.
#-----------------------------
grG_ObjDef[DCFq(dn)][grC_header] := `Debever connection form, q`:
grG_ObjDef[DCFq(dn)][grC_root] := DCFqdn_:
grG_ObjDef[DCFq(dn)][grC_rootStr] := `q `:
grG_ObjDef[DCFq(dn)][grC_indexList] := [dn]:
grG_ObjDef[DCFq(dn)][grC_calcFn] := grF_calc_DCFqdn:
grG_ObjDef[DCFq(dn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[DCFq(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[DCFq(dn)][grC_depends] := { e(bdn,dn), DCF(bup,bup) }:

grF_calc_DCFqdn := proc(object,index)
global 	gr_data, grG_metricName, Ndim:
local	a, s:
	s := 0:
	for a to Ndim[grG_metricName] do
		s := s + gr_data[DCFbupbup_,grG_metricName,2,a]*gr_data[ebdndn_,grG_metricName,a,a1_]:
	od:
RETURN(s):
end:

#-----------------------------
# Basis projection of Debever connection form 3.
#-----------------------------
grG_ObjDef[DCFr(dn)][grC_header] := `Debever connection form, r`:
grG_ObjDef[DCFr(dn)][grC_root] := DCFrdn_:
grG_ObjDef[DCFr(dn)][grC_rootStr] := `r `:
grG_ObjDef[DCFr(dn)][grC_indexList] := [dn]:
grG_ObjDef[DCFr(dn)][grC_calcFn] := grF_calc_DCFrdn:
grG_ObjDef[DCFr(dn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[DCFr(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[DCFr(dn)][grC_depends] := { e(bdn,dn), DCF(bup,bup) }:

grF_calc_DCFrdn := proc(object,index)
global 	gr_data, grG_metricName, Ndim:
local	a, s:
	s := 0:
	for a to Ndim[grG_metricName] do
		s := s + gr_data[DCFbupbup_,grG_metricName,3,a]*gr_data[ebdndn_,grG_metricName,a,a1_]:
	od:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi0
#-----------------------------
grG_ObjDef[CPsi0][grC_header] := `Weyl Scalar, Psi0`:
grG_ObjDef[CPsi0][grC_root] := Psi0_:
grG_ObjDef[CPsi0][grC_rootStr] := `Psi0`:
grG_ObjDef[CPsi0][grC_indexList] := []:
grG_ObjDef[CPsi0][grC_calcFn] := grF_calc_CPsi0:
grG_ObjDef[CPsi0][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPsi0][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi0][grC_depends] := { Cbeta, Ckappa, Cepsilon, Csigma, DCFq(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPsi0 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,ld,k]*
			gr_data[v,grG_metricName,md,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sb*Sk - Se*Ss)*2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi0
#-----------------------------
grG_ObjDef[CPsi0bar][grC_header] := `Weyl Scalar, Psi0bar`:
grG_ObjDef[CPsi0bar][grC_root] := Psi0bar_:
grG_ObjDef[CPsi0bar][grC_rootStr] := `Psi0bar`:
grG_ObjDef[CPsi0bar][grC_indexList] := []:
grG_ObjDef[CPsi0bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPsi0bar][grC_calcFnParms] := [Psi0]:
grG_ObjDef[CPsi0bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi0bar][grC_depends] := { CPsi0 }:

#-----------------------------
# Curvature coefficient: Psi1
#-----------------------------
grG_ObjDef[CPsi1][grC_header] := `Weyl Scalar, Psi1`:
grG_ObjDef[CPsi1][grC_root] := Psi1_:
grG_ObjDef[CPsi1][grC_rootStr] := `Psi1`:
grG_ObjDef[CPsi1][grC_indexList] := []:
grG_ObjDef[CPsi1][grC_calcFn] := grF_calc_CPsi1:
grG_ObjDef[CPsi1][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPsi1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi1][grC_depends] := { Cpi, Csigma, Ckappa, Cmu, DCFr(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPsi1 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,ld,k]*
			gr_data[v,grG_metricName,md,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 - Sp*Ss + Sk*Sm:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi1bar
#-----------------------------
grG_ObjDef[CPsi1][grC_header] := `Weyl Scalar, Psi1bar`:
grG_ObjDef[CPsi1][grC_root] := Psi1bar_:
grG_ObjDef[CPsi1][grC_rootStr] := `Psi1bar`:
grG_ObjDef[CPsi1][grC_indexList] := []:
grG_ObjDef[CPsi1][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPsi1][grC_calcFnParms] := [Psi1]:
grG_ObjDef[CPsi1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi1][grC_depends] := { Psi1 }:

#-----------------------------
# Curvature coefficient: Psi2
#-----------------------------
grG_ObjDef[CPsi2][grC_header] := `Weyl Scalar, Psi2`:
grG_ObjDef[CPsi2][grC_root] := Psi2_:
grG_ObjDef[CPsi2][grC_rootStr] := `Psi2`:
grG_ObjDef[CPsi2][grC_indexList] := []:
grG_ObjDef[CPsi2][grC_calcFn] := grF_calc_CPsi2:
grG_ObjDef[CPsi2][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPsi2][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi2][grC_depends] := { Cmu, Crho, Clambda, Csigma, Cpi, Ctau, Ckappa, Cnu,
			Cgamma, Calpha, DCFq(dn,pdn), detb, LevCS(up,up,up,up), DCFr(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPsi2 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*(
			gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,ld,k]*gr_data[v,grG_metricName,nd,l] -
			gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,md,k]*gr_data[v,grG_metricName,bd,l] +
			gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,bd,k]*gr_data[v,grG_metricName,nd,l] ):

	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/6 + (Sm*Sr - Sl*Ss - Sp*St + Sk*Sn + 2*Sg*Sr - 2*Sa*St )/3:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi2bar
#-----------------------------
grG_ObjDef[CPsi2bar][grC_header] := `Weyl Scalar, Psi2bar`:
grG_ObjDef[CPsi2bar][grC_root] := Psi2bar_:
grG_ObjDef[CPsi2bar][grC_rootStr] := `Psi2bar`:
grG_ObjDef[CPsi2bar][grC_indexList] := []:
grG_ObjDef[CPsi2bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPsi2bar][grC_calcFnParms] := [CPsi2]:
grG_ObjDef[CPsi2bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi2bar][grC_depends] := { CPsi2 }:

#-----------------------------
# Curvature coefficient: Psi3
#-----------------------------
grG_ObjDef[CPsi3][grC_header] := `Weyl Scalar, Psi3`:
grG_ObjDef[CPsi3][grC_root] := Psi3_:
grG_ObjDef[CPsi3][grC_rootStr] := `Psi3`:
grG_ObjDef[CPsi3][grC_indexList] := []:
grG_ObjDef[CPsi3][grC_calcFn] := grF_calc_CPsi3:
grG_ObjDef[CPsi3][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPsi3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi3][grC_depends] := { Clambda, Ctau, Cnu, Crho, DCFr(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPsi3 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,bd,k]*
			gr_data[v,grG_metricName,nd,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 - Sl*St + Sn*Sr:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi3bar
#-----------------------------
grG_ObjDef[CPsi3bar][grC_header] := `Weyl Scalar, Psi3bar`:
grG_ObjDef[CPsi3bar][grC_root] := Psi3bar_:
grG_ObjDef[CPsi3bar][grC_rootStr] := `Psi3bar`:
grG_ObjDef[CPsi3bar][grC_indexList] := []:
grG_ObjDef[CPsi3bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPsi3bar][grC_calcFnParms] := [CPsi3]:
grG_ObjDef[CPsi3bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi3bar][grC_depends] := { CPsi3 }:

#-----------------------------
# Curvature coefficient: Psi4
#-----------------------------
grG_ObjDef[CPsi4][grC_header] := `Weyl Scalar, Psi4`:
grG_ObjDef[CPsi4][grC_root] := Psi4_:
grG_ObjDef[CPsi4][grC_rootStr] := `Psi4`:
grG_ObjDef[CPsi4][grC_indexList] := []:
grG_ObjDef[CPsi4][grC_calcFn] := grF_calc_CPsi4:
grG_ObjDef[CPsi4][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPsi4][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi4][grC_depends] := { Calpha, Cnu, Cgamma, Clambda, DCFp(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPsi4 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*dcp[grG_metricName,i,j]*gr_data[v,grG_metricName,bd,k]*
			gr_data[v,grG_metricName,nd,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sa*Sn - Sg*Sl)*2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Psi4bar
#-----------------------------
grG_ObjDef[CPsi4bar][grC_header] := `Weyl Scalar, Psi4bar`:
grG_ObjDef[CPsi4bar][grC_root] := Psi4bar_:
grG_ObjDef[CPsi4bar][grC_rootStr] := `Psi4bar`:
grG_ObjDef[CPsi4bar][grC_indexList] := []:
grG_ObjDef[CPsi4bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPsi4bar][grC_calcFnParms] := [CPsi4]:
grG_ObjDef[CPsi4bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPsi4bar][grC_depends] := { CPsi4 }:

#-----------------------------
# Curvature coefficient: Phi00
#-----------------------------
grG_ObjDef[CPhi00][grC_header] := `Ricci Scalar, Phi00`:
grG_ObjDef[CPhi00][grC_root] := NPPhi00_:
grG_ObjDef[CPhi00][grC_rootStr] := `Phi00`:
grG_ObjDef[CPhi00][grC_indexList] := []:
grG_ObjDef[CPhi00][grC_calcFn] := grF_calc_CPhi00:
grG_ObjDef[CPhi00][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi00][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi00][grC_depends] := { Calpha, Ckappa, Cepsilon, Crho, DCFq(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPhi00 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,bd,k]*
			gr_data[v,grG_metricName,ld,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sa*Sk - Se*Sr)*2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Phi01
#-----------------------------
grG_ObjDef[CPhi01][grC_header] := `Ricci Scalar, Phi01`:
grG_ObjDef[CPhi01][grC_root] := NPPhi01_:
grG_ObjDef[CPhi01][grC_rootStr] := `Phi01`:
grG_ObjDef[CPhi01][grC_indexList] := []:
grG_ObjDef[CPhi01][grC_calcFn] := grF_calc_CPhi01:
grG_ObjDef[CPhi01][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi01][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi01][grC_depends] := { Ckappa, Cepsilon, Cgamma, Ctau, DCFq(dn,pdn), CPsi1, detb, LevCS(up,up,up,up) }:
grF_calc_CPhi01 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,md,k]*
			gr_data[v,grG_metricName,bd,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := -Detb*s/2 + (Sg*Sk - Se*St)*2 - gr_data[Psi1_,grG_metricName]:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Phi02
#-----------------------------
grG_ObjDef[CPhi02][grC_header] := `Ricci Scalar, Phi02`:
grG_ObjDef[CPhi02][grC_root] := NPPhi02_:
grG_ObjDef[CPhi02][grC_rootStr] := `Phi02`:
grG_ObjDef[CPhi02][grC_indexList] := []:
grG_ObjDef[CPhi02][grC_calcFn] := grF_calc_CPhi02:
grG_ObjDef[CPhi02][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi02][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi02][grC_depends] := { Cgamma, Csigma, Cbeta, Ctau, DCFq(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPhi02 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,nd,k]*
			gr_data[v,grG_metricName,md,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sg*Ss - Sb*St)*2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Phi10
#-----------------------------
grG_ObjDef[CPhi10][grC_header] := `Ricci Scalar, Phi10`:
grG_ObjDef[CPhi10][grC_root] := NPPhi10_:
grG_ObjDef[CPhi10][grC_rootStr] := `Phi10`:
grG_ObjDef[CPhi10][grC_indexList] := []:
grG_ObjDef[CPhi10][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPhi10][grC_calcFnParms] := [CPhi01]:
grG_ObjDef[CPhi10][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi10][grC_depends] := { CPhi01 }:

#-----------------------------
# Curvature coefficient: Phi11
#-----------------------------
grG_ObjDef[CPhi11][grC_header] := `Ricci Scalar, Phi11`:
grG_ObjDef[CPhi11][grC_root] := NPPhi11_:
grG_ObjDef[CPhi11][grC_rootStr] := `Phi11`:
grG_ObjDef[CPhi11][grC_indexList] := []:
grG_ObjDef[CPhi11][grC_calcFn] := grF_calc_CPhi11:
grG_ObjDef[CPhi11][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi11][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi11][grC_depends] := { Cpi, Ctau, Ckappa, Cnu, Crho, Cmu, Clambda, Csigma, DCFr(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPhi11 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcr,grG_metricName,i,j]*
			( gr_data[v,grG_metricName,md,k]*gr_data[v,grG_metricName,bd,l] +
			  gr_data[v,grG_metricName,ld,k]*gr_data[v,grG_metricName,nd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := -Detb*s/4 - ( Sp*St - Sk*Sn + Sr*Sm - Sl*Ss )/2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Phi12
#-----------------------------
grG_ObjDef[CPhi12][grC_header] := `Ricci Scalar, Phi12`:
grG_ObjDef[CPhi12][grC_root] := NPPhi12_:
grG_ObjDef[CPhi12][grC_rootStr] := `Phi12`:
grG_ObjDef[CPhi12][grC_indexList] := []:
grG_ObjDef[CPhi12][grC_calcFn] := grF_calc_CPhi12:
grG_ObjDef[CPhi12][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi12][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi12][grC_depends] := { Cnu, Csigma, Cmu, Ctau, DCFr(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPhi12 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,nd,k]*
			gr_data[v,grG_metricName,md,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sn*Ss - Sm*St): # *2 on last term
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: Phi20
#-----------------------------
grG_ObjDef[CPhi20][grC_header] := `Ricci Scalar, Phi20`:
grG_ObjDef[CPhi20][grC_root] := NPPhi20_:
grG_ObjDef[CPhi20][grC_rootStr] := `Phi20`:
grG_ObjDef[CPhi20][grC_indexList] := []:
grG_ObjDef[CPhi20][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPhi20][grC_calcFnParms] := [CPhi02]:
grG_ObjDef[CPhi20][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi20][grC_depends] := { CPhi02 }:

#-----------------------------
# Curvature coefficient: Phi21
#-----------------------------
grG_ObjDef[CPhi21][grC_header] := `Ricci Scalar, Phi21`:
grG_ObjDef[CPhi21][grC_root] := NPPhi21_:
grG_ObjDef[CPhi21][grC_rootStr] := `Phi21`:
grG_ObjDef[CPhi21][grC_indexList] := []:
grG_ObjDef[CPhi21][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[CPhi21][grC_calcFnParms] := [CPhi21]:
grG_ObjDef[CPhi21][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi21][grC_depends] := { CPhi21 }:

#-----------------------------
# Curvature coefficient: Phi22
#-----------------------------
grG_ObjDef[CPhi22][grC_header] := `Ricci Scalar, Phi22`:
grG_ObjDef[CPhi22][grC_root] := NPPhi22_:
grG_ObjDef[CPhi22][grC_rootStr] := `Phi22`:
grG_ObjDef[CPhi22][grC_indexList] := []:
grG_ObjDef[CPhi22][grC_calcFn] := grF_calc_CPhi22:
grG_ObjDef[CPhi22][grC_calcFnParms] := [NULL]:
grG_ObjDef[CPhi22][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CPhi22][grC_depends] := { Cnu, Cbeta, Cmu, Cgamma, DCFp(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_CPhi22 := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*dcp[grG_metricName,i,j]*gr_data[v,grG_metricName,nd,k]*
			gr_data[v,grG_metricName,md,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := Detb*s/2 + (Sn*Sb - Sm*Sg)*2:
RETURN(s):
end:

#-----------------------------
# Curvature coefficient: CRicci
#-----------------------------
grG_ObjDef[CRicci][grC_header] := `NPLambda := Ricci Scalar/24`:
grG_ObjDef[CRicci][grC_root] := NPLambda_:
grG_ObjDef[CRicci][grC_rootStr] := `NPLambda`:
grG_ObjDef[CRicci][grC_indexList] := []:
grG_ObjDef[CRicci][grC_calcFn] := grF_calc_DRicci:
grG_ObjDef[CRicci][grC_calcFnParms] := [NULL]:
grG_ObjDef[CRicci][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[CRicci][grC_depends] := { Cpi, Ctau, Ckappa, Cnu, Crho, Cmu, Clambda, Csigma, Cgamma, Calpha, DCFr(dn,pdn), DCFq(dn,pdn), detb, LevCS(up,up,up,up) }:
grF_calc_DRicci := proc(object, index)
global 	gr_data, grG_metricName, Ndim:
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,grG_metricName,i,j,k,l]*(
			gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,md,k]*gr_data[v,grG_metricName,bd,l] -
			gr_data[dcr,grG_metricName,i,j]*gr_data[v,grG_metricName,ld,k]*gr_data[v,grG_metricName,nd,l] +
		      2*gr_data[dcq,grG_metricName,i,j]*gr_data[v,grG_metricName,bd,k]*gr_data[v,grG_metricName,nd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := 2*Detb*s + (Sp*St - Sk*Sn - Sr*Sm + Sl*Ss + (Sg*Sr-Sa*St)*4 )*4:
RETURN(s/24):
end:

$undef v   
$undef dv  
$undef cp  
$undef cq  
$undef cr  
$undef dcp 
$undef dcq 
$undef dcr 
$undef LCS 
$undef Detb

$undef ld  
$undef nd  
$undef md  
$undef bd  
$undef n1  
$undef n2  
$undef n3  
$undef n4  

$undef  Sk 
$undef  Ss 
$undef  Sr 
$undef  Sm 
$undef  St 
$undef  Sp 
$undef  Sn 
$undef  Sl 
$undef  Sg 
$undef  Sa 
$undef  Sb 
$undef  Se 



