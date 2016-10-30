interface ( quiet=true ):
#==============================================================================
# invars - build invar.m library.
#
#==============================================================================

rootDir := `maple/invar/`:

readfile := proc (filename)
  printf (`Reading `.filename.` ...`):
  read ``.rootDir.filename:
  printf (` done.\n`):
end:

readfile ( `Version.mpl` ):

readfile ( `r1.mpl` ):
readfile ( `r2.mpl` ):
readfile ( `r3.mpl` ):
readfile ( `w1.mpl` ):
readfile ( `w2.mpl` ):
readfile ( `m1.mpl` ):
readfile ( `m2.mpl` ):
readfile ( `m3.mpl` ):
readfile ( `m4.mpl` ):
readfile ( `m5.mpl` ):
readfile ( `m6.mpl` ):

invar():

rootDir := `rootDir`:

save `invar.m`:
printf ( `Done invar.m\n` ):

quit:
#==============================================================================
