#==============================================================================
# Scalar invariant w1
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
# W1R - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[W1R][grC_header] := `CM invariant Re(W1)`:
grG_ObjDef[W1R][grC_root] := W1R_:
grG_ObjDef[W1R][grC_rootStr] := `W1R `:
grG_ObjDef[W1R][grC_indexList] := []:
grG_ObjDef[W1R][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[W1R][grC_calcFnParms] := 'gr_data[WeylSq_,grG_metricName]/8':
grG_ObjDef[W1R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W1R][grC_symPerm] := []:
grG_ObjDef[W1R][grC_depends] := { WeylSq }:

#------------------------------------------------------------------------------
# W1I - Coordinate representation
#------------------------------------------------------------------------------
grG_ObjDef[W1I][grC_header] := `CM invariant Im(W1)`:
grG_ObjDef[W1I][grC_root] := W1I_:
grG_ObjDef[W1I][grC_rootStr] := `W1I `:
grG_ObjDef[W1I][grC_indexList] := []:
grG_ObjDef[W1I][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[W1I][grC_calcFnParms] := Cstardndnupup_, Cdndnupup_, 8:
grG_ObjDef[W1I][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W1I][grC_depends] := {Cstar(dn,dn,up,up), C(dn,dn,up,up)}:

#------------------------------------------------------------------------------
# W1R_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[W1R_BASIS][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[W1R_BASIS][grC_calcFnParms] := Cbdnbdnbupbup_, Cbdnbdnbupbup_, 8:
grG_ObjDef[W1R_BASIS][grC_depends] := {C(bdn,bdn,bup,bup)}:
grG_ObjDef[W1R_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[W1R_BASIS][grC_displayName] := W1R:

#------------------------------------------------------------------------------
# W1I_BASIS - Basis representation
#------------------------------------------------------------------------------
grG_ObjDef[W1I_BASIS][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[W1I_BASIS][grC_calcFnParms] := Cstarbdnbdnbupbup_, Cbdnbdnbupbup_, 8:
grG_ObjDef[W1I_BASIS][grC_depends] := {Cstar(bdn,bdn,bup,bup), C(bdn,bdn,bup,bup)}:
grG_ObjDef[W1I_BASIS][grC_useWhen] := grF_useWhen_tetrad:
grG_ObjDef[W1I_BASIS][grC_displayName] := W1I:

#------------------------------------------------------------------------------
# W1_SPINOR - SPINOR polynomial representation
#------------------------------------------------------------------------------
grG_ObjDef[W1_SPINOR][grC_header] := `CM Invariant: W1`:
grG_ObjDef[W1_SPINOR][grC_root] := W1_:
grG_ObjDef[W1_SPINOR][grC_rootStr] := `W1`:
grG_ObjDef[W1_SPINOR][grC_indexList] := []:
grG_ObjDef[W1_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W1_SPINOR][grC_calcFn] := grF_calc_W1_SPINOR:
grG_ObjDef[W1_SPINOR][grC_depends] := {Psi0, Psi1, Psi2, Psi3, Psi4}:

grF_calc_W1_SPINOR := proc(object, iList)
local  s:
global gr_data, Ndim, grG_metricName;
s := 2*W4*W0-8*W3*W1+6*W2^2:
   RETURN(s):
end:

#------------------------------------------------------------------------------
# W1R_SPINOR - SPINOR representation
#------------------------------------------------------------------------------
grG_ObjDef[W1R_SPINOR][grC_displayName] := W1R:
grG_ObjDef[W1R_SPINOR][grC_calcFn] := grF_calc_W1R_SPINOR:
grG_ObjDef[W1R_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W1R_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[W1R_SPINOR][grC_depends] := { W1_SPINOR }:

grF_calc_W1R_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, gr_data[W1_,grG_metricName] ):
	RETURN(s):
end:

#------------------------------------------------------------------------------
# W1I_SPINOR - SPINOR representation
#------------------------------------------------------------------------------
grG_ObjDef[W1I_SPINOR][grC_displayName] := W1I:
grG_ObjDef[W1I_SPINOR][grC_calcFn] := grF_calc_W1I_SPINOR:
grG_ObjDef[W1I_SPINOR][grC_useWhen] := grF_when_SpinorInvar:
grG_ObjDef[W1I_SPINOR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[W1I_SPINOR][grC_depends] := { W1_SPINOR }:

grF_calc_W1I_SPINOR := proc(object, index)
global gr_data, Ndim, grG_metricName;
local s:
	s := subs ( I=0, expand ( -I*gr_data[W1_,grG_metricName] ) ):
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