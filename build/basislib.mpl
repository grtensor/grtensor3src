interface ( quiet=true ):
#==============================================================================
# bmake - build basislib.m library.
#
# File Created By: Denis Pollney
#            Date: August 25, 1994
#==============================================================================

rootDir := `maple/basis/`:

readfile := proc (filename)
  printf (`Reading `.filename.` ...`):
  read ``.rootDir.filename:
  printf (` done.\n`):
end:

readfile ( `Version.mpl` ):

readfile ( `NPSpin.mpl` ):
readfile ( `WeylSc.mpl` ):
readfile ( `RicciSc.mpl` ):
readfile ( `Petrov.mpl` ):
readfile ( `JMSpin.mpl` ):
readfile ( `CSpinlib.mpl` ):
readfile ( `CCurve.mpl` ):

basislib():

rootDir := `rootDir`:

save `basislib.m`:
printf ( `Done basislib.m\n` ):

quit:
#==============================================================================
