#////////////////////////////
#////////////////////////////
#
# OPERATORS
#
#////////////////////////////
#////////////////////////////


#----------------------------
# Jump
#
# For any object calculate value[defaultMetric] - value[Mint]
# for each component.
#
# BUG: presently only works on basic objects (i.e.
#    Jump[ Dsq[RiemSq] ..] will NOT work.)
#
#----------------------------
grG_ObjDef[Jump][grC_header] := ` Jump from defaultMetric - Mint`:
grG_ObjDef[Jump][grC_root] := Jump_:
grG_ObjDef[Jump][grC_rootStr] := `Jump `:
grG_ObjDef[Jump][grC_calcFn] := grF_calc_Jump:
grG_ObjDef[Jump][grC_operandSeq] := object,Mint:
grG_ObjDef[Jump][grC_depends] := { grG_object[grG_metricName], grG_object[grG_Mint] }:
#
# index list and symmetry depend on the object Jump operates on
#
grG_ObjDef[Jump][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Jump][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:


grF_calc_Jump := proc( object, iList)

global grG_metricName, gr_data;
local root:

  root := grG_ObjDef[grG_object][grC_root]:

  gr_data[root,grG_metricName,op(iList)] -
     gr_data[root, grG_Mint,op(iList)]:
end:

#----------------------------
# Mean
#
# For any object calculate (value[defaultMetric] + value[Mint])/2
# for each component.
#
# BUG: presently only works on basic objects (i.e.
#    Jump[ Dsq[RiemSq] ..] will NOT work.)
#
#----------------------------
grG_ObjDef[Mean][grC_header] := ` Mean value: (defaultMetric - Mint)/2`:
grG_ObjDef[Mean][grC_root] := Mean_:
grG_ObjDef[Mean][grC_rootStr] := `Mean `:
grG_ObjDef[Mean][grC_calcFn] := grF_calc_Mean:
grG_ObjDef[Mean][grC_operandSeq] := object,Mint:
grG_ObjDef[Mean][grC_depends] := { grG_object[grG_metricName], grG_object[grG_Mint] }:
#
# index list and symmetry depend on the object Jump operates on
#
grG_ObjDef[Mean][grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
grG_ObjDef[Mean][grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:


grF_calc_Mean := proc( object, iList)
global grG_metricName, gr_data;

local root:

  root := grG_ObjDef[grG_object][grC_root]:

  (gr_data[root,grG_metricName,op(iList)] +
     gr_data[root,grG_Mint,op(iList)])/2:
end:

