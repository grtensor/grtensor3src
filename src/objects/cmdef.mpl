#*********************************************************
# 
# GRTENSOR II MODULE: cmdef.mpl
#
# MultipleDefs for the CM scalars.
#
# File Created: November 27, 1994
#
# Changes:
# Nov 27 1995	Add spinor invariant multipleDefs and modify useWhen_Tetrad[dp]
#
# Feb 28 1996   Add arglist to useWhen functions [pm]
#
#*********************************************************

grG_multipleDef[ R1] := [ R1_SPINOR, R1_BASIS, R1]:
grG_multipleDef[ R2] := [ R2_SPINOR, R2_BASIS, R2]:
grG_multipleDef[ R3] := [ R3_SPINOR, R3_BASIS, R3]:

grG_multipleDef[ W1R] := [ W1R_SPINOR, W1R_BASIS, W1R]:
grG_multipleDef[ W1I] := [ W1I_SPINOR, W1I_BASIS, W1I]:
grG_multipleDef[ W2R] := [ W2R_SPINOR, W2R_BASIS, W2R]:
grG_multipleDef[ W2I] := [ W2I_SPINOR, W2I_BASIS, W2I]:

grG_multipleDef[ M1R] := [ M1R_SPINOR, M1R_BASIS, M1R]:
grG_multipleDef[ M1I] := [ M1I_SPINOR, M1I_BASIS, M1I]:
grG_multipleDef[ M2a] := [             M2a_BASIS, M2a]:
grG_multipleDef[ M2b] := [             M2b_BASIS, M2b]:
grG_multipleDef[ M2R] := [ M2R_SPINOR, M2R_BASIS, M2R]:
grG_multipleDef[ M2I] := [ M2I_SPINOR, M2I_BASIS, M2I]:
grG_multipleDef[ M2S] := [ M2_SPINOR,  M2S_BASIS, M2S]:
grG_multipleDef[ M3 ] := [ M3_SPINOR,  M3_BASIS,  M3]:
grG_multipleDef[ M4a] := [             M4a_BASIS, M4a]:
grG_multipleDef[ M4b] := [             M4b_BASIS, M4b]:
grG_multipleDef[ M4 ] := [ M4_SPINOR,  M4_BASIS,  M4]:
grG_multipleDef[ M5a] := [             M5a_BASIS, M5a]:
grG_multipleDef[ M5b] := [             M5b_BASIS, M5b]:
grG_multipleDef[ M5c] := [             M5c_BASIS, M5c]:
grG_multipleDef[ M5d] := [             M5d_BASIS, M5d]:
grG_multipleDef[ M5R] := [ M5R_SPINOR, M5R_BASIS, M5R]:
grG_multipleDef[ M5I] := [ M5I_SPINOR, M5I_BASIS, M5I]:
grG_multipleDef[ M5S] := [ M5_SPINOR,  M5S_BASIS, M5S]:
grG_multipleDef[ M6R] := [ M6R_SPINOR, M6R_BASIS, M6R]:
grG_multipleDef[ M6I] := [ M6I_SPINOR, M6I_BASIS, M6I]:

#grG_multipleDef[ R1] := [ R1_SPINOR, R1]:
#grG_multipleDef[ R2] := [ R2_SPINOR, R2]:
#grG_multipleDef[ R3] := [ R3_SPINOR, R3]:
#
#grG_multipleDef[ W1R] := [ W1R_SPINOR,  W1R]:
#grG_multipleDef[ W1I] := [ W1I_SPINOR,  W1I]:
#grG_multipleDef[ W2R] := [ W2R_SPINOR,  W2R]:
#grG_multipleDef[ W2I] := [ W2I_SPINOR,  W2I]:
#
#grG_multipleDef[ M1R] := [ M1R_SPINOR,  M1R]:
#grG_multipleDef[ M1I] := [ M1I_SPINOR,  M1I]:
#grG_multipleDef[ M2a] := [              M2a]:
#grG_multipleDef[ M2b] := [              M2b]:
#grG_multipleDef[ M2R] := [ M2R_SPINOR,  M2R]:
#grG_multipleDef[ M2I] := [ M2I_SPINOR,  M2I]:
#grG_multipleDef[ M2S] := [ M2_SPINOR,   M2S]:
#grG_multipleDef[ M3 ] := [ M3_SPINOR,   M3]:
#grG_multipleDef[ M4a] := [              M4a]:
#grG_multipleDef[ M4b] := [              M4b]:
#grG_multipleDef[ M4 ] := [ M4_SPINOR,   M4]:
#grG_multipleDef[ M5a] := [              M5a]:
#grG_multipleDef[ M5b] := [              M5b]:
#grG_multipleDef[ M5c] := [              M5c]:
#grG_multipleDef[ M5d] := [              M5d]:
#grG_multipleDef[ M5R] := [ M5R_SPINOR,  M5R]:
#grG_multipleDef[ M5I] := [ M5I_SPINOR,  M5I]:
#grG_multipleDef[ M5S] := [ M5_SPINOR,   M5S]:
#grG_multipleDef[ M6R] := [ M6R_SPINOR,  M6R]:
#grG_multipleDef[ M6I] := [ M6I_SPINOR,  M6I]:

#----------------------------------------
# grF_useWhen_tetrad
#----------------------------------------

grF_useWhen_tetrad := proc()
  if grF_checkIfAssigned( eta(bup,bup) ) then
     # if the coordinate components of the Ricci or Riemann
     # tensors have been calculated, or will be, then use regular coordinate
     # CMs.
     RETURN ( not ( grF_checkIfAssigned ( R(dn,dn,dn,dn) ) 
	         or grF_checkIfAssigned ( R(dn,dn) ) 
                 or member( R(dn,dn,dn,dn), args[1] ) 
	         or member( R(dn,dn), args[1] ) )
             ):
  fi:
  false;
end:

#----------------------------------------
# when_SpinorInvar
#----------------------------------------
grF_when_SpinorInvar := proc()
global grG_metricName; 

# If it's not a null tetrad, then these definitions can't be used.
if not grF_checkNullTetrad ( grG_metricName ) then
  RETURN ( false ):
fi:

# If either of the basis or component Riemann tensors have been
# assigned, and the NP curvature components not, then don't use
# the spinor definitions. [ Psi0 is used as a test of the last
# condition.]
if (  grF_checkIfAssigned ( R(bdn,bdn,bdn,bdn) ) or
      grF_checkIfAssigned ( R(dn,dn,dn,dn) )  or
      member ( R(bdn,bdn,bdn,bdn), args[1] ) or
      member(  R(dn,dn,dn,dn), args[1] )  or
      grF_checkIfAssigned ( R(bdn,bdn) ) or
      grF_checkIfAssigned ( R(dn,dn) )  or
      member ( R(bdn,bdn), args[1] ) or
      member(  R(dn,dn), args[1] )  
  and not grF_checkIfAssigned ( Psi0 ) ) then
  RETURN ( false ):

# Use the spinor definitions whenever the (i) NP curvature components
# have been calculated, or (ii) they have not been calculated, but
# neither has the Riemann tensor.
else
  RETURN ( true ):
fi:

end:
