interface(quiet=true):
#==============================================================================
# grii.mpl - build grii.m library.
#
# This should be run from a "fresh" maple session so extra variables etc.
# don't get stored in grtensor.m
#==============================================================================
interface(verboseproc=0):

rootDir := "maple/grii/":

# Set version and date information based on the contents of grii/Version:
#   (The following assume that the command "sed' is available in your
#   build environment)

s := "GRTensorII Version ".(
  op(2,ssystem ("sed -n '/Version:/s/Version:[ ]*//p' Version"))):
grG_Version := substring (s, 1..searchtext ("\n", s)-1):

s := op(2,ssystem ("sed -n '/Date:/s/Date:[ ]*//p' Version")):
grG_Date := substring (s, 1..searchtext ("\n", s)-1):

s := 's':

# Otherwise, if the build platform does not have sed, comment out the
# following lines and set the grG_Version and grG_Date variables
# manually. For example:
#
# grG_Version := test:
# grG_Date := today:

# The commands following this line should not require modification.

readfile := proc (filename)
  printf ("Reading "||filename||" ..."):
  read ""||rootDir||filename:
  printf (" done.\n"):
end:

anames_before := anames();
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
readfile ( "objects/tensors.mpl" ):
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

anames_after := anames(); 

snames := {seq(anames_after)} minus {seq(anames_before)}:

for i to length(snames) do
   printf("save %a type=%a\n", snames[i], type(snames[i]));
od:

savelib(seq(snames), "grii.m");

printf ( "Done grii.m\n" ):

quit
#==============================================================================


