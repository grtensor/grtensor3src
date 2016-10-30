#
# Module test
#
Toy := module()

	option package;
	export test;

	global grG_ObjDef;

	grG_ObjDef[a][name] := "toy name":

	test := proc()
	   global grG_ObjDef;
	   printf("test: %a", grG_ObjDef[a][name]);
	end proc:

end module;


#==============================================================================
# grii_2016.mpl - build grii.m library.
#
# This should be run from a "fresh" maple session so extra variables etc.
# don't get stored in grtensor.m
#
# Run from the top level of the project
#==============================================================================
interface(verboseproc=3):

GRTensorII := module()
option package;
export
	grinit;

global
	# internal details
	grG_ObjDef;


local
	ModuleLoad := proc()
	end proc:

# include may not be indented
$include  "maple/grii/objects/tensors_nm.mpl"
#macro( gr = grG_ObjDef[ds]):
#grG_ObjDef[ds][grC_header] := `Line element`:

grinit := proc()
    global grG_ObjDef;
		#grF_gen_rootSet():
		#grF_gen_calcFnSet():
		printf("debug: %a", grG_ObjDef[ds][grC_header]);
end proc:

end module;


#grii := proc() end:

#gc():
#grtensor (false);

#rootDir := "rootDir":

#save "grii.m":

#printf ( "Done grii.m\n" );

#quit
#==============================================================================


