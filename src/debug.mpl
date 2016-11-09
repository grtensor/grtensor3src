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
end proc: