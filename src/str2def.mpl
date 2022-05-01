# Stupid conversion program messed up all the tabbing !!
#****************************************
#
# STR2DEF ( String to Definition)
#
# Developed By: Peter Musgrave
#
# This module converts a string definition
# (e.g. CoD{a} T{b c} ) to a functional
# Maple expression (i.e. CoD( a, Tensor_( T,[dn,dn],[b,c],0) ).
#
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
#
# Dec  31 1993          Created
# Feb  20 1994          Change to Tensor_ representation
# Apr  31 1994          Add grF_strToObject
# Jun  25 1994          Added Operator_ support
# July 18 1994          Fixed `p(r)*(g{a b})` bug in grF-impliedTimes
#                       Fixed Sym/Asym bug (conflict with operator code)
# Aug   2 1994          Sym bug -> must ignore tetrad indices
#                       Plus further tetrad patches [pm]
# Aug  11 1994          Fix length check on sscanf for unix [pm]
# Sep  12 1994		Remove implied multiplication [pm]
# Sep  15 1994          Added symmetry support for operators
#                       (doSym rewritten) [pm]
# Sep  17 1994          Add cup/cdn to index find. No ; -> CoD [pm]
# Dec   6 1994  	Add pup/pdn to index find. [pm]
# Dec  14 1994 		Remove grF_explicitD [pm]
# Jan  16 1995          Add explicit index support [pm].
# Jan  26 1995          kdelta tensor converted to function [pm].
# Sept.28 1995		Fix grF_doSym (how did it ever work??) [pm]
# Oct. 25 1995          doSym fixes. Remove stale code [pm]
# Nov. 18 1995          Fix scalars from non-default metric [pm]
# Jan  17 1996          Catch Maple lists in str2def [pm]
# June  4 1996		Added support for cbup, cbdn [dp]
# June 11 1996		Check autoload libraries for scalars during grdef [dp]
# Sept 16 1997		Removed R3 type specifiers in proc headers [dp]
# Feb  14 1997          Switch convert(x,string) to convert(x,name) for R5 [dp]
# Feb  14 1997		Fixed parse of scalars on LHS of grdef expr [dp]
# Feb  24 1997		Added index consistency checking of definitions [dp]
# May   4 1998		Fixed recognition of explicit indices [dp]
# May   6 1998		Added consistency check for der. and basis idxs [dp]
# May  31 1998		verifyDefIndices does not check tdef if tdef=nodef [dp]
# Oct  18 1998		Fixed bugs in index parser for operators and tensors
#			which occur as arguments to functions [dp]
# Jan  24 1999		Fixed index parser for cbdn, pbdn [dp]
#
#-----------------------------------------
#
# See the documentation for the details of
# allowable string definitions.
#
#-----------------------------------------
#
# A number of the routines make use of a
# STRING data type which is an array
# representation of a Maple string. A
# STRING is an array of strings. The length
# is held in the 0th entry. All contiguous
# alpha characters are kept in a single entry
# in the array, and whitespace is deleted.
#
#-----------------------------------------
#
# The following functions are defined in this
# file:
#
# grF_brktFind:  find pairs of parenthesis in a STRING
#
# grF_doSym: change symmetry brackets to function calls
#
# grF_explicitD: convert ; to CoD or , to DIFF
#
# grF_impliedTimes: make implicit multiplication explicit
#
# grF_indexFind: find indices
#
# grF_opToFunction: convert operators like CoD{} to
#                   function calls
#
# grF_stringify: convert a maple string to a STRING
#
# grF_strstr: find all occurances of a string in a STRING
#
# grF_strToDef: convert a string to a functional defintion
#
#******************************************

# define used in debugging
#$define DEBUG option trace;
$define DEBUG 

grG_defineOperators := {`CoD`, `LieD`}:

defdebug := proc( s )

global grG_symList, grG_asymList;

	grF_strToDef( s );
	print(`Symmetric list ` = grG_symList );
	print(`Anti-symmetric list ` = grG_asymList );

end:


#------------------------------------------
# grF_brktFind( s, openStr, closeStr)
#
# s is a STRING.
#
# Return a list of ordered pairs indicating where
# in <s> pairs of matched brackets start and end.
#------------------------------------------

grF_brktFind := proc( s, openStr, closeStr)
DEBUG
 local i, openCnt, brktList, openList;

 openList := array(1..50):
 openCnt := 0:
 brktList := []:

 for i to s[0] do
	if s[i] = openStr then
	 	openCnt := openCnt + 1:
	 	openList[ openCnt] := i:
	elif s[i] = closeStr then
		if openCnt = 0 then
			ERROR(`Mismatched {}'s`);
		fi:
		brktList := [ op(brktList), [ openList[ openCnt], i]]:
		openCnt := openCnt - 1:
		if openCnt < 0 then
			ERROR(`Too many `.closeStr):
		fi:
	fi:
 od:

 if openCnt > 0 then
	 ERROR( `Too many `.openStr):
 fi:

 RETURN(brktList):

end: # brktFind()


#------------------------------------------
# grF_doSym( inStr, indices, brktList, symFn)
#
#  [ symFn is either Sym or Asym ]
#
# Convert implied symmetry to functions calls. e.g.
#   T{ (a b) } to Sym( [a,b], T{ a b} )
#
# Modifies inStr.
#
# Symmetry works by enclosing the affected terms by
# the function Sym(..) or Asym(..). These take a list
# of indices. They're activated as the function returns (? check this)
#
#------------------------------------------

grF_doSym := proc( inStr, indices, brktList, symFn)
DEBUG
local i,j,k, symList, symOver, sList, start, last,
	inBachBar, symType,
				openStr, closeStr, operatorType, tensorType, indexType,
				typeArray, openCnt, inOp, openList:

 #
 # build a parallel array, typeArray, which indicates
 # if the corresponding entry in inStr is inside
 # {}'s or is part of an operator.
 #
 # Entries in typeArray are either 0, tensorType,
 # operatorType or a sequence of these.
 #
 typeArray := array(1..inStr[0]):
 for i to inStr[0] do
	 typeArray[i] := []:
 od:

 #
 # mark tensor entries (but not the head)
 #
 for i in brktList do
	 for j from i[1] to i[2] do
		 typeArray[j] := [tensorType]:
	 od:
 od:

 #
 # mark operators (i.e ['s outside of tensors)
 #

 inOp := false:
 for i to inStr[0] do
	 if convert (inStr[i], name) = "[" and typeArray[i] = [] then
		 inOp := true:
	 elif convert (inStr[i], name) = "]" and typeArray[i] = [] then
		 inOp := false:
		 typeArray[i] := [operatorType]:
	 fi:
	 if inOp then
		 typeArray[i] := [op(typeArray[i]),operatorType]:
	 fi:
 od:

 #
 # find brackets for the type of sym requested, and
 # ensure that the brackets are inside tensors.
 # (Cannot use brktFind since it would mess up on
 #  e.g. LieD[ a, R{a [b}] X{c] d} )
 #
 if symFn = Sym then
	 openStr := "(":
	 closeStr := ")":
 else
	 openStr := "[":
	 closeStr := "]":
 fi:

 openList := array(1..50):
 openCnt := 0:
 sList := []:

 for i to inStr[0] do
	 if inStr[i] = openStr and has(typeArray[i], tensorType) then
	 openCnt := openCnt + 1:
	 openList[ openCnt] := i:
	 elif inStr[i] = closeStr and has(typeArray[i], tensorType) then
	 sList := [ op(sList), [ openList[ openCnt], i]]:
	 openCnt := openCnt - 1:
	 if openCnt < 0 then
		 ERROR(`Too many `.closeStr):
	 fi:
	 fi:
 od:

 if openCnt > 0 then
	 ERROR( `Too many `.openStr.` in symmetry.`):
 elif openCnt < 0 then
	 ERROR( `Too many `.closeStr.` in symmetry.`):
 fi:

 #
 # check if any entries in sList are inside
 # index braces
 #
 for  i in sList do
	 start := 0:
	 last := 0:
			# found opening ( inside { }

			#
			# FIND START of (a)sym
			#
			start := i[1]-1: # start points to start of first object affected

			if has( typeArray[i[1]], operatorType) then
				#
				# we're in an operator. Need to scan back to the start
				# of it.
				#
				while start > 1 and has( typeArray[start], operatorType) do
					start := start - 1:
				od:
			elif has( typeArray[i[1]], tensorType) then
				#
				# we're in a tensor. Need to scan back to the start
				# of it.
				#
				while start > 1 and has( typeArray[start], tensorType) do
					start := start - 1:
				od:
			fi:

			#
			# FIND END of (a)sym
			#
			# scan from the close of sym to the close of indices
			last := i[2]+1:
			if has( typeArray[i[2]], operatorType) then
				#
				# we're in an operator. Need to scan ahead to the end
				# of it.
				#
				while last < inStr[0] and has( typeArray[last], operatorType) do
					last := last + 1:
				od:
			elif has( typeArray[i[2]], tensorType) then
				#
				# we're in a tensor. Need to scan ahead to the end. 
				#
				while last < inStr[0] and has( typeArray[last], tensorType) do
					last := last + 1:
				od:
			fi:
			#
			# make last point to final } or ]
			#
			if last > inStr[0] then
				 ERROR(`Missing }`):
			elif last < inStr[0] then
					last := last - 1:
			fi:

			#
			# build a sequence of indices to be (A)Sym-ed over
			# We want to collect only those which are of the
			# same type as the first index after the ( or [
			#
			# We regard the types as :  up (cup and pup)
			#                           dn (cdn and pdn)
			#                          bup
			#                          bdn
			#
			symList := []:
			symOver := 0:
			inBachBar := false:

			# i is a list indicating position where symmetry symbols are found
			for k from i[1]+1 to i[2]-1 do

				if indices[k] <> 0 and not inBachBar then
					indexType := eval(subs( cdn=dn, pdn=dn, cup=up, pup=up, indices[k])):

					# convert index to name for eval of Sym/Asym
					if symList = [] then
						symType := indexType:
						symList := [ convert(inStr[k],name) ]:
					elif indexType = symType then
						symList := [ op(symList), convert(inStr[k],name) ]:
					fi:

				elif inStr[k] = "|" then
					#
					# found a Bach bar
					#
					inBachBar := not inBachBar:
					inStr[k] := "":
				fi:
			od: # for k

		 #
		 # add the Sym function to inStr but ONLY
		 # if it has more than one index in it (otherwise
		 # it's a tetrad index, e.g. (a) )
		 #
		 if nops(symList) > 1 then
				inStr[ start] := cat( symFn,"(",convert(symList, name),
							 ",", inStr[start] ):
				inStr[ last] := cat( inStr[last], ")" ):
				#
				# remove the sym brackets
				#
				inStr[ i[1] ] := "":
				inStr[ i[2] ] := "":
		 fi:

 od: # for i

end:

#------------------------------------------
# grF_indexFind( inStr)
#
# Find indices in inStr ( names within {} ) and
# return a List which contains an index function
# in entries corresponding to positions in inStr.
#
# e.g. grF_indexFind( grF_stringify( `T{ a ^b}`)):
#      yeilds: [ 0,0,0,dn,0,0,up,0 ]
#
#------------------------------------------

grF_indexFind := proc(inStr, brktList)
DEBUG
 local i, j, Prime, Up, Tetrad, Spinor, CoD, Partial, indices, explicit,
	iType, attribSet, upperCase, attrib_default, preChar:

 uses StringTools;

 indices := array(1..inStr[0]):
 for i to inStr[0] do 
 	indices[i] := 0: 
 od:

 for i in brktList do
	 attrib_default := {}:
	 for j from i[1]+1 to i[2]-1 do
		 # PM2016 - now need to skip spaces explicitly. 
		 if StringTools:-IsSpace(inStr[j]) then
				next
		 fi:
		 #
		 # if we encounter a ; or , then EVERY index from that point
		 # is a cdn or pdn
		 #
		 if inStr[j] = ";" then
			 attrib_default := {CoD}:
			elif inStr[j] = "," then
				attrib_default := {Partial}:
		 fi:
		 if not member( inStr[j],
									 { "'", "^", "(", ")", ";" ,",", "|", "", "$", "[", "]" } ) then
				#
				# if it's not a special character then it must be an index
				# name
				#
				# create a set to hold index attributes
				#
				attribSet := attrib_default:
				preChar := j-1:
				#
				# Is index name all upper case ?
				#
				upperCase := sscanf( inStr[j],
			 `%[QWERTYUIOPASDFGHJKLZXCVBNM1234567890_]`):
				if upperCase <> [] then
					if op(1,upperCase) = inStr[j] then
						# it is all uppercase letters
						attribSet := attribSet union { `Spinor` }:
					fi:
				fi:
				explicit := false:
				if inStr[preChar] = "$" then
					explicit := true:
					preChar := preChar - 1:
				fi:
				 
				if inStr[preChar] = "^" then
					attribSet := attribSet union { Up }:
					preChar := preChar - 1:
				fi:
		
				if inStr[preChar] = "("
					 and inStr[j+1] = ")" then
					 attribSet := attribSet union { Tetrad }:
					if inStr[preChar-1] = "^" then
							attribSet := attribSet union { Up }:
					fi:
			 fi:

			 if inStr[j+1] = "'" then
				 attribSet := attribSet union { Prime }
			 fi:

			#
			# now find the corresponding index function
			#
			if attribSet = {} then
				iType := dn:
			elif attribSet = {Up} then
				iType := up:
			elif attribSet = {CoD} then
				iType := cdn:
			elif attribSet = {CoD,Up} then
				iType := cup:
			elif attribSet = {Partial} then
				iType := pdn:
			elif attribSet = {Partial,Up} then
				iType := pup:
			elif attribSet = {Tetrad} then
				iType := bdn:
			elif attribSet = {Up,Tetrad} then
				iType := bup:
						elif attribSet = {Up,CoD,Tetrad} then
							iType := cbup:
						elif attribSet = {CoD,Tetrad} then
							iType := cbdn:
						elif attribSet = {Up,Partial,Tetrad} then
							iType := pbup:
						elif attribSet = {Partial,Tetrad} then
							iType := pbdn:
			elif attribSet = {Spinor} then
				iType := sdn:
			elif attribSet = {Up,Spinor} then
				iType := sup:
			elif attribSet = {Spinor,Prime} then
				iType := spdn:
			elif attribSet = {Up,Spinor,Prime} then
				iType := spup:
			else
				ERROR(`Could not determine iType: `.attribSet):
			fi:

			if explicit then
				indices[j] := explicit_[iType]:
			else
				indices[j] := iType:
			fi:
		fi:
	 od:
 od:

 RETURN( indices):

end:


#------------------------------------------
# grF_stringify( sdef)
#
# Convert <sdef> to an array of strings. Purely
# alpha substrings stay together as a single
# entry and special characters get an entry
# unto themselves.
#
#------------------------------------------

grF_stringify := proc( sdef )
DEBUG
 local outStr,  newName, leftover, charList, i;

 # BUILD A STRING ARRAY
 #
 # create an array in which Maple names are entered as a
 # single entry and all special characters occupy one entry
 # each
 #

 charList := []:
 leftover := sdef:

 while length(leftover) > 0 do
	 #
	 # try and scan a name. If cannot then copy over one character and retry
	 #
	 # strange platform dependence. On DOS/WIN the return value for
	 # sscanf is [``] while for UNIX it seems to be just []
	 #  (and in R5 scanf() returns [""].  dp, 2.14.98)
	 # note that A-Z and a-z ranges don't work !
	 # newName is a LIST
	 newName := sscanf( leftover,
		`%[1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_]`):
	 #
	 # if scanf did not match, then must be a special character, else a name
	 # that we want to collect into a single entry
	 #
	 if newName = [] or op(newName) = `` or op(newName) = "" then
			# Skip whitespace
			if substring( leftover, 1..1) <> ` ` and 
				substring( leftover, 1..1) <> " " then
				# make sure get a string and not a char
				charList := [ op(charList), convert(substring( leftover, 1..1), string) ]:
			fi:
			# remove what was parsed from the string
			leftover := substring( leftover, 2..length(leftover) ):
	 else
			# op() because sscanf returned a list
			charList := [ op(charList), op(newName)]:
			leftover := substring( leftover, length(op(newName))+1..length(leftover) ):
	 fi:
 od:
 #
 # copy over to an array (outStr) to be returned
 # Entries are converted to names. Why?
 #
 outStr := array(0..nops(charList) ):
 outStr[0] := nops(charList):
 for i to outStr[0] do
		outStr[i] := op(i,charList):
 od:
 RETURN(outStr):

end: # stringify

#------------------------------------------
# grF_strstr( s, target)
#
# return a sequence of the position of all
# occurances of target in s.
#------------------------------------------

grF_strstr := proc( s, target )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 local i, foundSeq:

 foundSeq := NULL:

 for i to s[0] do
	 if s[i] = target then
	 foundSeq := foundSeq, i:
	 fi:
 od:

 RETURN( foundSeq):

end: # strstr()

#-----------------------------------------------------------------
# grF_tensor2string
#-----------------------------------------------------------------

grF_tensor2string := proc (tensor)
local str, pos, idx, a:
	str := ``.(op(1,tensor)).`{`:
	pos := op(2,tensor):
	idx := op(3,tensor):
	for a to nops(pos) do
		if op(a,pos)=up then
			str := ``.str.`^`.(op(a,idx)):
		else
			str := ``.str.(op(a,idx)):
		fi:
		if a<nops(pos) then
			str := ``.str.` `:
		fi:
	od:
	str := ``.str.`}`:
	RETURN ( str ):
end:


#-----------------------------------------------------------------
# grF_verifyDefIndices
# Verify the definition indices in the tensor name
# are present in the tensor definition.
#-----------------------------------------------------------------
grF_verifyDefIndices := proc ( tname, tdef )
DEBUG
option trace;
local idxn, idxd:
	idxn := grF_checkIndices ( tname ):
	if type (tdef, list) then
		if not ((nops(op(1,idxn))=1 and nops(op(2,idxn))=0) or
			(nops(op(1,idxn))=0 and nops(op(2,idxn))=1) ) then
			ERROR (`rhs is a vector.`):
		fi:
	elif convert (tdef, name) <> `nodef` then
		idxd := grF_checkIndices ( tdef ):
		if grF_compareIndices(idxn,idxd) <> NULL then
			printf("Indices in name: %a\n", idxn);
			printf("Indices in definition: %a\n", idxd);
			ERROR (`lhs/rhs index conflict.`):
		fi:
	fi:
end:

(*
Maple normalizes '-' and '/' to '+' and '*'
*)

#-----------------------------------------------------------------
# grF_checkIndices
#-----------------------------------------------------------------

grF_checkIndices := proc ( t_expr )
DEBUG
local expr, stdidx, a, idx, stdterm, idxl, idxr:
	expr := expand ( t_expr ):

	if type (expr, `+`) then
		stdidx := NULL:
		for a in expr do
			idx := grF_checkTermIndices ( a ):
			if idx[1]=-1 then
				ERROR (`Index error:`,idx[2]):
			elif stdidx=NULL then
				stdidx := idx:
				stdterm := a:
			else
				# not sure what this is for. Some terms in sum can be numeric and not have an index
#        if grF_compareIndices (idx, stdidx)<>NULL then
#          printf("Indices in sum: %a\n", idx);
#          printf("Indices in definition: %a\n", stdidx);
#          ERROR (`Index conflict: `,idx[2]):
#        fi:
			fi:
		od:
	elif type (expr, `*`) or type (expr, function) then
		idx := grF_checkTermIndices (expr):
		if idx[1]=-1 then
			ERROR (`Error in tensor indices:`,idx[2]):
		fi:
	elif type (expr, list) then
		idx := [a]:
	elif type (expr, equation) then
		idxl := grF_checkIndices (lhs(expr)):
		idxr := grF_checkIndices (rhs(expr)):
		if grF_compareIndices (idxl, idxr)<>NULL then
			ERROR (`Index conflict between lhs and rhs of equation.`):
		else
			idx := idxl:
		fi:
	else
		idx := grF_getTermIndices ( expr ):
	fi:
	RETURN ( idx ):
end:

grF_compareIndices := proc ( idx1, idx2 )
	# check that the up indices and dn indices of idx1 and idx2 are identical.

	if ( {op(op(1,idx1))} <> {op(op(1,idx2))} ) or
		( {op(op(2,idx1))} <> {op(op(2,idx2))} ) then
		RETURN ( -1 ):
	fi:
	RETURN ():
end:

grF_appendIdx := proc(newidx, idxIn)
DEBUG
local appended_idx;

		if newidx[1] = -1 then
				appended_idx := newidx:
		else
				# append the resulting indices into the up/down sets
				# if there are new members
				if {op(op(1,idxIn))} intersect {op(op(1,newidx))} = {} and
					 {op(op(2,idxIn))} intersect {op(op(2,newidx))} = {} then
					appended_idx := [[op(op(1,idxIn)),op(op(1,newidx))],
						[op(op(2,idxIn)),op(op(2,newidx))]]:
				else
					appended_idx := [-1,({op(op(1,idxIn))} intersect {op(op(1,newidx))})
						union ({op(op(2,idxIn))} intersect {op(op(2,newidx))})]:
				fi:
		fi:
		RETURN(appended_idx)
end proc:

#-----------------------------------------------------------------
# grF_checkTermIndices
# Descend through expressions and functions and accumulate the 
# listing indices. 
#
# Returns: List of lists, with down index list and up index list
# [[<down_list], [<up_list>]]
#-----------------------------------------------------------------

grF_checkTermIndices := proc ( expr )
DEBUG
local a, idx, newidx, upset, dnset, dummyset:

	idx := [[],[]]:

	# if a terminal (index-bearing object) then get the indices for it
	if type(expr,function) and member (op(0,expr), {Tensor_, Operator_}) then
		idx := grF_getTermIndices (expr):
			#
			# May have indices in operator argument LieD[u,R{a b}] => 
			# Operator_(LieD, u, Tensor_(R, [dn, dn], [a, b], 0), [], [])
			#
		if member (op(0,expr), {Operator_}) then
			newidx := grF_checkTermIndices (op(2,expr)):
			idx := grF_appendIdx(newidx, idx):
		fi:

	elif type(expr,`*`) or type(expr,`+`) or type(expr,function) then
		for a in expr while idx<>-1 do
			# Sym and Asym function will have an argument list as the first entry, just skip
			if type(a, list) then
				 next;
			fi:
			# recurse through each term in the expression 
			newidx := grF_checkTermIndices (a):
			idx := grF_appendIdx(newidx, idx):
		od:
	fi:

	#
	# indices that appear in both the up and down set
	# are dummy/summation indices and are removed
	#
	if idx[1]<>-1 then
		upset := {op(op(1,idx))}:
		dnset := {op(op(2,idx))}:
		dummyset := upset intersect dnset:
		upset := upset minus dummyset:
		dnset := dnset minus dummyset:
		idx := [[op(upset)],[op(dnset)]]:
	fi:
	RETURN ( idx ):
end:

#-----------------------------------------------------------------
# grF_getTermIndices
# Get the listing indices for a terminating object (i.e. we are at
# a leaf of a expression/function chain and we can just take the
# indices)
#-----------------------------------------------------------------
grF_getTermIndices := proc ( expr_in )
DEBUG
local pos, idx, upidx, dnidx, a, expr:
	expr := expr_in;
	upidx := NULL:
	dnidx := NULL:
	if type (expr, function) then
		if op(0,expr)=Tensor_ then
			pos := op(2,expr):
			idx := op(3,expr):
			for a to nops(pos) do
				if member(pos[a], {up,cup,bup,pup,cbup,pbup}) then
					if member(idx[a],{upidx}) then
						# exiting on a repeated index in the same position - illegal
						RETURN ([-1,idx[a]]):
					else
						upidx := upidx, idx[a]:
					fi:
				elif member(pos[a], {dn,cdn,bdn,pdn,cbdn,pbdn}) then
					if member (idx[a], {dnidx}) then
						# exiting on a repeated index in the same position - illegal
						RETURN ([-1,idx[a]]):
					else
						dnidx := dnidx, idx[a]:
					fi:
				fi:
			od:
		elif op(0,expr)=Operator_ then
			pos := op(3,expr):
			idx := op(4,expr):
			for a to nops(pos) do
				if member(pos[a], {up,cup,bup,pup,cbdn,pbdn}) then
					if member(idx[a],{upidx}) then
						RETURN ([-1,idx[a]]):
					else
						upidx := upidx, idx[a]:
					fi:
				elif member(pos[a], {dn,cdn,bdn,pdn,cbdn,pbdn}) then
					if member (idx[a], {dnidx}) then
						RETURN ([-1,idx[a]]):
					else
						dnidx := dnidx, idx[a]:
					fi:
				fi:
			od:
		elif op(0,expr)=kdelta then
			upidx := op(op(3,op(1,expr))):
			dnidx := op(op(3,op(2,expr))):
		else
			printf("Unrecognized terminal object: %a\n", expr);
			#ERROR("Cannot get term indices for %a", op(0,expr));
		fi:
	else 
		 # this may be ok if defining a scalar
		 a := 0; # dummy assignment 
	fi:
	RETURN ([[upidx],[dnidx]])
end:

#------------------------------------------
# grF_strToDef( sdef, defLHS )
#
# Return a functional definition for sdef.
# defLHS is true if the string is the LHS of
# the tensordefinition.
#
# Basic idea:
# Find tensors based on {} and map these into a
# Tensor_() expression of the form:
#   Tensor_( name, [indices], [index_types], aux_metric)
#			- aux_metric is usually zero
# Sym and Asym operators are applied on exit to expand functions
#	- these are defined in def_fns.mpl
#------------------------------------------

grF_strToDef := proc( sdef, defLHS )
DEBUG
global grG_symList, grG_asymList;

 local work, workStr, brktList, indices,
	i, retExpr, iTypeSeq, iListSeq, inTensor,
	start, tName, gnum, gname, addToOperator,kdelta1, kdelta2,
	foundscalar, workTrim, newiList:

	uses StringTools;

	grG_symList := []:
	grG_asymList := []:


 work := sdef:
 workStr := grF_stringify( sdef):
 #
 # check to see if we have been passed a list (i.e. Maple
 # list and not string format at all)
 # 
 # (We need this since grdef now calls this routine directly)
 #
 #workTrim := StringTools:-Trim(workStr):
 if workStr[1] = "[" then
		 if traperror( parse( sdef)) <> lasterror then
			 # parse ok, so it is Maple syntax
			 RETURN( parse( sdef)):  # Exit here
		 else
			 ERROR("could not parse RHS");
		 fi:
 fi:

 #
 # first do Sym and Asym so that e.g.
 # xi{(a;b)} is handled properly
 #
 #

 #
 # Why are these commands repeated so many times??? Surely there
 # is a more sensible way to do this. DP.
 #
 # pass 1 does Sym expansions of tensors
 # pass 2 does Asym
 #
 brktList := grF_brktFind( workStr, "{", "}"):

 indices := grF_indexFind( workStr, brktList):

 # operates on workStr (awkward use returnable param)
 grF_doSym( workStr, indices, brktList, `Sym`):

 # now need to re-detect the brkt to do Asym
 work := grF_unstringify( workStr):
 workStr := grF_stringify( work):
 brktList := grF_brktFind( workStr, "{", "}"):
 indices := grF_indexFind( workStr, brktList):
 grF_doSym( workStr, indices, brktList, `Asym`):
 work := grF_unstringify( workStr):

 #
 # tidy up the string and find the indices
 #
 workStr := grF_stringify( grF_unstringify( workStr)):
 brktList := grF_brktFind( workStr, "{", "}"):
 indices := grF_indexFind( workStr, brktList):

 # build a set of index names for screening below
 # failed idea -> remove?
 indexSet := {}:
 for i to workStr[0] do
 		if indices[i] <> 0 then
 			indexSet := indexSet union {convert(workStr[i],name)}:
 		fi:
 	od:

 inTensor := false:
 addToOperator := false:
 foundscalar := false:

 #
 # Now sift through the string and put in Tensor_
 # and Operator_ functions
 #
 
 for i to workStr[0] do
	 #
	 # TENSOR ?
	 # If it's the beginning or end of a tensor, handle it.
	 #
	 #printf("workStr: %a type=%a\n", workStr[i], whattype(workStr[i]) );
	 if workStr[i] = "{" then
			 #
			 # Entered a tensor expression
			 # start some book keeping
			 #
			 iTypeSeq := NULL:
			 iListSeq := NULL:
			 start := i:
			 workStr[i] := "(":
			 inTensor := true:

	 elif workStr[i] = "}" then
			#
			# End of a tensor expression or indices to be added to
			# an operator.
			#
			# Generate a Tensor_ function. i.e.
			#   g{a b} -> Tensor( g, [dn,dn], [a,b], 0)
			#
			# [trailing integer indicates auxilaary metric number]
			#
			if not addToOperator then
				workStr[i] := "":
				inTensor := false:
				if workStr[start-1] = ">" then
					 if workStr[start-3] <> "<" then
						 ERROR(`Error in angle brackets.`):
					 fi:
					 #
					 # not for the default metric
					 #
					 gnum := parse( workStr[start-2]): # convert string to integer
					 workStr[start-1] := "";
					 workStr[start-2] := "";
					 workStr[start-3] := "";
					 tName := workStr[start-4]:
					 workStr[start-4] := "":
				 else
					 tName := workStr[start-1]:
					 gnum := 0:
				 fi:
				 #
				 # change e.g  `R`, `{`, `a`, `b`, `}` to
				 #  `Tensor_( R, [dn,dn], [a,b])`
				 #
				 # Note: This is converting the iList to names 
				 # (so explicit  3 -> `3`)  PM2016
				 newiList := []:
				 for index in iListSeq do
						 if type(index, integer) then
								newiList := [op(newiList), index]
						 else
								newiList := [op(newiList), convert(index, name)]:
						 fi:
				 od:
				 # breaks in Maple 18?
				 workStr[start-1] := convert( cat(`Tensor_(`, tName,`,`,
							convert( [iTypeSeq], string),`,`,
							convert(newiList,string),`,`,gnum,`)`) ,name):
			else # add indices to the end of an Operator
				 # PM2017 - convert indices to names
				 newiList := []:
				 for index in iListSeq do
						 if type(index, integer) then
								newiList := [op(newiList), index]
						 else
								newiList := [op(newiList), convert(index, name)]:
						 fi:
				 od:
				 workStr[i] := convert( cat( convert( [iTypeSeq], string),`,`,
								convert( newiList, string),`)`), name):
				 addToOperator := false:
				 inTensor := false:

			fi:

	 #
	 # OPERATORS e.g.
	 #
	 #  Op[operandSeq]{a b} -> Operator(Op, operandSeq, [dn,dn],[a,b]):
	 #
	 # Second clause in Boolean is to prevent Sym([ from being
	 # picked up as an operator. Actually any array reference
	 # will get treated like an operator...
	 #
	 elif workStr[i] = "["
		 and workStr[i-1] <> "(" then
		 workStr[i-1] := cat(`Operator_(`,workStr[i-1]):
		 workStr[i] := ",":

	 elif workStr[i] = "]" then
		 if not (workStr[0] > i and workStr[i+1] = ",") then
			 if i < workStr[0] and workStr[i+1] = "{" then
				 addToOperator := true:
				 workStr[i] := ",":
			 else
				 workStr[i] := ",[],[])": # no indices
			 fi:
		 fi:

	 #
	 # SCALAR (but need to make sure no added cdn indices, so
	 # test if next char [if it exists] is a { )
	 #
	 elif not inTensor then
		 if traperror (grF_checkIfDefined (convert(workStr[i],name), create)) = NULL then
			 #
			 # check not followed by { (i.e. R{;a}) or [ (i.e. operator)
			 #
			 if not( (i < workStr[0]) and
							(workStr[i+1] = "[" 
						or workStr[i+1] = "{")) then
				 #
				 # found a GRT scalar
				 #
				 gnum := 0:
				 if i+2 < workStr[0] and  workStr[i+1] = "<" then
					 #
					 # not for the default metric
					 #
					 gnum := parse( workStr[i+2]):
					 workStr[i+1] := ``;
					 workStr[i+2] := ``;
					 workStr[i+3] := ``;
				 fi:
				 workStr[i] := convert( cat(`Tensor_(`, workStr[i],`,`,
					 `[],[],`, convert(gnum,string),`)` ), name):  
			 fi:
		 fi:
		 #
		 # PM2016 - check if indices appear in expressions - make user pick new ones
		 # failed idea...
		 #expr := eval(convert(workStr[i], name)):
		 #printf("check expr %a for %a\n", expr, indexSet):
		 #if has(expr, indexSet) then
		 #		ERROR(sprintf("The expression %a contains one of the indices %a\nPlease choose a different index.\n", expr, indexSet)):
		 #fi:

	 fi:

	 #
	 # may be tidier to just convert these to grF_DIFF here and
	 # remove the code to do this from parseExpr.
	 #
	 if workStr[i] = "diff" then workStr[i] := "DIFF": fi:
	 if workStr[i] = "int" then workStr[i] := "INT": fi:

	 #
	 # clear all the junk inside {} and accumulate indices
	 #
	 if indices[i] <> 0 and inTensor then
	 #
	 # add the index name and type to the running list for
	 # this tensor
	 #
	 iTypeSeq := iTypeSeq, indices[i]:
	 iListSeq := iListSeq, workStr[i]:
	 workStr[i] := "":

	 fi: # if an index

	 if inTensor then
	 workStr[i] := "":
	 fi:

 od:
 #
 # now take the string, make it into an expression
 # and parse it (catching errors if necessary)
 #
 work := StringTools:-DeleteSpace(grF_unstringify( workStr)):
 #work := grF_unstringify( workStr):

 retExpr := traperror( parse( work) ):
 if retExpr = lasterror then
	#
	# parse caught an error
	#
	printf ("Parse could not create a functional expression for:\n"):
	printf ("  %a\n", work):
	printf ("Please recheck the definition.\n"):
	ERROR (`parse() failed`):
 fi:
 #
 # explicitly eval() since want Sym, CoD calls etc. to be invoked
 #

 RETURN( eval(retExpr)):

end:

#------------------------------------------
# grF_strToObject
#
# Given e.g. `R{a b}` return R(dn,dn)
#
#------------------------------------------

grF_strToObject := proc( objectStr)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local expr, object:

 expr := grF_strToDef( objectStr);
 if not op(0, expr) = Tensor_ then
	 ERROR(`Could not convert `,objectStr,` to an object name.`):
 fi:
 if nops( op(2,expr)) > 0 then
	 object := op(1,expr)(op(op(2,expr))):
 else
	 object := op(1,expr)
 fi:
 object;

end:

#------------------------------------------
# grF_unstringify( s : STRING)
#
# Return the string corresponding to <s>.
#------------------------------------------

grF_unstringify := proc ( inStr)
DEBUG
 local returnStr, i:

 # convert inStr back to a string

 returnStr := inStr[1]:

 for i from 2 to inStr[0] do
	 returnStr := cat( returnStr,` `,inStr[i]):
 od:
 RETURN( returnStr):
end:

$undef DEBUG

