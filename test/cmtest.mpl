#------------------------------------------------------------------------------
# CM Test
#
# Save the CM values into an array cmvalue[name][cm_entry] and write to the file
# specified. 
#------------------------------------------------------------------------------

cmlist := ["Ricciscalar", "R1", "R2", "R3", "W1R", "W1I", "W2R", "W2I", "M1R", "M1I",
		"M2R", "M2I", "M3", "M4", "M5R", "M5I"];

cmflip := ["W1R", "W1I", "W2R", "W2I","M1R", "M1I", "M2R", "M2I", "M5R", "M5I"];


cmsave := proc(file)
global cmvalues;
local i;
	for i in cmlist do:
		printf("save %s\n", i):
		cmvalues[i] := grcomponent(convert(i,symbol));
	od:
	save cmvalues, file;
end:

cmcheck := proc(file)
global cmdiff, cmvalues; 
local i;
	read file;
	for i in cmlist do:
		cmdiff[i] := simplify(expand(cmvalues[i] - grcomponent(convert(i,symbol))));
		printf("diff[%s] = %a\n", i, cmdiff[i]);
	od:
	# sometimes seems Im are opposite sign (signature?)
	printf("\nCheck for sign flip\n");
	for i in cmflip do:
		cmdiff[i] := simplify(cmvalues[i] + grcomponent(convert(i,symbol)));
		printf("sum[%s] = %a\n", i, cmdiff[i]);
	od:
	printf("Diff is in cmdiff\n");
end:



