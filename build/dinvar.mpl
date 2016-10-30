interface ( quiet=true ):
#==============================================================================
# dinvarmake - build the dinvar.m library.
#
#==============================================================================

rootDir := `maple/dinvar/`:

readfile := proc (filename)
  printf (`Reading `.filename.` ...`):
  read ``.rootDir.filename:
  printf (` done.\n`):
end:

readfile (`Version.mpl`):
readfile (`dinvar.mpl`):

rootDir := `rootDir`:

save `dinvar.m`:
printf ( `Done dinvar.m\n` ):

quit:
#==============================================================================
