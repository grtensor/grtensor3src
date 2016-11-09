#==============================================================================
# grii.mpl - build grii.m library.
#
# This should be run from a "fresh" maple session so extra variables etc.
# don't get stored in grtensor.m
#==============================================================================
interface(verboseproc=3):

# customize this line for your system
rootDir := "/home/grtensor/gitlab/GRTensorII/maple/grii/":

# Set version and date information based on the contents of grii/Version:
#   (The following assume that the command "sed' is available in your
#   build environment)


readfile := proc (filename)
  printf ("Reading %s", filename):
  read cat(rootDir, filename):
  printf (" done.\n"):
end:

# Read source code:

readfile ( "array.mpl" ):
readfile ( "autoload.mpl" ):
readfile ( "autoAlias.mpl" ):
readfile ( "cmd_sup.mpl" ):
readfile ( "commands.mpl" ):
readfile ( "constrai.mpl" ):
readfile ( "contract.mpl" ):
readfile ( "core.mpl" ):
readfile ( "create.mpl" ):
readfile ( "dalias.mpl" ):
readfile ( "define.mpl" ):
readfile ( "def_fns.mpl" ):
readfile ( "diffAlias.mpl"):
readfile ( "expandsqrt.mpl" ):
readfile ( "globals.mpl" ):
readfile ( "grcomp.mpl" ):
readfile ( "grdef.mpl" ):
readfile ( "grload.mpl" ):
readfile ( "grtensor.mpl" ):
readfile ( "grtransform.mpl" ):
readfile ( "initFn.mpl" ):
readfile ("inputFn.mpl"):
readfile ( "killing.mpl" ):
readfile ( "makeg.mpl"):
readfile ( "miscfn.mpl" ):
readfile ( "newmetric.mpl" ):
readfile ( "normalize.mpl" ):
readfile ( "nptetrad.mpl" ):
readfile ( "objects/basis.mpl" ):
readfile ( "objects/cmdef.mpl" ):
readfile ( "objects/diffop.mpl" ):
readfile ( "objects/dual.mpl" ):
readfile ( "objects/extras.mpl" ):
readfile ( "objects/gcalc.mpl" ):
readfile ( "objects/grvector.mpl" ):
readfile ( "objects/killing.mpl" ):
readfile ( "objects/ricci.mpl" ):
readfile ( "objects/tensors_nm.mpl" ):
readfile ( "objects/Vectors.mpl" ):
readfile ( "op_sup.mpl" ):
readfile ( "parse.mpl" ):
readfile ( "rdependent.mpl" ):
readfile ( "str2def.mpl" ):
readfile ( "symfn.mpl" ):
readfile ( "symmetry.mpl" ):
grF_gen_rootSet():
grF_gen_calcFnSet():

grii := proc() end:

gc():
grtensor (false);

rootDir := "rootDir":

#save "grii.m":

#printf ( "Done grii.m\n" ):

#quit
#==============================================================================


