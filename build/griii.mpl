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

$define junction
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
(*
with(FileTools); 
griiilib := FileTools:-JoinPath(["lib", "griii.mla"]);


if FileTools:-Exists(griiilib) then
   printf("Remove existing library %a\n", griiilib);
   FileTools:-Remove(griiilib);
fi:
if not FileTools:-Exists(griiilib) then
	march('create',griiilib,100);
fi:
*)

grtensor := module()
option package;
export
    autoAlias,
    difftool,
	gralter,
	grapply,
	grarray,
	grdisplay,
	grcalc, 
	grcalc1,
	grcalcd,
	grcalcalter,
	grclear,
	grcomponent,
	grconstraint,
	grDalias,
	grdef,
	greqn2set,
	grload, 
	grinit,
	grmap,
	grmetric,
	grnormalize,
	grnewmetric,
	groptions,
	grsaveg,
	grtransform,
	grundef,
	kdelta,
	KillingCoords,
	makeg, 
	nprotate,
	nptetrad,
	PetrovReport,
	qload, 
	grtestinput,   
$ifdef junction
	# Junction functions
	join,
	hypersurf,
$endif
	# debug
	grdebug, # debug fn
	grdata, # debug fn
	grdump, # debug fn
	Asym, 
	Sym;

global
	# internal details
	grG_indexFnSet,
	grG_subList,
	grG_metricSet,
	grG_rootSet,
	grG_ObjDef, 
	grG_sig_,
	grG_symmetry,
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
		grinit();
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
$include "src/objects/basis/PetrovReport.mpl"

$include "src/tools/difftool.mpl"

(*
In Module() restructuring require that the grG_ObjDef definitions
are established as the module loads. (GRII relied on the global
save of the grG_ObjDef contents) 

Wrap the object definitions in a procedure wrapper
*)

load_objects := proc()
global grG_ObjDef, grG_multipleDef, grF_calc_ds:

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

$include "src/objects/dinvar.mpl"

# NP basis objects
$include "src/objects/basis/CCurve.mpl"
$include "src/objects/basis/CSpinlib.mpl"
$include "src/objects/basis/JMSpin.mpl"
$include "src/objects/basis/NPSpin.mpl"
$include "src/objects/basis/Petrov.mpl"
$include "src/objects/basis/RicciSc.mpl"
$include "src/objects/basis/WeylSc.mpl"

# INVAR objects
$include "src/objects/invar/m1.mpl"
$include "src/objects/invar/m2.mpl"
$include "src/objects/invar/m3.mpl"
$include "src/objects/invar/m4.mpl"
$include "src/objects/invar/m5.mpl"
$include "src/objects/invar/m6.mpl"
$include "src/objects/invar/r1.mpl"
$include "src/objects/invar/r2.mpl"
$include "src/objects/invar/r3.mpl"
$include "src/objects/invar/w1.mpl"
$include "src/objects/invar/w2.mpl"

end proc:

(*
Contents of the junction package

*)
$ifdef junction

load_hypers_objects := proc()
global grG_ObjDef, grG_multipleDef, grF_pre_calc_ff1, grG_metricName:
local temp_metric; 
temp_metric := grG_metricName; 
grG_metricName := `grG_metricName`:
#$include "src/junction/clawHist.mpl"
$include "src/junction/objects.mpl"
#$include "src/junction/elasticity.mpl"
#$include "src/junction/e3_object.mpl"
$include "src/junction/objects_GC.mpl"
$include "src/junction/objects_null.mpl"
#$include "src/junction/newn.mpl"
$include "src/junction/oper.mpl"
#
grG_metricName := temp_metric;
end proc:

# Junction code
$include "src/junction/chain.mpl"
$include "src/junction/jdiff.mpl"
$include "src/junction/hypersurf.mpl"
$include "src/junction/jsave.mpl"
$include "src/junction/junction.mpl"
$include "src/junction/project.mpl"

$endif

(*
Useful debug routines
- also included in the export list
*)
$include "src/debug.mpl"

grinit := proc()
global grG_metricSet, grG_ObjDef;

	grG_metricSet := {}:
	globals_init():
	load_objects();
	load_hypers_objects():
    grF_gen_rootSet():
	grF_gen_calcFnSet():
	print("GRTensor III v2.0.1 Feb 10, 2017"):
	print("Copyright 2017, Peter Musgrave, Denis Pollney, Kayll Lake");
	print("Latest version is at http://github.com/grtensor/grtensor");
	print("For help ?grtensor");
	
end proc:

end module;

grinit();

savelib(grtensor);

printf("Module grtensor saved into repo at %s\n", savelibname);

# Hack to allow load and then debug in the same session when loaded manually. 
if not assigned(noquit) then
   quit;
fi:

