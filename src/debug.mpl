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
	printf("Depends:\n");
	print(grG_ObjDef[name][grC_depends]);

end proc:

grdump := proc()
	global grG_rootSet;

   printf("grG_rootSet=%a\n", grG_rootSet);
end proc:

#-----------------------------------------------------

grdata := proc( list)
global grG_ObjDef, grG_calcFlag; 

	if nops(list) = 0 then
	   for a in indices(gr_data) do
		  printf("gr_data%a = %a\n", a, gr_data[op(a)]);
	   od:
	else
		printf("gr_data%a = %a\n", list, gr_data[op(list)]):
	fi:
	for a in indices(grG_calcFlag) do
	   for b in indices(grG_calcFlag[op(a)]) do
	   		printf("grG_calcFlag%a%a = %a\n", a, b, grG_calcFlag[op(a)][op(b)]);
	   od:
	od:

end proc: