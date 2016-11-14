#
# Debug functions for GRTensorIII development
#

grdebug := proc( name)
global grG_ObjDef; 

	printf("symmetry : %a\n", grG_ObjDef[name][grC_symmetry]);
	printf("root : %a\n", grG_ObjDef[name][grC_root]);
	interface(verboseproc=3);
	printf("Symmetry:\n");
	print(grG_ObjDef[name][grC_symmetry]);
	printf("CalcFn:\n");
	print(grG_ObjDef[name][grC_calcFn]);
	printf("CalcFnParms:\n");
	print(grG_ObjDef[name][grC_calcFnParms]);

end proc:

grdata := proc( list)
global grG_ObjDef; 

	if nops(list) = 0 then
	   for a in indices(gr_data) do
		  printf("gr_data%a = %a\n", a, gr_data[op(a)]);
	   od:
	else
		printf("gr_data%a = %a\n", list, gr_data[op(list)]):
	fi:

end proc: