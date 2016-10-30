###########################
# GRHELP.MPL
###
# Converted from 5.2 to 5.3
###########################
#
# make the help screens from the text in
# \help
#
# write them in a seperate library
#
readlib(makehelp);
makehelp(`gralter`, `help/gralter.txt`);
makehelp(`grapply`, `help/grapply.txt`);
makehelp(`grcalc`, `help/grcalc.txt`);
makehelp(`grcalc1`, `help/grcalc1.txt`);
makehelp(`grtensor_commands`, `help/grcmd.txt`);
makehelp(`grcomponent`, `help/component.txt`);
makehelp(`grclear`, `help/grclear.txt`);
makehelp(`grDalias`, `help/dalias.txt`);
makehelp(`grdefine`, `help/define.txt`);
makehelp(`grdisplay`, `help/grdisp.txt`);
makehelp(`greqn2set`, `help/eqn2set.txt`);
makehelp(`grlib`, `help/grlib.txt`);
makehelp(`grload`, `help/load.txt`);
makehelp(`grloaddef`, `help/loaddef.txt`);
makehelp(`grloadobj`, `help/loadobj.txt`);
makehelp(`grmap`, `help/grmap.txt`);
makehelp(`grmetric`, `help/metric.txt`);
makehelp(`makeg`, `help/makeg.txt`);
makehelp(`grnewmetric`, `help/newmetric.txt`);
makehelp(`groptions`, `help/options.txt`);
makehelp(`grsavedef`, `help/savedef.txt`);
makehelp(`grsaveobj`, `help/saveobj.txt`);
makehelp(`grundefine`, `help/undefine.txt`);

# files for help displays

read `help/grobject.mpl`:
read `help/grtensor.mpl`:
read `help/grdefs.mpl`:
read `help/grsave.mpl`:

# dummy function

griihelp := proc() end:
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;


save `griihelp.m`;

