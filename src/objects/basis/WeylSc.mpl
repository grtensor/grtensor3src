#*********************************************************
#
# GRTENSOR II MODULE: WeylSc.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: August 25, 1994
#
# Definitions follow Chandrasekhar, Math. Theory of Black Holes, 2ed.
# The NP Weyl scalars are calculated using the formulae listed
# Newman and Penrose, J. Math. Phys., v3, #3, 1962, p566.
#
# Change history:
# Nov 20, 1995	Add NPnu to depends list for Psi4 [dp]
# Feb  5, 1997  Use conj() to calculate complex conjugates [dp]
#
#*********************************************************


$define kX   gr_data[NPkappa_,grG_metricName] 
$define kbX  gr_data[NPkappabar_,grG_metricName] 
$define sX   gr_data[NPsigma_,grG_metricName] 
$define sbX  gr_data[NPsigmabar_,grG_metricName] 
$define lX   gr_data[NPlambda_,grG_metricName] 
$define lbX  gr_data[NPlambdabar_,grG_metricName] 
$define nX   gr_data[NPnu_,grG_metricName] 
$define nbX  gr_data[NPnubar_,grG_metricName] 
$define rX   gr_data[NPrho_,grG_metricName] 
$define rbX  gr_data[NPrhobar_,grG_metricName] 
$define mX   gr_data[NPmu_,grG_metricName] 
$define mbX  gr_data[NPmubar_,grG_metricName] 
$define tX   gr_data[NPtau_,grG_metricName] 
$define tbX  gr_data[NPtaubar_,grG_metricName] 
$define pX   gr_data[NPpi_,grG_metricName] 
$define pbX  gr_data[NPpibar_,grG_metricName] 
$define eX   gr_data[NPepsilon_,grG_metricName] 
$define ebX  gr_data[NPepsilonbar_,grG_metricName] 
$define gX   gr_data[NPgamma_,grG_metricName] 
$define gbX  gr_data[NPgammabar_,grG_metricName] 
$define aX   gr_data[NPalpha_,grG_metricName] 
$define abX  gr_data[NPalphabar_,grG_metricName] 
$define bX   gr_data[NPbeta_,grG_metricName] 
$define bbX  gr_data[NPbetabar_,grG_metricName] 

grF_when_WPsi := proc()
  if grF_assignedFlag ( R(bdn,bdn), test ) then
    true:
  else
    false:
  fi:
end:

#-----------------------------
# Psi0
#-----------------------------
grG_ObjDef[Psi0][grC_header] := `Weyl Scalar, NP Psi0`:
grG_ObjDef[Psi0][grC_root] := Psi0_:
grG_ObjDef[Psi0][grC_rootStr] := `Psi0`:
grG_ObjDef[Psi0][grC_indexList] := []:
grG_ObjDef[Psi0][grC_calcFn] := grF_calc_Psi0:
grG_ObjDef[Psi0][grC_calcFnParms] := [NULL]:
grG_ObjDef[Psi0][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi0][grC_depends] := { e(bdn,up), NPsigma, NPrho, NPrhobar, NPepsilon, NPepsilonbar,
                     NPkappa, NPtau, NPpibar, NPalphabar, NPbeta }:
grG_ObjDef[Psi0][grC_attributes] := {use_diff_constraint_}:

grF_calc_Psi0 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -sX*( rX + rbX + 3*eX - ebX )
           + kX*( tX - pbX + abX + 3*bX ):
        for a to Ndim[grG_metricName] do
          s := s + gr_data[ebdnup_,grG_metricName,1,a]*diff(sX,gr_data[xup_,grG_metricName,a])
                 - gr_data[ebdnup_,grG_metricName,3,a]*diff(kX,gr_data[xup_,grG_metricName,a]):
        od:
	RETURN(s):
end:

#-----------------------------
# Psi0
#-----------------------------
grG_ObjDef[WPsi0][grC_displayName] := Psi0:
grG_ObjDef[WPsi0][grC_calcFn] := grF_calc_WPsi0:
grG_ObjDef[WPsi0][grC_useWhen] := grF_when_WPsi:
grG_ObjDef[WPsi0][grC_depends] := {C(bdn,bdn,bdn,bdn)}:

grF_calc_WPsi0 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := gr_data[Cbdnbdnbdnbdn_,grG_metricName,1,3,1,3]:
	RETURN(s):
end:

#-----------------------------
# NP Psi1
#-----------------------------
grG_ObjDef[Psi1][grC_header] := `Weyl Scalar, NP Psi1`:
grG_ObjDef[Psi1][grC_root] := Psi1_:
grG_ObjDef[Psi1][grC_rootStr] := `Psi1`:
grG_ObjDef[Psi1][grC_indexList] := []:
grG_ObjDef[Psi1][grC_calcFn] := grF_calc_Psi1:
grG_ObjDef[Psi1][grC_calcFnParms] := [NULL]:
grG_ObjDef[Psi1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi1][grC_depends] := { e(bdn,up), NPbeta, NPrhobar, NPepsilonbar, NPepsilon, NPalphabar,
                     NPpibar, NPsigma, NPalpha, NPpi, NPkappa, NPmu, NPgamma }:
grG_ObjDef[Psi1][grC_attributes] := {use_diff_constraint_}:

grF_calc_Psi1 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -bX*( rbX - ebX )
           + eX*( abX - pbX )
           - sX*( aX + pX )
           + kX*( mX + gX ):
        for a to Ndim[grG_metricName] do
          s := s + gr_data[ebdnup_,grG_metricName,1,a]*diff(bX,gr_data[xup_,grG_metricName,a])
	         - gr_data[ebdnup_,grG_metricName,3,a]*diff(eX,gr_data[xup_,grG_metricName,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Psi1
#-----------------------------
grG_ObjDef[WPsi1][grC_displayName] := Psi1:
grG_ObjDef[WPsi1][grC_calcFn] := grF_calc_WPsi1:
grG_ObjDef[WPsi1][grC_useWhen] := grF_when_WPsi:
grG_ObjDef[WPsi1][grC_depends] := {C(bdn,bdn,bdn,bdn)}:

grF_calc_WPsi1 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := gr_data[Cbdnbdnbdnbdn_,grG_metricName,1,2,1,3]:
	RETURN(s):
end:

#-----------------------------
# NP Psi2
#-----------------------------
grG_ObjDef[Psi2][grC_header] := `Weyl Scalar, NP Psi2`:
grG_ObjDef[Psi2][grC_root] := Psi2_:
grG_ObjDef[Psi2][grC_rootStr] := `Psi2`:
grG_ObjDef[Psi2][grC_indexList] := []:
grG_ObjDef[Psi2][grC_calcFn] := grF_calc_Psi2:
grG_ObjDef[Psi2][grC_calcFnParms] := [NULL]:
grG_ObjDef[Psi2][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi2][grC_depends] := { e(bdn,up), NPepsilonbar, NPrho, NPrhobar, NPepsilon, NPgamma,
                     NPalpha, NPtaubar, NPpi, NPbetabar, NPtau,
                     NPgammabar, NPmu, NPmubar, NPbeta, NPpibar, NPalphabar,
                     NPnu, NPkappa, NPlambda, NPsigma }:
grG_ObjDef[Psi2][grC_attributes] := {use_diff_constraint_}:

grF_calc_Psi2 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := ( ebX + 2*rX - rbX + 2*eX )*gX
           + ( -2*aX - tbX - pX + bbX)*tX
           + ( gbX + mX - mbX )*( rX + eX )
           + ( -2*bX - pbX + abX )*aX
           + ( -tbX - pX + bbX ) *bX
           + 2*( nX*kX -lX*sX ):
     	for a to Ndim[grG_metricName] do
 	  s := s + gr_data[ebdnup_,grG_metricName,1,a]*diff(gX,gr_data[xup_,grG_metricName,a])
                 - gr_data[ebdnup_,grG_metricName,2,a]*diff((rX+eX),gr_data[xup_,grG_metricName,a])
                 + gr_data[ebdnup_,grG_metricName,4,a]*diff((bX+tX),gr_data[xup_,grG_metricName,a])
                 - gr_data[ebdnup_,grG_metricName,3,a]*diff(aX,gr_data[xup_,grG_metricName,a]):
	od:
	s := s/3:
	RETURN(s):
end:

#-----------------------------
# Psi2
#-----------------------------
grG_ObjDef[WPsi2][grC_displayName] := Psi2:
grG_ObjDef[WPsi2][grC_calcFn] := grF_calc_WPsi2:
grG_ObjDef[WPsi2][grC_useWhen] := grF_when_WPsi:
grG_ObjDef[WPsi2][grC_depends] := {C(bdn,bdn,bdn,bdn)}:

grF_calc_WPsi2 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := gr_data[Cbdnbdnbdnbdn_,grG_metricName,1,3,4,2]:
	RETURN(s):
end:

#-----------------------------
# NP Psi3
#-----------------------------
grG_ObjDef[Psi3][grC_header] := `Weyl Scalar, NP Psi3`:
grG_ObjDef[Psi3][grC_root] := Psi3_:
grG_ObjDef[Psi3][grC_rootStr] := `Psi3`:
grG_ObjDef[Psi3][grC_indexList] := []:
grG_ObjDef[Psi3][grC_calcFn] := grF_calc_Psi3:
grG_ObjDef[Psi3][grC_calcFnParms] := [NULL]:
grG_ObjDef[Psi3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi3][grC_depends] := { e(bdn,up), NPalpha, NPgammabar, NPmubar, NPgamma, NPbetabar,
                     NPtaubar, NPnu, NPrho, NPepsilon, NPlambda, NPtau, NPbeta}:
grG_ObjDef[Psi3][grC_attributes] := {use_diff_constraint_}:

grF_calc_Psi3 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := aX*( gbX - mbX )
           + gX*( bbX - tbX )
           + nX*( rX + eX )
           - lX*( tX + bX ):
        for a to Ndim[grG_metricName] do
          s := s - gr_data[ebdnup_,grG_metricName,2,a]*diff(aX,gr_data[xup_,grG_metricName,a])
 	         + gr_data[ebdnup_,grG_metricName,4,a]*diff(gX,gr_data[xup_,grG_metricName,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Psi3
#-----------------------------
grG_ObjDef[WPsi3][grC_displayName] := Psi3:
grG_ObjDef[WPsi3][grC_calcFn] := grF_calc_WPsi3:
grG_ObjDef[WPsi3][grC_useWhen] := grF_when_WPsi:
grG_ObjDef[WPsi3][grC_depends] := {C(bdn,bdn,bdn,bdn)}:

grF_calc_WPsi3 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := gr_data[Cbdnbdnbdnbdn_,grG_metricName,1,2,4,2]:
	RETURN(s):
end:

#-----------------------------
# NP Psi4
#-----------------------------
grG_ObjDef[Psi4][grC_header] := `Weyl Scalar, NP Psi4`:
grG_ObjDef[Psi4][grC_root] := Psi4_:
grG_ObjDef[Psi4][grC_rootStr] := `Psi4`:
grG_ObjDef[Psi4][grC_indexList] := []:
grG_ObjDef[Psi4][grC_calcFn] := grF_calc_Psi4:
grG_ObjDef[Psi4][grC_calcFnParms] := [NULL]:
grG_ObjDef[Psi4][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi4][grC_depends] := { e(bdn,up), NPlambda, NPmu, NPmubar, NPgamma, NPgammabar,
                     NPnu, NPpi, NPtaubar, NPalpha, NPbetabar }:
grG_ObjDef[Psi4][grC_attributes] := {use_diff_constraint_}:

grF_calc_Psi4 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local a, s:
	s := -lX*( mX + mbX + 3*gX - gbX )
           + nX*( pX - tbX + 3*aX + bbX ):
	for a to Ndim[grG_metricName] do
   	  s := s - gr_data[ebdnup_,grG_metricName,2,a]*diff(lX,gr_data[xup_,grG_metricName,a])
                 + gr_data[ebdnup_,grG_metricName,4,a]*diff(nX,gr_data[xup_,grG_metricName,a]):
	od:
	RETURN(s):
end:

#-----------------------------
# Psi4
#-----------------------------
grG_ObjDef[WPsi4][grC_displayName] := Psi4:
grG_ObjDef[WPsi4][grC_calcFn] := grF_calc_WPsi4:
grG_ObjDef[WPsi4][grC_useWhen] := grF_when_WPsi:
grG_ObjDef[WPsi4][grC_depends] := {C(bdn,bdn,bdn,bdn)}:

grF_calc_WPsi4 := proc(object, index)
global gr_data, grG_metricName, Ndim;
local s:
	s := gr_data[Cbdnbdnbdnbdn_,grG_metricName,2,4,2,4]:
	RETURN(s):
end:

#==============================================================================
# COMPLEX CONJUGATES
#==============================================================================

#-----------------------------
# Psi0bar
#-----------------------------
grG_ObjDef[Psi0bar][grC_header] := `Weyl Scalar, NP Psi0bar`:
grG_ObjDef[Psi0bar][grC_root] := Psi0bar_:
grG_ObjDef[Psi0bar][grC_rootStr] := `Psi0bar`:
grG_ObjDef[Psi0bar][grC_indexList] := []:
grG_ObjDef[Psi0bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Psi0bar][grC_calcFnParms] := [Psi0]:
grG_ObjDef[Psi0bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi0bar][grC_depends] := { Psi0 }:

#-----------------------------
# NP Psi1bar
#-----------------------------
grG_ObjDef[Psi1bar][grC_header] := `Weyl Scalar, NP Psi1bar`:
grG_ObjDef[Psi1bar][grC_root] := Psi1bar_:
grG_ObjDef[Psi1bar][grC_rootStr] := `Psi1bar`:
grG_ObjDef[Psi1bar][grC_indexList] := []:
grG_ObjDef[Psi1bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Psi1bar][grC_calcFnParms] := [Psi1]:
grG_ObjDef[Psi1bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi1bar][grC_depends] := { Psi1 }:

#-----------------------------
# NP Psi2bar
#-----------------------------
grG_ObjDef[Psi2bar][grC_header] := `Weyl Scalar, NP Psi2bar`:
grG_ObjDef[Psi2bar][grC_root] := Psi2bar_:
grG_ObjDef[Psi2bar][grC_rootStr] := `Psi2bar`:
grG_ObjDef[Psi2bar][grC_indexList] := []:
grG_ObjDef[Psi2bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Psi2bar][grC_calcFnParms] := [Psi2]:
grG_ObjDef[Psi2bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi2bar][grC_depends] := { Psi2 }:

#-----------------------------
# NP Psi3bar
#-----------------------------
grG_ObjDef[Psi3bar][grC_header] := `Weyl Scalar, NP Psi3bar`:
grG_ObjDef[Psi3bar][grC_root] := Psi3bar_:
grG_ObjDef[Psi3bar][grC_rootStr] := `Psi3bar`:
grG_ObjDef[Psi3bar][grC_indexList] := []:
grG_ObjDef[Psi3bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Psi3bar][grC_calcFnParms] := [Psi3]:
grG_ObjDef[Psi3bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi3bar][grC_depends] := { Psi3 }:

#-----------------------------
# NP Psi4bar
#-----------------------------
grG_ObjDef[Psi4bar][grC_header] := `Weyl Scalar, NP Psi4bar`:
grG_ObjDef[Psi4bar][grC_root] := Psi4bar_:
grG_ObjDef[Psi4bar][grC_rootStr] := `Psi4bar`:
grG_ObjDef[Psi4bar][grC_indexList] := []:
grG_ObjDef[Psi4bar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[Psi4bar][grC_calcFnParms] := [Psi4]:
grG_ObjDef[Psi4bar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Psi4bar][grC_depends] := { Psi4 }:

#==============================================================================@
$undef kX   
$undef kbX  
$undef sX   
$undef sbX  
$undef lX   
$undef lbX  
$undef nX   
$undef nbX  
$undef rX   
$undef rbX  
$undef mX   
$undef mbX  
$undef tX   
$undef tbX  
$undef pX   
$undef pbX  
$undef eX   
$undef ebX  
$undef gX   
$undef gbX  
$undef aX   
$undef abX  
$undef bX   
$undef bbX  




