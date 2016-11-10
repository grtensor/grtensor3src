#*********************************************************
#
# GRTENSOR II MODULE: DSpinlib.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: March 10 1995
#
# NP spin coefficients as calculated via the Debever
# formalism. See McLenaghan's Brazilian School notes.
#
# Created: March 10, 1995.
#
#  5 Feb 97  Use conj() to calculate complex conjugates [dp]
#
#*********************************************************

$define gname  grG_metricName  
$define v      ebdndn_      
$define dv     ebdndnpdn_   
$define LCS    LevCSupupupup_       
$define Detb   gr_data[detb_,grG_metricName] 
$define ld     1 
$define nd     2 
$define md     3 
$define bd     4 


#-----------------------------
# NP spin coefficient: kappa
#-----------------------------
grG_ObjDef[Ckappa][grC_header] := `NP Spin Coefficient, kappa`:
grG_ObjDef[Ckappa][grC_root] := NPkappa_:
grG_ObjDef[Ckappa][grC_rootStr] := `kappa`:
grG_ObjDef[Ckappa][grC_indexList] := []:
grG_ObjDef[Ckappa][grC_calcFn] := grF_calc_Ckappa:
grG_ObjDef[Ckappa][grC_calcFnParms] := [NULL]:
grG_ObjDef[Ckappa][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ckappa][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Ckappa := proc(object, index)
local i,j,k,l,s:
global Ndim, grG_metricName, gr_data;
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[dv,gname,ld,i,j]*gr_data[v,gname,md,k]*
			gr_data[v,gname,ld,l]*gr_data[LCS,gname,i,j,k,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(Detb*s):
end:

#-----------------------------
# NP spin coefficient: sigma
#-----------------------------
grG_ObjDef[Csigma][grC_header] := `NP Spin Coefficient, sigma`:
grG_ObjDef[Csigma][grC_root] := NPsigma_:
grG_ObjDef[Csigma][grC_rootStr] := `sigma`:
grG_ObjDef[Csigma][grC_indexList] := []:
grG_ObjDef[Csigma][grC_calcFn] := grF_calc_Csigma:
grG_ObjDef[Csigma][grC_calcFnParms] := [NULL]:
grG_ObjDef[Csigma][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Csigma][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Csigma := proc(object, index)
local i,j,k,l,s:
global Ndim, grG_metricName, gr_data;
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[dv,gname,md,i,j]*gr_data[v,gname,ld,k]*
			gr_data[v,gname,md,l]*gr_data[LCS,gname,i,j,k,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(-Detb*s):
end:

#-----------------------------
# NP spin coefficient: lambda
#-----------------------------
grG_ObjDef[Clambda][grC_header] := `NP Spin Coefficient, lambda`:
grG_ObjDef[Clambda][grC_root] := NPlambda_:
grG_ObjDef[Clambda][grC_rootStr] := `lambda`:
grG_ObjDef[Clambda][grC_indexList] := []:
grG_ObjDef[Clambda][grC_calcFn] := grF_calc_Clambda:
grG_ObjDef[Clambda][grC_calcFnParms] := [NULL]:
grG_ObjDef[Clambda][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Clambda][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Clambda := proc(object, index)
local i,j,k,l,s:
global Ndim, grG_metricName, gr_data;
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[dv,gname,bd,i,j]*gr_data[v,gname,nd,k]*
			gr_data[v,gname,bd,l]*gr_data[LCS,gname,i,j,k,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(Detb*s):
end:

#-----------------------------
# NP spin coefficient: nu
#-----------------------------
grG_ObjDef[Cnu][grC_header] := `NP Spin Coefficient, nu`:
grG_ObjDef[Cnu][grC_root] := NPnu_:
grG_ObjDef[Cnu][grC_rootStr] := `nu`:
grG_ObjDef[Cnu][grC_indexList] := []:
grG_ObjDef[Cnu][grC_calcFn] := grF_calc_Cnu:
grG_ObjDef[Cnu][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cnu][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cnu][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Cnu := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[dv,gname,nd,i,j]*gr_data[v,gname,bd,k]*
			gr_data[v,gname,nd,l]*gr_data[LCS,gname,i,j,k,l]:
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(-Detb*s):
end:

#-----------------------------
# NP spin coefficient: rho
#-----------------------------
grG_ObjDef[Crho][grC_header] := `NP Spin Coefficient, rho`:
grG_ObjDef[Crho][grC_root] := NPrho_:
grG_ObjDef[Crho][grC_rootStr] := `rho`:
grG_ObjDef[Crho][grC_indexList] := []:
grG_ObjDef[Crho][grC_calcFn] := grF_calc_Crho:
grG_ObjDef[Crho][grC_calcFnParms] := [NULL]:
grG_ObjDef[Crho][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Crho][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Crho := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,ld,i,j]*gr_data[v,gname,nd,k]*gr_data[v,gname,ld,l] -
			gr_data[dv,gname,md,i,j]*gr_data[v,gname,bd,k]*gr_data[v,gname,ld,l] +
			gr_data[dv,gname,bd,i,j]*gr_data[v,gname,md,k]*gr_data[v,gname,ld,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(Detb*s/2):
end:

#-----------------------------
# NP spin coefficient: mu
#-----------------------------
grG_ObjDef[Cmu][grC_header] := `NP Spin Coefficient, mu`:
grG_ObjDef[Cmu][grC_root] := NPmu_:
grG_ObjDef[Cmu][grC_rootStr] := `mu`:
grG_ObjDef[Cmu][grC_indexList] := []:
grG_ObjDef[Cmu][grC_calcFn] := grF_calc_Cmu:
grG_ObjDef[Cmu][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cmu][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cmu][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Cmu := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,nd,i,j]*gr_data[v,gname,ld,k]*gr_data[v,gname,nd,l] +
			gr_data[dv,gname,md,i,j]*gr_data[v,gname,bd,k]*gr_data[v,gname,nd,l] -
			gr_data[dv,gname,bd,i,j]*gr_data[v,gname,md,k]*gr_data[v,gname,nd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(-Detb*s/2):
end:

#-----------------------------
# NP spin coefficient: tau
#-----------------------------
grG_ObjDef[Ctau][grC_header] := `NP Spin Coefficient, tau`:
grG_ObjDef[Ctau][grC_root] := NPtau_:
grG_ObjDef[Ctau][grC_rootStr] := `tau`:
grG_ObjDef[Ctau][grC_indexList] := []:
grG_ObjDef[Ctau][grC_calcFn] := grF_calc_Ctau:
grG_ObjDef[Ctau][grC_calcFnParms] := [NULL]:
grG_ObjDef[Ctau][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ctau][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Ctau := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,ld,i,j]*gr_data[v,gname,nd,k]*gr_data[v,gname,md,l] -
			gr_data[dv,gname,nd,i,j]*gr_data[v,gname,ld,k]*gr_data[v,gname,md,l] -
			gr_data[dv,gname,md,i,j]*gr_data[v,gname,bd,k]*gr_data[v,gname,md,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(Detb*s/2):
end:

#-----------------------------
# NP spin coefficient: pi
#-----------------------------
grG_ObjDef[Cpi][grC_header] := `NP Spin Coefficient, pi`:
grG_ObjDef[Cpi][grC_root] := NPpi_:
grG_ObjDef[Cpi][grC_rootStr] := `pi`:
grG_ObjDef[Cpi][grC_indexList] := []:
grG_ObjDef[Cpi][grC_calcFn] := grF_calc_Cpi:
grG_ObjDef[Cpi][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cpi][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cpi][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn) }:
grF_calc_Cpi := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,ld,i,j]*gr_data[v,gname,nd,k]*gr_data[v,gname,bd,l] -
			gr_data[dv,gname,nd,i,j]*gr_data[v,gname,ld,k]*gr_data[v,gname,bd,l] +
			gr_data[dv,gname,bd,i,j]*gr_data[v,gname,md,k]*gr_data[v,gname,bd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	RETURN(Detb*s/2):
end:

#-----------------------------
# NP spin coefficient: epsilon
#-----------------------------
grG_ObjDef[Cepsilon][grC_header] := `NP Spin Coefficient, epsilon`:
grG_ObjDef[Cepsilon][grC_root] := NPepsilon_:
grG_ObjDef[Cepsilon][grC_rootStr] := `epsilon`:
grG_ObjDef[Cepsilon][grC_indexList] := []:
grG_ObjDef[Cepsilon][grC_calcFn] := grF_calc_Cepsilon:
grG_ObjDef[Cepsilon][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cepsilon][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cepsilon][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn), Crho}:
grF_calc_Cepsilon := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
                if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,ld,i,j]*gr_data[v,gname,md,k]*gr_data[v,gname,bd,l] -
			gr_data[dv,gname,md,i,j]*gr_data[v,gname,ld,k]*gr_data[v,gname,bd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := (Detb*s + gr_data[NPrho_,gname])/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: gamma
#-----------------------------
grG_ObjDef[Cgamma][grC_header] := `NP Spin Coefficient, gamma`:
grG_ObjDef[Cgamma][grC_root] := NPgamma_:
grG_ObjDef[Cgamma][grC_rootStr] := `gamma`:
grG_ObjDef[Cgamma][grC_indexList] := []:
grG_ObjDef[Cgamma][grC_calcFn] := grF_calc_Cgamma:
grG_ObjDef[Cgamma][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cgamma][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cgamma][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn), Cmu}:
grF_calc_Cgamma := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,bd,i,j]*gr_data[v,gname,nd,k]*gr_data[v,gname,md,l] -
			gr_data[dv,gname,nd,i,j]*gr_data[v,gname,bd,k]*gr_data[v,gname,md,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := (Detb*s + gr_data[NPmu_,gname])/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: alpha
#-----------------------------
grG_ObjDef[Calpha][grC_header] := `NP Spin Coefficient, alpha`:
grG_ObjDef[Calpha][grC_root] := NPalpha_:
grG_ObjDef[Calpha][grC_rootStr] := `alpha`:
grG_ObjDef[Calpha][grC_indexList] := []:
grG_ObjDef[Calpha][grC_calcFn] := grF_calc_Calpha:
grG_ObjDef[Calpha][grC_calcFnParms] := [NULL]:
grG_ObjDef[Calpha][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Calpha][grC_depends] := { detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn), Cpi}:
grF_calc_Calpha := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,bd,i,j]*gr_data[v,gname,nd,k]*gr_data[v,gname,ld,l] -
			gr_data[dv,gname,nd,i,j]*gr_data[v,gname,bd,k]*gr_data[v,gname,ld,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := (Detb*s + gr_data[NPpi_,gname])/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: beta
#-----------------------------
grG_ObjDef[Cbeta][grC_header] := `NP Spin Coefficient, beta`:
grG_ObjDef[Cbeta][grC_root] := NPbeta_:
grG_ObjDef[Cbeta][grC_rootStr] := `beta`:
grG_ObjDef[Cbeta][grC_indexList] := []:
grG_ObjDef[Cbeta][grC_calcFn] := grF_calc_Cbeta:
grG_ObjDef[Cbeta][grC_calcFnParms] := [NULL]:
grG_ObjDef[Cbeta][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cbeta][grC_depends] :={ detb, LevCS(up,up,up,up), e(bdn,dn), e(bdn,dn,pdn), Ctau}:
grF_calc_Cbeta := proc(object, index)
global Ndim, grG_metricName, gr_data;
local i,j,k,l,s:
	s := 0:
	for i to Ndim[grG_metricName] do
	  for j to Ndim[grG_metricName] do
	    if j<>i then for k to Ndim[grG_metricName] do
	      if k<>i and k<>j then for l to Ndim[grG_metricName] do
	        if l<>i and l<>j and l<>k then
	          s := s + gr_data[LCS,gname,i,j,k,l]*(
			gr_data[dv,gname,ld,i,j]*gr_data[v,gname,md,k]*gr_data[v,gname,nd,l] -
			gr_data[dv,gname,md,i,j]*gr_data[v,gname,ld,k]*gr_data[v,gname,nd,l] ):
	        fi:
	      od fi:
	    od fi:
	  od:
	od:
	s := (Detb*s + gr_data[NPtau_,gname])/2:
	RETURN(s):
end:

#-----------------------------
# The following set of obects are complex conjugates
# of the D-spin coefficients defined above. They are
# obtained from the above objects by interchanging
# md's and md's in the indices.
#-----------------------------

#-----------------------------
# NP spin coefficient: kappabar
#-----------------------------
grG_ObjDef[Ckappabar][grC_header] := `NP Spin Coefficient, kappabar`:
grG_ObjDef[Ckappabar][grC_root] := NPkappabar_:
grG_ObjDef[Ckappabar][grC_rootStr] := `kappabar`:
grG_ObjDef[Ckappabar][grC_indexList] := []:
grG_ObjDef[Ckappabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Ckappabar][grC_calcFnParms] := [Ckappa]:
grG_ObjDef[Ckappabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ckappabar][grC_depends] := { Ckappa }:

#-----------------------------
# NP spin coefficient: sigmabar
#-----------------------------
grG_ObjDef[Csigmabar][grC_header] := `NP Spin Coefficient, sigmabar`:
grG_ObjDef[Csigmabar][grC_root] := NPsigmabar_:
grG_ObjDef[Csigmabar][grC_rootStr] := `sigmabar`:
grG_ObjDef[Csigmabar][grC_indexList] := []:
grG_ObjDef[Csigmabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Csigmabar][grC_calcFnParms] := [Csigma]:
grG_ObjDef[Csigmabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Csigmabar][grC_depends] := { Csigma }:

#-----------------------------
# NP spin coefficient: lambdabar
#-----------------------------
grG_ObjDef[Clambdabar][grC_header] := `NP Spin Coefficient, lambdabar`:
grG_ObjDef[Clambdabar][grC_root] := NPlambdabar_:
grG_ObjDef[Clambdabar][grC_rootStr] := `lambdabar`:
grG_ObjDef[Clambdabar][grC_indexList] := []:
grG_ObjDef[Clambdabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Clambdabar][grC_calcFnParms] := [Clambda]:
grG_ObjDef[Clambdabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Clambdabar][grC_depends] := { Clambda }:

#-----------------------------
# NP spin coefficient: nubar
#-----------------------------
grG_ObjDef[Cnubar][grC_header] := `NP Spin Coefficient, nubar`:
grG_ObjDef[Cnubar][grC_root] := NPnubar_:
grG_ObjDef[Cnubar][grC_rootStr] := `nubar`:
grG_ObjDef[Cnubar][grC_indexList] := []:
grG_ObjDef[Cnubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cnubar][grC_calcFnParms] := [Cnu]:
grG_ObjDef[Cnubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cnubar][grC_depends] := { Cnu }:

#-----------------------------
# NP spin coefficient: rhobar
#-----------------------------
grG_ObjDef[Crhobar][grC_header] := `NP Spin Coefficient, rhobar`:
grG_ObjDef[Crhobar][grC_root] := NPrhobar_:
grG_ObjDef[Crhobar][grC_rootStr] := `rhobar`:
grG_ObjDef[Crhobar][grC_indexList] := []:
grG_ObjDef[Crhobar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Crhobar][grC_calcFnParms] := [Crho]:
grG_ObjDef[Crhobar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Crhobar][grC_depends] := { Crho }:

#-----------------------------
# NP spin coefficient: mubar
#-----------------------------
grG_ObjDef[Cmubar][grC_header] := `NP Spin Coefficient, mubar`:
grG_ObjDef[Cmubar][grC_root] := NPmubar_:
grG_ObjDef[Cmubar][grC_rootStr] := `mubar`:
grG_ObjDef[Cmubar][grC_indexList] := []:
grG_ObjDef[Cmubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cmubar][grC_calcFnParms] := [Cmu]:
grG_ObjDef[Cmubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cmubar][grC_depends] := { Cmu }:

#-----------------------------
# NP spin coefficient: taubar
#-----------------------------
grG_ObjDef[Ctaubar][grC_header] := `NP Spin Coefficient, taubar`:
grG_ObjDef[Ctaubar][grC_root] := NPtaubar_:
grG_ObjDef[Ctaubar][grC_rootStr] := `taubar`:
grG_ObjDef[Ctaubar][grC_indexList] := []:
grG_ObjDef[Ctaubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Ctaubar][grC_calcFnParms] := [Ctau]:
grG_ObjDef[Ctaubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Ctaubar][grC_depends] := { Ctau }:

#-----------------------------
# NP Spin coefficient: pibar
#-----------------------------
grG_ObjDef[Cpibar][grC_header] := `NP Spin Coefficient, pibar`:
grG_ObjDef[Cpibar][grC_root] := NPpibar_:
grG_ObjDef[Cpibar][grC_rootStr] := `pibar`:
grG_ObjDef[Cpibar][grC_indexList] := []:
grG_ObjDef[Cpibar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cpibar][grC_calcFnParms] := [Cpi]:
grG_ObjDef[Cpibar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cpibar][grC_depends] := { Cpi }:

#-----------------------------
# NP Spin coefficient: epsilonbar
#-----------------------------
grG_ObjDef[Cepsilonbar][grC_header] := `NP Spin Coefficient, epsilonbar`:
grG_ObjDef[Cepsilonbar][grC_root] := NPepsilonbar_:
grG_ObjDef[Cepsilonbar][grC_rootStr] := `epsilonbar`:
grG_ObjDef[Cepsilonbar][grC_indexList] := []:
grG_ObjDef[Cepsilonbar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cepsilonbar][grC_calcFnParms] := [Cepsilon]:
grG_ObjDef[Cepsilonbar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cepsilonbar][grC_depends] := { Cepsilon }:

#-----------------------------
# NP Spin coefficient: gammabar
#-----------------------------
grG_ObjDef[Cgammabar][grC_header] := `NP Spin Coefficient, gammabar`:
grG_ObjDef[Cgammabar][grC_root] := NPgammabar_:
grG_ObjDef[Cgammabar][grC_rootStr] := `gammabar`:
grG_ObjDef[Cgammabar][grC_indexList] := []:
grG_ObjDef[Cgammabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cgammabar][grC_calcFnParms] := [Cgamma]:
grG_ObjDef[Cgammabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cgammabar][grC_depends] := { Cgamma }:

#-----------------------------
# NP Spin coefficient: alphabar
#-----------------------------
grG_ObjDef[Calphabar][grC_header] := `NP Spin Coefficient, alphabar`:
grG_ObjDef[Calphabar][grC_root] := NPalphabar_:
grG_ObjDef[Calphabar][grC_rootStr] := `alphabar`:
grG_ObjDef[Calphabar][grC_indexList] := []:
grG_ObjDef[Calphabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Calphabar][grC_calcFnParms] := [Calpha]:
grG_ObjDef[Calphabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Calphabar][grC_depends] := { Calpha }:

#-----------------------------
# NP Spin coefficient: betabar
#-----------------------------
grG_ObjDef[Cbetabar][grC_header] := `NP Spin Coefficient, betabar`:
grG_ObjDef[Cbetabar][grC_root] := NPbetabar_:
grG_ObjDef[Cbetabar][grC_rootStr] := `betabar`:
grG_ObjDef[Cbetabar][grC_indexList] := []:
grG_ObjDef[Cbetabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Cbetabar][grC_calcFnParms] := [Cbeta]:
grG_ObjDef[Cbetabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Cbetabar][grC_depends] := { Cbeta }:

#==============================================================================
$undef gname  
$undef v      
$undef dv     
$undef LCS    
$undef Detb   
$undef ld     
$undef nd     
$undef md     
$undef bd     

