interface ( quiet=true ):

rootDir := ``.homeDir.`/grii/src/help/`: # for gert
testDir := ``.homeDir.`/grii/src/help/`: # test files
testLib := ``.homeDir.`/grii/dlib/`:

readlib ( makehelp ):

makehelp ( Info, ``.rootDir.`Info.help` ):
makehelp ( PetrovReport, ``.rootDir.`PetrovReport.help` ):
makehelp ( autoAlias, ``.rootDir.`autoAlias.help` ):
makehelp ( cmscalar, ``.rootDir.`cmscalar.help` ):
makehelp ( diffAlias, ``.rootDir.`diffAlias.help` ):
makehelp ( difftool, ``.rootDir.`difftool.help` ):
makehelp ( dinvar, ``.rootDir.`dinvar.help` ):
makehelp ( grDalias, ``.rootDir.`grDalias.help` ):
makehelp ( gralter, ``.rootDir.`gralter.help` ):
makehelp ( grapply, ``.rootDir.`grapply.help` ):
makehelp ( grarray, ``.rootDir.`grarray.help` ):
makehelp ( grcalc, ``.rootDir.`grcalc.help` ):
makehelp ( grcalc1, ``.rootDir.`grcalc1.help` ):
makehelp ( grclear, ``.rootDir.`grclear.help` ):
makehelp ( grcomponent, ``.rootDir.`grcomponent.help` ):
makehelp ( grconstraint, ``.rootDir.`grconstraint.help` ):
makehelp ( grdef, ``.rootDir.`grdef.help` ):
makehelp ( grdefine, ``.rootDir.`grdefine.help` ):
makehelp ( grdisplay, ``.rootDir.`grdisplay.help` ):
makehelp ( greqn2set, ``.rootDir.`greqn2set.help` ):
makehelp ( grlib, ``.rootDir.`grlib.help` ):
makehelp ( grlimit, ``.rootDir.`grlimit.help` ):
makehelp ( grload, ``.rootDir.`grload.help` ):
makehelp ( grloaddef, ``.rootDir.`grloaddef.help` ):
makehelp ( grloadobj, ``.rootDir.`grloadobj.help` ):
makehelp ( grmap, ``.rootDir.`grmap.help` ):
makehelp ( grmetric, ``.rootDir.`grmetric.help` ):
makehelp ( grnewmetric, ``.rootDir.`grnewmetric.help` ):
makehelp ( grnormalize, ``.rootDir.`grnormalize.help` ):
makehelp ( groptions, ``.rootDir.`groptions.help` ):
makehelp ( grsavedef, ``.rootDir.`grsavedef.help` ):
makehelp ( grsaveg, ``.rootDir.`grsaveg.help` ):
makehelp ( grsaveobj, ``.rootDir.`grsaveobj.help` ):
makehelp ( grt_basis, ``.rootDir.`grt_basis.help` ):
makehelp ( grt_commands, ``.rootDir.`grt_commands.help` ):
makehelp ( grt_invars, ``.rootDir.`grt_invars.help` ):
makehelp ( grt_objects, ``.rootDir.`grt_objects.help` ):
makehelp ( grt_operators, ``.rootDir.`grt_operators.help` ):
makehelp ( grtensor, ``.rootDir.`grtensor.help` ):
makehelp ( grtransform, ``.rootDir.`grtransform.help` ):
makehelp ( grundefine, ``.rootDir.`grundefine.help` ):
makehelp ( kdelta, ``.rootDir.`kdelta.help` ):
makehelp ( killing, ``.rootDir.`killing.help` ):
makehelp ( makeg, ``.rootDir.`makeg.help` ):
makehelp ( nprotate, ``.rootDir.`nprotate.help` ):
makehelp ( nptetrad, ``.rootDir.`nptetrad.help` ):
makehelp ( qload, ``.rootDir.`qload.help` ):

makehelp ( report, ``.rootDir.`PetrovReport.help` ):
makehelp ( Petrov, ``.rootDir.`grt_basis.help` ):
makehelp ( petrov, ``.rootDir.`grt_basis.help` ):
makehelp ( spin, ``.rootDir.`grt_basis.help` ):
makehelp ( basis, ``.rootDir.`grt_basis.help` ):
makehelp ( tetrad, ``.rootDir.`grt_basis.help` ):
makehelp ( frame, ``.rootDir.`grt_basis.help` ):
makehelp ( NP, ``.rootDir.`grt_basis.help` ):
makehelp ( invars, ``.rootDir.`grt_invars.help` ):
makehelp ( Riemann, ``.rootDir.`grt_objects.help` ):
makehelp ( riemann, ``.rootDir.`grt_objects.help` ):
makehelp ( Ricci, ``.rootDir.`grt_objects.help` ):
makehelp ( ricci, ``.rootDir.`grt_objects.help` ):
makehelp ( Einstein, ``.rootDir.`grt_objects.help` ):
makehelp ( einstein, ``.rootDir.`grt_objects.help` ):
makehelp ( Weyl, ``.rootDir.`grt_objects.help` ):
makehelp ( weyl, ``.rootDir.`grt_objects.help` ):
makehelp ( Killing, ``.rootDir.`killing.help` ):
makehelp ( killing, ``.rootDir.`killing.help` ):
makehelp ( shear, ``.rootDir.`grt_operators.help` ):
makehelp ( vorticity, ``.rootDir.`grt_operators.help` ):
makehelp ( electric, ``.rootDir.`grt_operators.help` ):
makehelp ( magnetic, ``.rootDir.`grt_operators.help` ):
makehelp ( Kronecker, ``.rootDir.`kdelta.help` ):
makehelp ( kronecker, ``.rootDir.`kdelta.help` ):

griihelp := proc() end:

homeDir := `homeDir`:

save ``.testLib.`griihelp.m`:
printf ( `Saved as: `.testLib.`griihelp.m\n` ):

quit:
