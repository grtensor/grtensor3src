#==============================================================================
# autoLoad
#------------------------------------------------------------------------------
# Aliases referring to objects contained in autoloaded libraries must be 
# explictly added here (since autoLoading is carried out after function
# arguments are processed using screenArgs, which is where 
# aliases are expanded)
#==============================================================================

#------------------------------------------------------------------------------
# Library: basislib
#------------------------------------------------------------------------------

grG_autoLoad[basislib] := { 
	grG_lambdabdnbdnbdn, grG_rotbdnbdnbdn, grG_strbdnbdnbdn, 
	grG_detb, grG_Clambdabdnbdnbdn,

	grG_Psi0, grG_Psi1, grG_Psi2, grG_Psi3, grG_Psi4,
	grG_Psi0bar, grG_Psi1bar, grG_Psi2bar, grG_Psi3bar, grG_Psi4bar,
	grG_Phi00, grG_Phi01, grG_Phi02, grG_Phi10, grG_Phi11, grG_Phi12,
	grG_Phi20, grG_Phi21, grG_Phi22, grG_Lambda,

	grG_NPkappa, grG_NPsigma, grG_NPlambda, grG_NPnu,
	grG_NPrho, grG_NPmu, grG_NPtau, grG_NPpi, grG_NPepsilon, grG_NPgamma,
	grG_NPalpha, grG_NPbeta, 
	grG_NPkappabar, grG_sigmabar, grG_NPlambdabar, grG_NPnubar,
	grG_NPrhobar, grG_NPmubar, grG_NPtaubar, grG_NPpibar,
	grG_NPepsilonbar, grG_NPgammabar, grG_NPalphabar, grG_NPbetabar,

	grG_Petrov,

	grG_Ckappa, grG_Csigma, grG_Clambda, grG_Cnu, grG_Crho, grG_Cmu,
	grG_Ctau, grG_Cpi, grG_Cepsilon, grG_Cgamma, grG_Calpha, grG_Cbeta,
	grG_Ckappabar, grG_Csigmabar, grG_Clambdabar, grG_Cnubar, grG_Crhobar, 
	grG_Cmubar, grG_Ctaubar, grG_Cpibar,
	grG_Cepsilonbar, grG_Cgammabar, grG_Calphabar, grG_Cbetabar,

	grG_DCFbupbup, grG_DCFpdn, grG_DCFqdn, grG_DCFrdn, grG_CPsi0,
	grG_CPsi1, grG_CPsi2, grG_CPsi3, grG_CPsi4, grG_CPhi00, 
	grG_CPhi01, grG_CPhi02, grG_CPhi11, grG_CPhi12, grG_CPhi22,

	grG_nulltup, grG_basisup, grG_Curve
}:


grG_ObjDef[WeylSc][grC_alias] := Psi0, Psi1, Psi2, Psi3, Psi4:

grG_ObjDef[RicciSc][grC_alias] := Phi00, Phi01, Phi02, Phi11, Phi12, Phi22,
				 Lambda:

grG_ObjDef[NPSpin][grC_alias] := NPkappa, NPsigma, NPlambda, NPnu, NPrho, 
                       NPmu, NPtau, NPpi, NPepsilon, NPgamma, NPalpha, NPbeta:

grG_ObjDef[NPSpinbar][grC_alias] :=  NPkappabar, NPsigmabar, NPlambdabar,
                       NPnubar, NPrhobar, NPmubar, NPtaubar, NPpibar,
                       NPepsilonbar, NPgammabar, NPalphabar, NPbetabar:

grG_ObjDef[basisv(up)][grC_alias] := e1(up), e2(up), e3(up), e4(up):
grG_ObjDef[basisv(up)][grC_groupTitle] := `Contravariant basis vectors`:
grG_ObjDef[basisv(dn)][grC_alias] := w1(dn), w2(dn), w3(dn), w4(dn):
grG_ObjDef[basisv(dn)][grC_groupTitle] := `Covariant basis vectors`:
grG_ObjDef[nullt(up)][grC_alias] := NPl(up), NPn(up), NPm(up), NPmbar(up):
grG_ObjDef[nullt(up)][grC_groupTitle] := `Contravariant tetrad vectors`:
grG_ObjDef[nullt(dn)][grC_alias] := NPl(dn), NPn(dn), NPm(dn), NPmbar(dn):
grG_ObjDef[nullt(dn)][grC_groupTitle] := `Covariant tetrad vectors`:

grG_ObjDef[CSpin][grC_alias] := Ckappa, Csigma, Clambda, Cnu, Crho, 
			Cmu, Ctau, Cpi, Cepsilon, Cgamma, Calpha, Cbeta:
grG_ObjDef[CSpinbar][grC_alias] := Ckappabar, Csigmabar, Clambdabar, Cnubar, 
			Crhobar, Cmubar, Ctaubar, Cpibar, Cepsilonbar,
			Cgammabar, Calphabar, Cbetabar:

grG_ObjDef[CWeylSc][grC_alias] := CPsi0, CPsi1, CPsi2, CPsi3, CPsi4:

grG_ObjDef[CRicciSc][grC_alias] := CPhi00, CPhi01, CPhi02, CPhi11, CPhi12, 
				CPhi22, CRicci:

grG_ObjDef[Curve][grC_alias] := Psi0, Psi1, Psi2, Psi3, Psi4,
			Psi0bar, Psi1bar, Psi2bar, Psi3bar, Psi4bar,
			Phi00, Phi01, Phi02, Phi10, Phi11, Phi12,
			Phi20, Phi21, Phi22, Lambda:

#grG_ObjDef[XCMM][grC_alias] := XM1R,XM1I,XM2R,XM2I,XM3,XM4,XM5R,XM5I:
#
#grG_ObjDef[SCM][grC_alias] := Lambda, SR1, SR2, SR3, SW1R, SW1I, SW2R, SW2I,
#		   SM1R, SM1I, SM2R, SM2I, SM3, SM4, SM5R, SM5I:
#
#grG_ObjDef[SCMR][grC_alias] := Lambda, SR1, SR2, SR3:
#
#grG_ObjDef[SCMM][grC_alias] := SM1R, SM1I, SM2R, SM2I, SM3, SM4, SM5R, SM5I:
#
#grG_ObjDef[SCMW][grC_alias] := SW1R, SW1I, SW2R, SW2I:
#

#------------------------------------------------------------------------------
# Library: cmscalar
#------------------------------------------------------------------------------

#grG_autoLoad[cmscalar] := {grG_CM, grG_R1, grG_R3, grG_R2, grG_W1R,
#          grG_M2R, grG_M2I,grG_M3, grG_M4, grG_M5R, grG_M5I, grG_CMW,
#          grG_Cstar_4, grG_CMM, grG_LevC_4, grG_LevC_3, grG_C2dndnupup_,
#          grG_C2bdnbdnbupbup_, grG_W1I, grG_CMR, grG_M1I, grG_W2I, grG_W2R,
#          grG_M1R, grG_CMS, grG_M2S, grG_M5S, grG_S2updn, grG_S3updn, 
#          grG_S4updn,
#          grG_XR1, grG_XR2, grG_XR3, grG_XM1I, grG_XM1R, grG_XM2I, grG_XM2R,
#          grG_XM3, grG_XM4, grG_XM5I, grG_XM5R, grG_XM2a, grG_XM2b, grG_M6R,
#	  grG_M6I
#}:
#
#
#grG_ObjDef[CM][grC_alias] := R1,R2,R3,W1R,W1I,W2R,W2I,
#		   M1R, M1I, M2R, M2I, M3, M4, M5R, M5I, Ricciscalar:
#
#grG_ObjDef[CMR][grC_alias] := R1, R2, R3, Ricciscalar:
#
#grG_ObjDef[CMM][grC_alias] := M1R, M1I, M2R, M2I, M3, M4, M5R, M5I:
#
#grG_ObjDef[CMW][grC_alias] := W1R, W1I, W2R, W2I:

#------------------------------------------------------------------------------
# Library: dinvar
#------------------------------------------------------------------------------

grG_autoLoad[dinvar] := {
	grG_diRicci, grG_diRiem, grG_d2Riem, grG_d3Riem, grG_d4Riem,
	grG_diS, grG_diWeyl, grG_diWeylstar
}:

#------------------------------------------------------------------------------
# Library: invar
#------------------------------------------------------------------------------

grG_autoLoad[invar] := {
	grG_R1, grG_XR1, grG_R1_BASIS, grG_XR1_BASIS, grG_R1_SPINOR,
	grG_R2, grG_XR2, grG_R2_BASIS, grG_XR2_BASIS, grG_R2_SPINOR,
	grG_R3, grG_XR3, grG_R3_BASIS, grG_XR3_BASIS, grG_R3_SPINOR,
	grG_W1R, grG_W1I, grG_W1R_BASIS, grG_W1I_BASIS, grG_W1_SPINOR,
		grG_W1R_SPINOR, grG_W1I_SPINOR,
	grG_W2R, grG_W2I, grG_W2R_BASIS, grG_W2I_BASIS, grG_W2_SPINOR,
		grG_W2R_SPINOR, grG_W2I_SPINOR,
	grG_M1R, grG_M1I, grG_M1R_BASIS, grG_M1I_BASIS, grG_M1_SPINOR,
		grG_M1R_SPINOR, grG_M1I_SPINOR,
	grG_M2a, grG_M2b, grG_M2a_BASIS, grG_M2b_BASIS,
	grG_M2R, grG_M2I, grG_M2R_BASIS, grG_M2I_BASIS, grG_M2_SPINOR,
		grG_M2R_SPINOR, grG_M2I_SPINOR,
	grG_M3, grG_M3_BASIS, grG_M3_SPINOR,
	grG_M4a, grG_M4b, grG_M4, grG_M4a_BASIS, grG_M4b_BASIS, grG_M4_BASIS,
		grG_M4_SPINOR,
	grG_M5a, grG_M5b, grG_M5c, grG_M5d, grG_M5R, grG_M5I, grG_M5S, 
		grG_M5a_BASIS, grG_M5b_BASIS, grG_M5c_BASIS, grG_M5d_BASIS,
		grG_M5R_BASIS, grG_M5I_BASIS, grG_M5S_BASIS, grG_M5_SPINOR,
		grG_M5R_SPINOR, grG_M5I_SPINOR,
	grG_M6R, grG_M6I, grG_M6R_BASIS, grG_M6I_BASIS, grG_M6_SPINOR,
		grG_M6R_SPINOR, grG_M6I_SPINOR
}:

grG_ObjDef[invars][grC_alias] := 
	Ricciscalar, R1, R2, R3, W1R, W1I, W2R, W2I, M1R, M1I, M2R, M2I, M3, 
	M4, M5R, M5I, M6R, M6I:

grG_ObjDef[Rinvars][grC_alias] := Ricciscalar, R1, R2, R3:

grG_ObjDef[Winvars][grC_alias] := W1R, W1I, W2R, W2I:

grG_ObjDef[Minvars][grC_alias] :=
	M1R, M1I, M2R, M2I, M3, M4, M5R, M5I, M6R, M6I: 

grG_ObjDef[CMinvars][grC_alias] :=
	Ricciscalar, R1, R2, R3, W1R, W1I, W2R, W2I, M1R, M1I, M2R, M2I, M3, 
	M4, M5R, M5I:

grG_ObjDef[SSinvars][grC_alias] := Ricciscalar, R1, R2, R3, W1R, M1R, M2S, M5S:

grG_ObjDef[CM][grC_alias] := grG_ObjDef[CMinvars][grC_alias]:
grG_ObjDef[CMR][grC_alias] := Ricciscalar, R1, R2, R3:
grG_ObjDef[CMW][grC_alias] := W1R, W1I, W2R, W2I:
grG_ObjDef[CMM][grC_alias] := M1R, M1I, M2R, M2I, M3, M4, M5R, M5I:
grG_ObjDef[CMS][grC_alias] := Ricciscalar, R1, R2, R3, W1R, M1R, M2S, M5S:
grG_ObjDef[CMB][grC_alias] := Ricciscalar, R1, R2, W2R:

grG_ObjDef[RXinvars][grC_alias] := XR1, XR2, XR3:

#==============================================================================
