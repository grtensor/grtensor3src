#==============================================================================
# Scalar invariant m5
#
# 31 May 1996	Created. [dp]
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
# M6R - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M6R][grC_header] := `CM invariant Re(M6)`:
grG_ObjDef[M6R][grC_root] := M6R_:
grG_ObjDef[M6R][grC_rootStr] := `M6R `:
grG_ObjDef[M6R][grC_indexList] := []:
grG_ObjDef[M6R][grC_calcFn] := grF_calc_M6R:
grG_ObjDef[M6R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M6R][grC_depends] := { C(dn,dn,dn,dn), S2(up,up) }:

grF_calc_M6R := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cdndndndn, S2upup:
  # check for tensor/basis mode
  if object = M6R then
    Cdndndndn := grG_Cdndndndn_:
    S2upup := grG_S2upup_:
  else
    Cdndndndn := grG_Cbdnbdnbdnbdn_:
    S2upup := grG_S2bupbup_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cdndndndn,grG_metricName,a,b,c,d]*gr_data[S2upup.grG_metricName,a,c]*
            gr_data[S2upup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(s/32):
end:

#------------------------------------------------------------------------------
# M6I - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M6I][grC_header] := `CM invariant Im(M6)`:
grG_ObjDef[M6I][grC_root] := M6I_:
grG_ObjDef[M6I][grC_rootStr] := `M6I `:
grG_ObjDef[M6I][grC_indexList] := []:
grG_ObjDef[M6I][grC_calcFn] := grF_calc_M6I:
grG_ObjDef[M6I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M6I][grC_depends] := { Cstar(dn,dn,dn,dn), S2(up,up) }:

grF_calc_M6I := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cstardndndndn, S2upup:
  # check for tensor/basis mode
  if object = M6I then
    Cstardndndndn := grG_Cstardndndndn_:
    S2upup := grG_S2upup_:
  else
    Cstardndndndn := grG_Cstarbdnbdnbdnbdn_:
    S2upup := grG_S2bupbup_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cstardndndndn,grG_metricName,a,b,c,d]*gr_data[S2upup,grG_metricName,a,c]*
            gr_data[S2upup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(s/16):
end:

#------------------------------------------------------------------------------
# M6R_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M6R_BASIS][grC_calcFn] := grF_calc_M6R:
grG_ObjDef[M6R_BASIS][grC_depends] := { C(bdn,bdn,bdn,bdn), S2(bup,bup) }:
grG_ObjDef[M6R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M6R_BASIS][grC_displayName] := M6R:

#------------------------------------------------------------------------------
# M6I_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M6I_BASIS][grC_calcFn] := grF_calc_M6I:
grG_ObjDef[M6I_BASIS][grC_depends] := { Cstar(bdn,bdn,bdn,bdn), S2(bup,bup) }:
grG_ObjDef[M6I_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M6I_BASIS][grC_displayName] := M6I:

#------------------------------------------------------------------------------
# M6_SPINOR - Basis representation
#------------------------------------------------------------------------------

grG_ObjDef[M6_SPINOR][grC_header] := `Scalar Invariant: M6`:
grG_ObjDef[M6_SPINOR][grC_root] := M6_:
grG_ObjDef[M6_SPINOR][grC_rootStr] := `M6`:
grG_ObjDef[M6_SPINOR][grC_indexList] := []:
grG_ObjDef[M6_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M6_SPINOR][grC_calcFn] := grF_calc_M6_SPINOR:
grG_ObjDef[M6_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Psi0bar,
			Psi1bar, Psi2bar, Psi3bar, Psi4bar,
			Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20,
			Phi21, Phi22}:

grF_calc_M6_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s := 8*W4*R12*R01*R00*R11-8*W4*R02*R11^2*R00+4*W3*
R10*R02^2*R20-8*W1*R21*R02*R11*R20+4*W3*R12*R00^2*R22-4*W3*R02*
R10*R00*R22+8*W0*R21*R12*R11*R20-8*W0*R11^2*R22*R20+16*W2*R12*
R01*R10*R21-8*W2*R02*R11*R10*R21+4*W2*R02*R20*R00*R22+8*W1*R02*
R21^2*R10+8*W2*R22*R01*R00*R21-8*W1*R22*R11*R00*R21+8*W1*R12*
R21^2*R00-4*W3*R02*R20*R00*R12-2*W4*R12^2*R00^2+4*W4*R02*R10*
R00*R12+8*W2*R22*R11^2*R00-8*W2*R01^2*R22*R20-8*W3*R11*R02*R01*
R20+8*W3*R01^2*R12*R20-8*W3*R22*R01*R00*R11-8*W1*R22*R01*R10*
R21-8*W4*R01^2*R12*R10+8*W4*R11*R02*R01*R10-8*W2*R01*R12*R11*
R20+8*W2*R11^2*R02*R20-4*W1*R02*R20*R10*R22-2*W2*R20^2*R02^2-8*
W0*R12*R21^2*R10+8*W0*R22*R11*R10*R21+8*W3*R01^2*R22*R10-4*W2*
R12*R00*R10*R22+4*W2*R02*R10^2*R22+4*W1*R20^2*R02*R12+8*W2*R21*
R02*R01*R20-4*W2*R02*R20*R10*R12-2*W0*R20^2*R12^2+16*W1*R01*R22
*R11*R20-8*W2*R22*R01*R10*R11-8*W1*R21*R12*R01*R20-2*W2*R22^2*
R00^2-2*W4*R10^2*R02^2-8*W3*R21*R02*R01*R10-4*W1*R12*R20*R00*
R22+4*W1*R22^2*R00*R10+4*W2*R12^2*R20*R00-2*W0*R22^2*R10^2+4*W0
*R12*R20*R10*R22-8*W2*R02*R21^2*R00-8*W2*R12*R11*R00*R21+16*W3*
R02*R11*R00*R21-8*W3*R12*R01*R00*R21:
  RETURN(s):
end:

#------------------------------------------------------------------------------
# M6R_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[M6R_SPINOR][grC_displayName] := M6R:
grG_ObjDef[M6R_SPINOR][grC_calcFn] := grF_calc_M6R_SPINOR:
grG_ObjDef[M6R_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M6R_SPINOR][grC_depends] := { M6_SPINOR }:

grF_calc_M6R_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, gr_data[M6_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# M6I_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[M6I_SPINOR][grC_displayName] := M6I:
grG_ObjDef[M6I_SPINOR][grC_calcFn] := grF_calc_M6I_SPINOR:
grG_ObjDef[M6I_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M6I_SPINOR][grC_depends] := { M6_SPINOR }:

grF_calc_M6I_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, expand ( -I*gr_data[M6_,grG_metricName] ) ):
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