#==============================================================================
# Scalar invariant m5
#
#  1 Mar 1995	Basis represenations created. [pm]
# 15 May 1995	Created M5S. [pm]
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
# M5a - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5a][grC_header] := `CM invariant M5a`:
grG_ObjDef[M5a][grC_root] := M5a_:
grG_ObjDef[M5a][grC_rootStr] := `M5a `:
grG_ObjDef[M5a][grC_indexList] := []:
grG_ObjDef[M5a][grC_calcFn] := grF_calc_M5a:
grG_ObjDef[M5a][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5a][grC_depends] := { C(dn,dn,dn,dn), CS(up,up) }:

grF_calc_M5a := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cdndndndn, CSupup:
  # check for tensor/basis mode
  if object = M5a or object = M5S then
    Cdndndndn := Cdndndndn_:
    CSupup := CSupup_:
  else
    Cdndndndn := Cbdnbdnbdnbdn_:
    CSupup := CSbupbup_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cdndndndn,grG_metricName,a,b,c,d]*gr_data[CSupup,grG_metricName,a,c]*
            gr_data[CSupup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(-s/32):
end:

#------------------------------------------------------------------------------
# M5b - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5b][grC_header] := `CM invariant M5b`:
grG_ObjDef[M5b][grC_root] := M5b_:
grG_ObjDef[M5b][grC_rootStr] := `M5b `:
grG_ObjDef[M5b][grC_indexList] := []:
grG_ObjDef[M5b][grC_calcFn] := grF_calc_M5b:
grG_ObjDef[M5b][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5b][grC_depends] := { C(dn,dn,dn,dn), CSstar(up,up) }:

grF_calc_M5b := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cdndndndn, CSstarupup:
  # check for tensor/basis mode
  if object = M5b then
    Cdndndndn := Cdndndndn_:
    CSstarupup  := CSstarupup_:
  else
    Cdndndndn := Cbdnbdnbdnbdn_:
    CSstarupup  := CSstarbupbup_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cdndndndn,grG_metricName,a,b,c,d]*gr_data[CSstarupup,grG_metricName,a,c]*
            gr_data[CSstarupup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(-s/32):
end:

#------------------------------------------------------------------------------
# M5c - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5c][grC_header] := `CM invariant M5c`:
grG_ObjDef[M5c][grC_root] := M5c_:
grG_ObjDef[M5c][grC_rootStr] := `M5c `:
grG_ObjDef[M5c][grC_indexList] := []:
grG_ObjDef[M5c][grC_calcFn] := grF_calc_M5c:
grG_ObjDef[M5c][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5c][grC_depends] := { Cstar(dn,dn,dn,dn), CS(up,up) }:

grF_calc_M5c := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cstardndndndn, CSupup:
  # check for tensor/basis mode
  if object = M5c then
    Cstardndndndn := Cstardndndndn_:
    CSupup := CSupup_:
  else
    Cstardndndndn := Cstarbdnbdnbdnbdn_:
    CSupup := CSbupbup_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cstardndndndn,grG_metricName,a,b,c,d]*gr_data[CSupup,grG_metricName,a,c]*
            gr_data[CSupup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(-s/64):
end:

#------------------------------------------------------------------------------
# M5d - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5d][grC_header] := `CM invariant M5d`:
grG_ObjDef[M5d][grC_root] := M5d_:
grG_ObjDef[M5d][grC_rootStr] := `M5d `:
grG_ObjDef[M5d][grC_indexList] := []:
grG_ObjDef[M5d][grC_calcFn] := grF_calc_M5d:
grG_ObjDef[M5d][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5d][grC_depends] := { Cstar(dn,dn,dn,dn), CSstar(up,up) }:

grF_calc_M5d := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
local a, b, c, d, s, Cstardndndndn, CSstarupup:
  # check for tensor/basis mode
  if object = M5d then
    Cstardndndndn := Cstardndndndn_:
    CSstarupup  := CSstarupup_:
  else
    Cstardndndndn := Cstarbdnbdnbdnbdn_:
    CSstarupup  := CSstarbupbup_:
  fi:

  s := 0;
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName] do
        for d to Ndim[grG_metricName] do
          s := s + gr_data[Cstardndndndn,grG_metricName,a,b,c,d]*
            gr_data[CSstarupup,grG_metricName,a,c]*gr_data[CSstarupup,grG_metricName,b,d]:
        od:
      od:
    od:
  od:
  RETURN(-s/64):
end:

#------------------------------------------------------------------------------
# M5R - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5R][grC_header] := `CM invariant Re(M5)`:
grG_ObjDef[M5R][grC_root] := M5R_:
grG_ObjDef[M5R][grC_rootStr] := `M5R `:
grG_ObjDef[M5R][grC_indexList] := []:
grG_ObjDef[M5R][grC_calcFn] := grF_calc_M5R:
grG_ObjDef[M5R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5R][grC_depends] := { M5a, M5b }:

grF_calc_M5R := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
  RETURN(gr_data[M5a_,grG_metricName] + gr_data[M5b_,grG_metricName]):
end:

#------------------------------------------------------------------------------
# M5I - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[M5I][grC_header] := `CM invariant Im(M5)`:
grG_ObjDef[M5I][grC_root] := M5I_:
grG_ObjDef[M5I][grC_rootStr] := `M5I `:
grG_ObjDef[M5I][grC_indexList] := []:
grG_ObjDef[M5I][grC_calcFn] := grF_calc_M5I:
grG_ObjDef[M5I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5I][grC_depends] := { M5c, M5d }:

grF_calc_M5I := proc ( object, iList )
global gr_data, Ndim, grG_metricName;
  RETURN(gr_data[M5c_,grG_metricName] + gr_data[M5d_,grG_metricName]):
end:

#------------------------------------------------------------------------------
# M5S - Coordinate representation (spherical symmetry)
#------------------------------------------------------------------------------
grG_ObjDef[M5S][grC_header] := `CM invariant M5S`:
grG_ObjDef[M5S][grC_root] := M5a_:
grG_ObjDef[M5S][grC_rootStr] := `M5S `:
grG_ObjDef[M5S][grC_indexList] := []:
grG_ObjDef[M5S][grC_calcFn] := grF_calc_M5a:
grG_ObjDef[M5S][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5S][grC_depends] := { C(dn,dn,dn,dn), CS(up,up) }:
grG_ObjDef[M5S][grC_displayName] := M5S:

#------------------------------------------------------------------------------
# M5a_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5a_BASIS][grC_calcFn] := grF_calc_M5a:
grG_ObjDef[M5a_BASIS][grC_depends] := { C(bdn,bdn,bdn,bdn), CS(bup,bup) }:
grG_ObjDef[M5a_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5a_BASIS][grC_displayName] := M5a:

#------------------------------------------------------------------------------
# M5b_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5b_BASIS][grC_calcFn] := grF_calc_M5b:
grG_ObjDef[M5b_BASIS][grC_depends] := { C(bdn,bdn,bdn,bdn), CSstar(bup,bup) }:
grG_ObjDef[M5b_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5b_BASIS][grC_displayName] := M5b:

#------------------------------------------------------------------------------
# M5c_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5c_BASIS][grC_calcFn] := grF_calc_M5c:
grG_ObjDef[M5c_BASIS][grC_depends] := { Cstar(bdn,bdn,bdn,bdn), CS(bup,bup) }:
grG_ObjDef[M5c_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5c_BASIS][grC_displayName] := M5c:

#------------------------------------------------------------------------------
# M5d_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5d_BASIS][grC_calcFn] := grF_calc_M5d:
grG_ObjDef[M5d_BASIS][grC_depends] := { Cstar(bdn,bdn,bdn,bdn), CSstar(bup,bup) }:
grG_ObjDef[M5d_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5d_BASIS][grC_displayName] := M5d:

#------------------------------------------------------------------------------
# M5R_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5R_BASIS][grC_calcFn] := grF_calc_M5R:
grG_ObjDef[M5R_BASIS][grC_depends] := { M5a, M5b }:
grG_ObjDef[M5R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5R_BASIS][grC_displayName] := M5R:

#------------------------------------------------------------------------------
# M5I_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[M5I_BASIS][grC_calcFn] := grF_calc_M5I:
grG_ObjDef[M5I_BASIS][grC_depends] := { M5c, M5d }:
grG_ObjDef[M5I_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5I_BASIS][grC_displayName] := M5I:

#------------------------------------------------------------------------------
# M5S_BASIS - Basis representation (spherical symmetry)
#------------------------------------------------------------------------------
grG_ObjDef[M5S_BASIS][grC_calcFn] := grF_calc_M5a:
grG_ObjDef[M5S_BASIS][grC_depends] := { C(bdn,bdn,bdn,bdn), CS(bup,bup) }:
grG_ObjDef[M5S_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[M5S_BASIS][grC_displayName] := M5S:

#------------------------------------------------------------------------------
# M5_SPINOR - Spinor polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[M5_SPINOR][grC_header] := `CM Invariant: M5`:
grG_ObjDef[M5_SPINOR][grC_root] := M5_:
grG_ObjDef[M5_SPINOR][grC_rootStr] := `M5`:
grG_ObjDef[M5_SPINOR][grC_indexList] := []:
grG_ObjDef[M5_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[M5_SPINOR][grC_calcFn] := grF_calc_M5_SPINOR:
grG_ObjDef[M5_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4, Psi0bar,
			Psi1bar, Psi2bar, Psi3bar, Psi4bar,
			Phi00, Phi01, Phi02, Phi10, Phi11, Phi12, Phi20,
			Phi21, Phi22}:

grF_calc_M5_SPINOR := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local  s:
s := ((2*(-W3*W0+W2*W1)*R12+(2*W2*W0-2*W1^2)*R22+(W2^2-2*W3*W1+W4*W0)*R02)*W2c
+2*(-2*(-W3*W0+W2*W1)*R11-(2*W2*W0-2*W1^2)*R21-(W2^2-2*W3*W1+W4*W0)*R01)*W3c+(2
*(-W3*W0+W2*W1)*R10+(2*W2*W0-2*W1^2)*R20+(W2^2-2*W3*W1+W4*W0)*R00)*W4c)*R20+2*(
-(2*(-W3*W0+W2*W1)*R12+(2*W2*W0-2*W1^2)*R22+(W2^2-2*W3*W1+W4*W0)*R02)*W1c-2*(-2
*(-W3*W0+W2*W1)*R11-(2*W2*W0-2*W1^2)*R21-(W2^2-2*W3*W1+W4*W0)*R01)*W2c-(2*(-W3*
W0+W2*W1)*R10+(2*W2*W0-2*W1^2)*R20+(W2^2-2*W3*W1+W4*W0)*R00)*W3c)*R21+2*((2*(2*
W3*W1-2*W2^2)*R12+(-W3*W0+W2*W1)*R22+(W3*W2-W1*W4)*R02)*W2c+2*(-2*(2*W3*W1-2*W2
^2)*R11-(-W3*W0+W2*W1)*R21-(W3*W2-W1*W4)*R01)*W3c+(2*(2*W3*W1-2*W2^2)*R10+(-W3*
W0+W2*W1)*R20+(W3*W2-W1*W4)*R00)*W4c)*R10+4*(-(2*(2*W3*W1-2*W2^2)*R12+(-W3*W0+
W2*W1)*R22+(W3*W2-W1*W4)*R02)*W1c-2*(-2*(2*W3*W1-2*W2^2)*R11-(-W3*W0+W2*W1)*R21
-(W3*W2-W1*W4)*R01)*W2c-(2*(2*W3*W1-2*W2^2)*R10+(-W3*W0+W2*W1)*R20+(W3*W2-W1*W4
)*R00)*W3c)*R11+((2*(W3*W2-W1*W4)*R12+(W2^2-2*W3*W1+W4*W0)*R22+(2*W4*W2-2*W3^2)
*R02)*W2c+2*(-2*(W3*W2-W1*W4)*R11-(W2^2-2*W3*W1+W4*W0)*R21-(2*W4*W2-2*W3^2)*R01
)*W3c+(2*(W3*W2-W1*W4)*R10+(W2^2-2*W3*W1+W4*W0)*R20+(2*W4*W2-2*W3^2)*R00)*W4c)*
R00+2*(-(2*(W3*W2-W1*W4)*R12+(W2^2-2*W3*W1+W4*W0)*R22+(2*W4*W2-2*W3^2)*R02)*W1c
-2*(-2*(W3*W2-W1*W4)*R11-(W2^2-2*W3*W1+W4*W0)*R21-(2*W4*W2-2*W3^2)*R01)*W2c-(2*
(W3*W2-W1*W4)*R10+(W2^2-2*W3*W1+W4*W0)*R20+(2*W4*W2-2*W3^2)*R00)*W3c)*R01+((2*(
-W3*W0+W2*W1)*R12+(2*W2*W0-2*W1^2)*R22+(W2^2-2*W3*W1+W4*W0)*R02)*W0c+2*(-2*(-W3
*W0+W2*W1)*R11-(2*W2*W0-2*W1^2)*R21-(W2^2-2*W3*W1+W4*W0)*R01)*W1c+(2*(-W3*W0+W2
*W1)*R10+(2*W2*W0-2*W1^2)*R20+(W2^2-2*W3*W1+W4*W0)*R00)*W2c)*R22+2*((2*(2*W3*W1
-2*W2^2)*R12+(-W3*W0+W2*W1)*R22+(W3*W2-W1*W4)*R02)*W0c+2*(-2*(2*W3*W1-2*W2^2)*
R11-(-W3*W0+W2*W1)*R21-(W3*W2-W1*W4)*R01)*W1c+(2*(2*W3*W1-2*W2^2)*R10+(-W3*W0+
W2*W1)*R20+(W3*W2-W1*W4)*R00)*W2c)*R12+((2*(W3*W2-W1*W4)*R12+(W2^2-2*W3*W1+W4*
W0)*R22+(2*W4*W2-2*W3^2)*R02)*W0c+2*(-2*(W3*W2-W1*W4)*R11-(W2^2-2*W3*W1+W4*W0)*
R21-(2*W4*W2-2*W3^2)*R01)*W1c+(2*(W3*W2-W1*W4)*R10+(W2^2-2*W3*W1+W4*W0)*R20+(2*
W4*W2-2*W3^2)*R00)*W2c)*R02:
   RETURN(s):
end:

#------------------------------------------------------------------------------
# M5R_SPINOR - Spinor representation
#------------------------------------------------------------------------------
gr[grC_displayName] := M5R:
gr[grC_calcFn] := grF_calc_M5R_SPINOR:
gr[grC_useWhen] := grF_when_SpinorInvar:
gr[grC_depends] := { M5_SPINOR }:

grF_calc_M5R_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, gr_data[M5_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# M5I_SPINOR - Spinor representation
#------------------------------------------------------------------------------
gr[grC_displayName] := M5I:
gr[grC_calcFn] := grF_calc_M5I_SPINOR:
gr[grC_useWhen] := grF_when_SpinorInvar:
gr[grC_depends] := { M5_SPINOR }:

grF_calc_M5I_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, expand ( -I*gr_data[M5_,grG_metricName] ) ):
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
