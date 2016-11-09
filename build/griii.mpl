#==============================================================================
# grii_2016.mpl - build grii.m library.
#
# This should be run from a "fresh" maple session so extra variables etc.
# don't get stored in grtensor.m
#
# Run from the top level of the project
#
# Need to have created a repository in /lib with:
# march('create',"lib/griii.mla",100);
# (assuming maple was started in top level dir)
#==============================================================================
# savelibname is a Maple global for savelib()
#  savelibname := "/home/grtensor/gitlab/GRTensorIII/lib":
# PeterM Mac
savelibname := "/Users/peter/maple/gitlab/GRTensorIII/lib":

(*
In GRTensorII global variables were heavily used and
created on the fly with name concatentation. 

In the module-friendly refactor:
- all component data now in gr_data: gr_data[object, metric, index1,...]
- all dimension info in Ndim[metricName]
- generally need to declare things as global BUT Maple is lexically scoped so
  methods called from within a method have access to the variable in the outer
  method (including it's local vars)

Still need to handle signature, basis, np stuff

*)

grtensor := module()
option package;
export
    autoalias,
	gralter,
	grdisplay,
	grcalc, 
	grcalcalter,
	grcomponent,
	grdef,
	grload, 
	grloaddef,
	grinit,
	grmap,
	groptions,
	grsavedef,
	grtransform,
	kdelta,
	makeg, 
	nptetrad,
	qload, 
	grtestinput,   # remove when shipping
	grdebug;

global
	# internal details
	grG_indexFnSet,
	grG_subList,
	grG_metricSet,
	grG_rootSet,
	grG_ObjDef, 
	grG_sig_,
	grC_maxMetricsInDef,
	grG_usedNameSet,
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
	grOptionMapletInput;


local
	ModuleLoad := proc()
		grinit():
	end proc:

# include may not be indented

# constants used in several places (grload, makeg etc.)
$define grG_g 1 
$define grG_ds 2
$define grG_basis  3
$define grG_np  4


$include  "src/globals.mpl"

$include  "src/array.mpl" 
$include  "src/autoAlias.mpl"
$include  "src/cmd_sup.mpl"
$include  "src/commands.mpl"
$include  "src/constrai.mpl"
$include  "src/contract.mpl"
$include  "src/core.mpl"
$include  "src/create.mpl"
$include  "src/dalias.mpl"
$include  "src/define.mpl"
$include  "src/def_fns.mpl"
$include  "src/diffAlias.mpl"):
$include  "src/expandsqrt.mpl"
$include  "src/grcomp.mpl"
$include  "src/grdef.mpl"
$include  "src/grload.mpl"
$include  "src/grtensor.mpl"
$include  "src/grtransform.mpl"
$include  "src/initFn.mpl"
$include  "src/inputFn.mpl"):
$include  "src/killing.mpl"
$include  "src/makeg.mpl"):
$include  "src/miscfn.mpl"
$include  "src/newmetric.mpl"
$include  "src/normalize.mpl"
$include  "src/nptetrad.mpl"
$include  "src/op_sup.mpl"
$include  "src/parse.mpl"
$include  "src/rdependent.mpl"
$include  "src/str2def.mpl"
$include  "src/symfn.mpl"
$include  "src/symmetry.mpl"

(*
In Module() restructuring require that the grG_ObjDef definitions
are established as the module loads. (GRII relied on the global
save of the grG_ObjDef contents) 

Wrap the object definitions in a procedure wrapper
*)

load_objects := proc()
global grG_ObjDef:
$include  "src/objects/basis.mpl"
$include  "src/objects/cmdef.mpl"
$include  "src/objects/diffop.mpl"
$include  "src/objects/dual.mpl"
$include  "src/objects/extras.mpl"
$include  "src/objects/gcalc.mpl"
$include  "src/objects/grvector.mpl"
$include  "src/objects/killing.mpl"
$include  "src/objects/ricci.mpl"
$include  "src/objects/tensors.mpl"
$include  "src/objects/Vectors.mpl"
# autoload has aliases we need
$include  "src/autoload.mpl"
end proc:

(*
Useful debug routines
*)
$include "src/debug.mpl"

grinit := proc()
global grG_metricSet, grG_ObjDef;

	grG_metricSet := {}:
	globals_init():
	load_objects();
	grF_gen_rootSet():
	grF_gen_calcFnSet():
	print("GRTensor III"):
	print("Copyright 2016, Peter Musgrave, Denis Pollney, Kayll Lake");
	print("grtensor.org");
	
end proc:

end module;

grinit();

savelib(grtensor);

printf("Module grtensor saved into repo at %s\n", savelibname);

quit;
