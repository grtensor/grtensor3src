#==============================================================================
# grii_2016.mpl - build grii.m library.
#
# This should be run from a "fresh" maple session so extra variables etc.
# don't get stored in grtensor.m
#
# Run from the top level of the project
#==============================================================================
interface(verboseproc=3):

GRTensorII := module()
option package;
export
	gralter,
	grdisplay,
	grcalc, 
	grinit,
	grload, 
	groptions,
	makeg, 
	qload,
	# options
	grOptionDisplayLimit,
	grOptionAlterSize,
	grOptionCoordNames,
	grOptionTrace,
	grOptionVerbose,
	grOptionDefaultSimp,
	grOptionTermSize,
	grOptionTimeStamp,
	grOptionWindows,
	grOptionProfile,
	grOptionLLSC,
	grOptionMessageLevel,
	grOptionMaplet;

global
	# internal details
	grG_ObjDef, 
	grG_metricSet;


local
	ModuleLoad := proc()
	end proc:

# include may not be indented
$include  "maple/grii/globals.mpl"

$include  "maple/grii/array.mpl" 
$include  "maple/grii/autoload.mpl"
$include  "maple/grii/autoAlias.mpl"
$include  "maple/grii/cmd_sup.mpl"
$include  "maple/grii/commands.mpl"
$include  "maple/grii/constrai.mpl"
$include  "maple/grii/contract.mpl"
$include  "maple/grii/core.mpl"
$include  "maple/grii/create.mpl"
$include  "maple/grii/dalias.mpl"
$include  "maple/grii/define.mpl"
$include  "maple/grii/def_fns.mpl"
$include  "maple/grii/diffAlias.mpl"):
$include  "maple/grii/expandsqrt.mpl"
$include  "maple/grii/grcomp.mpl"
$include  "maple/grii/grdef.mpl"
$include  "maple/grii/grload.mpl"
$include  "maple/grii/grtensor.mpl"
$include  "maple/grii/grtransform.mpl"
$include  "maple/grii/initFn.mpl"
$include  "maple/grii/inputFn.mpl"):
$include  "maple/grii/killing.mpl"
$include  "maple/grii/makeg.mpl"):
$include  "maple/grii/miscfn.mpl"
$include  "maple/grii/newmetric.mpl"
$include  "maple/grii/normalize.mpl"
$include  "maple/grii/nptetrad.mpl"
$include  "maple/grii/objects/basis.mpl"
$include  "maple/grii/objects/cmdef.mpl"
$include  "maple/grii/objects/diffop.mpl"
$include  "maple/grii/objects/dual.mpl"
$include  "maple/grii/objects/extras.mpl"
$include  "maple/grii/objects/gcalc.mpl"
$include  "maple/grii/objects/grvector.mpl"
$include  "maple/grii/objects/killing.mpl"
$include  "maple/grii/objects/ricci.mpl"
$include  "maple/grii/objects/tensors_nm.mpl"
$include  "maple/grii/objects/Vectors.mpl"
$include  "maple/grii/op_sup.mpl"
$include  "maple/grii/parse.mpl"
$include  "maple/grii/rdependent.mpl"
$include  "maple/grii/str2def.mpl"
$include  "maple/grii/symfn.mpl"
$include  "maple/grii/symmetry.mpl"

grinit := proc()
    global grG_ObjDef;
		grF_gen_rootSet():
		grF_gen_calcFnSet():
		printf("debug: %a", grG_ObjDef[ds][grC_header]);
end proc:

end module;


#grii := proc() end:

#gc():
#grtensor (false);

#rootDir := "rootDir":

#save "grii.m":

#printf ( "Done grii.m\n" );

#quit
#==============================================================================


