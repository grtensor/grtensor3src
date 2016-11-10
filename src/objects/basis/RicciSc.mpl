#*********************************************************
#
# GRTENSOR II MODULE: RicciSc.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: August 25, 1994
#
# Definitions follow Chandrasekhar, Math. Theory of Black Holes, 2ed.
# The NP Ricci scalars are calculated using the formulae listed
# Newman and Penrose, J. Math. Phys., v3, #3, 1962, p566.
#
# Revisions:
#
# Jan  5, 95    Fixed definitions of Phi01, Lambda [dp]
#               Added multipleDef entry for Lambda [dp]
# Feb  5, 97	Use conj() to calculate complex conjugates [dp]
#
#*********************************************************


$define  kX   gr_data[NPkappa_,grG_metricName] 
$define  kbX  gr_data[NPkappabar_,grG_metricName] 
$define  sX   gr_data[NPsigma_,grG_metricName] 
$define  sbX  gr_data[NPsigmabar_,grG_metricName] 
$define  lX   gr_data[NPlambda_,grG_metricName] 
$define  lbX  gr_data[NPlambdabar_,grG_metricName] 
$define  nX   gr_data[NPnu_,grG_metricName] 
$define  nbX  gr_data[NPnubar_,grG_metricName] 
$define  rX   gr_data[NPrho_,grG_metricName] 
$define  rbX  gr_data[NPrhobar_,grG_metricName] 
$define  mX   gr_data[NPmu_,grG_metricName] 
$define  mbX  gr_data[NPmubar_,grG_metricName] 
$define  tX   gr_data[NPtau_,grG_metricName] 
$define  tbX  gr_data[NPtaubar_,grG_metricName] 
$define  pX   gr_data[NPpi_,grG_metricName] 
$define  pbX  gr_data[NPpibar_,grG_metricName] 
$define  eX   gr_data[NPepsilon_,grG_metricName] 
$define  ebX  gr_data[NPepsilonbar_,grG_metricName] 
$define  gX   gr_data[NPgamma_,grG_metricName] 
$define  gbX  gr_data[NPgammabar_,grG_metricName] 
$define  aX   gr_data[NPalpha_,grG_metricName] 
$define  abX  gr_data[NPalphabar_,grG_metricName] 
$define  bX   gr_data[NPbeta_,grG_metricName] 
$define  bbX  gr_data[NPbetabar_,grG_metricName] 

grF_when_RPhi := proc()
  if grF_assignedFlag ( R(bdn,bdn), test ) then
    true:
  else
    false:
  fi:
end:

#-----------------------------
# NP Phi00
#-----------------------------
grG_ObjDef[Phi00][grC_header] := `Ricci Scalar, Phi00`:
grG_ObjDef[Phi00][grC_displayName] := Phi00:
grG_ObjDef[Phi00][grC_root] := NPPhi00_:
grG_ObjDef[Phi00][grC_rootStr] := `Phi00`:
grG_ObjDef[Phi00][grC_indexList] := []:
grG_ObjDef[Phi00][grC_calcFn] := grF_calc_NPPhi00:
grG_ObjDef[Phi00][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi00][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi00][grC_depends] := { e(bdn,up), NPrho, NPepsilon, NPepsilonbar, NPkappa,
                     NPalpha, NPbetabar, NPpi, NPsigma, NPsigmabar, NPkappabar, NPtau }:
grG_ObjDef[Phi00][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi00 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -rX*( rX + eX + ebX )
           - sX*sbX + kbX*tX
           + kX*( 3*aX + bbX - pX ):
	for a to Ndim[grG_metricName] do
  	  s := s + gr_data[ebdnup_,gname,1,a]*diff(rX,gr_data[xup_,gname,a])
                 - gr_data[ebdnup_,gname,4,a]*diff(kX,gr_data[xup_,gname,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi00
#-----------------------------
grG_ObjDef[RPhi00][grC_displayName] := Phi00:
grG_ObjDef[RPhi00][grC_calcFn] := grF_calc_RPhi00:
grG_ObjDef[RPhi00][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi00][grC_depends] := { R(bdn,bdn) }:

grF_calc_RPhi00 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/2)*gr_data[Rbdnbdn_,gname,1,1]:
	RETURN(s):
end:

#-----------------------------
# NP Phi01
#-----------------------------
grG_ObjDef[Phi01][grC_header] := `Ricci Scalar, Phi01`:
grG_ObjDef[Phi01][grC_displayName] := Phi01:
grG_ObjDef[Phi01][grC_root] := NPPhi01_:
grG_ObjDef[Phi01][grC_rootStr] := `Phi01`:
grG_ObjDef[Phi01][grC_indexList] := []:
grG_ObjDef[Phi01][grC_calcFn] := grF_calc_NPPhi01:
grG_ObjDef[Phi01][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi01][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi01][grC_depends] := { e(bdn,up), NPalphabar, NPrhobar, NPepsilon, NPepsilonbar, NPbeta,
                     NPpibar, NPbetabar, NPsigma, NPkappa, NPlambdabar,
                     NPkappabar, NPgammabar }:
grG_ObjDef[Phi01][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi01 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -abX*( rbX + eX - 2*ebX )
           + ebX*( bX - pbX )
           - bbX*sX + kbX*lbX + kX*gbX - pbX*rbX:
	for a to Ndim[grG_metricName] do
 	  s := s + gr_data[ebdnup_,gname,1,a]*diff(abX,gr_data[xup_,gname,a])
                 - gr_data[ebdnup_,gname,3,a]*diff(ebX,gr_data[xup_,gname,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi01
#-----------------------------
grG_ObjDef[RPhi01][grC_displayName] := Phi01:
grG_ObjDef[RPhi01][grC_calcFn] := grF_calc_RPhi01:
grG_ObjDef[RPhi01][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi01][grC_depends] := { R(bdn,bdn) }:

grF_calc_RPhi01 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/2)*gr_data[Rbdnbdn_,gname,1,3]:
	RETURN(s):
end:

#-----------------------------
# NP Phi02
#-----------------------------
grG_ObjDef[Phi02][grC_header] := `Ricci Scalar, Phi02`:
grG_ObjDef[Phi02][grC_displayName] := Phi02:
grG_ObjDef[Phi02][grC_root] := NPPhi02_:
grG_ObjDef[Phi02][grC_rootStr] := `Phi02`:
grG_ObjDef[Phi02][grC_indexList] := []:
grG_ObjDef[Phi02][grC_calcFn] := grF_calc_NPPhi02:
grG_ObjDef[Phi02][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi02][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi02][grC_depends] := { e(bdn,up), NPlambdabar, NPepsilonbar, NPepsilon, NPrhobar,
 	             NPpibar, NPalphabar, NPbeta, NPsigma, NPmubar, NPnubar, NPkappa }:
grG_ObjDef[Phi02][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi02 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := lbX*( 3*ebX - eX - rbX )
 	   - pbX*( pbX + abX - bX )
           - sX*mbX + nbX*kX:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[ebdnup_,gname,1,a]*diff(lbX,gr_data[xup_,gname,a])
	         - gr_data[ebdnup_,gname,3,a]*diff(pbX,gr_data[xup_,gname,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi02
#-----------------------------
grG_ObjDef[RPhi02][grC_displayName] := Phi02:
grG_ObjDef[RPhi02][grC_calcFn] := grF_calc_RPhi02:
grG_ObjDef[RPhi02][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi02][grC_depends] := {R(bdn,bdn)}:

grF_calc_RPhi02 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/2)*gr_data[Rbdnbdn_,gname,3,3]:
	RETURN(s):
end:

#-----------------------------
# NP Phi10
#-----------------------------
grG_ObjDef[Phi10][grC_header] := `Ricci Scalar, Phi10`:
grG_ObjDef[Phi10][grC_displayName] := Phi10:
grG_ObjDef[Phi10][grC_root] := NPPhi10_:
grG_ObjDef[Phi10][grC_rootStr] := `Phi10`:
grG_ObjDef[Phi10][grC_indexList] := []:
grG_ObjDef[Phi10][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Phi10][grC_calcFnParms] := [Phi01]:
grG_ObjDef[Phi10][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi10][grC_depends] := { Phi01 }:

#-----------------------------
# NP Phi11
#-----------------------------
grG_ObjDef[Phi11][grC_header] := `Ricci Scalar, Phi11`:
grG_ObjDef[Phi11][grC_displayName] := Phi11:
grG_ObjDef[Phi11][grC_root] := NPPhi11_:
grG_ObjDef[Phi11][grC_rootStr] := `Phi11`:
grG_ObjDef[Phi11][grC_indexList] := []:
grG_ObjDef[Phi11][grC_calcFn] := grF_calc_NPPhi11:
grG_ObjDef[Phi11][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi11][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi11][grC_depends] := { e(bdn,up), NPbeta, NPgamma, NPtau, NPpi, NPgamma, NPmu, NPrho,
		     NPpibar, NPtau, NPalphabar, NPalpha, NPgammabar, NPmubar,
		     NPepsilon, NPrhobar, NPbeta, NPtaubar, NPepsilonbar,
		     NPbetabar, NPlambda, NPsigma, NPnu, NPkappa }:
grG_ObjDef[Phi11][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi11 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -pX*( bX + tX )
	   - rX*( gX + mX ) + aX*( -pbX - tX - abX + 2*bX )
	   + eX*( gbX + mbX + 2*gX - mX )
	   + gX*rbX - bX*tbX + gX*ebX - bX*bbX + lX*sX + nX*kX:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[ebdnup_,gname,1,a]*diff(gX,gr_data[xup_,gname,a])
		 - gr_data[ebdnup_,gname,2,a]*diff(eX,gr_data[xup_,gname,a])
		 + gr_data[ebdnup_,gname,3,a]*diff(aX,gr_data[xup_,gname,a])
		 - gr_data[ebdnup_,gname,4,a]*diff(bX,gr_data[xup_,gname,a]):
	od:
	s := s/2:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi11
#-----------------------------
grG_ObjDef[RPhi11][grC_displayName] := Phi11:
grG_ObjDef[RPhi11][grC_calcFn] := grF_calc_RPhi11:
grG_ObjDef[RPhi11][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi11][grC_depends] := { R(bdn,bdn) }:


grF_calc_RPhi11 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/4)*(gr_data[Rbdnbdn_,gname,1,2]+gr_data[Rbdnbdn_,gname,3,4]):
	RETURN(s):
end:

#-----------------------------
# NP Phi12
#-----------------------------
grG_ObjDef[Phi12][grC_header] := `Ricci Scalar, Phi12`:
grG_ObjDef[Phi12][grC_displayName] := Phi12:
grG_ObjDef[Phi12][grC_root] := NPPhi12_:
grG_ObjDef[Phi12][grC_rootStr] := `Phi12`:
grG_ObjDef[Phi12][grC_indexList] := []:
grG_ObjDef[Phi12][grC_calcFn] := grF_calc_NPPhi12:
grG_ObjDef[Phi12][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi12][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi12][grC_depends] := { e(bdn,up), NPgamma, NPtau, NPalphabar, NPbeta, NPgammabar, NPmu,
                     NPalpha, NPlambdabar, NPsigma, NPnu, NPepsilon, NPnubar }:
grG_ObjDef[Phi12][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi12 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -gX*( tX - abX - bX )
           + bX*( gX - gbX - mX )
           - mX*tX - aX*lbX + sX*nX + eX*nbX:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[ebdnup_,gname,3,a]*diff(gX,gr_data[xup_,gname,a])
		 - gr_data[ebdnup_,gname,2,a]*diff(bX,gr_data[xup_,gname,a])
	od:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi12
#-----------------------------
grG_ObjDef[RPhi12][grC_displayName] := Phi12:
grG_ObjDef[RPhi12][grC_calcFn] := grF_calc_RPhi12:
grG_ObjDef[RPhi12][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi12][grC_depends] := {R(bdn,bdn)}:

grF_calc_RPhi12 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/2)*gr_data[Rbdnbdn_,gname,2,3]:
	RETURN(s):
end:

#-----------------------------
# NP Phi20
#-----------------------------
grG_ObjDef[Phi20][grC_header] := `Ricci Scalar, Phi20`:
grG_ObjDef[Phi20][grC_displayName] := Phi20:
grG_ObjDef[Phi20][grC_root] := NPPhi20_:
grG_ObjDef[Phi20][grC_rootStr] := `Phi20`:
grG_ObjDef[Phi20][grC_indexList] := []:
grG_ObjDef[Phi20][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Phi20][grC_calcFnParms] := [Phi02]:
grG_ObjDef[Phi20][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi20][grC_depends] := { Phi02 }:

#-----------------------------
# NPPhi21
#-----------------------------
grG_ObjDef[Phi21][grC_header] := `Ricci Scalar, Phi21`:
grG_ObjDef[Phi21][grC_displayName] := Phi21:
grG_ObjDef[Phi21][grC_root] := NPPhi21_:
grG_ObjDef[Phi21][grC_rootStr] := `Phi21`:
grG_ObjDef[Phi21][grC_indexList] := []:
grG_ObjDef[Phi21][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Phi21][grC_calcFnParms] := [Phi12]:
grG_ObjDef[Phi21][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi21][grC_depends] := { Phi12 }:

#-----------------------------
# NP Phi22
#-----------------------------
grG_ObjDef[Phi22][grC_header] := `Ricci Scalar, Phi22`:
grG_ObjDef[Phi22][grC_displayName] := Phi22:
grG_ObjDef[Phi22][grC_root] := NPPhi22_:
grG_ObjDef[Phi22][grC_rootStr] := `Phi22`:
grG_ObjDef[Phi22][grC_indexList] := []:
grG_ObjDef[Phi22][grC_calcFn] := grF_calc_NPPhi22:
grG_ObjDef[Phi22][grC_calcFnParms] := [NULL]:
grG_ObjDef[Phi22][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Phi22][grC_depends] := { e(bdn,up), NPnu, NPtau, NPbeta, NPalphabar, NPmu, NPgamma,
		     NPgammabar, NPlambda, NPlambdabar, NPnubar, NPpi }:
grG_ObjDef[Phi22][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPPhi22 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -nX*( tX - 3*bX - abX )
           - mX*( mX + gX + gbX )
           - lX*lbX + nbX*pX:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[ebdnup_,gname,3,a]*diff(nX,gr_data[xup_,gname,a])
	         - gr_data[ebdnup_,gname,2,a]*diff(mX,gr_data[xup_,gname,a])
	od:
	RETURN(s):
end:

#-----------------------------
# Ricci Phi22
#-----------------------------
grG_ObjDef[RPhi22][grC_displayName] := Phi22:
grG_ObjDef[RPhi22][grC_calcFn] := grF_calc_RPhi22:
grG_ObjDef[RPhi22][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RPhi22][grC_depends] := {R(bdn,bdn)}:

grF_calc_RPhi22 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/2)*gr_data[Rbdnbdn_,gname,2,2]:
	RETURN(s):
end:

#-----------------------------
# NP Lambda
#-----------------------------
grG_ObjDef[NPLambda][grC_header] := `NPLambda := Ricci Scalar/24`:
grG_ObjDef[NPLambda][grC_displayName] := NPLambda:
grG_ObjDef[NPLambda][grC_root] := NPLambda_:
grG_ObjDef[NPLambda][grC_rootStr] := `NPLambda`:
grG_ObjDef[NPLambda][grC_indexList] := []:
grG_ObjDef[NPLambda][grC_calcFn] := grF_calc_NPLambda:
grG_ObjDef[NPLambda][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPLambda][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPLambda][grC_depends] := { e(bdn,up), NPepsilonbar, NPrho, NPrhobar, NPepsilon, NPgamma,
	   	     NPbeta, NPtau, NPbetabar, NPpi, NPalpha, NPtaubar,
                     NPalphabar, NPnu, NPkappa, NPmubar, NPlambda, NPsigma,
		     NPpibar, NPmu, NPgammabar }:
grG_ObjDef[NPLambda][grC_attributes] := {use_diff_constraint_}:

grF_calc_NPLambda := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := tX*pX + nX*kX - aX*abX - bX*bbX - mX*rX - lX*sX + 2*aX*bX
             - eX*gbX + bX*tbX + bX*pX - aX*tX + aX*pbX - 2*gX*eX - gX*ebX
             - eX*mX + eX*mbX + gX*rX + gX*rbX + 2*tX*bbX - 2*tX*tbX
             - 2*rX*mbX + 2*rX*gbX:

	for a to Ndim[grG_metricName] do
	  s := s - gr_data[ebdnup_,gname,1,a]*diff(gX,gr_data[xup_,gname,a])
		 - gr_data[ebdnup_,gname,2,a]*diff((2*rX-eX),gr_data[xup_,gname,a])
		 + gr_data[ebdnup_,gname,3,a]*diff(aX,gr_data[xup_,gname,a])
	         + gr_data[ebdnup_,gname,4,a]*diff((2*tX-bX),gr_data[xup_,gname,a]):
	od:
	s := s/6:
	RETURN(s):
end:

#-----------------------------
# Ricci Lambda
#-----------------------------
grG_ObjDef[RLambda][grC_displayName] := NPLambda:
grG_ObjDef[RLambda][grC_calcFn] := grF_calc_RLambda:
grG_ObjDef[RLambda][grC_useWhen] := grF_when_RPhi:
grG_ObjDef[RLambda][grC_depends] := {R(bdn,bdn)}:

grF_calc_RLambda := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := (1/12)*(gr_data[Rbdnbdn_,gname,1,2]-gr_data[Rbdnbdn_,gname,3,4]):
	RETURN(-s):
end:

#==============================================================================@
$undef  kX   
$undef  kbX   
$undef  sX   
$undef  sbX   
$undef  lX   
$undef  lbX  
$undef  nX   
$undef  nbX  
$undef  rX   
$undef  rbX  
$undef  mX   
$undef  mbX  
$undef  tX   
$undef  tbX  
$undef  pX   
$undef  pbX  
$undef  eX   
$undef  ebX  
$undef  gX   
$undef  gbX   
$undef  aX   
$undef  abX   
$undef  bX   
$undef  bbX  



