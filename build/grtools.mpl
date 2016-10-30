interface(quiet=true):
#==============================================================================
# toolmake - build the grtools.m library.
#
#==============================================================================

rootDir := `maple/grtools/`:

readfile := proc (filename)
  printf (`Reading `.filename.` ...`):
  read ``.rootDir.filename:
  printf (` done.\n`):
end:

readfile ( `Version.mpl` ):

readfile ( `difftool.mpl` ):
readfile ( `mixpar.mpl` ):
readfile ( `pexpand.mpl` ):
readfile ( `limit.mpl` ):

rootDir := `rootDir`:

save `grtools.m`:
printf ( `Done grtools.m\n` ):

quit

