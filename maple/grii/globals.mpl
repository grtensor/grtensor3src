###########################
# GLOBALS.MPL
###
# Converted from 5.2 to 5.3
###########################
#--------------------------------------------------------------------
# GLOBAL variables and constants used by GRTensor
#
# global symmetry info is in symmetry.mpl
#--------------------------------------------------------------------
# grG_ObjDef define the objects used by GRTensor. Defintions are in
# the files objects\*.mpl.
#
# grG_ObjDef[objectName][field] Fields:
#
# Field           Description
#
# grC_symmetry    Function for symmetry of the object
#                 see tsym.mpl for presently defined values:
#
# grC_calcFn      function used for calculation of a component
#
# grC_calcFnParms parmaters required by calc function in excess of the
#                 standard ones (which are objectName and indexList)
#
# grC_root        root for the global variable used when assigning values
#                 to the object. The grG_ prfix is added by the core
#                 routine. (so e.g. just specify Rdddd for fully
#                 covariant Riemann)
#
# grC_header      string displayed at the start
#
# grC_rootStr     string to be used as root during display
#
# grC_indexList   list of index names indicating type and position
#                      u - tensor index u   d- tensor index down
#                     tu - tetrad index u  td- tetrad index down
#                     su - spinor index u  sd- spinor index down
#                 e.g. [dn,dn,dn,d] for Riemann
#
# grC_depends     set of objects required to calculate this object
#--------------------------------------------------------------------
# Global variables used by core.mpl, initialized by command routines.
#
#       grG_metricName:     name of the metric
#       grG_fnCode:         operation to be done
#       grG_simpHow:        type of simplification etc. (0=none)
#       grG_preSeq          parms for simpHow which preceed tensor comp
#       grG_postSeq         parms which go after tensor comp in simpHow
#       grG_calc            boolean to calculate components
#       grG_simp            boolean to invoke simplification
#       grG_callComp        boolean to invoke per component display routine
#   grG_objectName      set by core to indicate name of object
#               currently being processed (used by
#               grF_clearObject)
#
#       Loop variables used by Core:
#       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       These are global so that they don't have to be passed to the
#       per component calculation routines, and so that ObjDef
#       expressions can rely on them. Note that when assigning ObjDef
#       record it's import to unassign these via grF_unassignLoopVars
#       (found in Miscfn.mpl).
#
#       a1_ .. a4_          Loop variables during core iterations
#       s1_ .. sn_          Summation variables used in sum routines
#
#
#--------------------------------------------------------------------
# Misc. globals
#       grG_coordStr.gname[]      array of strings for coodinate names


grG_indexFnSet := {up,dn,bup,bdn,pup,pdn,cup,cdn,cbup,cbdn,pbup,pbdn}:

# set of substitutions for the old GRtensor object names
# (misnomer they're really sequences)
#
grG_subList[metric] := g(dn,dn):
grG_subList[invmetric] := g(up,up):
grG_subList[d1metric] := g(dn,dn,dn):
grG_subList[Chr1] := Chr(dn,dn,dn):
grG_subList[Chr2] := Chr(dn,dn,up):
grG_subList[coordinates] := x(up):
grG_subList[Riemann] := R(dn,dn,dn,dn):
grG_subList[NRiemann] := R(up,dn,dn,dn):
grG_subList[MRiemann] := R(up,up,dn,dn):
grG_subList[URiemann] := R(up,up,up,up):
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_subList[Weyl] := C(dn,dn,dn,dn):
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_subList[MWeyl] := C(up,up,dn,dn):
### WARNING: calls to `C` for generating C code should be replaced by codegen[C]
grG_subList[UWeyl] := C(up,up,up,up):
grG_subList[Ricci] := R(dn,dn):
grG_subList[MRicci] := R(up,dn):
grG_subList[URicci] := R(up,up):
grG_subList[Einstein] := G(dn,dn):
grG_subList[MEinstein] := G(up,dn):
grG_subList[UEinstein] := G(up,up):

grG_subList[CM] := Ricciscalar,R1,R2,R3,W1R,W1I,W2R,W2I,
		   M1R,M1I, M2R, M2I, M3, M4, M5R, M5I:
grG_subList[CMS] := Ricciscalar,R1,R2,R3,W1R,M1R,M2S,M5S:
grG_subList[CMB] := Ricciscalar,R1,R2,W2R:

grG_subList[CMR] := Ricciscalar, R1, R2, R3:

grG_subList[CMM] := M1R, M1I, M2R, M2I, M3, M4, M5R, M5I:

grG_subList[CMW] := W1R, W1I, W2R, W2I:
grG_subList[W1] := W1R, W1I:
grG_subList[W2] := W2R, W2I:
grG_subList[M1] := M1R, M1I:
grG_subList[M2] := M2R, M2I:
grG_subList[M5] := M5R, M5I:
grG_subList[M6] := M6R, M6I:

#--------------------------------------------------------------------
# GLOBAL Option variables (aside from all the calculated results):
#
# grOptionDisplayLimit          see ?groptions for a full explanation
# grOptionCoordNames
# grOptionTrace
# grOptionDefaultSimp
#
# tcoreWeylFlat         true if weyl=0
# tcoreRicciFlat        true if ricci=0
# grRecord              list of what's been calculated

# set of metric names already in the session
grG_metricSet := {}:

# set defaults
grOptionDisplayLimit := 5000:
grOptionAlterSize := false:
grOptionCoordNames := true:
grOptionTrace := true:
grOptionVerbose := false:
grOptionDefaultSimp := 8:
grOptionTermSize := 100:
grOptionTimeStamp := true:
grOptionWindows := true:
grOptionProfile := false:
grOptionLLSC := true:
grOptionMessageLevel := 1:
grOptionMaplet := false:

# grG_rootSet
# List of the root function name concatenated with the
# number of indices [e.g. for R(dn,dn,dn,dn) -> R4].
#
# Created automatically by the routine grF_gen_rootSet() (in miscfn.mpl)
#
grG_rootSet := {}:

# grG_usedNameSet
# Keeps track of names that have been used in tensor definitions so
# that autoAlias can check when alias conflicts might arise.
grG_usedNameSet := {}:

#
# maximum number of metric which can be used in a single defintion
# (if increase this, change the unassign list in grdefine() )
#
grC_maxMetricsInDef := 4:



