#==============================================================================
# Scalar invariant m4
#
#  1 Mar 1995	Basis represenations created. [pm]
# 24 Jul 1995	Spinor polynomial representations created. [dp]
# 27 Nov 1995	Defs of real and imaginary spinor invariants created. [dp]
# 30 May 1996	Re-formulation in terms of CS(up,dn). [dp]
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
# M4a - Coorinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M4a][grC_header] := `CM invariant M4a`:
grG_ObjDef[M4a][grC_root] := M4a_:
grG_ObjDef[M4a][grC_rootStr] := `M4a `:
grG_ObjDef[M4a][grC_indexList] := []:
grG_ObjDef[M4a][grC_calcFn] := grF_calc_M4a:
grG_ObjDef[M4a][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M4a][grC_depends] := { S(up,dn), CS(up,dn) }:

grF_calc_M4a := proc ( object, iList )
local a, b, c, s, Supdn, CSupdn:
global grG_metricName, gr_data, Ndim;
  # check for tensor/basis mode
  if object = M4a then
    Supdn := Supdn_:
    CSupdn := CSupdn_:
  else
    Supdn := Sbupbdn_:
    CSupdn := CSbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        s := s + gr_data[CSupdn,grG_metricName,a,b]*gr_data[CSupdn,grG_metricName,b,c]*gr_data[Supdn,grG_metricName,c,a]:
      od:
    od:
  od:
  RETURN(-s/32):
end:

#------------------------------------------------------------------------------
# M4b - Coorinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M4b][grC_header] := `CM invariant M4b`:
grG_ObjDef[M4b][grC_root] := M4b_:
grG_ObjDef[M4b][grC_rootStr] := `M4b `:
grG_ObjDef[M4b][grC_indexList] := []:
grG_ObjDef[M4b][grC_calcFn] := grF_calc_M4b:
grG_ObjDef[M4b][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M4b][grC_depends] := { S(up,dn), CSstar(up,dn) }:

grF_calc_M4b := proc ( object, iList )
local a, b, c, s, Supdn, CSstarupdn:
global grG_metricName, gr_data, Ndim;
  # check for tensor/basis mode
  if object = M4b then
    Supdn := Supdn_:
    CSstarupdn  := CSstarupdn_:
  else
    Supdn := Sbupbdn_:
    CSstarupdn  := CSstarbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        s := s + gr_data[CSstarupdn,grG_metricName,a,b]*gr_data[CSstarupdn,grG_metricName,b,c]*gr_data[Supdn,grG_metricName,c,a]:
      od:
    od:
  od:
  RETURN(-s/32):
end:

#------------------------------------------------------------------------------
# M4 - Coorinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M4][grC_header] := `CM invariant M4`:
grG_ObjDef[M4][grC_root] := M4_:
grG_ObjDef[M4][grC_rootStr] := `M4 `:
grG_ObjDef[M4][grC_indexList] := []:
grG_ObjDef[M4][grC_calcFn] := grF_calc_M4:
grG_ObjDef[M4][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M4][grC_depends] := { M4a, M4b }:

grF_calc_M4 := proc ( object, iList )
global grG_metricName, gr_data, Ndim;
  RETURN( gr_data[M4a_,grG_metricName] + gr_data[M4b_,grG_metricName] ):
end:

#------------------------------------------------------------------------------
# M4a_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M4a_BASIS][grC_calcFn] := grF_calc_M4a:
grG_ObjDef[M4a_BASIS][grC_depends] := { S(bup,bdn), CS(bup,bdn) }:
grG_ObjDef[M4a_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M4a_BASIS][grC_displayName] := M4a:

#------------------------------------------------------------------------------
# M4b_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M4b_BASIS][grC_calcFn] := grF_calc_M4b:
grG_ObjDef[M4b_BASIS][grC_depends] := { S(bup,bdn), CSstar(bup,bdn) }:
grG_ObjDef[M4b_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M4b_BASIS][grC_displayName] := M4b:

#------------------------------------------------------------------------------
# M4_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M4_BASIS][grC_calcFn] := grF_calc_M4:
grG_ObjDef[M4_BASIS][grC_depends] := { M4a, M4b }:
grG_ObjDef[M4_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M4_BASIS][grC_displayName] := M4:

#------------------------------------------------------------------------------
# M4_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[M4_SPINOR][grC_displayName] := M4:
grG_ObjDef[M4_SPINOR][grC_calcFn] := grF_calc_M4_SPINOR:
grG_ObjDef[M4_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M4_SPINOR][grC_calcFn] := grF_calc_M4_SPINOR:
grG_ObjDef[M4_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Psi0bar,
			Psi1bar, Psi2bar, Psi3bar, Psi4bar,
			Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20,
			Phi21, Phi22}:

grF_calc_M4_SPINOR := proc(object, iList)
global grG_metricName, gr_data, Ndim;
local  s:
s := W0*R20^2*W4c*R11-2*W3*R02*W0c*R12*R11+W3*R02*W3c*R00*R20+W0*R22*W0c*R12*
R21-6*W3*R02*W2c*R11*R10-W0*R22*W1c*R12*R20+2*W3*R01*W0c*R12^2-W0*R20*W4c*R10*
R21+W0*R22^2*W1c*R10+2*W3*R00*W4c*R10*R11-2*W1*R10^2*W3c*R22+3*W2*R00*W3c*R10*
R22-W1*R22*W3c*R20*R00+W1*R20*W1c*R22*R02-W1*R21*W0c*R22*R02+W3*R01*W0c*R02*R22
+2*W1*R10*W3c*R20*R12+W3*R00^2*W4c*R21-3*W0*R21*W2c*R22*R10-4*W1*R11^2*W1c*R22+
6*W2*R01*W1c*R22*R11-W0*R22^2*W0c*R11-4*W3*R00*W3c*R11^2-W4*R00*W3c*R10*R02+4*
W1*R11*W1c*R12*R21+3*W0*R21*W2c*R12*R20-2*W3*R01^2*W1c*R22-W1*R20^2*W4c*R01-3*
W3*R01*W2c*R02*R20+W4*R00^2*W3c*R12-3*W2*R10*W3c*R20*R02+2*W3*R02*W1c*R12*R10-2
*W1*R21*W1c*R22*R01+2*W4*R01*W3c*R11*R00-2*W3*R01*W4c*R10^2-6*W2*R00*W2c*R22*
R11-W1*R22^2*W1c*R00+2*W1*R12*W0c*R22*R11-2*W4*R01^2*W3c*R10+W1*R21*W4c*R00*R20
+6*W3*R00*W2c*R12*R11+W4*R00*W4c*R10*R01+2*W1*R21*W3c*R01*R20+3*W2*R02*W0c*R12*
R21-2*W1*R12^2*W0c*R21+W0*R20*W3c*R10*R22-W4*R00^2*W4c*R11+6*W2*R11*W3c*R00*R21
-2*W3*R01*W3c*R00*R21-W0*R20^2*W3c*R12-W4*R02^2*W1c*R10+3*W2*R02*W2c*R21*R10-W3
*R01*W4c*R00*R20+W4*R02*W1c*R12*R00-3*W2*R12*W0c*R22*R01+2*W0*R21*W1c*R22*R11+6
*W2*R02*W2c*R11*R20-3*W2*R00*W2c*R12*R21-3*W1*R20*W2c*R21*R02-2*W3*R00*W3c*R10*
R12+3*W2*R12*W1c*R22*R00-2*W0*R21^2*W1c*R12+2*W0*R21^2*W3c*R10-W3*R00^2*W3c*R22
-4*W1*R11*W3c*R21*R10+2*W4*R01^2*W1c*R12-3*W4*R01*W2c*R12*R00+3*W3*R00*W2c*R01*
R22+3*W4*R01*W2c*R02*R10-6*W2*R01*W3c*R11*R20+4*W1*R11^2*W3c*R20+2*W3*R01*W1c*
R02*R21-2*W4*R01*W1c*R02*R11+4*W3*R02*W1c*R11^2-6*W2*R11*W1c*R02*R21-2*W1*R12*
W1c*R22*R10-2*W1*R21^2*W3c*R00-4*W3*R01*W1c*R12*R11-2*W0*R21*W3c*R11*R20+4*W3*
R01*W3c*R11*R10+2*W1*R12^2*W1c*R20-3*W2*R02*W1c*R12*R20+3*W2*R10*W4c*R20*R01+2*
W1*R21^2*W1c*R02-2*W1*R10*W4c*R20*R11+W3*R02^2*W1c*R20+W1*R22^2*W0c*R01-3*W2*
R00*W4c*R10*R21+2*W1*R10^2*W4c*R21-2*W3*R00*W1c*R12^2-W3*R02^2*W0c*R21+3*W1*R22
*W2c*R00*R21-W4*R02*W0c*R12*R01+2*W3*R01^2*W3c*R20+W1*R20^2*W3c*R02-W3*R00*W1c*
R02*R22+W4*R02^2*W0c*R11+2*W3*R02*W3c*R10^2+3*W2*R01*W2c*R12*R20-6*W1*R11*W2c*
R12*R20-3*W2*R01*W2c*R22*R10+6*W1*R11*W2c*R22*R10:
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


