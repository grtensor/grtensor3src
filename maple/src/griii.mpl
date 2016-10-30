#==============================================================================
# griii.mpl - read source for GRTensorIII
#
# griii is not provided as a Module but loaded direct from source. 
#==============================================================================

griii_load := proc (griii_dir)

	local src_dir;

	# Read source code:
	src_dir := cat(griii_dir, "/maple/src"):

	read cat(src_dir, "/array.mpl" ):
	read cat(src_dir, "/autoload.mpl" ):
	read cat(src_dir, "/autoAlias.mpl" ):
	read cat(src_dir, "/cmd_sup.mpl" ):
	read cat(src_dir, "/commands.mpl" ):
	read cat(src_dir, "/constrai.mpl" ):
	read cat(src_dir, "/contract.mpl" ):
	read cat(src_dir, "/core.mpl" ):
	read cat(src_dir, "/create.mpl" ):
	read cat(src_dir, "/dalias.mpl" ):
	read cat(src_dir, "/define.mpl" ):
	read cat(src_dir, "/def_fns.mpl" ):
	read cat(src_dir, "/diffAlias.mpl"):
	read cat(src_dir, "/expandsqrt.mpl" ):
	read cat(src_dir, "/globals.mpl" ):
	read cat(src_dir, "/grcomp.mpl" ):
	read cat(src_dir, "/grdef.mpl" ):
	read cat(src_dir, "/grload.mpl" ):
	read cat(src_dir, "/grtensor.mpl" ):
	read cat(src_dir, "/grtransform.mpl" ):
	read cat(src_dir, "/initFn.mpl" ):
	read cat(src_dir, "/inputFn.mpl"):
	read cat(src_dir, "/killing.mpl" ):
	read cat(src_dir, "/makeg.mpl"):
	read cat(src_dir, "/miscfn.mpl" ):
	read cat(src_dir, "/newmetric.mpl" ):
	read cat(src_dir, "/normalize.mpl" ):
	read cat(src_dir, "/nptetrad.mpl" ):
	read cat(src_dir, "/objects/basis.mpl" ):
	read cat(src_dir, "/objects/cmdef.mpl" ):
	read cat(src_dir, "/objects/diffop.mpl" ):
	read cat(src_dir, "/objects/dual.mpl" ):
	read cat(src_dir, "/objects/extras.mpl" ):
	read cat(src_dir, "/objects/gcalc.mpl" ):
	read cat(src_dir, "/objects/grvector.mpl" ):
	read cat(src_dir, "/objects/killing.mpl" ):
	read cat(src_dir, "/objects/ricci.mpl" ):
	read cat(src_dir, "/objects/tensors.mpl" ):
	read cat(src_dir, "/objects/Vectors.mpl" ):
	read cat(src_dir, "/op_sup.mpl" ):
	read cat(src_dir, "/parse.mpl" ):
	read cat(src_dir, "/rdependent.mpl" ):
	read cat(src_dir, "/str2def.mpl" ):
	read cat(src_dir, "/symfn.mpl" ):
	read cat(src_dir, "/symmetry.mpl" ):

	grF_gen_rootSet():
	grF_gen_calcFnSet():
end:


