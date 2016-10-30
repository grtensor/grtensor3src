interface(quiet=true):
#=================================================================-*-Maple-*-==
# spinor.mpl - make spinor tools package
#
# Denis Pollney
# 20 November 1996
#
#==============================================================================
interface(verboseproc=0):

rootDir := ``.homeDir.`/grii/d/spinor/`: # for gert
testDir := ``.homeDir.`/grii/d/spinor/`: # test files
testLib := ``.homeDir.`/grii/dlib/`:

readfile := proc ( filename )
  printf ( `Reading `.filename.` ...` ):
  read ``.rootDir.filename:
  printf ( ` done.\n` ):
end:

testfile := proc ( filename )
  printf ( `** Reading test `.filename.` ...` ):
  read ``.testDir.filename:
  printf ( ` done.\n` ):
end:

testfile ( `version.mpl` ):

# New classi modules
testfile ( `alias.mpl` ):
testfile ( `classify.mpl` ):
testfile ( `display.mpl` ):
testfile ( `dygen.mpl` ):
testfile ( `fixframe.mpl` ):
testfile ( `indep.mpl` ):
testfile ( `isotest.mpl` ):
testfile ( `operator.mpl` ):
testfile ( `ptype.mpl` ):
testfile ( `rotate.mpl` ):
testfile ( `rotatefn.mpl` ):
testfile ( `spinors.mpl` ):
testfile ( `stdtest.mpl` ):
testfile ( `symm.mpl` ):
testfile ( `util.mpl` ):

homeDir := `homeDir`:

save ``.testLib.`spinor.m`:

printf ( `Saved as: `.testLib.`spinor.m\n` ):

quit
#==============================================================================




