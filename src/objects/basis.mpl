#*********************************************************
#
# GRTENSOR II MODULE: basis.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake and Denis Pollney
#da
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
# The name of the multipleDef MUST also be the name of one of
# the definitions - otherwise will get an error in dependency 
# checking. 
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

#-----------------------------
# e(bdn,up) - standard definition.
#-----------------------------
grG_ObjDef[e(bdn,up)][grC_header] := `Basis vectors`:
grG_ObjDef[e(bdn,up)][grC_root] := ebdnup_:
grG_ObjDef[e(bdn,up)][grC_rootStr] := `e `:
grG_ObjDef[e(bdn,up)][grC_indexList] := [bdn,up]:
grG_ObjDef[e(bdn,up)][grC_calcFn] := grF_ebdnup:
grG_ObjDef[e(bdn,up)][grC_preCalcFn] := grF_precalc_ebdnup:
grG_ObjDef[e(bdn,up)][grC_calcFnParms] := [NULL]:
grG_ObjDef[e(bdn,up)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[e(bdn,up)][grC_depends] := { g(up,up) }:

grF_precalc_ebdnup := proc ( object, index )
	if not grF_checkIfAssigned ( e(bdn,dn) ) then
		ERROR(`Unable to calculate e(bdn,up). No basis vectors have been specified.`):
	fi:
end:

grF_ebdnup := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
		s := s + gr_data[gupup_,grG_metricName,a2_, a]*gr_data[ebdndn_,grG_metricName,a1_,a]:
	od:
RETURN(s):
end:

#-----------------------------
# e(bdn,dn)
#-----------------------------
grG_ObjDef[e(bdn,dn)][grC_header] := `Basis 1-forms`:
grG_ObjDef[e(bdn,dn)][grC_root] := ebdndn_:
grG_ObjDef[e(bdn,dn)][grC_rootStr] := `e `:
grG_ObjDef[e(bdn,dn)][grC_indexList] := [bdn,dn]:
grG_ObjDef[e(bdn,dn)][grC_calcFn] := grF_calc_ebdndn:
grG_ObjDef[e(bdn,dn)][grC_preCalcFn] := grF_precalc_ebdndn:
grG_ObjDef[e(bdn,dn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[e(bdn,dn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[e(bdn,dn)][grC_depends] := { g(dn,dn) }:

grF_precalc_ebdndn := proc ( object, index )
	if not grF_checkIfAssigned ( e(bdn,up) ) then
		ERROR(`Unable to calculate e(bdn,dn).  No basis vectors have been specified.`):
	fi:
end:

grF_calc_ebdndn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[gdndn_,grG_metricName,a,a2_]*gr_data[ebdnup_,grG_metricName,a1_,a]:
	od:
RETURN(s):
end:

#-----------------------------
# e(bup,up)
#-----------------------------
grG_ObjDef[e(bup,up)][grC_header] := `Basis vectors`:
grG_ObjDef[e(bup,up)][grC_root] := ebupup_:
grG_ObjDef[e(bup,up)][grC_rootStr] := `e `:
grG_ObjDef[e(bup,up)][grC_indexList] := [bup,up]:
grG_ObjDef[e(bup,up)][grC_calcFn] := grF_calc_ebupup:
grG_ObjDef[e(bup,up)][grC_calcFnParms] := [NULL]:
grG_ObjDef[e(bup,up)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[e(bup,up)][grC_depends] := {e(bdn,up),eta(bup,bup)}:

grF_calc_ebupup := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[etabupbup_,grG_metricName,a,a1_]*gr_data[ebdnup_,grG_metricName,a,a2_]:
	od:
	RETURN(s):
end:

#-----------------------------
# e(bup,dn)
#-----------------------------
grG_ObjDef[e(bup,dn)][grC_header] := `Basis 1-forms`:
grG_ObjDef[e(bup,dn)][grC_root] := ebupdn_:
grG_ObjDef[e(bup,dn)][grC_rootStr] := `e `:
grG_ObjDef[e(bup,dn)][grC_indexList] := [bup,dn]:
grG_ObjDef[e(bup,dn)][grC_calcFn] := grF_calc_ebupdn:
grG_ObjDef[e(bup,dn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[e(bup,dn)][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[e(bup,dn)][grC_depends] := {e(bdn,dn),eta(bup,bup)}:

grF_calc_ebupdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[etabupbup_,grG_metricName,a,a1_]*gr_data[ebdndn_,grG_metricName,a,a2_]:
	od:
	RETURN(s):
end:

#-----------------------------
# eta(bup,bup)
#-----------------------------
grG_ObjDef[eta(bup,bup)][grC_header] := `Basis inner product`:
grG_ObjDef[eta(bup,bup)][grC_root] := etabupbup_:
grG_ObjDef[eta(bup,bup)][grC_rootStr] := `eta`:
grG_ObjDef[eta(bup,bup)][grC_indexList] := [bup,bup]:
grG_ObjDef[eta(bup,bup)][grC_calcFn] := grF_ebdnup:
grG_ObjDef[eta(bup,bup)][grC_calcFnParms] := [NULL]:
grG_ObjDef[eta(bup,bup)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[eta(bup,bup)][grC_depends] := {}:

#-----------------------------
# eta(bdn,bdn)
#-----------------------------
grG_ObjDef[eta(bdn,bdn)][grC_header] := `Basis inner product`:
grG_ObjDef[eta(bdn,bdn)][grC_root] := etabdnbdn_:
grG_ObjDef[eta(bdn,bdn)][grC_rootStr] := `eta`:
grG_ObjDef[eta(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[eta(bdn,bdn)][grC_calcFn] := grF_calc_etabdnbdn:
grG_ObjDef[eta(bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[eta(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[eta(bdn,bdn)][grC_depends] := {g(dn,dn), e(bdn,up)}:

# This calc function has become redundant, since eta(bdn,bdn) is
# initialized when the spacetime is loaded.
grF_calc_etabdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  for b to Ndim[grG_metricName] do
	    s := s + gr_data[gdndn_,grG_metricName,a,b] * gr_data[ebdnup_,grG_metricName,a1_,a] * gr_data[ebdnup_,grG_metricName,a2_,b]:
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# lambda(bdn,bdn,bdn)
#-----------------------------
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_header] := `pre-Rotation Coefficients`:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_root] := lambdabdnbdnbdn_:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_rootStr] := `lambda`:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_calcFn] := grF_calc_lambdabdnbdnbdn:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a13:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_depends] := {e(bdn,up),e(bdn,dn,pdn)}:
grG_ObjDef[lambda(bdn,bdn,bdn)][grC_attributes] := {use_diff_constraint_}:

grF_calc_lambdabdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,s:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  for b to Ndim[grG_metricName] do
	    s := s + diff(gr_data[ebdndn_,grG_metricName,a2_,a], gr_data[xup_,grG_metricName, b] ) *
                     ( gr_data[ebdnup_,grG_metricName,a1_,a] * gr_data[ebdnup_,grG_metricName,a3_,b]
	             - gr_data[ebdnup_,grG_metricName,a1_,b] * gr_data[ebdnup_,grG_metricName,a3_,a] ):
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# rot(bdn,bdn,bdn)
#-----------------------------
grG_ObjDef[rot(bdn,bdn,bdn)][grC_header] := `Rotation Coefficients`:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_root] := rotbdnbdnbdn_:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_rootStr] := `gamma`:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_calcFn] := grF_calc_rotbdnbdnbdn:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a12:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_depends] := {lambda(bdn,bdn,bdn)}:
grG_ObjDef[rot(bdn,bdn,bdn)][grC_attributes] := {use_diff_constraint_}:

grF_when_genrot := proc()
global gr_data, grG_metricName, Ndim:
  if assigned ( gr_data[constant_eta,grG_metricName] ) and
              gr_data[constant_eta,grG_metricName] = false then
    true:
  else
    false:
  fi:
end:

grF_calc_rotbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s:
global gr_data, grG_metricName, Ndim:
	s := (gr_data[lambdabdnbdnbdn_,grG_metricName,a1_,a2_,a3_]
            + gr_data[lambdabdnbdnbdn_,grG_metricName,a3_,a1_,a2_]
            - gr_data[lambdabdnbdnbdn_,grG_metricName,a2_,a3_,a1_])/2:
	RETURN(s):
end:

#-----------------------------
# genrot(bdn,bdn,bdn)
#-----------------------------
grG_ObjDef[genrot(bdn,bdn,bdn)][grC_displayName] := rot(bdn,bdn,bdn):
grG_ObjDef[genrot(bdn,bdn,bdn)][grC_calcFn] := grF_calc_genrotbdnbdnbdn:
grG_ObjDef[genrot(bdn,bdn,bdn)][grC_depends] := {e(bdn,up),e(bdn,dn,cdn)}:
grG_ObjDef[genrot(bdn,bdn,bdn)][grC_useWhen] := grF_when_genrot:
grG_ObjDef[genrot(bdn,bdn,bdn)][grC_symmetry] := grF_sym_nosym3:

grF_calc_genrotbdnbdnbdn := proc (object, index)
local s,a,b:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  for b to Ndim[grG_metricName] do
	    s := s + gr_data[ebdnup_,grG_metricName,a1_,a]*
	             gr_data[ebdndncdn_,grG_metricName,a2_,a,b]*
	             gr_data[ebdnup_,grG_metricName,a3_,b]:
	  od:
	od:
	RETURN(s):
end:

#-----------------------------
# str(bdn,bdn,bdn)
#-----------------------------
grG_ObjDef[str(bdn,bdn,bdn)][grC_header] := `Structure Constants`:
grG_ObjDef[str(bdn,bdn,bdn)][grC_root] := strbdnbdnbdn_:
grG_ObjDef[str(bdn,bdn,bdn)][grC_rootStr] := `C`:
grG_ObjDef[str(bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn]:
grG_ObjDef[str(bdn,bdn,bdn)][grC_preCalcFn] := grF_precalc_strbdnbdnbdn:
grG_ObjDef[str(bdn,bdn,bdn)][grC_calcFn] := grF_calc_strbdnbdnbdn:
grG_ObjDef[str(bdn,bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[str(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a23:
grG_ObjDef[str(bdn,bdn,bdn)][grC_depends] := {rot(bdn,bdn,bdn)}:
grG_ObjDef[str(bdn,bdn,bdn)][grC_attributes] := {use_diff_constraint_}:

grF_precalc_strbdnbdnbdn := proc ()
global grG_ObjDef, gr_data, grG_metricName, Ndim:
  if assigned ( gr_data[constant_eta,grG_metricName] )
        and gr_data[constant_eta,grG_metricName] = false then
    grG_ObjDef[str(bdn,bdn,bdn)][grC_symmetry] := grF_sym_nosym3:
  else
    grG_ObjDef[str(bdn,bdn,bdn)][grC_symmetry] := grF_sym_3a23:
  fi:
end:

grF_calc_strbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s:
	s := gr_data[rotbdnbdnbdn_,grG_metricName,a1_,a3_,a2_] - gr_data[rotbdnbdnbdn_,grG_metricName,a2_,a3_,a1_]:
	RETURN(s):
end:

#-----------------------------
# R(bdn,bdn,bdn,bdn) [Alternate form of the Riemann tensor]
#-----------------------------
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_root] := `Covariant Riemann`:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_root] := Rbdnbdnbdnbdn_:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_rootStr] := `R`:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn,bdn]:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_calcFn] := grF_calc_Rbdnbdnbdnbdn:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_symmetry] := grF_sym_Riem:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_depends] := {rot(bdn,bdn,bdn), rot(bdn,bup,bdn)}:
grG_ObjDef[R(bdn,bdn,bdn,bdn)][grC_attributes] := {use_diff_constraint_}:

grF_calc_Rbdnbdnbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, s:
global gr_data, grG_metricName, Ndim:

  s := 0:
  for a to Ndim[grG_metricName] do
    s := s - diff( gr_data[rotbdnbdnbdn_,grG_metricName,a1_,a2_,a3_], gr_data[xup_,grG_metricName,a] )*
       gr_data[ebdnup_,grG_metricName,a4_,a] +
       diff( gr_data[rotbdnbdnbdn_,grG_metricName,a1_,a2_,a4_], gr_data[xup_,grG_metricName,a] )*
       gr_data[ebdnup_,grG_metricName,a3_,a] +
       gr_data[rotbdnbdnbdn_,grG_metricName,a2_,a1_,a]*
     ( gr_data[rotbdnbupbdn_,grG_metricName,a3_,a,a4_] - gr_data[rotbdnbupbdn_,grG_metricName,a4_,a,a3_] )
     + gr_data[rotbdnbdnbdn_,grG_metricName,a,a1_,a3_]*gr_data[rotbdnbupbdn_,grG_metricName,a2_,a,a4_]
     - gr_data[rotbdnbdnbdn_,grG_metricName,a,a1_,a4_]*gr_data[rotbdnbupbdn_,grG_metricName,a2_,a,a3_]:
  od:

  RETURN(s):
end:

#-----------------------------
# genR(bdn,bdn,bdn,bdn)
#-----------------------------
grG_ObjDef[genR(bdn,bdn,bdn,bdn)][grC_displayName] := R(bdn,bdn,bdn,bdn):
grG_ObjDef[genR(bdn,bdn,bdn,bdn)][grC_calcFn] := grF_calc_genRbdnbdnbdnbdn:
grG_ObjDef[genR(bdn,bdn,bdn,bdn)][grC_depends] := {rot(bdn,bdn,bdn),rot(bdn,bup,bdn),rot(bdn,bup,bup,pdn),eta(bdn,bdn),e(bdn,up)}:
grG_ObjDef[genR(bdn,bdn,bdn,bdn)][grC_useWhen] := grF_when_genR:

grF_when_genR := proc()
global gr_data, grG_metricName, Ndim:
  if assigned ( gr_data[constant_eta,grG_metricName] ) and gr_data[constant_eta,grG_metricName] = false then
    true:
  else
    false:
  fi:
end:

grF_calc_genRbdnbdnbdnbdn := proc (object, index)
local s,a,b,c:
global gr_data, grG_metricName, Ndim:
	s := 0:
	for a to Ndim[grG_metricName] do
	  for b to Ndim[grG_metricName] do
	    for c to Ndim[grG_metricName] do
	      s := s + gr_data[rotbdnbupbuppdn_,grG_metricName,a1_,a,b,c]*gr_data[ebdnup_,grG_metricName,a3_,c]*gr_data[etabdnbdn_,grG_metricName,a,a2_]*gr_data[etabdnbdn_,grG_metricName,b,a4_]
	             - gr_data[rotbdnbupbuppdn_,grG_metricName,a1_,a,b,c]*gr_data[ebdnup_,grG_metricName,a4_,c]*gr_data[etabdnbdn_,grG_metricName,a,a2_]*gr_data[etabdnbdn_,grG_metricName,b,a3_]:
	    od:
	  od:
	od:
	for a to Ndim[grG_metricName] do
	  s := s + gr_data[rotbdnbdnbdn_,grG_metricName,a2_,a1_,a]* ( gr_data[rotbdnbupbdn_,grG_metricName,a3_,a,a4_] - gr_data[rotbdnbupbdn_,grG_metricName,a4_,a,a3_] )
	         + gr_data[rotbdnbdnbdn_,grG_metricName,a,a1_,a3_]*gr_data[rotbdnbupbdn_,grG_metricName,a2_,a,a4_]
	         - gr_data[rotbdnbdnbdn_,grG_metricName,a,a1_,a4_]*gr_data[rotbdnbupbdn_,grG_metricName,a2_,a,a3_]:
	od:
	RETURN(s):
end:

#-----------------------------
# R(bdn,bdn) [Alternate form of the Ricci tensor]
#-----------------------------
grG_ObjDef[R(bdn,bdn)][grC_root] := `Covariant Ricci`:
grG_ObjDef[R(bdn,bdn)][grC_root] := Rbdnbdn_:
grG_ObjDef[R(bdn,bdn)][grC_rootStr] := `R`:
grG_ObjDef[R(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[R(bdn,bdn)][grC_calcFn] := grF_calc_Rbdnbdn:
grG_ObjDef[R(bdn,bdn)][grC_calcFnParms] := [NULL]:
grG_ObjDef[R(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[R(bdn,bdn)][grC_depends] := {eta(bup,bup), R(bdn,bdn,bdn,bdn)}:


grF_calc_Rbdnbdn := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s:
global gr_data, grG_metricName, Ndim:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[etabupbup_,grG_metricName,a,b]*gr_data[Rbdnbdnbdnbdn_,grG_metricName,a,a1_,b,a2_]:
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

grG_ObjDef[bRicciscalar][grC_header] := `Ricci scalar`:
grG_ObjDef[bRicciscalar][grC_root] := scalarR_:
grG_ObjDef[bRicciscalar][grC_rootStr] := `R `:
grG_ObjDef[bRicciscalar][grC_indexList] := []:
grG_ObjDef[bRicciscalar][grC_symmetry] := grF_sym_scalar:

grG_ObjDef[bRicciscalar][grC_displayName] := Ricciscalar:
grG_ObjDef[bRicciscalar][grC_calcFn] := grF_calc_bRsc:
grG_ObjDef[bRicciscalar][grC_depends] := {R(bdn,bdn)}:
grG_ObjDef[bRicciscalar][grC_useWhen] := grF_useWhen_tetrad:

grF_calc_bRsc := proc(object, index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s:
global gr_data, grG_metricName, Ndim:

  s := 0:
  for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
      s := s + gr_data[etabupbup_,grG_metricName,a,b]*gr_data[Rbdnbdn_,grG_metricName,a,b]:
    od:
  od:

  RETURN(s):
end:

#-----------------------------
# Ricciscalar [Another alternate form of the Ricci scalar]
#-----------------------------

grG_ObjDef[NPRicciscalar][grC_displayName] := Ricciscalar:
grG_ObjDef[NPRicciscalar][grC_calcFn] := grF_calc_NPRsc:
grG_ObjDef[NPRicciscalar][grC_depends] := {Lambda}:
grG_ObjDef[NPRicciscalar][grC_useWhen] := grF_when_NPRsc:

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
  RETURN(24*gr_data[Lambda_,grG_metricName]):
end:


#----------------------------
# C(bdn,bdn,bdn,bdn) [Alternate form of the Weyl tensor]
#----------------------------
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_header] := `Covariant Weyl`:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_root] := Cbdnbdnbdnbdn_:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_rootStr] := `C`:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_indexList] := [bdn,bdn,bdn,bdn]:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_calcFn] := grF_calc_Cbdnbdnbdnbdn:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_symmetry] := grF_sym_Riem:
grG_ObjDef[C(bdn,bdn,bdn,bdn)][grC_depends] := {eta(bdn,bdn), R(bdn,bdn,bdn,bdn), R(bdn,bdn), bRicciscalar}:

grF_calc_Cbdnbdnbdnbdn := proc(objectName,index)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local s;
global gr_data, grG_metricName, Ndim:
 s := gr_data[Rbdnbdnbdnbdn_,grG_metricName,a1_,a2_,a3_,a4_]
     -1/(Ndim[grG_metricName]-2)*
		 (gr_data[etabdnbdn_,grG_metricName,a1_,a3_]*gr_data[Rbdnbdn_,grG_metricName,a4_,a2_] -
		  gr_data[etabdnbdn_,grG_metricName,a1_,a4_]*gr_data[Rbdnbdn_,grG_metricName,a3_,a2_] -
		  gr_data[etabdnbdn_,grG_metricName,a2_,a3_]*gr_data[Rbdnbdn_,grG_metricName,a4_,a1_] +
		  gr_data[etabdnbdn_,grG_metricName,a2_,a4_]*gr_data[Rbdnbdn_,grG_metricName,a3_,a1_]) +
	    1/(Ndim[grG_metricName] - 1)/(Ndim[grG_metricName] - 2)*
	    gr_data[scalarR_,grG_metricName]*
	    (gr_data[etabdnbdn_,grG_metricName,a1_,a3_]*gr_data[etabdnbdn_,grG_metricName,a4_,a2_] -
	     gr_data[etabdnbdn_,grG_metricName,a1_,a4_]*gr_data[etabdnbdn_,grG_metricName,a3_,a2_] ):
 RETURN(s):
end:

#----------------------------
# G(bdn,bdn) [Alternate form of the Einstein tensor]
#----------------------------
grG_ObjDef[G(bdn,bdn)][grC_header] := `Covariant Einstein`:
grG_ObjDef[G(bdn,bdn)][grC_root] := Gbdnbdn_:
grG_ObjDef[G(bdn,bdn)][grC_rootStr] := `G`:
grG_ObjDef[G(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[G(bdn,bdn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[G(bdn,bdn)][grC_calcFnParms] := grG_Rbdnbdn_[grG_metricName,a1_,a2_]
	- 1/2*(gr_data[etabdnbdn_,grG_metricName,a1_,a2_] * gr_data[scalarR_,grG_metricName]):
grG_ObjDef[G(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[G(bdn,bdn)][grC_depends] := {eta(bdn,bdn), R(bdn,bdn), bRicciscalar}:

#----------------------------
# S(bdn,bdn) [Alternate form of the trace free Ricci tensor]
#----------------------------
grG_ObjDef[S(bdn,bdn)][grC_header] := `Covariant trace-free Ricci`:
grG_ObjDef[S(bdn,bdn)][grC_root] := Sbdnbdn_:
grG_ObjDef[S(bdn,bdn)][grC_rootStr] := `S`:
grG_ObjDef[S(bdn,bdn)][grC_indexList] := [bdn,bdn]:
grG_ObjDef[S(bdn,bdn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[S(bdn,bdn)][grC_calcFnParms] :=
	'gr_data[Rbdnbdn_,grG_metricName,a1_,a2_]' -
	(1/Ndim[grG_metricName])*'gr_data[etabdnbdn_,grG_metricName,a1_,a2_] * gr_data[scalarR_,grG_metricName]':
grG_ObjDef[S(bdn,bdn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[S(bdn,bdn)][grC_depends] := { eta(bdn,bdn) ,R(bdn,bdn), bRicciscalar }:

#----------------------------
# WeylSq - multiple def
#----------------------------
grG_ObjDef[bWeylSq][grC_displayName] := WeylSq:
grG_ObjDef[bWeylSq][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[bWeylSq][grC_calcFnParms] := Cbdnbdnbupbup_,Cbdnbdnbupbup_:
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_ObjDef[bWeylSq][grC_depends] := {C(bdn,bdn,bup,bup)}:
grG_ObjDef[bWeylSq][grC_useWhen] := grF_useWhen_tetrad:

#----------------------------
# RiemSq - multiple def
#----------------------------
grG_ObjDef[bRiemSq][grC_displayName] := RiemSq:
grG_ObjDef[bRiemSq][grC_calcFn] := grF_calc_RiemSq:
grG_ObjDef[bRiemSq][grC_calcFnParms] := Rbdnbdnbupbup_,Rbdnbdnbupbup_:
grG_ObjDef[bRiemSq][grC_depends] := {R(bdn,bdn,bup,bup)}:
grG_ObjDef[bRiemSq][grC_useWhen] := grF_useWhen_tetrad:

#----------------------------
# RicciSq - multiple def
#----------------------------
grG_ObjDef[bRicciSq][grC_displayName] := RicciSq:
grG_ObjDef[bRicciSq][grC_calcFn] := grF_calc_bRicciSq:
grG_ObjDef[bRicciSq][grC_depends] := {R(bup,bdn)}:
grG_ObjDef[bRicciSq][grC_useWhen] := grF_useWhen_tetrad:

grF_calc_bRicciSq := proc(object, index)
local i,j,s;
global gr_data, grG_metricName, Ndim:
   s := 0:
   for i to Ndim[grG_metricName] do
      s := s + gr_data[Rbupbdn_,grG_metricName,i,i] * gr_data[Rbupbdn_,grG_metricName,i,i]:
      for j from i+1 to Ndim[grG_metricName] do
	   s := s + 2 * gr_data[Rbupbdn_,grG_metricName,i,j] * gr_data[Rbupbdn_,grG_metricName,j,i]:
      od;
   od;
   RETURN(s):
end:

#----------------------------
# testNP
#----------------------------
grG_ObjDef[testNP][grC_header] := `Test NP inner product`:
grG_ObjDef[testNP][grC_root] := testNPbdnbdn_:
grG_ObjDef[testNP][grC_rootStr] := `testNP`:
grG_ObjDef[testNP][grC_indexList] := [bdn,bdn]:
grG_ObjDef[testNP][grC_calcFn] := grF_calc_testNPbdnbdn:
grG_ObjDef[testNP][grC_calcFnParms] := [NULL]:
grG_ObjDef[testNP][grC_symmetry] := grF_sym_nosym2:
grG_ObjDef[testNP][grC_depends] := { e(bdn,dn), e(bdn,up) }:


grF_calc_testNPbdnbdn := proc(object, index)
local s, a:
global gr_data, grG_metricName, Ndim:
  s := 0:
  for a to Ndim[grG_metricName] do
    s := s + gr_data[ebdndn_,grG_metricName,a1_,a]*gr_data[ebdnup_,grG_metricName,a2_,a]:
  od:
  RETURN(s):
end:
