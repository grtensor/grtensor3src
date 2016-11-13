#==============================================================================
# autoLoad
#------------------------------------------------------------------------------
# in griii there are no autoload libraries (all objects are in the main package)
# Definitions of aliases are defined here.
#==============================================================================

#------------------------------------------------------------------------------
# Library: basislib
#------------------------------------------------------------------------------

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


#------------------------------------------------------------------------------
# Library: invar
#------------------------------------------------------------------------------


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
