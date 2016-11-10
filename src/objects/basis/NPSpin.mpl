#*********************************************************
#
# GRTENSOR II MODULE: NPSpin.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: August 25, 1994
#
# The NP spin coefficients defined by
# Newman and Penrose, J. Math. Phys., v3, #3, 1962, p566.
#
#  5 Feb 97  Use conj() to calculate complex conjugates [dp]
#
#*********************************************************


#-----------------------------
# NP spin coefficient: kappa
#-----------------------------
grG_ObjDef[NPkappa][grC_header] := `NP Spin Coefficient, kappa`:
grG_ObjDef[NPkappa][grC_root] := NPkappa_:
grG_ObjDef[NPkappa][grC_rootStr] := `kappa`:
grG_ObjDef[NPkappa][grC_indexList] := []:
grG_ObjDef[NPkappa][grC_calcFn] := grF_calc_NPkappa:
grG_ObjDef[NPkappa][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPkappa][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPkappa][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPkappa := proc(object, index)
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,3,1,1]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: sigma
#-----------------------------
grG_ObjDef[NPsigma][grC_header] := `NP Spin Coefficient, sigma`:
grG_ObjDef[NPsigma][grC_root] := NPsigma_:
grG_ObjDef[NPsigma][grC_rootStr] := `sigma`:
grG_ObjDef[NPsigma][grC_indexList] := []:
grG_ObjDef[NPsigma][grC_calcFn] := grF_calc_NPsigma:
grG_ObjDef[NPsigma][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPsigma][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPsigma][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPsigma := proc(object, index)
local s:
global gr_data, grG_metricName, Ndim:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,3,1,3]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: lambda
#-----------------------------
grG_ObjDef[NPlambda][grC_header] := `NP Spin Coefficient, lambda`:
grG_ObjDef[NPlambda][grC_root] := NPlambda_:
grG_ObjDef[NPlambda][grC_rootStr] := `lambda`:
grG_ObjDef[NPlambda][grC_indexList] := []:
grG_ObjDef[NPlambda][grC_calcFn] := grF_calc_NPlambda:
grG_ObjDef[NPlambda][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPlambda][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPlambda][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPlambda := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,2,4,4]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: nu
#-----------------------------
grG_ObjDef[NPnu][grC_header] := `NP Spin Coefficient, nu`:
grG_ObjDef[NPnu][grC_root] := NPnu_:
grG_ObjDef[NPnu][grC_rootStr] := `nu`:
grG_ObjDef[NPnu][grC_indexList] := []:
grG_ObjDef[NPnu][grC_calcFn] := grF_calc_NPnu:
grG_ObjDef[NPnu][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPnu][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPnu][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPnu := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,2,4,2]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: rho
#-----------------------------
grG_ObjDef[NPrho][grC_header] := `NP Spin Coefficient, rho`:
grG_ObjDef[NPrho][grC_root] := NPrho_:
grG_ObjDef[NPrho][grC_rootStr] := `rho`:
grG_ObjDef[NPrho][grC_indexList] := []:
grG_ObjDef[NPrho][grC_calcFn] := grF_calc_NPrho:
grG_ObjDef[NPrho][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPrho][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPrho][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPrho := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,3,1,4]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: mu
#-----------------------------
grG_ObjDef[NPmu][grC_header] := `NP Spin Coefficient, mu`:
grG_ObjDef[NPmu][grC_root] := NPmu_:
grG_ObjDef[NPmu][grC_rootStr] := `mu`:
grG_ObjDef[NPmu][grC_indexList] := []:
grG_ObjDef[NPmu][grC_calcFn] := grF_calc_NPmu:
grG_ObjDef[NPmu][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPmu][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPmu][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPmu := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,2,4,3]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: tau
#-----------------------------
grG_ObjDef[NPtau][grC_header] := `NP Spin Coefficient, tau`:
grG_ObjDef[NPtau][grC_root] := NPtau_:
grG_ObjDef[NPtau][grC_rootStr] := `tau`:
grG_ObjDef[NPtau][grC_indexList] := []:
grG_ObjDef[NPtau][grC_calcFn] := grF_calc_NPtau:
grG_ObjDef[NPtau][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPtau][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPtau][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPtau := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,3,1,2]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: pi
#-----------------------------
grG_ObjDef[NPpi][grC_header] := `NP Spin Coefficient, pi`:
grG_ObjDef[NPpi][grC_root] := NPpi_:
grG_ObjDef[NPpi][grC_rootStr] := `pi`:
grG_ObjDef[NPpi][grC_indexList] := []:
grG_ObjDef[NPpi][grC_calcFn] := grF_calc_NPpi:
grG_ObjDef[NPpi][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPpi][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPpi][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPpi := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,2,4,1]:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: epsilon
#-----------------------------
grG_ObjDef[NPepsilon][grC_header] := `NP Spin Coefficient, epsilon`:
grG_ObjDef[NPepsilon][grC_root] := NPepsilon_:
grG_ObjDef[NPepsilon][grC_rootStr] := `epsilon`:
grG_ObjDef[NPepsilon][grC_indexList] := []:
grG_ObjDef[NPepsilon][grC_calcFn] := grF_calc_NPepsilon:
grG_ObjDef[NPepsilon][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPepsilon][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPepsilon][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPepsilon := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := ( gr_data[rotbdnbdnbdn_,grG_metricName,2,1,1] +
               gr_data[rotbdnbdnbdn_,grG_metricName,3,4,1] )/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: gamma
#-----------------------------
grG_ObjDef[NPgamma][grC_header] := `NP Spin Coefficient, gamma`:
grG_ObjDef[NPgamma][grC_root] := NPgamma_:
grG_ObjDef[NPgamma][grC_rootStr] := `gamma`:
grG_ObjDef[NPgamma][grC_indexList] := []:
grG_ObjDef[NPgamma][grC_calcFn] := grF_calc_NPgamma:
grG_ObjDef[NPgamma][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPgamma][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPgamma][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPgamma := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := ( gr_data[rotbdnbdnbdn_,grG_metricName,2,1,2] +
               gr_data[rotbdnbdnbdn_,grG_metricName,3,4,2] )/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: alpha
#-----------------------------
grG_ObjDef[NPalpha][grC_header] := `NP Spin Coefficient, alpha`:
grG_ObjDef[NPalpha][grC_root] := NPalpha_:
grG_ObjDef[NPalpha][grC_rootStr] := `alpha`:
grG_ObjDef[NPalpha][grC_indexList] := []:
grG_ObjDef[NPalpha][grC_calcFn] := grF_calc_NPalpha:
grG_ObjDef[NPalpha][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPalpha][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPalpha][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPalpha := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := ( gr_data[rotbdnbdnbdn_,grG_metricName,2,1,4] +
               gr_data[rotbdnbdnbdn_,grG_metricName,3,4,4] )/2:
	RETURN(s):
end:

#-----------------------------
# NP spin coefficient: beta
#-----------------------------
grG_ObjDef[NPbeta][grC_header] := `NP Spin Coefficient, beta`:
grG_ObjDef[NPbeta][grC_root] := NPbeta_:
grG_ObjDef[NPbeta][grC_rootStr] := `beta`:
grG_ObjDef[NPbeta][grC_indexList] := []:
grG_ObjDef[NPbeta][grC_calcFn] := grF_calc_NPbeta:
grG_ObjDef[NPbeta][grC_calcFnParms] := [NULL]:
grG_ObjDef[NPbeta][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPbeta][grC_depends] := {rot(bdn,bdn,bdn)}:

grF_calc_NPbeta := proc(object, index)
global gr_data, grG_metricName, Ndim:
local s:
	s := ( gr_data[rotbdnbdnbdn_,grG_metricName,2,1,3] +
               gr_data[rotbdnbdnbdn_,grG_metricName,3,4,3] )/2:
	RETURN(s):
end:

#-----------------------------
# The following set of obects are complex conjugates
# of the NP-spin coefficients defined above. They are
# obtained from the above objects by interchanging
# 3's and 4's in the indices.
#------------------------------

#-----------------------------
# NP spin coefficient: kappabar
#-----------------------------
grG_ObjDef[NPkappabar][grC_header] := `NP Spin Coefficient, kappabar`:
grG_ObjDef[NPkappabar][grC_root] := NPkappabar_:
grG_ObjDef[NPkappabar][grC_rootStr] := `kappabar`:
grG_ObjDef[NPkappabar][grC_indexList] := []:
grG_ObjDef[NPkappabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPkappabar][grC_calcFnParms] := [NPkappa]:
grG_ObjDef[NPkappabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPkappabar][grC_depends] := { NPkappa }:

grF_calcConjugate := proc ( object, index )
global gr_data, grG_metricName, Ndim:
local conjObj, root:
  conjObj := grG_ObjDef[object][grC_calcFnParms][1]:
  root := (grG_ObjDef[conjObj][grC_root]):
  RETURN ( conj ( gr_data[root,grG_metricName] ) ):
end:

#-----------------------------
# NP spin coefficient: sigmabar
#-----------------------------
grG_ObjDef[NPsigmabar][grC_header] := `NP Spin Coefficient, sigmabar`:
grG_ObjDef[NPsigmabar][grC_root] := NPsigmabar_:
grG_ObjDef[NPsigmabar][grC_rootStr] := `sigmabar`:
grG_ObjDef[NPsigmabar][grC_indexList] := []:
grG_ObjDef[NPsigmabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPsigmabar][grC_calcFnParms] := [NPsigma]:
grG_ObjDef[NPsigmabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPsigmabar][grC_depends] := { NPsigma }:

#-----------------------------
# NP spin coefficient: lambdabar
#-----------------------------
grG_ObjDef[NPlambdabar][grC_header] := `NP Spin Coefficient, lambdabar`:
grG_ObjDef[NPlambdabar][grC_root] := NPlambdabar_:
grG_ObjDef[NPlambdabar][grC_rootStr] := `lambdabar`:
grG_ObjDef[NPlambdabar][grC_indexList] := []:
grG_ObjDef[NPlambdabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPlambdabar][grC_calcFnParms] := [NPlambda]:
grG_ObjDef[NPlambdabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPlambdabar][grC_depends] := { NPlambda }:

#-----------------------------
# NP spin coefficient: nubar
#-----------------------------
grG_ObjDef[NPnubar][grC_header] := `NP Spin Coefficient, nubar`:
grG_ObjDef[NPnubar][grC_root] := NPnubar_:
grG_ObjDef[NPnubar][grC_rootStr] := `nubar`:
grG_ObjDef[NPnubar][grC_indexList] := []:
grG_ObjDef[NPnubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPnubar][grC_calcFnParms] := [NPnu]:
grG_ObjDef[NPnubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPnubar][grC_depends] := { NPnu }:

#-----------------------------
# NP spin coefficient: rhobar
#-----------------------------
grG_ObjDef[NPrhobar][grC_header] := `NP Spin Coefficient, rhobar`:
grG_ObjDef[NPrhobar][grC_root] := NPrhobar_:
grG_ObjDef[NPrhobar][grC_rootStr] := `rhobar`:
grG_ObjDef[NPrhobar][grC_indexList] := []:
grG_ObjDef[NPrhobar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPrhobar][grC_calcFnParms] := [NPrho]:
grG_ObjDef[NPrhobar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPrhobar][grC_depends] := { NPrho }:

#-----------------------------
# NP spin coefficient: mubar
#-----------------------------
grG_ObjDef[NPmubar][grC_header] := `NP Spin Coefficient, mubar`:
grG_ObjDef[NPmubar][grC_root] := NPmubar_:
grG_ObjDef[NPmubar][grC_rootStr] := `mubar`:
grG_ObjDef[NPmubar][grC_indexList] := []:
grG_ObjDef[NPmubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPmubar][grC_calcFnParms] := [NPmu]:
grG_ObjDef[NPmubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPmubar][grC_depends] := { NPmu }:

#-----------------------------
# NP spin coefficient: taubar
#-----------------------------
grG_ObjDef[NPtaubar][grC_header] := `NP Spin Coefficient, taubar`:
grG_ObjDef[NPtaubar][grC_root] := NPtaubar_:
grG_ObjDef[NPtaubar][grC_rootStr] := `taubar`:
grG_ObjDef[NPtaubar][grC_indexList] := []:
grG_ObjDef[NPtaubar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPtaubar][grC_calcFnParms] := [NPtau]:
grG_ObjDef[NPtaubar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPtaubar][grC_depends] := { NPtau }:

#-----------------------------
# NP spin coefficient: pibar
#-----------------------------
grG_ObjDef[NPpibar][grC_header] := `NP Spin Coefficient, pibar`:
grG_ObjDef[NPpibar][grC_root] := NPpibar_:
grG_ObjDef[NPpibar][grC_rootStr] := `pibar`:
grG_ObjDef[NPpibar][grC_indexList] := []:
grG_ObjDef[NPpibar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPpibar][grC_calcFnParms] := [NPpi]:
grG_ObjDef[NPpibar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPpibar][grC_depends] := { NPpi }:

#-----------------------------
# NP spin coefficient: epsilonbar
#-----------------------------
grG_ObjDef[NPepsilonbar][grC_header] := `NP Spin Coefficient, epsilonbar`:
grG_ObjDef[NPepsilonbar][grC_root] := NPepsilonbar_:
grG_ObjDef[NPepsilonbar][grC_rootStr] := `epsilonbar`:
grG_ObjDef[NPepsilonbar][grC_indexList] := []:
grG_ObjDef[NPepsilonbar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPepsilonbar][grC_calcFnParms] := [NPepsilon]:
grG_ObjDef[NPepsilonbar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPepsilonbar][grC_depends] := { NPepsilon }:

#-----------------------------
# NP spin coefficient: gammabar
#-----------------------------
grG_ObjDef[NPgammabar][grC_header] := `NP Spin Coefficient, gammabar`:
grG_ObjDef[NPgammabar][grC_root] := NPgammabar_:
grG_ObjDef[NPgammabar][grC_rootStr] := `gammabar`:
grG_ObjDef[NPgammabar][grC_indexList] := []:
grG_ObjDef[NPgammabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPgammabar][grC_calcFnParms] := [NPgamma]:
grG_ObjDef[NPgammabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPgammabar][grC_depends] := { NPgamma }:

#-----------------------------
# NP spin coefficient: alphabar
#-----------------------------
grG_ObjDef[NPalphabar][grC_header] := `NP Spin Coefficient, alphabar`:
grG_ObjDef[NPalphabar][grC_root] := NPalphabar_:
grG_ObjDef[NPalphabar][grC_rootStr] := `alphabar`:
grG_ObjDef[NPalphabar][grC_indexList] := []:
grG_ObjDef[NPalphabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPalphabar][grC_calcFnParms] := [NPalpha]:
grG_ObjDef[NPalphabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPalphabar][grC_depends] := { NPalpha }:

#-----------------------------
# NP spin coefficient: betabar
#-----------------------------
grG_ObjDef[NPbetabar][grC_header] := `NP Spin Coefficient, betabar`:
grG_ObjDef[NPbetabar][grC_root] := NPbetabar_:
grG_ObjDef[NPbetabar][grC_rootStr] := `betabar`:
grG_ObjDef[NPbetabar][grC_indexList] := []:
grG_ObjDef[NPbetabar][grC_calcFn] := grF_calcConjugate:
grG_ObjDef[NPbetabar][grC_calcFnParms] := [NPbeta]:
grG_ObjDef[NPbetabar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[NPbetabar][grC_depends] := { NPbeta }:

#==============================================================================@
