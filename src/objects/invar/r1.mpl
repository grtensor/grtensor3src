#==============================================================================
# Scalar invariant r1
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
# R1 - Component representation
#------------------------------------------------------------------------------
grG_ObjDef[R1][grC_header] := `CM invariant R1`:
grG_ObjDef[R1][grC_root] := R1_:
grG_ObjDef[R1][grC_rootStr] := `R1 `:
grG_ObjDef[R1][grC_indexList] := []:
grG_ObjDef[R1][grC_calcFn] := grF_calc_R1:
grG_ObjDef[R1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[R1][grC_depends] := { S(up,dn) }:

grF_calc_R1 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, b, s, Supdn;
  # check for tensor/basis mode
  if object = R1 then
    Supdn := Supdn_:
  else
    Supdn := Sbupbdn_:
  fi:
  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
	s := s + gr_data[Supdn,grG_metricName,a,b] * gr_data[Supdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(s/4):
end:

#------------------------------------------------------------------------------
# XR1 - Component representation (alternate)
#------------------------------------------------------------------------------
grG_ObjDef[XR1][grC_header] := `CM invariant R1`:
grG_ObjDef[XR1][grC_root] := XR1_:
grG_ObjDef[XR1][grC_rootStr] := `XR1 `:
grG_ObjDef[XR1][grC_indexList] := []:
grG_ObjDef[XR1][grC_calcFn] := grF_calc_XR1:
grG_ObjDef[XR1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[XR1][grC_depends] := { S2(up,dn) }:

grF_calc_XR1 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, s, S2updn:

  # check for tensor/basis mode
  if object = XR1 then
    S2updn := S2updn_:
  else
    S2updn := S2bupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
	s := s + gr_data[S2updn,grG_metricName,a,a]:
  od:
  RETURN(s/4):
end:

#------------------------------------------------------------------------------
# R1_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[R1_BASIS][grC_calcFn] := grF_calc_R1:
grG_ObjDef[R1_BASIS][grC_depends] := { S(bup,bdn) }:
grG_ObjDef[R1_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[R1_BASIS][grC_displayName] := R1:

#------------------------------------------------------------------------------
# XR1_BASIS - Basis representation (alternate)
#------------------------------------------------------------------------------
grG_ObjDef[XR1_BASIS][grC_calcFn] := grF_calc_XR1:
grG_ObjDef[XR1_BASIS][grC_depends] := { S2(bup,bdn) }:
grG_ObjDef[XR1_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[XR1_BASIS][grC_displayName] := R1:

#------------------------------------------------------------------------------
# R1_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[R1_SPINOR][grC_displayName] := R1:
grG_ObjDef[R1_SPINOR][grC_calcFn] := grF_calc_R1_SPINOR:
grG_ObjDef[R1_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[R1_SPINOR][grC_calcFn] := grF_calc_R1_SPINOR:
grG_ObjDef[R1_SPINOR][grC_depends] := { Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20, Phi21,
			Phi22 }:

grF_calc_R1_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
  s := 2*R22*R00-4*R21*R01+2*R20*R02-4*R12*R10+4*R11^2:
  RETURN(s):
end:

#==============================================================================
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

