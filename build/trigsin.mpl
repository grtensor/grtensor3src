interface ( quiet=true ):
#==============================================================================
# trigmake - make the trigsin.m library.
#
#==============================================================================

rootDir := `maple/trigsin/`:

readfile := proc (filename)
  printf (`Reading `.filename.` ...`):
  read ``.rootDir.filename:
  printf (` done.\n`):
end:

readfile ( `Version.mpl` ):
readfile ( `trigsin.mpl` ):

rootDir := `rootDir`:

save `trigsin.m`:
printf ( `Done trigsin.m\n` ):

quit:
#==============================================================================
