#==============================================================================
# Scalar invariant w2
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
# W2I - Coorinate representation
#------------------------------------------------------------------------------
grG_ObjDef[W2I][grC_header] := `CM invariant Im(W2)`:
grG_ObjDef[W2I][grC_root] := W2I_:
grG_ObjDef[W2I][grC_rootStr] := `W2I `:
grG_ObjDef[W2I][grC_indexList] := []:
grG_ObjDef[W2I][grC_calcFn] := grF_calc_W2:
grG_ObjDef[W2I][grC_calcFnParms] := Cstardndnupup_,-4:
grG_ObjDef[W2I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W2I][grC_depends] := { C2(dn,dn,up,up), Cstar(dn,dn,up,up) }:

#------------------------------------------------------------------------------
# W2R
#------------------------------------------------------------------------------
grG_ObjDef[W2R][grC_header] := `CM invariant Re(W2)`:
grG_ObjDef[W2R][grC_root] := W2R_:
grG_ObjDef[W2R][grC_rootStr] := `W2R `:
grG_ObjDef[W2R][grC_indexList] := []:
grG_ObjDef[W2R][grC_calcFn] := grF_calc_W2:
grG_ObjDef[W2R][grC_calcFnParms] := Cdndnupup_,-4:
grG_ObjDef[W2R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W2R][grC_depends] := { C2(dn,dn,up,up), C(dn,dn,up,up) }:

grF_calc_W2 := proc(object, iList)
global gr_data, Ndim, grG_metricName;
local a,b,c,d, s, root1, C2dndnupup:
  root1 := grG_ObjDef[object][grC_calcFnParms][1]:
  if object=W2R or object=W2I then
    C2dndnupup := C2dndnupup_:
  else
    C2dndnupup := C2bdnbdnbupbup_:
  fi:

  s := 0:
  for a to Ndim[grG_metricName]-1 do
    for b from a+1 to Ndim[grG_metricName] do
      for c to Ndim[grG_metricName]-1 do
        for d from c+1 to Ndim[grG_metricName] do
          s := s + gr_data[root1,grG_metricName,a,b,c,d] * gr_data[C2dndnupup,grG_metricName,c,d,a,b]:
       od:
     od:
   od:
 od:
 RETURN( s/grG_ObjDef[object][grC_calcFnParms][2] ):
end:

#------------------------------------------------------------------------------
# W2I_BASIS
#------------------------------------------------------------------------------
grG_ObjDef[W2I_BASIS][grC_calcFn] := grF_calc_W2:
grG_ObjDef[W2I_BASIS][grC_calcFnParms] := Cstarbdnbdnbupbup_,-4:
grG_ObjDef[W2I_BASIS][grC_depends] := { C2(bdn,bdn,bup,bup), Cstar(bdn,bdn,bup,bup) }:
grG_ObjDef[W2I_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[W2I_BASIS][grC_displayName] := W2I:

#------------------------------------------------------------------------------
# W2R_BASIS
#------------------------------------------------------------------------------
grG_ObjDef[W2R_BASIS][grC_calcFn] := grF_calc_W2:
grG_ObjDef[W2R_BASIS][grC_calcFnParms] := Cbdnbdnbupbup_,-4:
grG_ObjDef[W2R_BASIS][grC_depends] := { C2(bdn,bdn,bup,bup), C(bdn,bdn,bup,bup) }:
grG_ObjDef[W2R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[W2R_BASIS][grC_displayName] := W2R:

#------------------------------------------------------------------------------
# W2_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[W2_SPINOR][grC_header] := `CM Invariant: W2`:
grG_ObjDef[W2_SPINOR][grC_root] := W2_:
grG_ObjDef[W2_SPINOR][grC_rootStr] := `W2`:
grG_ObjDef[W2_SPINOR][grC_indexList] := []:
grG_ObjDef[W2_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W2_SPINOR][grC_calcFn] := grF_calc_W2_SPINOR:
grG_ObjDef[W2_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4}:

grF_calc_W2_SPINOR := proc(object, iList)
local  s:
global gr_data, Ndim, grG_metricName;
s := 12*W3*W1*W2-6*W3^2*W0-6*W2^3+6*W2*W0*W4-6*W1^2*W4:
   RETURN(s):
end:

#------------------------------------------------------------------------------
# W2R_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[W2R_SPINOR][grC_displayName] := W2R:
grG_ObjDef[W2R_SPINOR][grC_calcFn] := grF_calc_W2R_SPINOR:
grG_ObjDef[W2R_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[W2R_SPINOR][grC_depends] := { W2_SPINOR }:

grF_calc_W2R_SPINOR := proc(object, index)
local s:
global gr_data, Ndim, grG_metricName;
	s := subs ( I=0, gr_data[W2_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# W2I_SPINOR - Spinor representation
#------------------------------------------------------------------------------
grG_ObjDef[W2I_SPINOR][grC_displayName] := W2I:
grG_ObjDef[W2I_SPINOR][grC_calcFn] := grF_calc_W2I_SPINOR:
grG_ObjDef[W2I_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[W2I_SPINOR][grC_depends] := { W2_SPINOR }:

grF_calc_W2I_SPINOR := proc(object, index)
local s:
global gr_data, Ndim, grG_metricName;
	s := subs ( I=0, expand ( -I*gr_data[W2_,grG_metricName] ) ):
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