#==============================================================================
# Scalar invariant m2
#
#  1 Mar 1995	Basis represenations created. [pm]
# 15 May 1995	Added M2S. [pm]
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
# M2a - First term in m2 (also used in m3) - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M2a][grC_header] := `Invariant M2a`:
grG_ObjDef[M2a][grC_root] := M2a_:
grG_ObjDef[M2a][grC_rootStr] := `M2a `:
grG_ObjDef[M2a][grC_indexList] := []:
grG_ObjDef[M2a][grC_calcFn] := grF_calc_M2a:
grG_ObjDef[M2a][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2a][grC_depends] := { CS(up,dn) }:

grF_calc_M2a := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, s, CSupdn:
  # check for tensor/basis mode
  if object = M2a or object = M2S then
    CSupdn := CSupdn_:
  else
    CSupdn := CSbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[CSupdn,grG_metricName,a,b]*gr_data[CSupdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(s/16):
end:

#------------------------------------------------------------------------------
# M2b - Second term in m2 (also used in m3) - Coordinate representation.
#------------------------------------------------------------------------------
grG_ObjDef[M2b][grC_header] := `Invariant M2b`:
grG_ObjDef[M2b][grC_root] := M2b_:
grG_ObjDef[M2b][grC_rootStr] := `M2b `:
grG_ObjDef[M2b][grC_indexList] := []:
grG_ObjDef[M2b][grC_calcFn] := grF_calc_M2b:
grG_ObjDef[M2b][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2b][grC_depends] := { CSstar(up,dn) }:

grF_calc_M2b := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, s, CSstarupdn:
  # check for tensor/basis mode
  if object = M2b then
    CSstarupdn := CSstarupdn_:
  else
    CSstarupdn := CSstarbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[CSstarupdn,grG_metricName,a,b]*gr_data[CSstarupdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(s/16):
end:

#------------------------------------------------------------------------------
# M2R - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M2R][grC_header] := `CM invariant Re(M2)`:
grG_ObjDef[M2R][grC_root] := M2R_:
grG_ObjDef[M2R][grC_rootStr] := `M2R `:
grG_ObjDef[M2R][grC_indexList] := []:
grG_ObjDef[M2R][grC_calcFn] := grF_calc_M2R:
grG_ObjDef[M2R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2R][grC_depends] := { M2a, M2b }:

grF_calc_M2R := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
  RETURN(gr_data[M2a_,grG_metricName] - gr_data[M2b_,grG_metricName]):
end:

#------------------------------------------------------------------------------
# M2I - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M2I][grC_header] := `CM invariant Im(M2)`:
grG_ObjDef[M2I][grC_root] := M2I_:
grG_ObjDef[M2I][grC_rootStr] := `M2I `:
grG_ObjDef[M2I][grC_indexList] := []:
grG_ObjDef[M2I][grC_calcFn] := grF_calc_M2I:
grG_ObjDef[M2I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2I][grC_depends] := { CS(up,dn), CSstar(up,dn) }:

grF_calc_M2I := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, s, CSupdn, CSstarupdn:
  # check for tensor/basis mode
  if object = M2I then
    CSupdn := CSupdn_:
    CSstarupdn  := CSstarupdn_:
  else
    CSupdn := CSbupbdn_:
    CSstarupdn  := CSstarbupbdn_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[CSupdn,grG_metricName,a,b]*gr_data[CSstarupdn,grG_metricName,b,a]:
    od:
  od:
  RETURN(-s/8):
end:

#------------------------------------------------------------------------------
# M2S - Coordinate representation (spherical symmetry)
#------------------------------------------------------------------------------
grG_ObjDef[M2S][grC_header] := `Invariant M2S`:
grG_ObjDef[M2S][grC_root] := M2a_:
grG_ObjDef[M2S][grC_rootStr] := `M2S `:
grG_ObjDef[M2S][grC_indexList] := []:
grG_ObjDef[M2S][grC_calcFn] := grF_calc_M2a:
grG_ObjDef[M2S][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2S][grC_depends] := { CS(up,dn) }:
grG_ObjDef[M2S][grC_displayName] := M2S:

#------------------------------------------------------------------------------
# M2a_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M2a_BASIS][grC_calcFn] := grF_calc_M2a:
grG_ObjDef[M2a_BASIS][grC_depends] := { CS(bup,bdn) }:
grG_ObjDef[M2a_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M2a_BASIS][grC_displayName] := M2a:

#------------------------------------------------------------------------------
# M2b_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M2b_BASIS][grC_calcFn] := grF_calc_M2b:
grG_ObjDef[M2b_BASIS][grC_depends] := { CSstar(bup,bdn) }:
grG_ObjDef[M2b_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M2b_BASIS][grC_displayName] := M2b:

#------------------------------------------------------------------------------
# M2R_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M2R_BASIS][grC_calcFn] := grF_calc_M2R:
grG_ObjDef[M2R_BASIS][grC_depends] := { M2a, M2b }:
grG_ObjDef[M2R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M2R_BASIS][grC_displayName] := M2R:

#------------------------------------------------------------------------------
# M2I_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M2I_BASIS][grC_calcFn] := grF_calc_M2I:
grG_ObjDef[M2I_BASIS][grC_depends] := { CS(bup,bdn), CSstar(bup,bdn) }:
grG_ObjDef[M2I_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M2I_BASIS][grC_displayName] := M2I:

#------------------------------------------------------------------------------
# M2S_BASIS - Basis representation (spherical symmetry)
#------------------------------------------------------------------------------
grG_ObjDef[M2S_BASIS][grC_calcFn] := grF_calc_M2a:
grG_ObjDef[M2S_BASIS][grC_depends] := { CS(bup,bdn) }:
grG_ObjDef[M2S_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M2S_BASIS][grC_displayName] := M2S:

#------------------------------------------------------------------------------
# M2_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[M2_SPINOR][grC_calcFn] := grF_calc_M2_SPINOR:
grG_ObjDef[M2_SPINOR][grC_header] := `CM Invariant: M2`:
grG_ObjDef[M2_SPINOR][grC_root] := M2_:
grG_ObjDef[M2_SPINOR][grC_rootStr] := `M2`:
grG_ObjDef[M2_SPINOR][grC_indexList] := []:
grG_ObjDef[M2_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M2_SPINOR][grC_calcFn] := grF_calc_M2_SPINOR:
grG_ObjDef[M2_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Phi00, Phi01, Phi02,
			Phi10, Phi11, Phi12, Phi20, Phi21, Phi22}:

grF_calc_M2_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s := 4*W1^2*R21^2+2*W4*R02*W0*R20-4*W3*R12*W0*R20+4*W2*R22*W0*R20+2*W4*R00*W0*
R22-4*W3*R10*W0*R22+4*W2*R10*W1*R22-4*W1^2*R22*R20-4*W3*R02*W1*R20+4*W2*R12*W1*
R20+4*W4*R02*W2*R00+4*W3*R12*W2*R00+2*W2^2*R22*R00-4*W1*R22*W3*R00-4*W3^2*R02*
R00-4*W4*R01^2*W2-8*W3*R11*W2*R01+2*W2^2*R20*R02-4*W2^2*R21*R01-4*W4*R02*W1*R10
+16*W3*R12*W1*R10+4*W3^2*R01^2+8*W3*R11*W0*R21-4*W4*R01*W0*R21+4*W3*R02*W2*R10-
16*W2^2*R12*R10+8*W1*R21*W3*R01-4*W2*R21^2*W0-4*W4*R00*W1*R12+8*W4*R01*W1*R11-
16*W3*R11^2*W1-8*W2*R21*W1*R11+16*W2^2*R11^2:
   RETURN(s):
end:

#------------------------------------------------------------------------------
# M2R_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[M2R_SPINOR][grC_displayName] := M2R:
grG_ObjDef[M2R_SPINOR][grC_calcFn] := grF_calc_M2R_SPINOR:
grG_ObjDef[M2R_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M2R_SPINOR][grC_depends] := { M2_SPINOR }:

grF_calc_M2R_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, gr_data[M2_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# M2I_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[M2I_SPINOR][grC_displayName] := M2I:
grG_ObjDef[M2I_SPINOR][grC_calcFn] := grF_calc_M2I_SPINOR:
grG_ObjDef[M2I_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[M2I_SPINOR][grC_depends] := { M2_SPINOR }:

grF_calc_M2I_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, expand ( -I*gr_data[M2_,grG_metricName] ) ):
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
