#================================================================-*-Maple-*-==
# grdef
#
# A modified form of grdefine to automatically construct optimized symmetry
# routines based on a symmetry list which can be specified by brackets among
# the indices on the left-hand side of a tensor equation.
#
# Routines for handling the right-hand side of the tensor equation are
# those used by grdefine().
#
# Created by: Denis Pollney
# Date:       21 September 1995
#
# Modifications:
# ---------------------------------------------------------------------------
# 19 Oct 1995	Added reading of syms from lhs of tensor definition. [dp]
# 27 Mar 1996   Fixed bug in initialization of anti-symmetric objects. [dp]
#  3 Apr 1996   Fixed indexing bug for symmetric loops. [dp]
# 21 May 1996	Fixed bug in initialization of anti-symmetric objects. [dp]
# 11 Jun 1996	Fixed support for defining equation-type objects. [dp]
#  8 Jul 1996   Moved anti-symmetry init loop to main calc loop. [dp]
# 11 Jul 1996	Fixed initialization of freeIndexSeq for scalars. [dp]
# 29 Jul 1996	Fixed passing of index list to calc function. [dp]
# 20 Aug 1996	Added symfn= argument to grdef(). [dp]
# 11 Mar 1997	Add explicit RETURN(NULL) to generated symFn. [dp]
#  4 Nov 1997	Ensured that assigned grG_metricName is not entered in
#                 calc function. [dp]
# 14 Feb 1997   Switch convert(x,string) to convert(x,name) for R5 [dp]
# 14 Feb 1997	Fixed parse of scalars on LHS of grdef expr [dp]
# 24 Feb 1997	Cleaned up unassign and reassign of metrics [dp]
# 18 Oct 1998	Added grC_defineStr, grC_symmList, grC_grdefArgs to
#               the grG_ObjDef parameters, for sake of grsavedef, loaddef [dp]
# 20 Nov 1998   Fixed loop ranges in create_symFn which were being assigned
#               based on a fixed number of dimensions due to 24Feb97 [dp]
# 27 Jul 1999   Newly defined tensor names are added to grG_usedNameSet [dp]
#  9 Sep 1999   Added check to see if procmake has already been loaded [dp]
#
#============================================================================

# define used in debugging
#$define DEBUG option trace;
$define DEBUG 

#----------------------------------------------------------------------------
# grdef
#----------------------------------------------------------------------------

grdef := proc ( )
local a, defineStr, symSet, asymSet, subRanges, eqPos, tensorName, tensorDef,
	symList, newTensor, newTensorDef, symFn, grdefArgs:
global grG_default_metricName;
DEBUG
# Check the command-line arguments:

uses StringTools;

if nargs < 1 then
		ERROR ( `grdef() requires at least one argument.` ):
fi:

defineStr := args[1]:
grdefArgs := [args]:
symSet := {}:
asymSet := {}:
symFn := {}:
subRanges := {}:

for a from 2 to nargs do
	if type ( args[a], equation ) then
		if lhs(args[a]) = sym then
			if type ( rhs(args[a]), set ) then
				symSet := rhs(args[a]):
			else
				ERROR ( `Symmetries must be specified as a set, eg. sym={[1,3]}.` ):
			fi:
		elif lhs(args[a]) = asym then
			if type ( rhs(args[a]), set ) then
				asymSet := rhs(args[a]):
			else
				ERROR ( `Symmetries must be specified as a set, eg. asym={[1,3]}.` ):
			fi:
		elif lhs(args[a]) = restrict then
			if type ( rhs(args[a]), set ) then
				subRanges := rhs(args[a]):
			else
				ERROR ( 
					`Restricted index ranges must be specified as a set, eg. restrict={c=1..3}.`):
			fi:
		elif lhs(args[a]) = symfn then
			if assigned ( grG_ObjDef[rhs(args[a])][grC_symmetry] ) then
				symFn := rhs(args[a]):
			else
				ERROR ( `The symmetry function must be specified using the name of a pre-defined object, eg. symfn=R(dn,dn,dn,dn).` ):
			fi:
		fi:
	fi:
od:

# old style back-quote definitions convert to string
if type( defineStr, symbol) then
	 defineStr := convert( defineStr, string): 
fi:

if type ( defineStr, string ) then
		defineStr := StringTools:-Squeeze(defineStr);
		eqPos := searchtext ( `:=`, defineStr ):
		if eqPos > 0 then
				tensorName := substring ( defineStr, 1..eqPos-1 ):
				tensorName := StringTools:-Trim(tensorName);
				tensorDef  := substring ( defineStr, eqPos+2..length(defineStr) ):
				tensorDef := StringTools:-Trim(tensorDef):
		else 
				tensorName := defineStr:
		fi:
		symList := grF_determineIndexSymmetries ( tensorName ):
		tensorName := grF_extractSymmetries ( tensorName ):
		newTensor := grF_strToDef ( tensorName, true ):
else
		ERROR ( `First argument must be of type string.` ):
fi:

if assigned ( tensorDef ) then
		newTensorDef := grF_strToDef ( tensorDef, false ):
else
		newTensorDef := nodef:
fi:

if assigned ( symList ) then
		symSet := symSet union symList[1]:
		asymSet:= asymSet union symList[2]:
fi:
if type ( newTensorDef, list ) then
		 if not assigned(grG_default_metricName) then
				ERROR(`Load a metric first.`);
		 fi:
fi:

grF_verifyDefIndices (newTensor, newTensorDef):

grF_grdef ( newTensor, newTensorDef, symSet, asymSet, subRanges,
	symFn, defineStr, grdefArgs )
end:

#------------------------------------------------------------------------------
# grF_grdef
#------------------------------------------------------------------------------
grF_grdef := proc ( newTensor, newTensorDef, symSet, asymSet, subRanges, symfn,
	defineStr, grdefArgs)
DEBUG
global	grG_parseAuxMetrics, grF_DIFF, grF_INT, grG_Object, grG_metricName,
	grF_symFn_, grG_rootSet, grG_ObjDef, grG_usedNameSet, gr_data:
local	b, i, newObject, indexList, newRoot, newObj, newISeq, subList,
	freeIndexNbr, obj_lhs, obj_rhs, name_lhs, name_rhs:

	if nops(newTensor) > 1 then
		#
		# got back a tensor
		#
		if nops(op(2,newTensor)) > 0 then
			newObject := op(1,newTensor)( op( op( 2,newTensor) ) ):
			indexList := op(3, newTensor):
		else
			newObject := op(1,newTensor):
			indexList := []:
		fi:
	else
		newObject := newTensor:
		indexList := []:
	fi:

	# find symmetries specified in the new tensor's indices

	# do this so that assignments work properly
	grF_unassignLoopVars():
	grF_unassignMetricNames():
	grG_parseAuxMetrics := {}:
	#
	# diff presents a problem with evaluation at the wrong time, so
	# use our own dummy function DIFF which we turn off during
	# definitions
	#
	grF_DIFF := 'grF_DIFF':
	grF_INT := 'grF_INT':

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	# Step 1:
	# first get the listing indices
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#
	# new object could be either a tensor or scalar
	#
	if type(newTensor, function) then
		newRoot := op(1,newTensor);
		if nops(op(2,newTensor)) > 0 then
			newObj := op(1,newTensor)( op( op(2,newTensor))):
			newISeq := op( op(2,newTensor)); # get a seq of e.g: u,d,d
		else
			newObj := op(1,newTensor):
			newISeq := NULL:
		fi:
	else
		newRoot := newObject;
		newObj := newObject:
		newISeq := NULL:
	fi:
	#
	# Could we create this object automatically ?? If so do it.
	# 
	if not (traperror(grF_checkIfDefined(newObj, check)) = lasterror) then
		printf(`This object is already defined. The new definition has been ignored.\n`);
				 RETURN():
	fi:

	#
	# build a list of equations which can substitute the
	# standard listing indices used by core (a1_, a2_ etc.) for the
	# arbitrary user indices. (e.g. alpha = a1_ etc.)
	# Important to assign them in order because
	# the symmetries imposed must match the permList.
	#
	subList := [];
	for b to nops(indexList) do
	 subList := [op(subList), indexList[b] = a||b||_ ];
	od:
	#
	# FILL IN THE REST OF THE DEFINITION
	#
	grG_ObjDef[newObj][grC_attributes] := {user_defined_}:
	grG_ObjDef[newObj][grC_header] := convert(newObj,name):
	grG_ObjDef[newObj][grC_root] := cat(newRoot,newISeq,_);
	grG_ObjDef[newObj][grC_rootStr] := convert(newRoot, name):
	grG_ObjDef[newObj][grC_indexList] := [newISeq]:
	grG_ObjDef[newObj][grC_defineStr] := defineStr:
	grG_ObjDef[newObj][grC_symList] := [symSet, asymSet]:
	grG_ObjDef[newObj][grC_grdefArgs] := grdefArgs:

	#+++++++++++++++++++++++++++++++++++++++++++++++++++
	# Step 2: Examine expression
	#+++++++++++++++++++++++++++++++++++++++++++++++++++
	# is the formula an equation, or a basic object ??
	freeIndexNbr := nops ( [ newISeq ] ):

	if newTensorDef = nodef then
		# basic object, user will provide components
		grG_ObjDef[newObj][grC_preCalcFn] := grF_preEnterComp:
		grG_ObjDef[newObj][grC_calcFn] := grF_enterComp:
		grG_ObjDef[newObj][grC_depends] := {}:

	elif type( newTensorDef, list) then
		 #
		 # for vectors, allow the third argument to be the
		 # component values of the vector for the default
		 # metric
		 #
		 if freeIndexNbr > 1 then
				ERROR(`Only direct definition of vectors is allowed at present.`);
		 fi:
		 grG_ObjDef[newObj][grC_preCalcFn] := grF_preEnterComp:
		 grG_ObjDef[newObj][grC_calcFn] := grF_enterComp:
		 grG_ObjDef[newObj][grC_depends] := {}:  
		 #
		 # assign the components
		 #
		 grG_metricName := grG_default_metricName:
		 if nops(newTensorDef) <> Ndim[grG_metricName] then
				ERROR(`Dimension of default metric and number of components are not equal`);
		 fi:
		 for b to nops(newTensorDef) do
				gr_data[cat(newRoot,newISeq,_),grG_default_metricName,b] := newTensorDef[b]:
		 od:
		 grF_assignedFlag( newObj, set); # indicate this object has been calc'd
		 printf(`Components assigned for metric: %a\n`,grG_metricName);
	
	elif type( newTensorDef, equation) then
			#
			# object is an equation. grdefine() the lhs and rhs seperatly
			# (since they may involve different numbers of summations)
			#
			# can we get into trouble with out of order indices ??
			# No, because subList refers to them by name.
			#

			b := NULL:
			b := seq( a||i||_, i=1..nops(indexList) );

			obj_lhs := subs( newRoot = lhs_||newRoot, newTensor):
			obj_rhs := subs( newRoot = rhs_||newRoot, newTensor):

			name_lhs := subs( newRoot = lhs_||newRoot, newObject):
			name_rhs := subs( newRoot = rhs_||newRoot, newObject):
			
			# last two params are hacked in - may break savedef/loaddef (does anyone use those?)
			grF_grdef ( obj_lhs, lhs(newTensorDef), symSet, asymSet, subRanges, symfn, lhs(newTensorDef), [] );
			grF_grdef ( obj_rhs, rhs(newTensorDef), symSet, asymSet, subRanges, symfn, rhs(newTensorDef), [] );

			grG_ObjDef[newObj][grC_calcFn] := grF_calc_scalar:
			grG_ObjDef[newObj][grC_calcFnParms] :=
				 gr_data[(grG_ObjDef[name_lhs][grC_root]),grG_metricName,b]
				 = gr_data[(grG_ObjDef[name_rhs][grC_root]),grG_metricName,b]:
			grG_ObjDef[newObj][grC_depends] := {name_lhs, name_rhs}:

	else
			#+++++++++++++++++++++++++++++++++++++++++++++++++++++
			#
			# THE GUTS!
			# have some expression we must build a procedure for. This
			# next statement builds the required calcFn and adds the
			# necessary terms to the depends list
			#
			#+++++++++++++++++++++++++++++++++++++++++++++++++++++
			grF_calc_||newRoot||op(newISeq) :=
				grF_buildCalcFn(newTensorDef, newObj, indexList, subList, subRanges):
			grG_ObjDef[newObj][grC_calcFn] := grF_calc_||newRoot||op(newISeq):
	fi:

 if grG_parseAuxMetrics <> {} then
	 grG_ObjDef[newObj][grC_auxMetrics] := grG_parseAuxMetrics:
 fi:

if symfn = {} then
	if not type ( symSet, set ) or not type ( asymSet, set ) then
		ERROR ( `Symmetries must be specified as a set.` ):
	fi:

	if not assigned ( grF_symFn_[freeIndexNbr,symSet,asymSet] ) then
		grF_symFn_[freeIndexNbr,symSet,asymSet] := 
			grF_create_symFn ( freeIndexNbr, symSet, asymSet ):
	fi:
	grG_ObjDef[newObj][grC_symmetry] := grF_symFn_[freeIndexNbr,symSet,asymSet]:
else
	grG_ObjDef[newObj][grC_symmetry] := grG_ObjDef[symfn][grC_symmetry]:
fi:

 #
 # add to the root set (so we can raise & lower its indices automagically)
 #
 if newISeq = NULL then
	 grG_rootSet := grG_rootSet union {cat(grG_,newRoot)}:
 else
	 grG_rootSet := grG_rootSet union {cat(grG_,newRoot,_,freeIndexNbr)}:
 fi:

	if type (newObj, function) then
		grG_usedNameSet := grG_usedNameSet union {op(0,newObj)}:
	else
		grG_usedNameSet := grG_usedNameSet union {newObj}:
	fi:

 printf(`Created definition for %a\n` ,newObj);
 #
 # turn on grF_DIFF
 #
 grF_DIFF := diff:
 grF_INT := int:

 if not assigned ( grG_metricName ) then
	 grF_reassignMetrics():
 fi:

 NULL;

end:

#----------------------------------------------------------------------------
# create_symFn
# Given symmetry/asymmetry lists of the form [1,2,...,n], this function
# writes the corresponding symmetry function.
#----------------------------------------------------------------------------

grF_create_symFn := proc ( freeIndexNbr, symSet, asymSet )
#option trace;
local a, i, j, k, l, symFn, freeIndexSeq, symIndexSeq, symIndices, asymIndices,
		loopNbr, found, asymNbr, replaceSeq, permNbr, sym1, sym2, perm1, perm2,
		sym, loopParms, permList, lastLoopIndex, permsign1, permsign2,
		stdIndexList, initLoop, initLoopParms, initStmt, fullSymList,
		symCoreLoop, asymIndexSeq, replaceSet, initLoopNbr, zeroCond, initLoops,
		idxList, idxSign, zeros, xrefs, idxInfo, metricName:

global grG_calc, grG_operands, grG_metricName:

grG_calc := 'grG_calc':
grG_operands := 'grG_operands':
metricName := grG_metricName:
grG_metricName := 'grG_metricName':

symIndices := {}:
asymIndices := {}:
loopNbr := 1:

fullSymList := [op(symSet union asymSet)]:
idxInfo := grF_getIdxInfo (freeIndexNbr, symSet, asymSet):

idxList := idxInfo[1]:
idxSign := idxInfo[2]:

#
# Choose names for summation variables, a1_, a2_, ...:
#
if freeIndexNbr > 0 then
	freeIndexSeq := a1_:
	for i from 2 to freeIndexNbr do
		freeIndexSeq := freeIndexSeq, a||i||_;
	od:
else
	freeIndexSeq := NULL:
fi:

#
# Heart of the symmetry routine, calls the calc function and assigns to
# tensor standard component [a1_,a2_,a3_,...]:
#
#symFn := `&:=`( 'gr_data'[
#	`&expseq`(`&args`[2],'grG_metricName','grG_operands',freeIndexSeq)], 
#	`&function`(`&args`[3], `&expseq`(`&args`[1], [freeIndexSeq] ) ) ):
# Inert form of gr_data[symSet, grG_metricName, grG_operands, freeIndexSeq] := 
freeIndexSeqInert := NULL;
for a in freeIndexSeq do
	freeIndexSeqInert := freeIndexSeqInert, ToInert(a):
od:
symFn := _Inert_STATSEQ(
		  _Inert_ASSIGN(             
				ToInert(gr_data[ root, grG_metricName, grG_operands, freeIndexSeq]),
				ToInert(calcFn(objectName, [freeIndexSeq]))
		  )
		);

#printf("line 432\n");
#x0 := FromInert(symFn);

xrefs := NULL:
zeros := NULL:
for a to nops ( idxList ) do
	symIndexSeq := op ( grF_createIdxNameList ( idxList[a] ) ):
	if symIndexSeq <> freeIndexSeq then
	symIndexSeqInert := NULL:
	for b in symIndexSeqInert do
		symIndexSeqInert := symIndexSeqInert, ToInert(b):
	od:
#		xrefs := `&:=`(
#			'gr_data'[
#			`&expseq`(`&args`[2],'grG_metricName','grG_operands', symIndexSeq)], 
#			idxSign[a]*'gr_data'[
#			`&expseq`(`&args`[2],'grG_metricName', 'grG_operands', freeIndexSeq)] ),
#			xrefs:
		xrefs := _Inert_ASSIGN(             
					_Inert_TABLEREF(
						_Inert_NAME("gr_data"), 
						_Inert_EXPSEQ( _Inert_NAME("root"),
										_Inert_NAME("grG_metricName"), 
										_Inert_NAME("grG_operands"), 
										symIndexSeqInert
									)
					),
						_Inert_PROD(
							ToInert(idxSign[a]),
							_Inert_TABLEREF(
								_Inert_NAME("gr_data"), 
								_Inert_EXPSEQ( _Inert_NAME("root"),
												_Inert_NAME("grG_metricName"), 
												_Inert_NAME("grG_operands"), 
												freeIndexSeqInert
											)
							)
						)
				), xrefs;

#		zeros := `&:=`(
#			'gr_data'[
#			`&expseq`(`&args`[2],'grG_metricName','grG_operands', symIndexSeq)],
#			0 ),
#			zeros:
		zeros := _Inert_ASSIGN(             
					_Inert_TABLEREF(
						_Inert_NAME("gr_data"), 
						_Inert_EXPSEQ( _Inert_NAME("root"),
										_Inert_NAME("grG_metricName"), 
										_Inert_NAME("grG_operands"), 
										symIndexSeqInert
									)
					),
					ToInert(0)
				), zeros:
	fi:
od:

#
# If there are anti-symmetries, then if any of the anti-symmetric indices
# are equal the coefficient is set to zero rather than calling the calc
# function.
#
if asymSet <> {} then
	asymNbr := 0:
	for i in asymSet do
		asymNbr := asymNbr + 1:
		replaceSet[asymNbr] := {}:
		for j to nops ( i ) do
			replaceSet[asymNbr] := replaceSet[asymNbr] union 
				{ a||(op(j,[op(i)]))||_ }:
		od:
	od:

#	zeroCond[1] := `&function`(nops, `&expseq`( replaceSet[1] ) ) 
#		< nops(replaceSet[1]):
	zeroCond[1] := _Inert_LESSTHAN(_Inert_FUNCTION(_Inert_NAME("nops"), _Inert_EXPSEQ(replaceSet[1])),  
						ToInert(nops(replaceSet[1])) 
					):
	for i from 2 to asymNbr do
#		zeroCond[i] := zeroCond[i-1] or 
#			`&function`(nops, `&expseq`( replaceSet[i] ) ) < nops(replaceSet[i]):
		zeroCond[i] := _Inert_OR( zeroCond[i-1],  
							_Inert_LESSTHAN(_Inert_FUNCTION(_Inert_NAME("nops"), _Inert_EXPSEQ(replaceSet[i])),  
								ToInert(nops(replaceSet[i])) 
							)
					):	
	od:

#	symFn := `&if`( zeroCond[asymNbr],
#		`&statseq`(zeros,`&:=`('gr_data'
#		[`&expseq`(`&args`[2],'grG_metricName','grG_operands',freeIndexSeq)], 0 ) ),
#		`&statseq`( xrefs, symFn ) ):
	symFn := _Inert_IF( 
		_Inert_CONDPAIR(zeroCond[asymNbr]),
		_Inert_STATSEQ(_InertASSIGN(					
						_Inert_TABLEREF(
							_Inert_NAME("gr_data"), 
							_Inert_EXPSEQ( _Inert_NAME("root"),
								_Inert_NAME("grG_metricName"), 
								_Inert_NAME("grG_operands"), 
								freeIndexSeqInert
						)
					),
					ToInert(0)
				)
		)
	);
else
#	symFn := `&statseq`( xrefs, symFn ):
	symFn := _Inert_STATSEQ( xrefs, symFn):
fi:

#printf("line 550\n");
#x1 := FromInert(symFn);

#
# Set up loop parameters ( loopParms[i] = loop-variable, `from'-value )
# for each index in the specified symmetry. The loopParms list will
# be used later to write the loops into the sym-function. Note that
# if the value `-1' is used as `from'-value if the loop is to start
# from the number 1 [this is needed because `1' in the `from'-value spot
# is used to indicate `start from index variable 1'.
#
for sym in fullSymList do
	lastLoopIndex := -1:
	for i in { op( sym ) } do
		if not member ( i, symIndices union asymIndices ) then
			loopParms[loopNbr] := i, lastLoopIndex:
			loopNbr := loopNbr + 1:
			lastLoopIndex := i:
			if member ( sym, symSet ) then
				symIndices := symIndices union { i }:
			else
				asymIndices := asymIndices union { i }:
			fi:
		fi:
	od:
od:

loopNbr := loopNbr - 1:
symFn := grF_setUpDoLoops ( symFn, freeIndexNbr, symIndices, 
	asymIndices, loopParms, loopNbr, false ):

#printf("Loops\n");
#x1 := FromInert(_Inert_STATSEQ(symFn));

#
# add `if grG_calc and assigned ( calcFn )` 
#
#symFn := `&if`(  grG_calc and `&function`(assigned,`&expseq`(`&args`[3])), 
#				`&statseq`( symFn ) ):

symFn :=_Inert_STATSEQ( 
		  _Inert_IF(
			_Inert_CONDPAIR( 
				_Inert_AND( 
					_Inert_NAME("grG_calc"), 
					_Inert_FUNCTION(_Inert_ASSIGNEDNAME("assigned", "PROC", _Inert_ATTRIBUTE(_Inert_NAME("protected", 
						_Inert_ATTRIBUTE(_Inert_NAME("protected"))))), _Inert_EXPSEQ(_Inert_NAME("calcFn")))
				),
				_Inert_STATSEQ(symFn)
			)
		  )
		);

x2 := FromInert(symFn);

#
# add a loop which calls grF_symCore:
#
#symCoreLoop := grF_setUpDoLoops (
#		`&function`(grF_symCore, `&expseq`(`&args`[1],[freeIndexSeq],`&args`[2])),
#		freeIndexNbr, symIndices, asymIndices, loopParms, loopNbr, true ):

#
# Had a hard time getting a direct reference to grF_symCore to evaluate. Tried lots of things, but
# as a work around decided to pass as a param, since calcFn does that and it works
# Ugh! pm - Sept 2018

symCoreLoop := grF_setUpDoLoops (
				_Inert_STATSEQ(
					ToInert(coreFn(objectName, [freeIndexSeq], root))
#					_Inert_FUNCTION(_Inert_ASSIGNEDNAME("grF_symCore", "PROC"), 
#						_Inert_EXPSEQ( _Inert_NAME("objectName"), ToInert([freeIndexSeq]), _Inert_NAME("root"))
#					)
				),
				freeIndexNbr, symIndices, asymIndices, loopParms, loopNbr, true ):


x3 := FromInert(symCoreLoop);

#symFn := `&statseq`( symFn, symCoreLoop, `&function`(RETURN,`&expseq`()) ):
# change - leave return as implicit

# symmetry function must return null, 

symFn := _Inert_STATSEQ( symFn, symCoreLoop, _Inert_RETURN(_Inert_NAME("NULL")));

  procFn := _Inert_PROC(
    _Inert_PARAMSEQ(_Inert_NAME("objectName"), _Inert_NAME("root"), _Inert_NAME("calcFn"), _Inert_NAME("coreFn")),
    _Inert_LOCALSEQ(),
    _Inert_OPTIONSEQ(), 
#    _Inert_OPTIONSEQ(_Inert_NAME("trace")), 
    _Inert_EXPSEQ(), 
    _Inert_STATSEQ(symFn),
    _Inert_DESCRIPTIONSEQ(), 
    _Inert_GLOBALSEQ(_Inert_NAME("grF_symCore")), # define globals? Or rely on scoping 
    _Inert_LEXICALSEQ(), 
    _Inert_EOP(_Inert_EXPSEQ())
  );
  procActive := FromInert(procFn):
  grG_metricName := metricName:
  RETURN (procActive);

end:

#---------------------------------------------------------------------------
# createIdxNameList
#---------------------------------------------------------------------------

grF_createIdxNameList := proc ( idxList )
local	i, idxNameList:
idxNameList := []:
for i in idxList do
	idxNameList := [ op ( idxNameList ), a||i||_ ]
od:
RETURN ( idxNameList ):
end:

#------------------------------------------------------------------------------
# setUpDoLoops
#------------------------------------------------------------------------------

grF_setUpDoLoops := proc ( loopStmts, freeIndexNbr, symIndices, asymIndices, 
	loopParms, loopNbr, asymmetrize )
local i, symFn, fromval, loopVar:
#option trace; 
# Set up the do-loops for indices not involved in any symmetrizations:

symFn := loopStmts:
for i to freeIndexNbr do
		if not member ( i, symIndices union asymIndices ) then
			#symFn := `&for`( a||i||_, 1, 1, Ndim['grG_metricName'], true, `&statseq`(symFn) ):
			loopVar := cat("a",i,"_");
			symFn := grF_inertFor(loopVar, _Inert_INTPOS(1),_Inert_STATSEQ(symFn));
#			printf("loops0\n");
#			x1 := FromInert(symFn);
		fi:
od:
#printf("loops1\n");
#x1 := FromInert(symFn);

# Set up the do-loops for symmetrized indices using the loopParms list:
for i from loopNbr to 1 by -1 do
		if member ( loopParms[i][1], symIndices ) or 
			( member ( loopParms[i][1], asymIndices ) and not asymmetrize ) then
				if loopParms[i][2] = -1 then
#						symFn := `&for`( a||(loopParms[i][1])||_, 1, 1, Ndim['grG_metricName'],
#								true, `&statseq`(symFn) ):
						loopVar := cat("a",loopParms[i][1],"_");
						symFn := grF_inertFor(loopVar, _Inert_INTPOS(1), _Inert_STATSEQ(symFn));

				else
#						symFn := `&for`( a||(loopParms[i][1])||_, a||(loopParms[i][2])||_, 1,
#								Ndim['grG_metricName'], true, `&statseq`(symFn) ):
						loopVar := cat("a",loopParms[i][1],"_");
						fromVar := cat("a",loopParms[i][2],"_");
						symFn := grF_inertFor(loopVar, _Inert_NAME(fromVar), _Inert_STATSEQ(symFn));
				fi:
		else
				if loopParms[i][2] = -1 and asymmetrize then
						fromval := 1:
				else
						fromval := a||(loopParms[i][2])||_ + 1:
				fi:
#				symFn := `&for`( a||(loopParms[i][1])||_, fromval, 1,
#						Ndim['grG_metricName'], true, `&statseq`(symFn) ):
						loopVar := cat("a",loopParms[i][1],"_");
						symFn := grF_inertFor(loopVar, _Inert_NAME(fromVal), _Inert_STATSEQ(symFn));
#		printf("loops2\n");
#		x1 := FromInert(symFn);
		fi:
od:

RETURN ( symFn ):
end:

#------------------------------------------------------------------------------
# replaceListElement
#------------------------------------------------------------------------------

grF_replaceListElement := proc ( ilist, oldelement, newelement )
local i, newseq:

if ilist[1] = oldelement then
		newseq := newelement:
else
		newseq := ilist[1]:
fi:
for i from 2 to nops ( ilist ) do
		if ilist[i] = oldelement then
				newseq := newseq, newelement:
		else
				newseq := newseq, ilist[i]:
		fi:
od:

RETURN ( [ newseq ] ):
end:

#------------------------------------------------------------------------------
# appendToPermSeq
#------------------------------------------------------------------------------
grF_appendToPermSeq := proc ( permList, appendList )
local	a, b, appendPerms, newAppendList, newList, nextList:

# new permutations to append to the permList
appendPerms := combinat[permute] ( appendList[1] ):

# new appendList ( = appendList minus appendList[1] )
newAppendList := []:
for a from 2 to nops ( appendList ) do
	newAppendList := [op(newAppendList), appendList[a]]
od:

newList := []:
if nops ( newAppendList ) > 0 then
	nextList := []:
	if nops ( permList ) > 0 then
		for a in permList do
			for b in appendPerms do
				if nextList = [] then
					nextList := grF_appendToPermSeq ( [[op(a),b]],
						newAppendList ):
				else
					nextList := nextList, grF_appendToPermSeq ( [[op(a),b]],
						newAppendList ):
				fi:
			od:
		od:
		newList := [nextList]:
	else
		nextList := []:
		for b in appendPerms do
			if nextList = [] then
				nextList := grF_appendToPermSeq ( [[b]], newAppendList ):
			else
				nextList := nextList, grF_appendToPermSeq ( [[b]], newAppendList ):
			fi:
		od:
		newList := [nextList]:
	fi:
else
	if nops ( permList ) > 0 then
		for a in permList do
			for b in appendPerms do
				newList := [op(newList), [op(a),b]]:
			od:
		od:
	else
		for b in appendPerms do
			newList := [op(newList), [b]]:
		od:
	fi:
fi:

RETURN ( op(newList) ):
end:

#------------------------------------------------------------------------------
# createIdxList
#------------------------------------------------------------------------------
grF_createIdxList := proc ( permList, freeIndexNbr )
local	a, b, i, idxList, tmpPermList, idxFound:

tmpPermList := permList:
idxList := []:
for b in tmpPermList do
	i[b] := 1:
od:

for a to freeIndexNbr do
	idxFound := false:
	for b in tmpPermList while not idxFound do
		if member ( a, {op(b)} ) then
			idxList := [ op ( idxList ), b[i[b]] ]:
			i[b] := i[b] + 1:
			idxFound := true:
		fi:
	od:
	if not idxFound then
		idxList := [ op ( idxList ), a ]:
	fi:
od:

RETURN ( idxList ):
end:

#------------------------------------------------------------------------------
# idxPermSign
#------------------------------------------------------------------------------
grF_idxPermSign := proc ( permList, asymSet )
local	a, asymMatch, permSign:

permSign := 1:
for a in permList do
	asymMatch := { op ( combinat[permute] ( a ) ) } intersect asymSet:
	if asymMatch <> {} then
		permSign := permSign * grF_permSign ( a, op ( asymMatch ) ):
	fi:
od:
RETURN ( permSign ):
end:

#------------------------------------------------------------------------------
# createIdxList
#------------------------------------------------------------------------------
grF_getIdxInfo := proc (freeIndexNbr, symSet, asymSet)
local fullSymList, permList, idxList, idxSign, a:

#
# For each symmetry specified, set up the cross-references:
#
# Construct a list of all permutations of indices that will be
# cross-referenced to the standard component.
# The following loops construct new index lists (ie. alternate orderings of
# indices) by going through all permutations of all of the symmetric
# indices.
# The variable permList has the following format:
# eg. permList = [ [[1,2],[3,4],[5,6,7]], [[1,2],[3,4],[6,7,5]], ... etc. ]
# if there are permutations specified over the indices: [1,2] and [3,4] and
# [5,6,7]. Each permutation of the individual groups are represented.
# Symmetries and anti-symmetries are not distinguished at this point.
#
fullSymList := [op(symSet union asymSet)]:
if nops (fullSymList) > 0 then
	permList := [grF_appendToPermSeq ([], fullSymList)]:
else
	permList := []:
fi:
#
# For each of the permutations of indices represented in permList,
# a full set of indices of the form eg. [3,4,2,1,5,6] are created and
# each of these lists assigned a +1 or -1 sign depending on whether
# they are a net odd permutation or net even in the anti-symmetric indices.
# 
idxList := []:
if nops (permList) > 0 then
	idxList := [grF_createIdxList (op (1, permList), freeIndexNbr)]:
	idxSign := [grF_idxPermSign (op (1, permList), asymSet)]:
	for a from 2 to nops (permList) do
		idxList := [ op (idxList), grF_createIdxList (op (a, permList),
			freeIndexNbr) ]:
		idxSign := [op (idxSign), grF_idxPermSign (op (a, permList),
			asymSet)]:
	od:
fi:

RETURN ([idxList,idxSign])
end:

#==============================================================================
grF_oldcreateIdxList := proc ( permList, freeIndexNbr )
local	a, b, i, permIdxList, permIdxSet, idxList:

permIdxList := []:
permIdxSet := {}:
for a in permList do
	for b in a do
		permIdxList := [ op ( permIdxList ), b ]:
		permIdxSet := permIdxSet union { b }:
	od:
od:

idxList := []:
i := 1:
for a to freeIndexNbr do
	if member ( a, permIdxSet ) then
		idxList := [ op ( idxList ), permIdxList[i] ]:
		i := i + 1:
	else
		idxList := [ op ( idxList ), a ]:
	fi:
od:

RETURN ( idxList ):
end:

$undef DEBUG
