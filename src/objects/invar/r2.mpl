#==============================================================================
# Scalar invariant r2
#
#  1 Mar 1995	Basis represenations created. [pm]
# 24 Jul 1995	Spinor polynomial representations created. [dp]
# 27 Nov 1995	Defs of real and imaginary spinor invariants created. [dp]
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
# R2 - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[R2][grC_header] := `CM invariant R2`:
grG_ObjDef[R2][grC_root] := R2_:
grG_ObjDef[R2][grC_rootStr] := `R2 `:
grG_ObjDef[R2][grC_indexList] := []:
grG_ObjDef[R2][grC_calcFn] := grF_calc_R2:
grG_ObjDef[R2][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[R2][grC_symPerm] := []:
grG_ObjDef[R2][grC_depends] := { S(up,dn) }:

grF_calc_R2 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, b, c, s, s1,Supdn;
  # check for tensor/basis mode
  if object = R2 then
    Supdn := Supdn_:
  else
    Supdn := Sbupbdn_:
  fi:
  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
	s := s + gr_data[Supdn,grG_metricName,a,b] * gr_data[Supdn,grG_metricName,b,c] *
		 gr_data[Supdn,grG_metricName,c,a]:
      od:
    od:
  od:
  RETURN(-s/8):
end:

#------------------------------------------------------------------------------
# XR2 - Coordinate representation (alternate)
#------------------------------------------------------------------------------
grG_ObjDef[XR2][grC_header] := `CM invariant R2`:
grG_ObjDef[XR2][grC_root] := XR2_:
grG_ObjDef[XR2][grC_rootStr] := `XR2 `:
grG_ObjDef[XR2][grC_indexList] := []:
grG_ObjDef[XR2][grC_calcFn] := grF_calc_XR2:
grG_ObjDef[XR2][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[XR2][grC_symPerm] := []:
grG_ObjDef[XR2][grC_depends] := { S3(up,dn) }:

grF_calc_XR2 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, s, S3updn:

  # check for tensor/basis mode
  if object = XR2 then
    S3updn := S3updn_:
  else
    S3updn := S3bupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[S3updn,grG_metricName,a,a]:
  od:
  RETURN(-s/8):
end:

#------------------------------------------------------------------------------
# R2_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[R2_BASIS][grC_calcFn] := grF_calc_R2:
grG_ObjDef[R2_BASIS][grC_depends] := { S3(bup,bdn) }:
grG_ObjDef[R2_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[R2_BASIS][grC_displayName] := R2:

#------------------------------------------------------------------------------
# XR2_BASIS - Basis representation (alternate)
#------------------------------------------------------------------------------
grG_ObjDef[XR2_BASIS][grC_calcFn] := grF_calc_XR2:
grG_ObjDef[XR2_BASIS][grC_depends] := { S3(bup,bdn) }:
grG_ObjDef[XR2_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[XR2_BASIS][grC_displayName] := R2:

#------------------------------------------------------------------------------
# R2_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[R2_SPINOR][grC_displayName] := R2:
grG_ObjDef[R2_SPINOR][grC_calcFn] := grF_calc_R2_SPINOR:
grG_ObjDef[R2_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[R2_SPINOR][grC_calcFn] := grF_calc_R2_SPINOR:
grG_ObjDef[R2_SPINOR][grC_depends] := { Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20, Phi21,
			Phi22 }:

grF_calc_R2_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s :=  6*R22*R11*R00-6*R22*R10*R01+6*R21*R10*R02-6*R21*R00*R12+6*R12*R01*R20-6*
R20*R11*R02:
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
