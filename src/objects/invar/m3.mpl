#==============================================================================
# Scalar invariant m3
#
#  1 Mar 1995	Basis represenations created. [pm]
# 24 Jul 1995	Spinor polynomial representations created. [dp]
# 27 Nov 1995	Defs of real and imaginary spinor invariants created. [dp]
# 30 May 1996	Re-formulation in terms of M2a, M2b. [dp]
# 31 May 1996	Created from cmscalar.mpl, cmbasis.mpl, SpinorInvar.mpl. [dp]
#==============================================================================

$define R00 gr_data[NPPhi00_,grG_metricName] 
$define R01 gr_data[NPPhi01_,grG_metricName] 
$define R02 gr_data[NPPhi02_,grG_metricName] 
$define R10 gr_data[NPPhi10_,grG_metricName] 
$define R11 gr_data[NPPhi11_,grG_metricName] 
$define R12 gr_data[NPPhi12_,grG_metricName] 
$define R20 gr_data[NPPhi20_,grG_metricName] 
$define R21 gr_data[NPPhi21_,grG_metricName] 
$define R22 gr_data[NPPhi22_,grG_metricName] 

$define W0 gr_data[Psi0_,grG_metricName] 
$define W1 gr_data[Psi1_,grG_metricName] 
$define W2 gr_data[Psi2_,grG_metricName] 
$define W3 gr_data[Psi3_,grG_metricName] 
$define W4 gr_data[Psi4_,grG_metricName] 

$define W0c gr_data[Psi0bar_,grG_metricName] 
$define W1c gr_data[Psi1bar_,grG_metricName] 
$define W2c gr_data[Psi2bar_,grG_metricName] 
$define W3c gr_data[Psi3bar_,grG_metricName] 
$define W4c gr_data[Psi4bar_,grG_metricName] 



#------------------------------------------------------------------------------
# M3 - Coordinate representation (see m2.mpl for definitions of m2a, m2b)
#------------------------------------------------------------------------------
grG_ObjDef[M3][grC_header] := `CM invariant M3`:
grG_ObjDef[M3][grC_root] := M3_:
grG_ObjDef[M3][grC_rootStr] := `M3 `:
grG_ObjDef[M3][grC_indexList] := []:
grG_ObjDef[M3][grC_calcFn] := grF_calc_M3:
grG_ObjDef[M3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M3][grC_depends] := { M2a, M2b }:

grF_calc_M3 := proc ( object, iList )
global grG_metricName, gr_data, Ndim;
  RETURN(gr_data[M2a_,grG_metricName] + gr_data[M2b_,grG_metricName]):
end:

#------------------------------------------------------------------------------
# M3_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M3_BASIS][grC_calcFn] := grF_calc_M3:
grG_ObjDef[M3_BASIS][grC_calcFnParms] := 'grG_M3_[grG_metricName]':
grG_ObjDef[M3_BASIS][grC_depends] := { M2a, M2b }:
grG_ObjDef[M3_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M3_BASIS][grC_displayName] := M3:

#------------------------------------------------------------------------------
# M3_SPINOR
#------------------------------------------------------------------------------
grG_ObjDef[M3_SPINOR][grC_displayName] := M3:
grG_ObjDef[M3_SPINOR][grC_calcFn] := grF_calc_M3_SPINOR:
grG_ObjDef[M3_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M3_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Psi0bar,
			Psi1bar, Psi2bar, Psi3bar, Psi4bar,
			Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20,
			Phi21, Phi22}:

grF_calc_M3_SPINOR := proc(object, iList)
global grG_metricName, gr_data, Ndim;
local  s:
s := -4*W2*R21*W1c*R02+2*W2*R02*W0c*R22-4*W1*R12*W0c*R22-16*W2*R11*W1c*R12+8*
W3*R01*W1c*R12-4*W3*R02*W0c*R12+4*W2*R12^2*W0c+8*W1*R21*W3c*R10-4*W2*R01*W1c*
R22+W4*R02^2*W0c+8*W3*R01*W3c*R10-16*W2*R11*W3c*R10-4*W0*R21*W3c*R20+8*W1*R11*
W1c*R22-4*W2*R21*W3c*R00-4*W2*R01*W3c*R20+8*W1*R11*W3c*R20+W0*R22^2*W0c-4*W3*
R02*W2c*R10+8*W2*R12*W2c*R10-4*W1*R22*W2c*R10+2*W2*R02*W2c*R20-4*W1*R12*W2c*R20
+2*W4*R02*W2c*R00-4*W3*R12*W2c*R00+4*W0*R21^2*W2c+2*W0*R22*W2c*R20+2*W2*R22*W2c
*R00-4*W4*R01*W3c*R00+8*W3*R11*W3c*R00+8*W3*R11*W1c*R02-4*W4*R01*W1c*R02+W0*R20
^2*W4c+8*W2*R01*W2c*R21-16*W1*R11*W2c*R21-16*W3*R01*W2c*R11+16*W2*R11^2*W2c+4*
W4*R01^2*W2c-4*W3*R00*W4c*R10+4*W2*R10^2*W4c+8*W1*R21*W1c*R12+2*W2*R00*W4c*R20-
4*W1*R10*W4c*R20-4*W0*R21*W1c*R22+W4*R00^2*W4c:
   RETURN(s):
end:

#==============================================================================@
$undef R00 
$undef R01 
$undef R02 
$undef R10 
$undef R11 
$undef R12 
$undef R20 
$undef R21 
$undef R22 

$undef W0  
$undef W1  
$undef W2  
$undef W3  
$undef W4  

$undef W0c  
$undef W1c  
$undef W2c  
$undef W3c  
$undef W4c  

