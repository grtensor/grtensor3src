#
# Debug functions for GRTensorIII development
#

grdebug := proc( name)
global grG_ObjDef; 

	interface(verboseproc=3);
	for i in indices(grG_ObjDef[name]) do
		index := op(i):
		printf("[%a]:\n", index);
		print(grG_ObjDef[name][index]):
	od:

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
	   for b in list do
		   for a in indices(gr_data) do
		      if member(b, a) then
			     printf("gr_data%a = %a\n", a, gr_data[op(a)]);
			  fi:
		   od:
	   od:
	fi:
	for a in indices(grG_calcFlag) do
	   for b in indices(grG_calcFlag[op(a)]) do
	   		printf("grG_calcFlag%a%a = %a\n", a, b, grG_calcFlag[op(a)][op(b)]);
	   od:
	od:

end proc: