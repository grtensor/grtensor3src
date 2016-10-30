#*********************************************************
# 
# GRTENSOR II MODULE: basis.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake and Denis Pollney
#
# File Created By: Denis Pollney
#            Date: August 24 1994
#
# Revisions:
#
# Mar 10, 1995  Modify definitions to accomodate dual bases in makeg [dp]
# Nov 15, 1995	Add precalc to lambda, rot, str to accomodate non-constant
#               eta(bup,bup) [dp]
# Nov 27, 1995  Ricciscalar now uses grF_useWhen_tetrad [pm]
# Nov 27, 1995	Add MultipleDefs for basis versions of Riemsq,WeylSq,RiccSq[dp]
# Dec  8, 1995  Make Weyl, Einstein, S use bRicciscalar
# Feb 28, 1996  useWhen functions now take arrlist parameter [pm]
# May 23, 1996  Fix WeylSq dependency [pm]
# May 26, 1996  Allow genrot and genR to use n<>4 dimensions [dp]
# Feb  4, 1997	Replace 0,0 checks with checkIfAssigned [dp]
#*********************************************************

#-----------------------------------------------------------
# multipleDefs for the basis library:
#-----------------------------------------------------------

grG_multipleDef[Ricciscalar] := [NPRicciscalar, bRicciscalar, tRicciscalar]:
grG_multipleDef[RiemSq] := [bRiemSq, RiemSq]:
grG_multipleDef[WeylSq] := [bWeylSq, WeylSq]:
grG_multipleDef[RicciSq] := [bRicciSq, RicciSq]:

grG_multipleDef[rot(bdn,bdn,bdn)] := [ genrot(bdn,bdn,bdn), rot(bdn,bdn,bdn) ]:
grG_multipleDef[R(bdn,bdn,bdn,bdn)] := [ genR(bdn,bdn,bdn,bdn), R(bdn,bdn,bdn,bdn) ]:

grG_multipleDef[Psi0] := [WPsi0, Psi0]:
grG_multipleDef[Psi1] := [WPsi1, Psi1]:
grG_multipleDef[Psi2] := [WPsi2, Psi2]:
grG_multipleDef[Psi3] := [WPsi3, Psi3]:
grG_multipleDef[Psi4] := [WPsi4, Psi4]:

grG_multipleDef[Phi00] := [RPhi00, Phi00]:
grG_multipleDef[Phi01] := [RPhi01, Phi01]:
grG_multipleDef[Phi02] := [RPhi02, Phi02]:
grG_multipleDef[Phi11] := [RPhi11, Phi11]:
grG_multipleDef[Phi12] := [RPhi12, Phi12]:
grG_multipleDef[Phi22] := [RPhi22, Phi22]:
grG_multipleDef[Lambda]:= [RLambda, Lambda]:

#===========================================================
#
# Fundamental basis objects:
#
#===========================================================
macro(gname = grG_metricName):

#-----------------------------
# e(bdn,up) - standard definition.
#-----------------------------
macro( gr = grG_ObjDef[e(bdn,up)]):
gr[grC_header] := `Basis vectors`:
gr[grC_root] := ebdnup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,up]:
gr[grC_calcFn] := grF_ebdnup:
gr[grC_preCalcFn] := grF_precalc_ebdnup:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { g(up,up) }:

grF_precalc_ebdnup := proc ( object, index )
	if not grF_checkIfAssigned ( e(bdn,dn) ) then
		ERROR(`Unable to calculate e(bdn,up). No basis vectors have been specified.`):  
	fi:
end:

grF_ebdnup := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, s:
	s := 0:
	for a to Ndim||grG_metricName do
		s := s + grG_gupup_[grG_metricName,a2_, a]*grG_ebdndn_[grG_metricName,a1_,a]:
	od:
RETURN(s):
end:

#-----------------------------
# e(bdn,dn)
#-----------------------------
macro ( gr = grG_ObjDef[e(bdn,dn)]):
gr[grC_header] := `Basis 1-forms`:
gr[grC_root] := ebdndn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bdn,dn]:
gr[grC_calcFn] := grF_calc_ebdndn:
gr[grC_preCalcFn] := grF_precalc_ebdndn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { g(dn,dn) }:

grF_precalc_ebdndn := proc ( object, index )
	if not grF_checkIfAssigned ( e(bdn,up) ) then
		ERROR(`Unable to calculate e(bdn,dn).  No basis vectors have been specified.`):
	fi:
end:

grF_calc_ebdndn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
	s := 0:
	for a to Ndim||grG_metricName do
	  s := s + grG_gdndn_[gname,a,a2_]*grG_ebdnup_[gname,a1_,a]:
	od:
RETURN(s):
end:

#-----------------------------
# e(bup,up)
#-----------------------------
macro ( gr = grG_ObjDef[e(bup,up)]):
gr[grC_header] := `Basis vectors`:
gr[grC_root] := ebupup_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,up]:
gr[grC_calcFn] := grF_calc_ebupup:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := {e(bdn,up),eta(bup,bup)}:

grF_calc_ebupup := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
	s := 0:
	for a to Ndim||grG_metricName do
	  s := s + grG_etabupbup_[gname,a,a1_]*grG_ebdnup_[gname,a,a2_]:
	od:
	RETURN(s):
end:

#-----------------------------
# e(bup,dn)
#-----------------------------
macro ( gr = grG_ObjDef[e(bup,dn)]):
gr[grC_header] := `Basis 1-forms`:
gr[grC_root] := ebupdn_:
gr[grC_rootStr] := `e `:
gr[grC_indexList] := [bup,dn]:
gr[grC_calcFn] := grF_calc_ebupdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := {e(bdn,dn),eta(bup,bup)}:

grF_calc_ebupdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
	s := 0:
	for a to Ndim||grG_metricName do
	  s := s + grG_etabupbup_[gname,a,a1_]*grG_ebdndn_[gname,a,a2_]:
	od:
	RETURN(s):
end:

#-----------------------------
# eta(bup,bup)
#-----------------------------
macro( gr = grG_ObjDef[eta(bup,bup)]):
gr[grC_header] := `Basis inner product`:
gr[grC_root] := etabupbup_:
gr[grC_rootStr] := `eta`:
gr[grC_indexList] := [bup,bup]:
gr[grC_calcFn] := grF_ebdnup:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:

#-----------------------------
# eta(bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[eta(bdn,bdn)]):
gr[grC_header] := `Basis inner product`:
gr[grC_root] := etabdnbdn_:
gr[grC_rootStr] := `eta`:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_etabdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {g(dn,dn), e(bdn,up)}:

# This calc function has become redundant, since eta(bdn,bdn) is
# initialized when the spacetime is loaded.
grF_calc_etabdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
	s := 0:
	for a to Ndim||grG_metricName do
	  for b to Ndim||grG_metricName do
	    s := s + grG_gdndn_[gname,a,b] * grG_ebdnup_[gname,a1_,a] * grG_ebdnup_[gname,a2_,b]:
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# lambda(bdn,bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[lambda(bdn,bdn,bdn)]):
gr[grC_header] := `pre-Rotation Coefficients`:
gr[grC_root] := lambdabdnbdnbdn_:
gr[grC_rootStr] := `lambda`:
gr[grC_indexList] := [bdn,bdn,bdn]:
gr[grC_calcFn] := grF_calc_lambdabdnbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_3a13:
gr[grC_depends] := {e(bdn,up),e(bdn,dn,pdn)}:
gr[grC_attributes] := {use_diff_constraint_}:

grF_calc_lambdabdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
	s := 0:
	for a to Ndim||grG_metricName do
	  for b to Ndim||grG_metricName do
	    s := s + diff(grG_ebdndn_[gname,a2_,a], grG_xup_[gname, b] ) * 
                     ( grG_ebdnup_[gname,a1_,a] * grG_ebdnup_[gname,a3_,b]
	             - grG_ebdnup_[gname,a1_,b] * grG_ebdnup_[gname,a3_,a] ):
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# rot(bdn,bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[rot(bdn,bdn,bdn)]):
gr[grC_header] := `Rotation Coefficients`:
gr[grC_root] := rotbdnbdnbdn_:
gr[grC_rootStr] := `gamma`:
gr[grC_indexList] := [bdn,bdn,bdn]:
gr[grC_calcFn] := grF_calc_rotbdnbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_3a12:
gr[grC_depends] := {lambda(bdn,bdn,bdn)}:
gr[grC_attributes] := {use_diff_constraint_}:

grF_when_genrot := proc()
  if assigned ( grG_constant_eta[grG_metricName] ) and  
              grG_constant_eta[grG_metricName] = false then
    true:
  else
    false:
  fi:
end:

grF_calc_rotbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s:
	s := (grG_lambdabdnbdnbdn_[gname,a1_,a2_,a3_]
            + grG_lambdabdnbdnbdn_[gname,a3_,a1_,a2_]
            - grG_lambdabdnbdnbdn_[gname,a2_,a3_,a1_])/2:
	RETURN(s):
end:

#-----------------------------
# genrot(bdn,bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[genrot(bdn,bdn,bdn)]):
gr[grC_displayName] := rot(bdn,bdn,bdn):
gr[grC_calcFn] := grF_calc_genrotbdnbdnbdn:
gr[grC_depends] := {e(bdn,up),e(bdn,dn,cdn)}:
gr[grC_useWhen] := grF_when_genrot:
gr[grC_symmetry] := grF_sym_nosym3:

grF_calc_genrotbdnbdnbdn := proc (object, index)
local s,a,b:
	s := 0:
	for a to Ndim||grG_metricName do
	  for b to Ndim||grG_metricName do
	    s := s + grG_ebdnup_[grG_metricName,a1_,a]*
	             grG_ebdndncdn_[grG_metricName,a2_,a,b]*
	             grG_ebdnup_[grG_metricName,a3_,b]:
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# str(bdn,bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[str(bdn,bdn,bdn)]):
gr[grC_header] := `Structure Constants`:
gr[grC_root] := strbdnbdnbdn_:
gr[grC_rootStr] := `C`:
gr[grC_indexList] := [bdn,bdn,bdn]:
gr[grC_preCalcFn] := grF_precalc_strbdnbdnbdn:
gr[grC_calcFn] := grF_calc_strbdnbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_3a23:
gr[grC_depends] := {rot(bdn,bdn,bdn)}:
gr[grC_attributes] := {use_diff_constraint_}:

grF_precalc_strbdnbdnbdn := proc ()
global grG_ObjDef:
  if assigned ( grG_constant_eta[grG_metricName] ) 
        and grG_constant_eta[grG_metricName] = false then
    grG_ObjDef[str(bdn,bdn,bdn)][grC_symmetry] := grF_sym_nosym3:
  else
    grG_ObjDef[str(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a23:
  fi:
end:

grF_calc_strbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s:
	s := grG_rotbdnbdnbdn_[gname,a1_,a3_,a2_] - grG_rotbdnbdnbdn_[gname,a2_,a3_,a1_]:
	RETURN(s):
end:

#-----------------------------
# R(bdn,bdn,bdn,bdn) [Alternate form of the Riemann tensor]
#-----------------------------
macro( gr = grG_ObjDef[R(bdn,bdn,bdn,bdn)]):
gr[grC_root] := `Covariant Riemann`:
gr[grC_root] := Rbdnbdnbdnbdn_:
gr[grC_rootStr] := `R`:
gr[grC_indexList] := [bdn,bdn,bdn,bdn]:
gr[grC_calcFn] := grF_calc_Rbdnbdnbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_Riem:
gr[grC_depends] := {rot(bdn,bdn,bdn), rot(bdn,bup,bdn)}:
gr[grC_attributes] := {use_diff_constraint_}:

grF_calc_Rbdnbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, s:

  s := 0:
  for a to Ndim||grG_metricName do
    s := s - diff( grG_rotbdnbdnbdn_[gname,a1_,a2_,a3_], grG_xup_[gname,a] )*
       grG_ebdnup_[gname,a4_,a] +
       diff( grG_rotbdnbdnbdn_[gname,a1_,a2_,a4_], grG_xup_[gname,a] )*
       grG_ebdnup_[gname,a3_,a] +
       grG_rotbdnbdnbdn_[gname,a2_,a1_,a]*
     ( grG_rotbdnbupbdn_[gname,a3_,a,a4_] - grG_rotbdnbupbdn_[gname,a4_,a,a3_] )
     + grG_rotbdnbdnbdn_[gname,a,a1_,a3_]*grG_rotbdnbupbdn_[gname,a2_,a,a4_]
     - grG_rotbdnbdnbdn_[gname,a,a1_,a4_]*grG_rotbdnbupbdn_[gname,a2_,a,a3_]:
  od:

  RETURN(s):
end:

#-----------------------------
# genR(bdn,bdn,bdn,bdn)
#-----------------------------
macro( gr = grG_ObjDef[genR(bdn,bdn,bdn,bdn)]):
gr[grC_displayName] := R(bdn,bdn,bdn,bdn):
gr[grC_calcFn] := grF_calc_genRbdnbdnbdnbdn:
gr[grC_depends] := {rot(bdn,bdn,bdn),rot(bdn,bup,bdn),rot(bdn,bup,bup,pdn),eta(bdn,bdn),e(bdn,up)}:
gr[grC_useWhen] := grF_when_genR:

grF_when_genR := proc()
  if assigned ( grG_constant_eta[grG_metricName] ) and grG_constant_eta[grG_metricName] = false then
    true:
  else
    false:
  fi:
end:

grF_calc_genRbdnbdnbdnbdn := proc (object, index)
local s,a,b,c:
	s := 0:
	for a to Ndim||grG_metricName do
	  for b to Ndim||grG_metricName do
	    for c to Ndim||grG_metricName do
	      s := s + grG_rotbdnbupbuppdn_[gname,a1_,a,b,c]*grG_ebdnup_[gname,a3_,c]*grG_etabdnbdn_[gname,a,a2_]*grG_etabdnbdn_[gname,b,a4_]
	             - grG_rotbdnbupbuppdn_[gname,a1_,a,b,c]*grG_ebdnup_[gname,a4_,c]*grG_etabdnbdn_[gname,a,a2_]*grG_etabdnbdn_[gname,b,a3_]:
	    od:
	  od:
	od:
	for a to Ndim||grG_metricName do
	  s := s + grG_rotbdnbdnbdn_[gname,a2_,a1_,a]* ( grG_rotbdnbupbdn_[gname,a3_,a,a4_] - grG_rotbdnbupbdn_[gname,a4_,a,a3_] )
	         + grG_rotbdnbdnbdn_[gname,a,a1_,a3_]*grG_rotbdnbupbdn_[gname,a2_,a,a4_]
	         - grG_rotbdnbdnbdn_[gname,a,a1_,a4_]*grG_rotbdnbupbdn_[gname,a2_,a,a3_]:
	od:
	RETURN(s):
end:

#-----------------------------
# R(bdn,bdn) [Alternate form of the Ricci tensor]
#-----------------------------
macro( gr = grG_ObjDef[R(bdn,bdn)]):
gr[grC_root] := `Covariant Ricci`:
gr[grC_root] := Rbdnbdn_:
gr[grC_rootStr] := `R`:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_Rbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {eta(bup,bup), R(bdn,bdn,bdn,bdn)}:


grF_calc_Rbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s:

  s := 0:
  for a to Ndim||grG_metricName do
    for b to Ndim||grG_metricName do
      s := s + grG_etabupbup_[gname,a,b]*grG_Rbdnbdnbdnbdn_[gname,a,a1_,b,a2_]:
    od:
  od:

  RETURN(s):
end:

#-----------------------------
# Ricciscalar [Alternate form of the Ricci scalar]
#
# (this object is an oddity - since it's used
# by G(bdn,bdn) we need it to have a full definition
# and since it's also an invariant it's
# multiple def'd as well.
#-----------------------------

macro( gr = grG_ObjDef[bRicciscalar]):
gr[grC_header] := `Ricci scalar`:
gr[grC_root] := scalarR_:
gr[grC_rootStr] := `R `:
gr[grC_indexList] := []:
gr[grC_symmetry] := grF_sym_scalar:

gr[grC_displayName] := Ricciscalar:
gr[grC_calcFn] := grF_calc_bRsc:
gr[grC_depends] := {R(bdn,bdn)}:
gr[grC_useWhen] := grF_useWhen_tetrad:

grF_calc_bRsc := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s:

  s := 0:
  for a to Ndim||grG_metricName do
    for b to Ndim||grG_metricName do
      s := s + grG_etabupbup_[gname,a,b]*grG_Rbdnbdn_[gname,a,b]:
    od:
  od:

  RETURN(s):
end:

#-----------------------------
# Ricciscalar [Another alternate form of the Ricci scalar]
#-----------------------------

macro( gr = grG_ObjDef[NPRicciscalar]):
gr[grC_displayName] := Ricciscalar:
gr[grC_calcFn] := grF_calc_NPRsc:
gr[grC_depends] := {Lambda}:
gr[grC_useWhen] := grF_when_NPRsc:

grF_when_NPRsc := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

  #
  # if it's a null tetrad and none of the tensor or basis
  # curvature objects have been or will be calced then
  # use NP methods
  #
  if grF_checkNullTetrad ( grG_metricName ) then
     if not ( grF_checkIfAssigned ( R(bdn,bdn) ) or
          grF_checkIfAssigned ( R(bdn,bdn,bdn,bdn) ) or 
          grF_checkIfAssigned ( R(dn,dn,dn,dn) ) or
          grF_checkIfAssigned ( R(dn,dn) ) or
          member( R(bdn,bdn), args[1] ) or
          member( R(bdn,bdn,bdn,bdn), args[1] ) or 
          member( R(dn,dn,dn,dn), args[1] ) or
          member( R(dn,dn), args[1] ) ) then
            true:
      else
            false;
      fi:
  else
    false:
  fi:
end:

grF_calc_NPRsc := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  RETURN(24*grG_NPLambda_[grG_metricName]):
end:


#----------------------------
# C(bdn,bdn,bdn,bdn) [Alternate form of the Weyl tensor]
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
macro( gr = grG_ObjDef[C(bdn,bdn,bdn,bdn)]):
gr[grC_header] := `Covariant Weyl`:
gr[grC_root] := Cbdnbdnbdnbdn_:
gr[grC_rootStr] := `C`:
gr[grC_indexList] := [bdn,bdn,bdn,bdn]:
gr[grC_calcFn] := grF_calc_Cbdnbdnbdnbdn:
gr[grC_symmetry] := grF_sym_Riem:
gr[grC_depends] := {eta(bdn,bdn), R(bdn,bdn,bdn,bdn), R(bdn,bdn), bRicciscalar}:

grF_calc_Cbdnbdnbdnbdn := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s;
 s := grG_Rbdnbdnbdnbdn_[gname,a1_,a2_,a3_,a4_]
     -1/(Ndim||grG_metricName-2)*
		 (grG_etabdnbdn_[gname,a1_,a3_]*grG_Rbdnbdn_[gname,a4_,a2_] -
		  grG_etabdnbdn_[gname,a1_,a4_]*grG_Rbdnbdn_[gname,a3_,a2_] -
		  grG_etabdnbdn_[gname,a2_,a3_]*grG_Rbdnbdn_[gname,a4_,a1_] +
		  grG_etabdnbdn_[gname,a2_,a4_]*grG_Rbdnbdn_[gname,a3_,a1_]) +
	    1/(Ndim||grG_metricName - 1)/(Ndim||grG_metricName - 2)*
	    grG_scalarR_[gname]*
	    (grG_etabdnbdn_[gname,a1_,a3_]*grG_etabdnbdn_[gname,a4_,a2_] -
	     grG_etabdnbdn_[gname,a1_,a4_]*grG_etabdnbdn_[gname,a3_,a2_] ):
 RETURN(s):
end:

#----------------------------
# G(bdn,bdn) [Alternate form of the Einstein tensor]
#----------------------------
macro( gr = grG_ObjDef[G(bdn,bdn)]):
gr[grC_header] := `Covariant Einstein`:
gr[grC_root] := Gbdnbdn_:
gr[grC_rootStr] := `G`:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := grG_Rbdnbdn_[gname,a1_,a2_]
	- 1/2*(grG_etabdnbdn_[gname,a1_,a2_] * grG_scalarR_[gname]):
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {eta(bdn,bdn), R(bdn,bdn), bRicciscalar}:

#----------------------------
# S(bdn,bdn) [Alternate form of the trace free Ricci tensor]
#----------------------------
macro( gr = grG_ObjDef[S(bdn,bdn)]):
gr[grC_header] := `Covariant trace-free Ricci`:
gr[grC_root] := Sbdnbdn_:
gr[grC_rootStr] := `S`:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] :=
	'grG_Rbdnbdn_[gname,a1_,a2_]' -
	(1/Ndim[gname])*'grG_etabdnbdn_[gname,a1_,a2_] * grG_scalarR_[gname]':
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { eta(bdn,bdn) ,R(bdn,bdn), bRicciscalar }:

#----------------------------
# WeylSq - multiple def
#----------------------------
macro( gr = grG_ObjDef[bWeylSq]):
gr[grC_displayName] := WeylSq:
gr[grC_calcFn] := grF_calc_RiemSq:
gr[grC_calcFnParms] := Cbdnbdnbupbup_,Cbdnbdnbupbup_:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
gr[grC_depends] := {C(bdn,bdn,bup,bup)}:
gr[grC_useWhen] := grF_useWhen_tetrad:

#----------------------------
# RiemSq - multiple def
#----------------------------
macro( gr = grG_ObjDef[bRiemSq]):
gr[grC_displayName] := RiemSq:
gr[grC_calcFn] := grF_calc_RiemSq:
gr[grC_calcFnParms] := Rbdnbdnbupbup_,Rbdnbdnbupbup_:
gr[grC_depends] := {R(bdn,bdn,bup,bup)}:
gr[grC_useWhen] := grF_useWhen_tetrad:

#----------------------------
# RicciSq - multiple def
#----------------------------
macro( gr = grG_ObjDef[bRicciSq]):
gr[grC_displayName] := RicciSq:
gr[grC_calcFn] := grF_calc_bRicciSq:
gr[grC_depends] := {R(bup,bdn)}:
gr[grC_useWhen] := grF_useWhen_tetrad:

grF_calc_bRicciSq := proc(object, index)
local i,j,s;
   s := 0:
   for i to Ndim||grG_metricName do
      s := s + grG_Rbupbdn_[gname,i,i] * grG_Rbupbdn_[gname,i,i]:
      for j from i+1 to Ndim||grG_metricName do
	   s := s + 2 * grG_Rbupbdn_[gname,i,j] * grG_Rbupbdn_[gname,j,i]:
      od;
   od;
   RETURN(s):
end:

#----------------------------
# testNP
#----------------------------
macro ( gr = grG_ObjDef[testNP(bdn,bdn)] ):
gr[grC_header] := `Test NP inner product`:
gr[grC_root] := testNPbdnbdn_:
gr[grC_rootStr] := `testNP`:
gr[grC_indexList] := [bdn,bdn]:
gr[grC_calcFn] := grF_calc_testNPbdnbdn:
gr[grC_calcFnParms] := [NULL]:
gr[grC_symmetry] := grF_sym_nosym2:
gr[grC_depends] := { e(bdn,dn), e(bdn,up) }:


grF_calc_testNPbdnbdn := proc(object, index)
local s, a:
  s := 0:
  for a to Ndim||grG_metricName do
    s := s + grG_ebdndn_[gname,a1_,a]*grG_ebdnup_[gname,a2_,a]:
  od:
  RETURN(s):
end:
