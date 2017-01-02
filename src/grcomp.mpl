#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE:
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: distant past
#
#
# Purpose: print display/alter size
#
# Revisions:
#
# Oct    5, 93   Fix ()^2 in invmetric
# Dec    9, 93   Disallow coord names for grdisplay( x(up) );
# Jan    7, 94   Rewrote dispStr -> dispStr2 to allow Greek in output
# Apr   24, 94   Added latex etc.
# Apr   31, 94   Add cup, cdn support
# May   28, 94   Add grF_saveObj clause
# Jun   27, 94   Add grF_testGen clause
# July   7, 94   Add grF_dispStr3
# July  30, 94   Remove dispStr2. Fix dispStr3. Use bup/dbn [dp?]
# Sept  21, 94   Add grOptionWindow support to dispStr [pm]
# Dec    6, 94   Add pup.pdn [pm]
# March 10, 95   Add some routines to handle 1,2-index objects. [dp]
# March 10, 95   Don't display coord names for basis objects, only #'s. [dp]
# April 26, 95   Prevent display of zero vectors/matrix. [dp]
# May   13, 95   Fix printing of objects with operands. [dp]
# Aug   22, 95   Display operator arguments as part of root String [pm]
# Nov   20, 95   Minor change to 'if's in grF_displayMetric [dp]
# June   4, 96   Added support for cbup, cbdn, pbup, pbdn [dp]
# Nov	14, 96   Fix `all compnts zero` output for vector/matrix opers. [dp]
# Feb    5, 97   Add display of complex quantities to displaymetric [dp]
# Sept  16, 97   Removed R3 type specifiers in proc headers [dp]
# Feb   14, 97   Switch convert(x,string) to convert(x,name) for R5 [dp]
# May   31, 97   Fixed display of square brackets in output indices [dp]
# Oct   27, 98	 Fixed index order display bug in dispStr3 [dp]
#
# NOTE: The ordering of components in dispStr3 relies on maple's
#   multiplication to not change the order of terms. This can result in
#   bugs and should be changed. [dp 27Oct98]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#**********************************************************
#
# Routines in this file:
#    grF_component(),
#    grF_dispStr()
#
#**********************************************************


#//////////////////////////////////////////////////////////
# grF_component(objectName,indexList, value)
#
#       objectName      name of the tensor or scalar
#       indexList       list of indices for the object
#       value		value of the component
#
# This was originally a display routine for a single
# component of a tensor. It has expanded to encompass
# certain special cases which cannot be handled as
# alter/apply functions (i.e. those which require some
# knowledge of the object and its indices). These include:
#  saveobj, latex and testGen
#
#///////////////////////////////////////////////////////////

grF_component := proc(objectName,indexList,value)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_displayZero, grOptionDisplayLimit;
local size, dispStr, i , subSup:

   if grG_simpHow[1]=grF_saveObj and ( value<>0 and value <> (0=0) ) then
     print ( value ):
     #
     # for save obj we must save the zero values as well
     #
     appendto( grG_simpHow[2] ):
     #
     # grG_postSeq will contain either `[grG_metricName`
     #   or `[grG_surfaceName`
     #
     printf(`grG_%a%s,grG_operands`,
                grG_ObjDef[objectName][grC_root], grG_postSeq):
     if indexList <> [] then
        for i to nops(indexList) do
          printf(`,%a`, indexList[i]);
        od:
     fi:
     printf(`] := `);
     printf(`%a:\n`, value);
     writeto(terminal):

   elif grG_fnCode = grF_testGen then
     #
     # TEST GENERATION
     #
     # (for test obj we must test the zero values as well)
     #
     # Generate code to compare the value of the object to the
     # assigned GRTensor object.
     #
     appendto( grG_postSeq ):

     printf(`if normal(grG_%a[%a`, grG_ObjDef[objectName][grC_root],
             grG_metricName):

     if grG_operands <> NULL then
       for i in [grG_operands] do
         printf(`,%a`, i):
       od:
     fi:

     if indexList <> [] then
        for i to nops(indexList) do
          printf(`,%a`, indexList[i]);
        od:
     fi:
     printf(`] - (%a)) = 0 then\n`, value);
     printf(`print(okay); else global_okay := false: print(not_okay,%a,%s); fi:\n`,
             objectName, convert(indexList, name) ):
     writeto(terminal):
   #
   # only do something if the component value is non-zero
   #
   elif not (value = 0 or value = (0 = 0)) then

       if assigned ( grG_ObjDef[objectName][grC_displayFn] ) then
         dispStr := grG_ObjDef[objectName][grC_displayFn](objectName,indexList):
       else
         dispStr := grF_dispStr3(objectName,indexList, false);
       fi:
       size := length(value):

       if (grG_fnCode = grC_ALTER) then
	 #
	 # display info on the size change realized
	 #
	 print(dispStr,cat(` changed to `,size,` (words)`)):
	 grG_displayZero := false: # suppress all component zero msg.

       elif grG_fnCode = grC_DISP then
	 #
	 # check that size is `reasonable` before printing it.
	 #
	 grG_displayZero := false:
	 if (size < grOptionDisplayLimit) then
                if grG_ObjDef[objectName][grC_objType] = Matrix then
			print(dispStr = evalm(value) ):
		else
			print(dispStr=value):
		fi:
	 else
		print(dispStr =` `||size||` words. Exceeds grOptionDisplayLimit`):
	 fi:

       elif grG_fnCode = grC_APPLY then
	 #
	 # function to apply is in grG_simpHow[1] and the file
	 # to put the resutls in is in grG-simpHow[2]
	 #
	 if grG_simpHow[1] = latex then 
	   #
	   # need to build a lhs (in proper LaTeX form)
	   #
	   appendto( grG_simpHow[2] ):
	   printf ("% %a %a\n",objectName, indexList):
	   latex(grG_preSeq, value, grG_postSeq):
	   writeto(terminal):
         else
	   appendto( grG_simpHow[2] ):
	   printf ("%a\n", grG_simpHow[1](grG_preSeq, value, grG_postSeq)):
	   writeto(terminal):
         fi:
       fi:

  fi:



end:

#///////////////////////////////////////////////////////////
#
# grF_dispStr3
#
# 2nd Generation Display string. Allow greek indices to be
# pretty printed in Maple for Windows.
#
# Presently allows up to four indices. Needs fixing when
# spinors are included.
#
#///////////////////////////////////////////////////////////

grF_dispStr3 := proc(object, indices, define )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, iList, num, upList, dnList, indexType, rootStr, template, 
	tpl, List, idxRoot, idx, curUpRoot, curDnRoot, dnset:
global grOptionCoordNames, grOptionWindows, gr_data;

 #
 # is the index type implied by an operand ??
 #

 indexType := grG_ObjDef[object][grC_indexList]:

 rootStr := grG_ObjDef[object][grC_rootStr]:

 #
 # make refernce to a global (cheesy)
 #
 if grG_operands <> NULL then
   rootStr := convert( cat( rootStr,  
              convert([grG_operands], name)), name):
 fi:

 if indexType = [] then
 	RETURN(rootStr):
 fi:

 #
 # KLUDGE: for now treat cup and cdn as up and dn
 #
 # indexType := subs( cup=up, cdn=dn, grG_ObjDef[object][grC_indexList]):

 num := nops(indices):

 #
 # if coordinate names option, need to change list to be coord strings
 # if called by define want to use names in parm list as indices
 #
 if define then
  # called by define, so use abstract index names, not coords
  iList := indices:
  rootStr := op(0,object):

 else
   for a to nops(indices) do
	 #
	 # SPECIAL CASE: If x(up) then no coord names, only numbers
	 #
	 if grOptionCoordNames
            and not object = x(up)
            and not member ( indexType[a], {bup,bdn,cbup,cbdn,pbup,pbdn} )
            and grG_ObjDef[object][grC_objType] <> symSpinor
         then
	   iList[a] := gr_data[xup_,grG_metricName, indices[a] ]:
	 else
	   iList[a] := convert(indices[a], name):
	 fi:
   od:
 fi:
 #
 # LOTS of bogus raise null strings to powers etc. stuff
 # ahead to make Maple look like it does super/sub scripting
 #
 if not grOptionWindows then
   
   for a to 5 do
    if a <= num then
      if indexType[a] = up then
 	  upList[a] := ` ^`||(iList[a]):
      elif indexType[a] = dn then
 	  dnList[a] := ` `||(iList[a]):
      elif indexType[a] = pdn then
 	  dnList[a] := ` ,`||(iList[a]):
      elif indexType[a] = pup then
 	  upList[a] := ` ,^`||(iList[a]):
      elif indexType[a] = cdn then
 	  dnList[a] := ` ;`||(iList[a]):
      elif indexType[a] = cup then
 	  upList[a] := ` ;^`||(iList[a]):
      elif indexType[a] = bup then
 	  upList[a] := ` ^(`||(iList[a])||`)`:
      elif indexType[a] = bdn then
 	  dnList[a] := ` (`||(iList[a])||`)`:
      elif indexType[a] = cbup then
          upList[a] := ` ;(`||(iList[a])||`)`:
     elif indexType[a] = cbdn then
          dnList[a] := ` ;^(`||(iList[a])||`)`:
      elif indexType[a] = pbup then
          upList[a] := ` ,(`||(iList[a])||`)`:
      elif indexType[a] = pbdn then
          dnList[a] := ` ,^(`||(iList[a])||`)`:
      fi:
    fi:
  od:


   #  set up a number of templates
   template[num] := rootStr:
   for a to 5 do
      if assigned ( upList[a] ) then
         template[num] := ``||(template[num])||(upList[a]):
      fi:
      if assigned ( dnList[a] ) then
         template[num] := ``||(template[num])||(dnList[a]):
      fi:
   od:

 else
   #
   # for a windows environment we can take advantage
   # of array index display to get subscripts.
   #
   # Be careful with expressions since we want Greek to
   # appear as the symbols
   #
   idxRoot[1] := rootStr:

   curUpRoot := ``:
   curDnRoot := ``:
   if num > 1 then
     idxRoot[2] := ``:
     if member (indexType[2],{dn,cdn,pdn,bdn,cbdn,pbdn}) then
       dnset := {iList[2]}:
     else
       dnset := {}:
     fi:
   fi:

   for a from 3 to num do
     List[a] := ``:
     if member(indexType[a],{up,cup,pup,bup,cbup,pbup}) then
       idxRoot[a] := ``||(curUpRoot)||` `:
       curUpRoot := idxRoot[a]:
     else
       idxRoot[a] := ``||(curDnRoot)||` `:
       curDnRoot := idxRoot[a]:
     fi:
   od:

   for a to num do
       idx := iList[a]:
       if indexType[a] = up then
	  List[a] := idxRoot[a]^idx:
       elif indexType[a] = dn then
	  List[a] := idxRoot[a][idx]:
       elif indexType[a] = cdn then
	  List[a] := idxRoot[a][`;`*idx]:
       elif indexType[a] = cup then
	  List[a] := idxRoot[a][`;`]^idx:
       elif indexType[a] = pdn then
	  List[a] := idxRoot[a][`,`*idx]:
       elif indexType[a] = pup then
	  List[a] := idxRoot[a][`,`]^idx:
       elif indexType[a] = bup then
	  List[a] := idxRoot[a]^(``*idx):
       elif indexType[a] = bdn then
	  List[a] := idxRoot[a][`(`*idx*`)`]:
       elif indexType[a] = cbup then
          List[a] := idxRoot[a][`;`]^(``*idx):
       elif indexType[a] = cbdn then
          List[a] := idxRoot[a][`;(`*idx*`)`]:
       elif indexType[a] = pbup then
          List[a] := idxRoot[a][`,`]^(``*idx):
       elif indexType[a] = pbdn then
          List[a] := idxRoot[a][`,(`*idx*`)`]:
       fi:
# NOTE: The ordering of components in dispStr3 relies on maple's
#   multiplication to not change the order of terms in tpl. This can
#   result in bugs and should be changed. [dp 27Oct98]
       if a = 1 then
	 tpl := List[a];
       else
	 tpl := tpl*List[a];
       fi:
   od:
   template[num] := tpl; # this isn''t working yet (get ;x^2 for
			 # R(dn,dn,dn,dn,dn,cdn)
 fi:

 RETURN( template[num]):

end:



#-------------------------------------------------------------------
# grF_displaymetric.
#-------------------------------------------------------------------
grF_displaymetric := proc ( gname, gtype )
global	grG_metricName, Ndim:
local displayList;
	grG_metricName := gname:
	print ( `Default spacetime` = gname ):
	displayList := x(up):
	if gtype = grG_g or gtype = grG_ds then
		displayList := displayList, ds:
	elif gtype = grG_basis or gtype = grG_np then
		displayList := displayList, eta( bup, bup ):
		if Ndim[gname] = 4 then
			if grF_checkIfAssigned ( NPl(dn) ) then 
				displayList := displayList, nullt(dn):
			elif grF_checkIfAssigned ( w1(dn) ) then
				displayList := displayList, basisv(dn):
			elif grF_checkIfAssigned ( e(bdn,dn) ) then
				displayList := displayList, e(bdn,dn):
			fi:
			if grF_checkIfAssigned ( NPl(up) ) then
				displayList := displayList, nullt(up):
			elif grF_checkIfAssigned ( e1(up) ) then
				displayList := displayList, basisv(up):
			elif grF_checkIfAssigned ( e(bdn,up) ) then
				displayList := displayList, e(bdn,up):
			fi:
		else
			if grF_checkIfAssigned ( e(bdn,dn) ) then
				displayList := displayList, e(bdn,dn):
			fi:
			if grF_checkIfAssigned ( e(bdn,up) ) then
				displayList := displayList, e(bdn,up):
			fi:
		fi:
	fi:
	grdisplay ( displayList ):
	if assigned ( gr_data[contraint_,gname] ) then
		print ( Constraints = gr_data[constraint_,gname] ):
	fi:
	if assigned ( complexSet_ ) and complexSet_<>{} then
		print ( `Complex quantities` = complexSet_ ):
	fi:
	if assigned ( gr_data[Text_,gname] ) then
		print ( gr_data[Text_,gname]
		 ):
	fi:
end:

#-------------------------------------------------------------------
# grF_displayHeaders.
#-------------------------------------------------------------------
grF_displayHeaders := proc ( objectName )
global	grG_lastHeader:
local	a, header, opset:
	header := grG_ObjDef[objectName][grC_header]:
	# only print metric name for fist object in a list.
	if grG_lastHeader = NULL then
		print(`For the `||grG_metricName||` spacetime:`):
	fi:
	# prevent repeat headers (for aliased objects, such as basis(dn))
	if header<>grG_lastHeader then
		print ( header ):
	fi:
	grG_lastHeader := header:
	# print operands, if there are any.
#	if assigned( grG_ObjDef[objectName][grC_operandSeq]) then
#		opset := {}:
#		for a in grG_ObjDef[objectName][grC_operandSeq] do
#			opset := opset union { grG_.a }:
#		od:
#		print ( `with operands: `.opset ):
#	fi:
end:

#-------------------------------------------------------------------
# grF_slickdisplay.
# If this 1 or 2 index object can be displayed as a vector or
# matric, then do so.
#
# Then return a null fn code to core so it does not do per-component
# display.
#-------------------------------------------------------------------
grF_slickdisplay := proc ( objectName )
global	grG_fnCode, grG_displayZero:
local	indnbr, toobig, fnCode:
	fnCode := grC_DISP:
	indnbr := nops ( objectName ):
	print ( objectName ):
	if indnbr = 1 or indnbr = 2 then
		grG_displayZero := grF_checkzero ( objectName ):
		if grG_displayZero = false then
			toobig := grF_testrowsize ( objectName ):
			if not toobig and not grG_displayZero then
				if indnbr = 1 then
					grF_displayvector ( objectName ):
				else
					grF_displaymatrix ( objectName ):
				fi:
				fnCode := grC_tmpNoDISP:
			fi:
		fi:
	fi:
RETURN ( fnCode ):
end:

#-------------------------------------------------------------------
# grF_checkzero
#-------------------------------------------------------------------
grF_checkzero := proc ( objectName )
global Ndim:
local	a, b, gname, Object, opList, displayZero:
	displayZero := true:
	gname := grG_metricName:
	Object := grG_ObjDef[objectName][grC_root]:
        opList := grF_checkOperands ( objectName ):
	if nops ( objectName ) = 1 then
		for a to Ndim[gname] while displayZero = true do
			if gr_data[Object,gname,opList,a]<>0 then
				displayZero := false:
			fi:
		od:
	else
		for a to Ndim[gname] while displayZero = true do
			for b to Ndim[gname] while displayZero = true do
				if gr_data[Object,gname,opList,a,b]<>0 then
					displayZero := false:
				fi:
			od:
		od:
	fi:
RETURN ( displayZero ):
end:

#-------------------------------------------------------------------
# grF_testrowsize.
#-------------------------------------------------------------------
grF_testrowsize := proc ( objectName )
local	a, b, gname, Object, maxsize, rowsize, tmprowsize, toobig:
global grOptionTermSize, gr_data, Ndim;
	gname := grG_metricName:
	Object := grG_ObjDef[objectName][grC_root]:
	maxsize := grOptionTermSize*Ndim[gname]:
	if nops ( objectName ) = 1 then
		rowsize := 0:
		for a to Ndim[gname] while rowsize < maxsize do
			rowsize := rowsize + length ( gr_data[Object,gname,a] ):
		od:
	else
		rowsize := 0:
		for a to Ndim[gname] while rowsize < maxsize do
			tmprowsize := 0:
			for b to Ndim[gname] while tmprowsize < maxsize do
				tmprowsize := tmprowsize + length ( gr_data[Object,gname,a,b] ):
			od:
			if tmprowsize > rowsize then	
				rowsize := tmprowsize:
			fi:
		od:
	fi:
	if rowsize < maxsize then
		toobig := false
	else
		toobig := true:
	fi:
RETURN ( toobig ):
end:

#-------------------------------------------------------------------
# grF_displayvector.
#-------------------------------------------------------------------
grF_displayvector := proc ( objectName )
local	a, gname, Object, vec, opList, dispObj:
global gr_data, Ndim:
	
	gname := grG_metricName:
	Object := grG_ObjDef[objectName][grC_root]:
	vec := array ( 1.. Ndim[gname] ):
	opList := gname:
	if assigned ( grG_ObjDef[objectName][grC_operandSeq]) then
		opList := opList,grG_||(grG_ObjDef[objectName][grC_operandSeq]):
	fi:
	for a to Ndim[gname] do
		vec[a] := gr_data[Object,opList,a]:
	od:
	dispObj := grF_symbTensorName ( objectName ):
	print ( dispObj = eval ( vec ) ):
end:

#-------------------------------------------------------------------
# grF_displaymatrix.
#-------------------------------------------------------------------
grF_displaymatrix := proc ( objectName )
global Ndim:
local	a, b, gname, Object, mat, opList, dispObj:
	gname := grG_metricName:
	Object := grG_ObjDef[objectName][grC_root]:
	mat := array ( 1.. Ndim[gname], 1.. Ndim[gname] ):
	opList := gname:
	if assigned ( grG_ObjDef[objectName][grC_operandSeq]) then
		opList := opList,grG_||(grG_ObjDef[objectName][grC_operandSeq]):
	fi:
	for a to Ndim[gname] do
		for b to Ndim[gname] do
			mat[a,b] := gr_data[Object,opList,a,b]:
		od:
	od:
	dispObj := grF_symbTensorName ( objectName ):
	print ( dispObj = eval ( mat ) ):
end:

#-------------------------------------------------------------------
# grF_symbTensorName
#-------------------------------------------------------------------
grF_symbTensorName := proc ( objectName )
local	rootStr, indexType1, indexType2, idx1, idx2, pos1, pos2,
	dispObj, idxnbr, a, b:
	rootStr := grG_ObjDef[objectName][grC_rootStr]:
	idxnbr := nops ( grG_ObjDef[objectName][grC_indexList] ):
	indexType1 := grG_ObjDef[objectName][grC_indexList][1]:
	idx1 := grF_setindexstr ( indexType1, a ):
	pos1 := grF_setindexpos ( indexType1 ):
	if idxnbr = 1 then
		if pos1 = up then
			dispObj := rootStr^idx1:
		else
			dispObj := rootStr[idx1]:
		fi:
	elif idxnbr = 2 then
		indexType2 := grG_ObjDef[objectName][grC_indexList][2]:
		idx2 := grF_setindexstr ( indexType2, b ):
		pos2 := grF_setindexpos ( indexType2 ):
		if pos1 = up and pos2 = up then
			dispObj := rootStr^idx1*``^idx2:
		elif pos1 = up and pos2 = dn then
			dispObj := rootStr^idx1*``[idx2]:
		elif pos1 = dn and pos2 = up then
			dispObj := rootStr[idx1]^idx2:
		else
			dispObj := rootStr[idx1]*``[idx2]:
		fi:
	else
		ERROR ( `symbTensorName name only accepts 1 or 2 indices` ):
	fi:
	RETURN ( dispObj ):
end:

#-------------------------------------------------------------------
# grF_setindexstr.
#-------------------------------------------------------------------
grF_setindexstr := proc ( indextype, idx )
	if   indextype = up or indextype = dn then
		RETURN ( idx ):
	elif indextype = pup or indextype = pdn then
		RETURN ( cat(`,`,idx) ):
	elif indextype = cup or indextype = cdn then
		RETURN ( cat(`;`,idx) ):
	elif indextype = bup or indextype = bdn then
		RETURN ( cat(`(`,idx,`)` ) ):
        elif indextype = cbup or indextype = cbdn then
                RETURN ( cat(`;(`,idx,`)`) ):
        elif indextype = pbup or indextype = pbdn then
                RETURN ( cat(`,(`,idx,`)`) ):
	else
		ERROR ( `Could not determine index type.` ):
	fi:
end:

#-------------------------------------------------------------------
# grF_setindexpos.
#-------------------------------------------------------------------
grF_setindexpos := proc ( indextype )
local	upset, dnset:
	upset := { up, pup, cup, bup, cbup, pbup }:
	dnset := { dn, pdn, cdn, bdn, cbdn, pbdn }:
	if member ( indextype, upset ) then
		RETURN(up):
	elif member ( indextype, dnset ) then
		RETURN(dn):
	else
		ERROR ( `Could not determine index position` ):
	fi:
end:

#-------------------------------------------------------------------
# grF_checkOperands.
#-------------------------------------------------------------------
grF_checkOperands := proc ( objectName )
local	a, Operands:
	Operands := NULL:
	if assigned ( grG_ObjDef[objectName][grC_operandSeq] ) then
		for a in grG_ObjDef[objectName][grC_operandSeq] do
			Operands := Operands, grG_||a:
		od:
	fi:
RETURN ( Operands ):
end:

#==============================================================================





