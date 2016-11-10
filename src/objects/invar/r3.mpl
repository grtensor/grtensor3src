#==============================================================================
# Scalar invariant r3
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
# R3 - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[R3][grC_header] := `CM invariant R3`:
grG_ObjDef[R3][grC_root] := R3_:
grG_ObjDef[R3][grC_rootStr] := `R3 `:
grG_ObjDef[R3][grC_indexList] := []:
grG_ObjDef[R3][grC_calcFn] := grF_calc_R3:
grG_ObjDef[R3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[R3][grC_depends] := { S(up,dn) }:

grF_calc_R3 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s,Supdn;
  # check for tensor/basis mode
  if object = R3 then
    Supdn := Supdn_:
  else
    Supdn := Sbupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      if Supdn[grG_metricName,a,b] <> 0 then
        for c to Ndim[grG_metricName] do
          for d to Ndim[grG_metricName] do
	  s := s + gr_data[Supdn,grG_metricName,a,b] * gr_data[Supdn,grG_metricName,b,c] *
		 gr_data[Supdn,grG_metricName,c,d] * gr_data[Supdn,grG_metricName,d,a]:
          od:
        od:
      fi:
    od:
  od:
  RETURN(s/16):
end:

#------------------------------------------------------------------------------
# XR3 - Coordinate representation (alternate)
#------------------------------------------------------------------------------
grG_ObjDef[XR3][grC_header] := `CM invariant R3`:
grG_ObjDef[XR3][grC_root] := XR3_:
grG_ObjDef[XR3][grC_rootStr] := `XR3 `:
grG_ObjDef[XR3][grC_indexList] := []:
grG_ObjDef[XR3][grC_calcFn] := grF_calc_XR3:
grG_ObjDef[XR3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[XR3][grC_depends] := { S4(up,dn) }:

grF_calc_XR3 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a, s, S4updn;

  # check for tensor/basis mode
  if object = XR3 then
    S4updn := S4updn_:
  else
    S4updn := S4bupbdn_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[S4updn,grG_metricName,a,a]:
  od:
  RETURN(s/16):
end:

#------------------------------------------------------------------------------
# R3_BASIS - Basis representation
#------------------------------------------------------------------------------

grG_ObjDef[R3_BASIS][grC_calcFn] := grF_calc_R3:
grG_ObjDef[R3_BASIS][grC_depends] := { S(bup,bdn) }:
grG_ObjDef[R3_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[R3_BASIS][grC_displayName] := R3:

#------------------------------------------------------------------------------
# XR3_BASIS - Basis representation
#------------------------------------------------------------------------------

grG_ObjDef[XR3_BASIS][grC_calcFn] := grF_calc_XR3:
grG_ObjDef[XR3_BASIS][grC_depends] := { S4(bup,bdn) }:
grG_ObjDef[XR3_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[XR3_BASIS][grC_displayName] := R3:

#------------------------------------------------------------------------------
# R3_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[R3_SPINOR][grC_displayName] := R3:
grG_ObjDef[R3_SPINOR][grC_calcFn] := grF_calc_R3_SPINOR:
grG_ObjDef[R3_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[R3_SPINOR][grC_calcFn] := grF_calc_R3_SPINOR:
grG_ObjDef[R3_SPINOR][grC_depends] := {Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20, Phi21,
			Phi22}:

grF_calc_R3_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s := 4*R10^2*R12^2-8*R20*R12*R10*R02-8*R20*R02*R21*R01+4*R21^2*R02*R00+2*R20^2
*R02^2+12*R20*R11^2*R02-8*R11*R02*R21*R10-8*R10*R22*R11*R01-8*R20*R12*R11*R01-8
*R21*R12*R11*R00-8*R00*R22*R10*R12+4*R10^2*R22*R02+4*R01^2*R22*R20+4*R00*R12^2*
R20+2*R00^2*R22^2+12*R22*R11^2*R00-8*R21*R11^2*R01-8*R11^2*R12*R10+4*R11^4-8*
R01*R22*R21*R00+4*R21^2*R01^2+24*R01*R12*R21*R10:
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
