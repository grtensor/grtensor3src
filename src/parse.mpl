#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE:
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: Long ago
#
#
# Purpose: Support Routines for parsing expressions during definition
#
# grF_buildCalcFn
# grF_parseInit
# grF_parseExpr
# grF_isTensor
# grF_filterSum
#
# Revisions:
#
# Jan  1, 1994   Exit if get bad dummy indices
# May 21, 1994   Treat cdn dummies as dn, etc.
# Jun 25, 1994   Added Operator support
# Sep 12, 1994   Add sum in ^ trapping to sumInFunk 
#		 Fix internalRef bug [pm]
# Oct 25, 1994   Fix a bug in grF-sumInFunk (had assumed top
#                had multiple operands) [pm]
# Dec  6, 1994   Add pup/pdn support [pm]
# Sept. 28, 1995 Comment out implied sum checking - conflicts with kdelta
#		 implementation [pm]
# Nov. 19 1995   Dependencies for non-default metric & dependencies for
#		 tensors in operators [pm]
# June  4 1996   Added support for cbup, cbdn [dp]
# June 11 1996   Added grG_firstTerm as flag for initializations [dp]
# Sept 16 1996   Removed R3 type specifiers in proc headers [dp]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# define used in debugging
#$define DEBUG option trace;
$define DEBUG 

#----------------------------------------------------------
# grF_buildCalcFn
#       expr            - the expression to build a fn for
#       newObject       - the name of the new object
#       indexList       - list of listing indices
#       listingSub      - subs to map listing indices to a1_ etc.
#       subRanges       - sub range summations (i.e. not 1..Ndim.gname)
#
# - given an expression from grdefine build a procedure to
# calculate a particular term of this expression, performing
# all necessary summations
#----------------------------------------------------------

grF_buildCalcFn := proc( expr, newObject, indexList, listingSub, subRanges)
DEBUG
global  grG_ObjDef, 
        grG_firstTerm: # if true, then carry out init in grF_parse

local a,b,i, body, s, loopStmt, exStmt,
	  subRangeSet,
	  sumRange,
	  impliedSums,
	  lastTerm,
	  listingSet,
	  maxSum,
	  maxsubSum,        # max number of subrange dummy indices in any term
	  numDummy,         # number of dummy indices
	  dependSet,        # list of things this object depends on
	  dummySub,         # sub list for dummy names -> GRT names
	  dummySet,         # set of dummy indices
	  localSeq,
	  sumExpr,          # expanded form of expr
	  sumTerms,         # array in which sumTerms[n] is the formula for
			# terms to be added in at the nth summation

	  sumL, sumR,       # used for lhs and rhs or sum range
	  toCheck,	    # dependency name to check if defined
	  termExpr;         # expression for a single term in the sum of products
 #
 # The idea: need to ensure terms with different numbers of
 # summations are added in at the appropriate place. This
 # routine builds a procedure of the form:
 #
 #      s := no summation terms
 #      for s1_ to Ndim... do
 #         s := s + (1 summation terms)
 #         for s2_ to ...
 #           s := s + (2 summation terms)
 #           etc.
 #
 # Those terms with partially summed indices have their
 # sum perfomed by bracketing the term with sum( )

 #
 # So the first order of business is to expand the terms to
 # get a sum of products form, then parse them a term at a time
 # and label the dummy indices appropriatly. Do this for each
 # term, dividing them up into 1, 2 etc. summation terms.
 #
 sumExpr := expand ( expr ):
 #
 # if there are summations inside functions define will NOT
 # work properly. Check for this
 #
 grG_firstTerm := true:

 if grF_sumInFunk ( expr ) then
   printf ("grdef encountered a summation within a function\n"):
   printf ("you will need to define the expression in multiple steps\n"):
   ERROR(`grdef aborted`):
 fi:

 listingSet := {op(indexList)}:
 sumTerms := array(0..11, [0,0,0,0,0,0,0,0,0,0,0,0]):
 maxSum := 0:
 maxsubSum := 0:
 dependSet := {}:

 lastTerm := nops(sumExpr):
 if nops(sumExpr) = 1 or not type(sumExpr, `+`) then
   lastTerm := 1;
 fi:

 # build a set of subRange indices
 subRangeSet := {}:
 for a to nops( subRanges) do
	subRangeSet := subRangeSet union { lhs(subRanges[a]) }:
 od:

 for b to lastTerm do
	if lastTerm = 1 then
	   termExpr := sumExpr:
	else
	   termExpr := op(b, sumExpr):
	fi:
	#
    # PARSE
    #
	# parse, converting DIFF->grF_DIFF, returned result has internal names
	# of GRT objects in place of tensor notation
	# (there is a LOT of stuff going on in here, including the setting of
    #  index information via globals)
	#
 	termExpr := grF_parse( termExpr );

	# see how many dummy indices there are
	dummySet := ( {op(grG_parseList[grC_allIndices])} minus listingSet)
		 minus subRangeSet: # remove subRange dummy indices

	# keep track of the term with the largest number of sums as we go
	maxSum := max( nops(dummySet), maxSum):
	numDummy := nops(dummySet):
    #
	# relabel the dummy indices s1_ .. sn_
	# and verify they occur in both up and down lists
	#
	dummySub := NULL:
        impliedSums := `intersect`(
	  `union`(seq({op(grG_parseList[i])},i={up,cup,pup,bup,cbup,pbup})),
	  `union`(seq({op(grG_parseList[i])},i={dn,cdn,pdn,bdn,cbdn,pbdn}))
                   ):

	for a to nops(dummySet) do
#
#	Comment out for now.
#       Since kdelta's have e.g. kdelta(Tensor(x, [a], [up]),Tensor(x,[b],[up])
#       We do have sums which are not up/dn pairs...
#
#          if not member( dummySet[a], impliedSums) then
#	       printf(`Dummy index %a does not appear in both up & dn form.\n`,
#			   dummySet[a]):
#	       ERROR(`Bad dummy indices`):
#	   fi:
	   dummySub := dummySub, dummySet[a] = s||a||_:
	od:
  	#
	# now do index substitutions.
	#
	termExpr := grF_data_subs( termExpr, [dummySub] ):
	termExpr := grF_data_subs( termExpr, listingSub):

	#
	# handle any subranged indices
	#
	if subRangeSet <> {} then
	  maxsubSum := max( maxsubSum, nops(subRangeSet)):
	  for a to nops( subRanges) do
	#
	# form the subrange. Leave integers alone, and change
	# Ndim -> Ndim[grG_metricName]
	# Ndim[1] -> Ndim[grG_metricName.1]
	#
	sumL := grF_filterSum( op(1,rhs( subRanges[a])) ):
	sumR := grF_filterSum( op(2,rhs( subRanges[a])) ):
	sumRange := sd||a||_ = sumL..sumR:
	termExpr := sum( subs(lhs(subRanges[a])=sd||a||_, termExpr),
					sumRange):
	  od:
	fi:

	#
	# now we're ready to add this to our list of terms for a given
	# loop level in the sum
	#
	sumTerms[numDummy] := sumTerms[numDummy] + termExpr:

	# add dependencies to the global list
	dependSet := dependSet union { op(grG_parseList[grC_Pdepends]) }:

        grG_firstTerm := false:
 od: # for each term


 #
 # check that all the objects used in the definition are known
 # issue a warning if not
 #
 # don't check metric names (yet) since we want to leave them unassigned
 #
 for a to nops(dependSet) do
   if not type( dependSet[a], indexed) then
       #
       # if from the non-default metric the dependency entry
       # will be [ metricName, objectName] and not a simple entry
       #
       if type( dependSet[a], list)  then
          toCheck := op(2,dependSet[a]):
       else
          toCheck := dependSet[a]
       fi:
       if traperror( grF_checkIfDefined( toCheck, create )) = lasterror then
	     printf ("Warning = %a\n", lasterror):
       fi:
   fi:
 od:

 # generate the dependency list
 grG_ObjDef[newObject][grC_depends] := dependSet:

 #
 # now we can generate the procedure to do this calculation for us
 #

 #
 # now put together the rest around the loop sequence
 #
 localSeq := _Inert_NAME("s"):
 #
 # build a sequence of local variables
 #
 for a in grG_parseSet[grC_explicit] do
    localSeq := localSeq, _Inert_NAME(cat("explicit_",a));
 od:
 for a to maxSum do
   localSeq := localSeq, _Inert_NAME(cat("s", a, "_"));
 od:
 for a to maxsubSum do
   localSeq := localSeq, _Inert_NAME(cat("sd", a, "_"));
 od:
 #
 # generate stmts to test explicit coords (if any)
 #
 exStmt := NULL:
 for a in grG_parseSet[grC_explicit] do
 #   exStmt := exStmt,`&:=`(explicit_||a,grF_checkExplicitIndex(grG_metricName,a)):
 	 exStmt := exStmt, 
 	 			_Inert_ASSIGN(
 	 				_Inert_NAME(cat("explicit_", a)),
 	 				_Inert_FUNCTION("grF_checkExplicitIndex", 
 	 					_Inert_EXPSEQ(_Inert_NAME(a))
 	 				)
 	 			):
 od:
 #
 # generate the loops to do implied summations
 #
# for a from maxSum by -1 to 1 do
#	loopStmt := `&for`( s||a||_, 1, 1, Ndim['grG_metricName'], true,
#	`&statseq`( `&:=`(s, s + sumTerms[a]), loopStmt) ):
# od:

 loopStmt := _Inert_STATSEQ();

 for a from maxSum by -1 to 1 do
 	if version() > 1265877 then
		loopStmt := 
			    _Inert_FORFROM(
			      _Inert_NAME(cat("s",a,"_")),   # loop variable
			      _Inert_INTPOS(1),         	 # from 
			      _Inert_INTPOS(1),         	 # step
			      ToInert(Ndim[grG_metricName]),  # limit
	      		  _Inert_NAME("true", _Inert_ATTRIBUTE(_Inert_NAME("protected", 
	         			_Inert_ATTRIBUTE(_Inert_NAME("protected"))))), 
			      # body
			      _Inert_STATSEQ(
			      	_Inert_ASSIGN( 
			      		_Inert_NAME("s"), 
			      		_Inert_SUM( 
			      			_Inert_NAME("s"),
			      			ToInert(sumTerms[a])
			      		)
			      	), 
			      	loopStmt
			      ),
			      _Inert_NAME("false", _Inert_ATTRIBUTE(_Inert_NAME("protected",
			         _Inert_ATTRIBUTE(_Inert_NAME("protected")))))
		    	);
	else
		loopStmt := 
			    _Inert_FORFROM(
			      _Inert_NAME(cat("s",a,"_")),   # loop variable
			      _Inert_INTPOS(1),         	 # from 
			      _Inert_INTPOS(1),         	 # step
			      ToInert(Ndim[grG_metricName]),  # limit
	      		  _Inert_NAME("true", _Inert_ATTRIBUTE(_Inert_NAME("protected", 
	         			_Inert_ATTRIBUTE(_Inert_NAME("protected"))))), 
			      # body
			      _Inert_STATSEQ(
			      	_Inert_ASSIGN( 
			      		_Inert_NAME("s"), 
			      		_Inert_SUM( 
			      			_Inert_NAME("s"),
			      			ToInert(sumTerms[a])
			      		)
			      	), 
			      	loopStmt
			      )
		    	);
    fi:
  od:

# body := `&proc`( [object, iList], [localSeq], [],
#	 `&statseq`( exStmt, `&:=`(s, sumTerms[0]), loopStmt) ):

  procBody := _Inert_PROC(
    _Inert_PARAMSEQ(_Inert_NAME("object"), _Inert_NAME("iList")),
    _Inert_LOCALSEQ(localSeq),
    _Inert_OPTIONSEQ(), 
#    _Inert_OPTIONSEQ(_Inert_NAME("trace")), 
    _Inert_EXPSEQ(), 
    _Inert_STATSEQ(_Inert_ASSIGN( _Inert_NAME("s"), ToInert(sumTerms[0])),
    	loopStmt, 
    	_Inert_RETURN(_Inert_NAME("s"))
    	), 
    _Inert_DESCRIPTIONSEQ(), 
    _Inert_GLOBALSEQ(), 
    _Inert_LEXICALSEQ(), 
    _Inert_EOP(_Inert_EXPSEQ())
  ):
  RETURN (FromInert(procBody)):

# RETURN( procmake( body ) );

end:

#--------------------------------------------------
# grF_data_subs
# - only want to sub into expressions that are grdata
#   terms in case a param conflicts with a index
#   eg: a*gr_data[gdndn_,a] 
#--------------------------------------------------

grF_data_subs := proc(expr, subvalues)
DEBUG
	if op(0,expr) = gr_data then
		RETURN( subs(subvalues,expr));
	elif member(whattype(expr), {fraction,float,integer}) then 
		RETURN(expr);
	elif nops(expr) > 1 then 
		RETURN(map(grF_data_subs, expr, subvalues)):
	else
		RETURN(expr);
	fi:
end proc:

#--------------------------------------------------
# grF_filterSum
#
# ( a grF_buildCalcFn support routine)
#
# Want to change Ndim[x] -> Ndim[grG_metricName.x]
#                Ndim    -> Ndim[grG_metricName]
# and leave integers alone
#
# Could get something like e.g. n[1]-1
#
#--------------------------------------------------

grF_filterSum := proc( expr)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, newExpr;
  #
  # only allow one Ndim to appear in the expression
  #
  if type(expr, integer) then
	RETURN( expr);
  else
	for a to 5 do
	  if has(expr, Ndim[a]) then
	   # substitute for Ndim[1] Ndim[2] etc.
	   newExpr := subs( Ndim[a] = Ndim[grG_metricName||a], expr):
	   RETURN(newExpr);
	  fi:
	od:
	newExpr := subs( Ndim = Ndim[grG_metricName], expr):
	RETURN( newExpr);
  fi:

end:


#----------------------------------------------------------
# grF_parse
#
# This routine parses an expression in inert Tensor form
# i.e. containing Tensor_ and
#   1) accumulates a list of indices, by type
#   2) builds a dependency list
#   3) changes the expression to internal form e.g. grG_gdndn_[..]
#
# The actual "parsing" happens by subbing in tensor_ for Tensor_
# and then evaluating. Prior to this need to handle DIFF calls
# (since an index up in the second arg of DIFF is REALLY down).
#
#----------------------------------------------------------

grF_parse := proc( inExpr )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_parseList, grG_parseSet, grG_parseAuxMetrics;

local a, expr;

 if grG_firstTerm then
   grG_parseSet[ grC_explicit] := {}:
 fi:
 for a in grG_indexFnSet do
   #
   # keep a list for each type of index
   #
   grG_parseList[a] := [];
 od:
 
 grG_parseList[grC_Pdepends] := []:   # dependencies
 grG_parseList[grC_allIndices] := []: # indices found
 grG_parseSet[grC_allIndices] := {}:  # indices found
 grG_parseAuxMetrics := {}: # auxillary metrics required

 #
 # Step 1: Any DIFF's which have vector args need to have
 # their indices added to a different list than usual
 #
 expr := eval( subs( DIFF = grdiff_, inExpr)):
 #
 # Step 2: Operator-> operator_, Tensor_ -> tensor_
 #
 # Operator_ MUST be done first, since its operands
 # might include Tensor_ fns which have to be handled
 # differently when they are operands
 #
 expr := eval( subs( Operator_ = operator_, expr));
 expr := eval( subs( Tensor_ = tensor_, expr));

end:

#----------------------------------------------------------
# grdiff_
#
# diff routine for use during parsing
#
# If second arg is a tensor add its args to the opposite
# list from that in iType (down in denom = up)
#
# Return as grF_DIFF (which is mapped to diff when we are
# not in the midst of defining new objects)
#----------------------------------------------------------

grdiff_ := proc( a, b)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_parseList;
local i, arg2;

 if op(0,b) = Tensor_ then
	for i to nops( op(2,b) ) do
	  if op(2,b)[i] = up then
	grG_parseList[dn] := [op(grG_parseList[dn]), op(3,b)[i] ]:
	  elif op(2,b)[i] = dn then
	grG_parseList[up] := [op(grG_parseList[up]), op(3,b)[i] ]:
	  fi:
	od:
	#
	# dereference the tensor argument to ensure
	# that its indices are counted only once
	#
	arg2 := grF_internalRef( op(b) ):
        #
        # add the object to the dependency list
        #
        grG_parseList[ grC_Pdepends] := [ op( grG_parseList[ grC_Pdepends]),
			op(1,b)(op(op(2,b))) ]:
 else
	arg2 := b:
 fi:
 grF_DIFF(a,arg2);

end:


#----------------------------------------------------------
#
# tensor_
#
# The "active" form. When evaluated return the name of the
# internal representation of the object. Add to the
# index lists initalized by grF_parse as appropriate.
#
#----------------------------------------------------------


tensor_ := proc( root, iType, iList, gnum)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global  grG_parseList, grG_parseSet, grG_parseAuxMetrics;

local a, newDep, new_iType, new_iList:

 new_iType := iType: # if iType has explicit_'s need to strip them and
                     # leave only their argument
 new_iList := iList:

 for a to nops(iType) do
   #
   # add each index to the appropriate list
   #
   if type(iType[a],indexed) then
      #
      # explicit index
      #
      grG_parseSet[ grC_explicit] := grG_parseSet[ grC_explicit] union {iList[a]}:
      new_iType := subs( iType[a] = op(iType[a]), new_iType);
      new_iList := subs( iList[a] = explicit_||(iList[a]), new_iList ):
   else
      grG_parseList[ iType[a] ] := [ op(grG_parseList[iType[a]]), iList[a] ]:
      grG_parseList[ grC_allIndices ] := [ op(grG_parseList[grC_allIndices]),
				   iList[a] ]:
   fi:
 od:
 if iType = [] then
   newDep := root:
 else
   newDep := root(op(new_iType)):
 fi:

 if gnum > 0 then
   newDep := [ grG_metricName||gnum, newDep ]:
   grG_parseAuxMetrics := grG_parseAuxMetrics union {gnum}:
 fi:

 grG_parseList[ grC_Pdepends] := [ op( grG_parseList[ grC_Pdepends]),
			newDep ]:

 grF_internalRef(root, new_iType, new_iList, gnum, []);

end:

#----------------------------------------------------------
# tensorOperand_
#
# The "active" form for a Tensor_ stmt inside an operator.
# When evaluated return the objectName. Add the indices to
# the appropriate lists.
#
# Since we only expect one Tensor_ in an operandSeq return
# a
#
# i.e. Tensor_( g, [dn,dn], [a, b], 0) -> g(dn,dn)
#
#----------------------------------------------------------


tensorOperand_ := proc( root, iType, iList, gnum)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global  grG_parseList, grG_tensorOp, grG_parseAuxMetrics;

local a, newDep:

 for a to nops(iType) do
   #
   # add each index to the appropriate list
   #
   grG_parseList[ iType[a] ] := [ op(grG_parseList[iType[a]]), iList[a] ]:
   grG_parseList[ grC_allIndices ] := [ op(grG_parseList[grC_allIndices]),
			   iList[a] ]:
 od:

 if iType = [] then
   newDep := root:
 else
   newDep := root(op(iType)):
 fi:

 if gnum > 0 then
   newDep := [ grG_metricName||gnum, newDep ]:
   grG_parseAuxMetrics := grG_parseAuxMetrics union {gnum}:
 fi:

 grG_parseList[ grC_Pdepends] := [ op( grG_parseList[ grC_Pdepends]),
			newDep ]:

 grG_tensorOp := op(iList):
 if iType <> [] then
   root(op(iType));
 else
   root;
 fi:

end:

#----------------------------------------------------------
# operator_
#
# The "active" form. When evaluated return the name of the
# internal representation of the operator. Add to the
# index lists initalized by grF_parse as appropriate.
#
#----------------------------------------------------------


operator_ := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_parseList;

local a, newDep, iType, iList, operandSeq, opSeq, root:

 root := args[1]:
 iType := args[nargs-1]: # e.g. [dn,dn]
 iList := args[nargs]: # e.g. [a, b]
 operandSeq := seq( args[a], a=2..nargs-2):
 opSeq := op(eval(subs( Tensor_=tensorOperand_, [operandSeq]))):

 for a to nops(iType) do
   #
   # add each index to the appropriate list
   #
   grG_parseList[ iType[a] ] := [ op(grG_parseList[iType[a]]), iList[a] ]:
   grG_parseList[ grC_allIndices ] := [ op(grG_parseList[grC_allIndices]),
				   iList[a] ]:
 od:

 #
 # generate the dependency
 #
 if iType = [] then
   newDep := root[opSeq]:
 else
   newDep := root[opSeq](op(iType)):
 fi:
 grG_parseList[ grC_Pdepends] := [ op( grG_parseList[ grC_Pdepends]),
			newDep ]:

 # (-1 indicates operator)
 grF_internalRef(root, iType, iList, -1, [operandSeq]);

end:


#----------------------------------------------------------
# grF_internalRef
#
# generate an internal reference to the components of
# Tensor_
#----------------------------------------------------------

grF_internalRef := proc( root, iType, iList, gnum, operands)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
#
# gnum = -1 indicates an operator
#
local root2, gname, object, opSeq:
 #
 # now build the internal reference to return
 #

 if iType = [] then
   object := root:
 else
   object := root( op(iType) ):
 fi:

 opSeq := NULL:
 gname := grG_metricName:
 if gnum > 0 then
   gname := grG_metricName||gnum:
 elif gnum = -1 then
   #
   # an operator
   #
   opSeq := op( operands):
   if iList = [] then
     #
     # need to take indices from the Tensor_() object which
     # is an argument
     #
     # ASSUMPTION: operandSeq has one and only one Tensor_() stmt
     #
     opSeq := eval(subs( Tensor_=tensorOperand_, [opSeq])):
     if assigned(grG_tensorOp) then
     	opSeq := op(opSeq), grG_tensorOp:
     else
     	opSeq := op(opSeq):
     fi:
   fi:

 fi:
 root2 := grG_ObjDef[ object][ grC_root]:
 if not assigned( grG_ObjDef[object][grC_root]) then
    root2 := cat(root,op(iType),`_`): 
 fi:
 RETURN( gr_data[root2, gname, opSeq, op(iList)] ):
end:


#----------------------------------------------------------
#
# grF_sumInFunk
#
# Check the expression for functions which contain
# implied summations. Such expressions will fail in
# grdefine.
#
# e.g. ln( u^a u_a) will become ln( u^1 u_1) + ln(...) etc.
#      which is wrong.
#----------------------------------------------------------

grF_sumInFunk := proc(expr)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local value,i,top,bot:
 value := false:
 if type(expr,`*`) then
   #
   # Contraction in denomenators are not allowed.
   # Contractions in functions in the numerator are not allowed.
   #
   top := numer(expr);
   bot := denom(expr);
   if bot <> 1 then 
      value := value or grF_sumInFunk( top ):
      grF_parse(bot):
      if ({op(grG_parseList[up]),op(grG_parseList[bup]),op(grG_parseList[cup]),
          op(grG_parseList[cbup]),op(grG_parseList[pbup])} intersect
          {op(grG_parseList[dn]),op(grG_parseList[bup]),op(grG_parseList[cup]),
          op(grG_parseList[cbdn]),op(grG_parseList[pbdn])})
          <> {} then
      printf(`Summation in denom.\n`);
      value := true:
      fi:
   else
      for i to nops(expr) do
         value := value or grF_sumInFunk(op(i,expr));
      od:
   fi:

 elif type(expr,`+`) then
   for i to nops(expr) do
     value := value or grF_sumInFunk( op(i,expr) ):
   od:
   
 elif type(expr, numeric) then
   value := false:

 elif type(expr, function) then
   if op(0,expr) = Tensor_ or op(0,expr) = Operator_ then
     value := false:
   else
     #
     # found a genuine function. Are there dummy indices ??
     #
     for i to nops(expr) do
       grF_parse(op(i,expr)):
       if ({op(grG_parseList[up]),op(grG_parseList[bup]),
            op(grG_parseList[cup]),op(grG_parseList[cbup]),
            op(grG_parseList[pbup])}
           intersect
           {op(grG_parseList[dn]),op(grG_parseList[bup]),
            op(grG_parseList[cup]),op(grG_parseList[cbdn]),
            op(grG_parseList[pbdn])})
           <> {} then
         printf(`Summation in function %a\n`, op(0,expr)):
	 RETURN(true):
       fi:
     od:
     RETURN(false):
   fi:


 else
   value := false:
 fi:

 value;

end:

$undef DEBUG
