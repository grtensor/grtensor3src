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
macro( gr = grG_ObjDef[Jump]):
gr[grC_header] := ` Jump from defaultMetric - Mint`:
gr[grC_root] := Jump_:
gr[grC_rootStr] := `Jump `:
gr[grC_calcFn] := grF_calc_Jump:
gr[grC_operandSeq] := object,Mint:
gr[grC_depends] := { grG_object[grG_metricName], grG_object[grG_Mint] }:
#
# index list and symmetry depend on the object Jump operates on
#
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:


grF_calc_Jump := proc( object, iList)

local root:

  root := grG_ObjDef[grG_object][grC_root]:

  grG_||root[grG_metricName,op(iList)] -
     grG_||root[grG_Mint,op(iList)]:
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
macro( gr = grG_ObjDef[Mean]):
gr[grC_header] := ` Mean value: (defaultMetric - Mint)/2`:
gr[grC_root] := Mean_:
gr[grC_rootStr] := `Mean `:
gr[grC_calcFn] := grF_calc_Mean:
gr[grC_operandSeq] := object,Mint:
gr[grC_depends] := { grG_object[grG_metricName], grG_object[grG_Mint] }:
#
# index list and symmetry depend on the object Jump operates on
#
gr[grC_indexList] := grG_ObjDef[grG_object][grC_indexList]:
gr[grC_symmetry] := grG_ObjDef[grG_object][grC_symmetry]:


grF_calc_Mean := proc( object, iList)

local root:

  root := grG_ObjDef[grG_object][grC_root]:

  (grG_||root[grG_metricName,op(iList)] +
     grG_||root[grG_Mint,op(iList)])/2:
end:

