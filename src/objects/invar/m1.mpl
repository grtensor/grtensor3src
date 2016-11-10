#==============================================================================
# Scalar invariant M1
#
#  1 Mar 1995	Basis represenations created. [pm]
# 24 Jul 1995	Spinor polynomial representations created. [dp]
# 27 Nov 1995	Defs of real and imaginary spinor invariants created. [dp]
# 31 May 1996	Created from cmscalar.mpl. [dp]
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
# M1R - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M1R][grC_header] := `CM invariant Re(M1)`:
grG_ObjDef[M1R][grC_root] := M1R_:
grG_ObjDef[M1R][grC_rootStr] := `M1R `:
grG_ObjDef[M1R][grC_indexList] := []:
grG_ObjDef[M1R][grC_calcFn] := grF_calc_M1R:
grG_ObjDef[M1R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M1R][grC_depends] := { S(up,dn), CS(up,dn) }:

grF_calc_M1R := proc ( object, iList )
local a, b, s, CSupdn, Supdn:
global gr_data, Ndim, grG_metricName;
  # check for tensor/basis mode
  if object = M1R then
    CSupdn := CSupdn_:
    Supdn  := Supdn_:
  else
    CSupdn := CSbupbdn_:
    Supdn  := Sbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[CSupdn,grG_metricName,a,b]*gr_data[Supdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(s/8):
end:

#------------------------------------------------------------------------------
# M1I - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M1I][grC_header] := `CM invariant Im(M1)`:
grG_ObjDef[M1I][grC_root] := M1I_:
grG_ObjDef[M1I][grC_rootStr] := `M1I `:
grG_ObjDef[M1I][grC_indexList] := []:
grG_ObjDef[M1I][grC_calcFn] := grF_calc_M1I:
grG_ObjDef[M1I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M1I][grC_depends] := { S(up,dn), CSstar(up,dn) }:

grF_calc_M1I := proc ( object, iList )
local a, b, s, CSstarupdn, Supdn:
global gr_data, Ndim, grG_metricName;
  # check for tensor/basis mode
  if object = M1I then
    CSstarupdn := CSstarupdn_:
    Supdn  := Supdn_:
  else
    CSstarupdn := CSstarbupbdn_:
    Supdn  := Sbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[CSstarupdn,grG_metricName,a,b]*gr_data[Supdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(s/8):
end:

#------------------------------------------------------------------------------
# M1R_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M1R_BASIS][grC_calcFn] := grF_calc_M1R:
grG_ObjDef[M1R_BASIS][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M1R_BASIS][grC_depends] := { S(bup,bdn), CS(bup,bdn) }:
grG_ObjDef[M1R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M1R_BASIS][grC_displayName] := M1R:

#------------------------------------------------------------------------------
# M1I_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M1I_BASIS][grC_calcFn] := grF_calc_M1I:
grG_ObjDef[M1I_BASIS][grC_displayName] := M1I:
grG_ObjDef[M1I_BASIS][grC_depends] := { S(bup,bdn), CSstar(bup,bdn) }:
grG_ObjDef[M1I_BASIS][grC_useWhen] := grF_useWhen_tetrad:

#------------------------------------------------------------------------------
# M1_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[M1_SPINOR][grC_header] := `CM Invariant: M1`:
grG_ObjDef[M1_SPINOR][grC_root] := M1_:
grG_ObjDef[M1_SPINOR][grC_rootStr] := `M1`:
grG_ObjDef[M1_SPINOR][grC_indexList] := []:
grG_ObjDef[M1_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M1_SPINOR][grC_calcFn] := grF_calc_M1_SPINOR:
grG_ObjDef[M1_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Phi00, Phi01, Phi02,
			Phi10, Phi11, Phi12, Phi20, Phi21, Phi22}:

grF_calc_M1_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s := 2*W2*R02*R20-4*W1*R12*R20-4*W2*R21*R01+2*W0*R22*R20-2*W4*R01^2+8*W3*R11*
R01-8*W2*R11^2+8*W1*R21*R11+2*W4*R02*R00-4*W3*R12*R00+2*W2*R22*R00-4*W1*R22*R10
-4*W3*R02*R10+8*W2*R12*R10-2*W0*R21^2:
   RETURN(s):
end:

#------------------------------------------------------------------------------
# M1R_SPINOR
#------------------------------------------------------------------------------
grG_ObjDef[M1R_SPINOR][grC_displayName] := M1R:
grG_ObjDef[M1R_SPINOR][grC_calcFn] := grF_calc_M1R_SPINOR:
grG_ObjDef[M1R_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
gr[grC_depends] := { M1_SPINOR }:

grF_calc_M1R_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, gr_data[M1_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# M1I_SPINOR
#------------------------------------------------------------------------------
grG_ObjDef[M1I_SPINOR][grC_displayName] := M1I:
grG_ObjDef[M1I_SPINOR][grC_calcFn] := grF_calc_M1I_SPINOR:
grG_ObjDef[M1I_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M1I_SPINOR][grC_depends] := { M1_SPINOR }:

grF_calc_M1I_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, expand ( -I*gr_data[M1_,grG_metricName] ) ):
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

