##*************************************************************************
#
# GRTENSOR II MODULE: makeg.mpl
#
# (C) 1992-1999 Peter Musgrave, Kayll Lake, Denis Pollney
#
#Date:       	Description:
# 28 Jan 1994 	Created.
#  1 Feb 1994	Basic functionality finished.
#  2 Feb 1994	Added diffConstraints. If not equation error handling doesn't
#			work properly. BUG
#  2 Mar 1994	Added _ to variables in output file.
# 18 May 1994	Added tetrad entry option. [dp]
# 30 Jun 1994   Added algebraic constraints [pm]
# 13 Sep 1994   Fixed algebraic constraints [pm]
# 19 Sep 1994   Only constraints from now on [pm]
# 11 Dec 1994   Use convert(hostfile) [pm]
# 10 Mar 1995   Fairly major re-write, add dual bases, clean up code [dp]
# 31 Mar 1995   Add a newline after Info [pm]
# 20 Nov 1995   Assign cross references across diagonal in grF_initip [dp]
# 27 Nov 1995	Add grG_checkNullTetrad to verify whether tetrad is null [dp]
#  9 May 1996   Add option to load w/o saving [pm]
# 22 Aug 1996	Add initialization of signature [dp]
# 14 Nov 1996	Improve error checking on input [dp]
#  4 Feb 1997	Replace 0,0 checks with checkIfAssigned [dp]
#  5 Feb 1997	Added prompts for complex-valued quantities in metric [dp]
#  5 Feb 1997   Calculate mbar from m using conj() [dp]
#  5 Feb 1997   Add `default value' as second argument to my_readstat [dp]
# 24 Feb 1997	Fix printout of warning message in my_readstat [dp]
# 16 Apr 1997	Switch all lprint()s to printf()s [dp]
# 12 Jun 1997   Remove 4-d dependence in displaybasisv [dp]
# 16 Sep 1997	Fix error-checking in getds() and allow single term ds[dp]
#  5 Dec 1997	Changed location of complex_ in metric file [dp]
# 14 Feb 1998   Switch convert(x,string) to convert(x,name) for R5 [dp]
# 29 Apr 1999   Added ability to enter basis vectors as differentials [dp]
# 18 Aug 1999   Switched readstat and grF_my_readstat to grF_readstat [dp]
# 20 Aug 1999   Changed use of " to ` for R4 compatibility [dp]
# 15 Sep 2016   Change input to use grF_inputFn. [pm]
#
#*************************************************************************


#-------------------------------------------------------------------
# These routines make some use of a structure, G.
# G has the following sub-elements:
#	G.gname  := name of metric/basis.
#	G.gdim   := dimension of entry.
#	G.sig	 := signature of spacetime
#	G.coord  := coordinates
#       G.complex:= set of complex coordinates
#	G.gtype  := type of entry = { grG_g, grG_ds, grG_basis, grG_np}
#	G.basisu := contravariant components of the basis, if they exist; or
#		    0 if they do not.
#	G.basisd := covariant components of the basis, if they exist; or
#		    0 if they do not.
#	G.metric := components of metric for gtype = {grG_g or grG_ds}; or
#		    components of basis inner product for gtype =
#                   {grG-basis, or grG_np}.
#
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# makeg.
#-------------------------------------------------------------------
makeg := proc ()
global  complexSet_:
local	G, happy, abort, response, coords, metrictype, bases, metricdir,
  stsig,  
   G_basisd,
   G_basisu,
   G_basisip, 
   G_complex,
   G_constraint,
   G_coord, 
   G_gname,
   G_info,
   G_sig,
   G_gtype,
   G_gdim,
   G_metric;
global
   grOptionMetricPath:

   if not type (grOptionMetricPath, string) then
      printf("grOptionMetricPath is not assigned\n");
      printf("Please assign a value where metrics can be saved\n");
      printf("   grOptionMetricPath := \"<filepath>\";\n");
      return;
   fi:

printf ( `\n \nMakeg 2.0: GRTensor metric/basis entry utility\n \n` ):
printf ( `To quit makeg, type 'exit' at any prompt.\n \n` ):

#
# Set metric name and type.
#
if nargs < 1 then 
	ERROR ( `Missing metric name parameter.`):
fi:
if nargs = 2 then
	metricdir := args[2]:
else
	metricdir := grOptionMetricPath:
fi:

G_gname := grF_setgname ( args[1] ):
G_gtype := grF_setgtype( gtypeList ):

#
# Set coordinates and dimension.
#
coords := 'coords':
while not assigned ( coords ) do
	coords := grF_getcoords():
	if G_gtype = grG_np and nops ( coords ) <> 4 then
		print ( `NP tetrads must have four coordinates.` ):
		coords := 'coords':
	fi:
od:
G_coord := coords:
G_gdim := nops ( coords ):

stsig := 'stsig':
if grOptionLLSC = false and not G_gtype = grG_np then
	while not assigned ( stsig ) do
		stsig := grF_getsig ( nops ( coords ) ):
	od:
fi:

if not assigned ( stsig ) then
  if G_gtype = grG_np then
    stsig := -2:
  else
    stsig := 2:
  fi:
fi:

if assigned ( stsig ) then
	G_sig := stsig:
else
	G_sig := evaln ( G_sig ):
fi:
#
# Get input based on type of metric.
#
G_metric := 0:
G_basisu := 0:
G_basisd := 0:
if G_gtype = grG_g then
	G_metric := grF_getg ( G_gdim, G_coord ):
elif G_gtype = grG_ds then
	G_metric := grF_getds ( G_gdim, G_coord ):
elif G_gtype = grG_basis then
	bases    := grF_promptbasisv  ( G_gdim, G_gtype, G_coord ):
	G_basisu := bases[1]:
	G_basisd := bases[2]:
	G_metric := grF_getbasisip ( G_gdim, G_coord ):
elif G_gtype = grG_np then
	bases    := grF_promptbasisv  ( G_gdim, G_gtype, G_coord ):
	G_basisu := bases[1]:
	G_basisd := bases[2]:
	G_metric := array ( 1..4, 1..4, [[0,1,0,0], [1,0,0,0], [0,0,0,-1], [0,0,-1,0] ] ):
else
   printf("Unknown type %a", G_gtype);
   return;
fi:

if not G_gtype = grG_np then
  complexSet_ := grF_getcomplex ( G_coord ):
fi:
G_complex := complexSet_:


happy := false:
abort := false:
while not happy do
	grF_displayEntry ( G_basisd,
					   G_basisu,
					   G_basisip, 
					   G_complex,
					   G_constraint,
					   G_coord, 
					   G_info,
					   G_gtype,
					   G_gdim,
					   G_metric ):
	response := grF_getdisplayResponse ( G_gtype, G_basisd, G_basisu ):
	if response = newmetric then
		G_metric := grF_getg ( G_gdim, G_coord ):
	elif response = newbasisuv then
		G_basisd := grF_getbasisv ( G_gdim, G_gtype, G_coord,  1 ):
	elif response = newbasisdv then
		G_basisu := grF_getbasisv ( G_gdim, G_gtype, G_coord, -1 ):
	elif response = newbasisip then
		G_metric := grF_getbasisip ( G_gdim ):
	elif response = correctmetric then
		G_metric := grF_correctmetric ( G_metric, G_coord ):
	elif response = correctbasisuv then
		G_basisu := grF_correctbasisv ( G_gdim, G_gtype, G_basisu, G_coord ):
	elif response = correctbasisdv then
		G_basisd := grF_correctbasisv ( G_gdim, G_gtype, G_basisd, G_coord ):
	elif response = addconstraints then
		G_constraint := grF_addconstraints():
	elif response = addtext then
		G_info := grF_addtext():
	elif response = saveEntry then
		grF_saveEntry ( metricdir,
					    G_gdim, 
						G_gname, 
						G_gtype, 
						G_coord,
						G_constraint, 
						G_complex,
						G_info,
						G_metric,
						G_sig, 
						G_basisd,
						G_basisu):

		happy := true:
    elif response = useEntry then
                grF_usemetric( G_gdim, 
						G_gname, 
						G_gtype, 
						G_coord,
						G_constraint, 
						G_complex,
						G_info,
						G_metric,
						G_sig, 
						G_basisd,
						G_basisu):
                happy := true:
                abort := true;
	else
		printf ( `makeg() aborted at user's request.\n` ):
		happy := true: 
		abort := true:
	fi:
od:

if not abort then
	response := grF_makeg_input (`Do you wish to use this spacetime in the current session?\n(1=yes [default], other=no): `, 1):
	if response = 1 then
		printf ( `Initializing: %a\n`, G_gname ):
		grF_usemetric ( G_gdim, 
						G_gname, 
						G_gtype, 
						G_coord,
						G_constraint, 
						G_complex,
						G_info,
						G_metric,
						G_sig, 
						G_basisd,
						G_basisu ):
	fi:
fi:

printf ( `makeg() completed.\n` ):
end:

#-------------------------------------------------------------------
# getdisplayResponse
#-------------------------------------------------------------------
grF_getdisplayResponse := proc ( G_gtype, G_basicd, G_basisu )
local	choice, choices, selection, vtype, ambiguity1, ambiguity2, s:
	
	s := `Internal error`:

	if G_gtype = grG_g or G_gtype = grG_ds then
		s := sprintf ( `You may choose to:\n`);
		s := cat(s, sprintf ( `   0) Use the metric WITHOUT saving it,\n` )):
		s := cat(s, sprintf ( `   1) Save the metric as it is,\n` )):
		s := cat(s, sprintf ( `   2) Correct an element of the metric,\n` )):
		s := cat(s, sprintf ( `   3) Re-enter the metric,\n` )):
		s := cat(s, sprintf ( `   4) Add/change constraint equations, \n` )):
		s := cat(s, sprintf ( `   5) Add a text description, or\n` )):
		s := cat(s, sprintf ( `   6) Abandon this metric and return to Maple.\n` )):
		choices := [ useEntry, saveEntry, correctmetric, newmetric, addconstraints, addtext, abandon ]:

	elif G_gtype = grG_basis then
		s := sprintf ( `You may choose to:\n`);
		s := cat(s, sprintf ( `   0) Use the metric WITHOUT saving it,\n` )):
		s := cat(s, sprintf ( `   1) Save the metric as it is,\n` )):
		s := cat(s, sprintf ( `   2) Re-enter a basis vector,\n` )):
		s := cat(s, sprintf ( `   3) Re-enter the inner product,\n` )):
		s := cat(s, sprintf ( `   4) Add/change constraints,\n ` )):
		s := cat(s, sprintf ( `   5) Add a text description, or\n` )):
		s := cat(s, sprintf ( `   6) Abandon this metric and return to Maple.\n` )):
		if G_basisu<>0 and G_basisd=0 then
			choices := [ useEntry,saveEntry, correctbasisuv, newbasisip, addconstraints, addtext, abandon ]:
		elif G_basisd<>0 and G_basisu=0 then
			choices := [ useEntry,saveEntry, correctbasisdv, newbasisip, addconstraints, addtext, abandon ]:
		else
			choices := [ useEntry,saveEntry, correctbasisv, newbasisip, addconstraints, addtext, abandon ]:
		fi:
	
	elif G_gtype = grG_np then
		s := sprintf ( `You may choose to:\n`);
		s := cat(s, sprintf ( `   0) Use the metric WITHOUT saving it,\n` )):
		s := cat(s, sprintf ( `   1) Save the metric as it is,\n` )):
		s := cat(s, sprintf ( `   2) Re-enter a basis vector,\n` )):
		s := cat(s, sprintf ( `   3) Add/change constraints,\n` )):
		s := cat(s, sprintf ( `   4) Add a text description, or\n` )):
		s := cat(s, sprintf ( `   5) Abandon this metric and return to Maple.\n` )):
		choices := [ useEntry, saveEntry, correctbasisv, addconstraints, addtext, abandon, nil ]:
	fi:
	choice := 'choice':
	while not assigned ( choice ) do
		choice := grF_makeg_input(s, []):
		if not member ( choice, {0,1,2,3,4,5,6,7} ) then 
			selection := nil:
		else
			selection := choices[choice+1]:
		fi:
		if selection = nil then
			printf ( `Invalid input.\n` ):
			choice := 'choice':
		fi:
	od:
	if selection = correctbasisv then
		ambiguity1 := G_basisu=0 and G_basisd=0:
		ambiguity2 := not ( G_basisu=0 or G_basisd=0 ):
		if ambiguity1 or ambiguity2 then
			while not assigned ( vtype ) do
				s := sprintf ( `Would you like to correct a 1) covariant vector, or\n` ):
				s := cat(s, sprintf(`                            2) contravariant vector?`)):
				vtype :=  grF_makeg_input ( s, [] ):
				if not member ( vtype, { 1, 2 } ) then
					printf ( `Invalid input. Please enter either 1 or 2.\n` ):
					vtype := 'vtype':
				fi:
			od:
		elif G_basisu=0 then
			vtype = 1:
		elif G_basisd=0 then 
			vtype = 2:
		fi:
		if vtype = 1 then 
			selection := correctbasisdv:
		else
			selection := correctbasisuv:
		fi:
	fi:

RETURN ( selection ):
end:

#-------------------------------------------------------------------
# getg.
#-------------------------------------------------------------------
grF_getg := proc ( gdim, coord )
local a, b, diag, metric, s:
	metric := array ( 1..gdim, 1..gdim ):
	while not assigned ( diag ) do
		s := sprintf ( `Is the metric :\n`):
		s := cat(s, sprintf(` 1) Diagonal\n` )):
		s := cat(s, sprintf(` 2) Symmetric\n` )):
		diag := grF_makeg_input ( s, 2 ):
		if not member (diag, {1, 2}) then
			printf ( `Invalid input. Please enter 1 or 2. [default=2]: \n` ):
			diag := 'diag':
		fi:
	od:
	if diag = 1 then
		for a to gdim do
			for b from a+1 to gdim do
				metric[a,b] := 0:
				metric[b,a] := 0:
			od:
		od:
		for a to gdim do
			metric[a,a] := grF_getmetricelement ( a, a, coord[a], coord[a] ):
		od:
	else
		for a to gdim do
			for b from a to gdim do
				metric[a,b] := grF_getmetricelement ( a, b, coord[a], coord[b] ):
				metric[b,a] := metric[a,b]:
			od:
		od:
	fi:
RETURN ( metric ):
end:

#-------------------------------------------------------------------
# getds.
#-------------------------------------------------------------------
grF_getds := proc ( gdim, coord )
local	ds, metric, i, j, cmpt, happy, divby, symfac, tlist, s:
	happy := false:
	while not happy do
		happy := true:
 		metric := array(1..gdim,1..gdim,[seq([seq(0,i=1..gdim)],i=1..gdim)]);
 		s := sprintf ( `Enter the line element using d[coord] to indicate differentials.\n` );
 		s := cat(s, sprintf(`(for example,  r^2*(d[theta]^2 + sin(theta)^2*d[phi]^2)\n`));
 		s := cat(s, sprintf(`[Type 'exit' to quit makeg]\n`));

 		ds := grF_makeg_input (s, []);

  		#
  		# now expand ds^2 and sift through picking out terms
  		# and putting them in the metric array
  		#
  		ds := expand(ds):
### WARNING: note that `I` is no longer of type `^`
  		if type ( ds, `*` ) or type ( ds, `^` ) then
			tlist := [ds]:
		else
			tlist := [op(ds)]:
  		fi:
  		for i in tlist do
    			divby := 2;
		        cmpt := NULL:
			for j to gdim do
				if has(i, d[coord[j]]) then
					if has ( i, d[coord[j]]^2 ) then
						cmpt := cmpt, j, j:
		                                symfac := 1:
		                       else
						cmpt := cmpt, j;
		                                symfac := 1/2:
		                        fi:
		      		fi:
		    	od:
    			if nops ( [cmpt] ) <> 2 then
       				printf(`Error - the following term is not quadratic in d[]: %a\n`, i );
       				happy := false;
       				break;
    			else
       				metric[cmpt] := metric[cmpt] + symfac*i/(d[coord[op(1,[cmpt])]]*d[coord[op(2,[cmpt])]]);
       				if op(1,[cmpt])<>op(2,[cmpt]) then
         				metric[op(2,[cmpt]),op(1,[cmpt])] := metric[cmpt]:
                                fi:
    			fi:
 		 od:
 	od:
RETURN ( metric ):
end:



#-------------------------------------------------------------------
# promptbasisv.
#-------------------------------------------------------------------
grF_promptbasisv := proc ( gdim, gtype, coord )
local 	vtype, basisu, basisd, s:
	while not assigned ( vtype ) do
		s := sprintf ( `Would you like to enter:\n`);
		s := cat(s, sprintf ( ` 1) covariant components,\n` )):
		s := cat(s, sprintf ( ` 2) contravariant components, or\n` )):
		s := cat(s, sprintf ( ` 3) both.` )):
		vtype := grF_makeg_input ( s, [] ):
		if not member ( vtype, {1,2,3} ) then
			printf ( `Invalid input. Please enter 1, 2, or 3.\n` ):
			vtype := 'vtype':
		fi:
	od:
	if vtype = 1 then
		basisd := grF_getbasisv ( gdim, gtype, coord, -1 ):
		basisu := 0:
	elif vtype = 2 then
		basisd := 0:
		basisu := grF_getbasisv ( gdim, gtype, coord,  1 ):
	else
		basisd := grF_getbasisv ( gdim, gtype, coord, -1 ):
		basisu := grF_getbasisv ( gdim, gtype, coord,  1 ):
	fi:
RETURN ( [basisu, basisd] ):
end:

#-------------------------------------------------------------------
# getcomplex
#-------------------------------------------------------------------
grF_getcomplex := proc( coord )
global complexSet_:
local complexSet, complexCoords, tmpSet, a, s:
    while not assigned ( complexSet ) do
		s := sprintf ( `\nIf there are any complex valued coordinates, constants or functions\n` ):
		s := cat(s, sprintf ( `for this spacetime, please enter them as a SET ( eg. { z, psi } ).\n` )):
		s := cat(s, sprintf ( `\nComplex quantities [default={}]: ` )):
		complexSet := grF_makeg_input ( s, {} ):
		if not type ( complexSet, set ) and not type ( complexSet, list ) then
		    printf ( `Invalid input. Please enter the values as a SET.\n` ):
		    complexSet := 'complexSet':
		else
		    complexCoords := {op(complexSet)} intersect {op(coord)}:
		    if complexCoords <> {} then
				tmpSet := complexSet_:
				complexSet_ := complexSet:
				for a in complexCoords do
				    if not member ( conj(a), {op(coord)} ) then
						printf ( `Warning: You have specified %a as a coordinate, but not its conjugate, conj(%a). For this spacetime, %a will be regarded as a Real.\n`, a, a, a ):
						complexSet := {op(complexSet)} minus {a}:
				    fi:
				od:
				complexSet_ := tmpSet:
		    fi:
		    tmpSet := complexSet:
		    complexSet := {}:
		    for a in tmpSet do
				if type ( a, function ) then
				    complexSet := complexSet union {op ( 0, a )}:
				else
				    complexSet := complexSet union {a}:
				fi:
		    od:
        fi:
    od:
    RETURN ( {op(complexSet)} ):
end:

#-------------------------------------------------------------------
# getbasisv.
#-------------------------------------------------------------------
grF_getbasisv := proc ( gdim, gtype, coord, vtype )
global	complexSet_:
local	i, j, vec, vname, basis, vstr, mbar:
	basis := array ( 0..gdim, 0..gdim ):
	if gtype = grG_basis then
		vname := [ seq ( i, i=1..gdim ) ]:
	else
		vname := [ `l`, `n`, `m` ]:
	fi:
	if vtype = -1 then 
		vstr := `covariant`:
	else
		vstr := `contravariant`:
	fi:
	for i to nops(vname) do 
		vec := 'vec':
		while not assigned ( vec ) do
			vec := grF_makeg_input ( `Enter the `||vstr||
			` components of basis vector '`||(vname[i])||`' as a LIST (eg. [1,0,0,0]) or differential (eg. d[x] + d[y]):`, [] ):
			if type (vec, algebraic) then
			        vec := grF_algfun2vector (gdim, vec, coord):
			fi:
			if not type ( vec, list ) then
 			        printf ( `Invalid input. Please enter the vector as a LIST or differential.\n` ):
				vec := 'vec':
			fi:
		od:
		for j to gdim do basis[i,j] := vec[j] od:
	od:
	if gtype = grG_np then
	    complexSet_ := grF_getcomplex ( coord ):
	    mbar := grF_calcmbar ( vec, coord ):
	    for j to 4 do
		basis[4,j] := mbar[j]:
	    od:
	fi:
RETURN ( basis ):
end:

#-------------------------------------------------------------------
# calcmbar
#-------------------------------------------------------------------
grF_calcmbar := proc ( m, coord )
local mbar, found, a, i1, i2:
    if ({op(coord)} intersect complexSet_) = {} then
	mbar := array ( 1..4, [seq ( conj(m[a]), a=1..4 )] ):
    else
	found := false:
	for a to 4 while not found do
	    if member ( coord[a], complexSet_ ) then
		i1 := a:
	    elif member ( conj(coord[a]), complexSet_ ) then
		i2 := a:
	    fi:
	od:
	if assigned ( i1 ) and assigned ( i2 ) then
	    for a to 4 do
		if a = i1 then
		    mbar[a] := conj ( m[i2] ):
		elif a = i2 then
		    mbar[a] := conj ( m[i1] ):
		else
		    mbar[a] := conj ( m[a] ):
		fi:
	    od:
	else
	    ERROR ( `Could not resolve complex coordinates.` ):
	fi:	
    fi:
    RETURN ( mbar ):
end:

#-------------------------------------------------------------------
# getbasisip.
#-------------------------------------------------------------------
grF_getbasisip := proc ( gdim, gtype )
local a, b, diag, metric:
	metric := array ( 1..gdim, 1..gdim ):
	while not assigned ( diag ) do
		s := sprintf ( `Is the basis inner product:\n`):
		s := cat(s, sprintf(` 1) Diagonal\n` )):
		s := cat(s, sprintf(` 2) Symmetric\n`)):
		diag := grF_makeg_input( s, []):
		if diag<1 or diag>2 then
			printf ( `Invalid input. Please enter 1 or 2.\n` ):
			diag := 'diag':
		fi:
	od:
	if diag = 1 then
		for a  to gdim do
			for b from a+1 to gdim do
				metric[a,b] := 0:
				metric[b,a] := 0:
			od:
		od:
		for a to gdim do
			metric[a,a] := grF_getipelement ( a, a ):
		od:
	else
		for a to gdim do
			for b from a to gdim do
				metric[a,b] := grF_getipelement ( a, b ):
				metric[b,a] := metric[a,b]:
			od:
		od:
	fi:
RETURN ( metric ):
end:

#-------------------------------------------------------------------
# correctmetric.
#-------------------------------------------------------------------
grF_correctmetric := proc ( metric, coord )
local	a, e1, e2, new_element, val, etype, enops:
	new_element := 'new_element':
	while not assigned ( new_element ) do
		new_element := grF_makeg_input ( `Which element do you wish to correct? (eg. [r,theta])`, []):
		etype := traperror ( type ( new_element, list ) ):
		if etype=lasterror or not etype then
			printf ( `Invalid input. Please enter two coordinate names as a list.\n` ):
			new_element := 'new_element':
		else
			enops := traperror ( nops ( new_element ) ):
			if enops=lasterror or enops<>2 then
				printf ( `Invalid input. Please enter two coordinate names as a list.\n` ):
				new_element := 'new_element':
			else
			    if type ( new_element[1], integer )
			        and ( new_element[1] > 0 )
			        and ( new_element[1] <= nops(coord) ) then
				e1 := new_element[1]:
			    fi:
			    if type ( new_element[2], integer )
			        and ( new_element[2] > 0 )
			        and ( new_element[2] <= nops(coord) ) then
				e2 := new_element[2]:
			    fi:
			    if not assigned ( e1 ) or not assigned ( e2 ) then
				for a to nops(coord) do
				  if new_element[1] = coord[a] then e1 := a fi:
				  if new_element[2] = coord[a] then e2 := a fi:
				od:
			    fi:
			    if not assigned ( e1 ) or not assigned ( e2 ) then
			        printf ( `Entries are not coordinates specified for this metric.\n` ):
			        new_element := 'new_element':
			    fi:
			fi:
		fi:
	od:
	printf ( `Current value:\n` ):
	print  ( g[new_element[1]]*``[new_element[2]] = metric[e1,e2] ):
	metric[e1,e2] := grF_makeg_input ( `New value:`, [] ):
	metric[e2,e1] := metric[e1,e2]:
RETURN ( metric ):
end:

#-------------------------------------------------------------------
# correctbasisv.
#-------------------------------------------------------------------
grF_correctbasisv := proc ( gdim, gtype, basis, coord )
local	vinput, npvector, new_vector, a, e1, v, val, s:
	if gtype = grG_np then
		vinput := `(l,n,m,mbar)`:
		npvector := [l,n,m,mbar]:
	else 
		vinput := `(1..4)`:
	fi:
	new_vector := 'new_vector':
	while not assigned ( new_vector ) do
		new_vector := grF_makeg_input ( `Which vector do you wish to correct?`||vinput, [] ):
		if gtype = grG_basis then
			if new_vector<1 or new_vector>gdim then
				printf ( `Invalid input. Please enter a value from the set %a.\n`, vinput ):
				new_vector := 'new_vector':
			fi
		else
			if not member ( new_vector, {l,n,m,mbar} ) then
				printf ( `Invalid input. Please enter a value from the set %a.\n`, vinput ):
				new_vector := 'new_vector':
			fi
		fi:
	od:
	if gtype = grG_np then
		for a to nops(coord) do
			if new_vector = npvector[a] then e1 := a fi:
		od:
	else
		e1 := new_vector:
	fi:
	v := array ( 1..gdim ):
	for a to gdim do
		v[a] := basis[e1,a]:
	od:
	printf ( `Current vector:\n` ):
	if gtype = grG_np then
		print ( npvector[e1] = eval ( v ) ):
	else
		print ( e[e1] = eval ( v ) ):
	fi:
	val := 'val':
	printf ( `New vector:\n` ):
	while not assigned ( val ) do
		val := grF_makeg_input ( ``, [] ):
		if not type ( val, list ) or nops ( val ) <> gdim then
			print ( `Invalid input. Entry must be a LIST of dimension`||gdim||`.` ):
			val := 'val':
		fi:
	od:
	for a to gdim do
		basis[e1,a] := val[a]:
	od:
	RETURN ( basis ):
end:

#-------------------------------------------------------------------
# addconstraints.
#-------------------------------------------------------------------
grF_addconstraints := proc ()
local	constraint, diffOk, i:
	constraint := 'constraint':
	while not assigned ( constraint ) do
		printf ( `Enter constraints as a LIST of equations\n` ):
		printf ( ` (eg. [ diff ( m(r,t), r ) = r^2*m(r,t), diff ( m(r,t), t ) = t^2*m(r,t)^2 ] ).\n`):
		constraint := grF_makeg_input (``, []):
		if not type ( constraint, list ) then
			printf ( `Invalid input. Please enter differential constraints as a LIST.\n` ):
			constraint := 'constraint':
		else
			#
			# Screen the constraints. Are they equations? Is the lhs diff()?
			#
			diffOk := true:
			for i in constraint do
				if not type ( i, equation ) then
					printf ( `Element %a in the set is not an equation. Please re-enter constraints.\n`, i ):
					diffOk := false:
				fi:
			od:
			if not diffOk then
				constraint := 'constraint':
			fi:
		fi:
	od:
RETURN ( constraint ):
end:

#-------------------------------------------------------------------
# addtext.
#-------------------------------------------------------------------
grF_addtext := proc ()
local	info:
	printf ( `Enter text information:\n` ):
	info := readline():
RETURN ( info ):
end:

#-------------------------------------------------------------------
# saveEntry.
#-------------------------------------------------------------------
grF_saveEntry := proc ( metricdir,
					    G_gdim, 
						G_gname, 
						G_gtype, 
						G_coord,
						G_constraint, 
						G_complex,
						G_info,
						G_metric,
						G_sig, 
						G_basisd,
						G_basisu)

local	metricfile, metricname, r, i, j:
global grOptionLLSC;
	
	metricname := G_gname;
	if not type(G_gname, string) then
	   metricname := sprintf("%a", G_gname);
	fi:
	metricname := cat(metricname,".mpl");
	metricfile := FileTools:-JoinPath([metricdir, metricname]);
	printf("Save to: %s\n", metricfile);
	fd := fopen( metricfile, WRITE);

	fprintf (fd, `Ndim_ := %a:\n`, G_gdim ):
	for i to G_gdim do
		fprintf ( fd, `%a := %a:\n`, x||i||_, G_coord[i] ):
	od:
	if type (G_sig, integer) and not grOptionLLSC then
		fprintf ( fd, `sig_ := %a:\n`, G_sig ):
	fi:
 	if nops ( G_complex ) > 0 then
		fprintf ( fd, `complex_ := %a:\n`, G_complex ):
	fi:
	if G_gtype = grG_g or G_gtype = grG_ds then
		for i to G_gdim do 
			for j from i to G_gdim do
				if G_metric[i,j] <> 0 then
					fprintf ( fd, `%a := %a:\n`, g||i||j||_, G_metric[i,j] ):
				fi:
			od:
		od:
	elif G_gtype = grG_basis or G_gtype = grG_np then
		for i to G_gdim do
			for j from i to G_gdim do
				if G_metric[i,j] <> 0 then
					fprintf ( fd, `%a := %a:\n`, eta||i||j||_, G_metric[i,j] ):
				fi:
			od:
		od:
		if G_basisu<>0 then
			for i to G_gdim do
				for j to G_gdim do
					if G_basisu[i,j] <> 0 then
						fprintf ( fd, `%a := %a:\n`, b||i||j||_, G_basisu[i,j] ):
					fi:
				od:
			od:
		fi:
		if G_basisd<>0 then
			for i to G_gdim do
				for j to G_gdim do
					if G_basisd[i,j] <> 0 then
						fprintf ( fd, `%a := %a:\n`, bd||i||j||_, G_basisd[i,j] ):
					fi:
				od:
			od:
		fi:
	fi:
	if assigned ( G_constraint ) then
		fprintf ( fd, `constraint_ := %a:\n`, G_constraint ):
	fi:
	if type ( G_info, string ) then
		fprintf ( fd, `Info_ := ``%s``:\n\n`, G_info ):
	fi:
	fclose(fd);
	printf ( `Information written to: %a\n`, metricfile ):
end:

#-------------------------------------------------------------------
# usemetric.
#-------------------------------------------------------------------
grF_usemetric := proc ( G_gdim, 
						G_gname, 
						G_gtype, 
						G_coord,
						G_constraint, 
						G_complex,
						G_info,
						G_metric,
						G_sig, 
						G_basisd,
						G_basisu)
global  Ndim, grG_constraint, grG_Ndim, grG_metricName, grG_default_metricName, grG_Info_, grG_sig_, grG_complexSet_, gr_data:
local 	i, btype:
	Ndim[(G_gname)] := G_gdim:
	grG_metricName := G_gname:
	grG_default_metricName := grG_metricName:
	for i to G_gdim do
		gr_data[xup_,grG_metricName,i] := G_coord[i]:
	od:
	grF_assignedFlag ( x(up), set, grG_metricName ):
	if G_gtype = grG_g or G_gtype = grG_ds then
		grF_initg ( G_gdim, G_metric, grG_metricName ):
	elif G_gtype = grG_basis or G_gtype = grG_np then
		if G_basisd <> 0 then
			grF_initbasisdn ( G_gdim, G_basisd, grG_metricName, G_gtype ):
		fi:
		if G_basisu <> 0 then
			grF_initbasisup ( G_gdim, G_basisu, grG_metricName, G_gtype ):
		fi:
		grF_initip ( G_gdim, G_metric, grG_metricName ):
	fi:

	if assigned ( G_constraint ) then
		grG_constraint[grG_metricName] := [op(G_constraint)]:
		grF_assignedFlag ( constraint, set, grG_metricName ):
	fi:

 	if nops(G_complex) > 0 then
		grG_complexSet_[grG_metricName] := G_complex:
	fi:

	if assigned ( G_info ) then
		grG_Info_[grG_metricName] := G_info:
		grF_assignedFlag ( info, set, grG_metricName ):
	fi:

	grG_sig_[grG_metricName] := G_sig:
	grF_assignedFlag ( sig, set, grG_metricName ):

	grF_initMetric ( grG_metricName ):
	grF_displaymetric ( grG_metricName, G_gtype ):
end:

#-------------------------------------------------------------------
# displayEntry.
#-------------------------------------------------------------------
grF_displayEntry := proc ( G_basisd,
						   G_basisu,
						   G_basisip, 
						   G_complex,
						   G_constraint,
						   G_coord, 
						   G_info,
						   G_gtype,
						   G_gdim,
						   G_metric
						)
local	alert:
	print ( `The values you have entered are:` ):
	print ( Coordinates =  G_coord ):
	if assigned ( G_constraint ) then
		print ( Constraints = G_constraint ):
	fi:
	if G_gtype = grG_g or G_gtype = grG_ds then
		grF_displayg ( G_gdim, G_metric, G_coord ):
	elif G_gtype = grG_basis or G_gtype = grG_np then
		if G_basisu<>0 then 
			grF_displaybasisv ( G_gdim, G_gtype, G_basisu, 1 ):
		fi:
		if G_basisd<>0 then 
			grF_displaybasisv ( G_gdim, G_gtype, G_basisd, -1):
		fi:
		grF_displaybasisip ( G_basisip, G_metric ):
		if G_basisd<>0 and G_basisu<>0 then
			alert := grF_checkbasisproblems ( G_gdim, G_metric, G_basisu, G_basisd ):
			if alert = true then
				print ( `Warning: the basis vectors are not consistent with the inner product` ):
			fi:
		fi:
	fi:

	#if assigned ( G_complex ) and nops(G_complex) > 0 then
		print ( `Complex quantities` = G_complex ):
	#fi:

	if assigned ( G_info ) then
		print ( G_info ):
	fi:

end:

#-------------------------------------------------------------------
# displayg.
#-------------------------------------------------------------------
grF_displayg := proc ( gdim, metric, coord )
local	a, b, maxSize, size:	
	print ( `Metric:` ):
	maxSize := 0:
	for a to gdim do
		size := 0:
		for b to gdim do
			size := size + length ( metric[a,b] ):
		od:
		if size > maxSize then maxSize := size fi:
	od:
	if maxSize < grOptionTermSize then
		a := 'a': b := 'b':
		print ( g[a]*``[b] = eval ( metric ) ):
	else
		for a to gdim do
			for b to gdim do
				print ( g[coord[a]]*``[coord[b]] = metric[a,b] ):
			od:
		od:
	fi:	
end:

#-------------------------------------------------------------------
# displaybasisv.
#-------------------------------------------------------------------
grF_displaybasisv := proc ( gdim, gtype, basis, btype )
local	a, b, maxSize, size, vname, v, e:
	if btype = 1 then 
		print ( `Basis vectors:` ):
	else
		print ( `Basis 1-forms:` ):
	fi:
	if gtype = grG_np then
		vname := [l,n,m,mbar]:
	elif btype = -1 then
	    vname := NULL:
	    for a to gdim do
  		  vname := vname,omega[a]:
  		od:
  		vname := [vname]:
	else
	    vname := NULL:
	    for a to gdim do
  		  vname := vname,e[a]:
  		od:
  		vname := [vname]:
	fi:
	maxSize := 0:
	for a to gdim do
		size := 0:
		for b to gdim do
			size := size + length ( basis[a,b] ):
		od:
		if size > maxSize then maxSize := size fi:
	od:
	if maxSize < grOptionTermSize*gdim then
		v := array ( 1..gdim ):
		for a to gdim do
			for b to gdim do
				v[b] := basis[a,b]:
 			od:
			print ( vname[a] = eval ( v ) ):
		od:
	else
		for a to gdim do
			for b to gdim do
				if btype = 1 then
					print ( vname[a]^coord[b] = basis[a,b] ):
				else
					print ( vname[a][coord[b]] = basis[a,b] ):
				fi:
			od:
		od:
	fi:
end:

#-------------------------------------------------------------------
# displaybasisip.
#-------------------------------------------------------------------
grF_displaybasisip := proc ( gdim, ip )
	print ( `Inner product of basis vectors:` ):
	print ( eta = eval ( ip ) ):
end:


#-------------------------------------------------------------------
# setgname.
#-------------------------------------------------------------------
grF_setgname := proc ( gname )
global 	grG_metricSet:
	if not type ( gname, name ) then
		ERROR ( `The metric name must be of type NAME.` ):
	elif member ( gname, grG_metricSet ) then
		ERROR ( `Metric name has already been used:`, gname ):
	fi:
RETURN ( gname ):
end:

#-------------------------------------------------------------------
# setgtype.
#-------------------------------------------------------------------
grF_setgtype := proc( gtypeList ) 
local s, gtype:
	while not assigned ( gtype ) do
		s := sprintf ( `Do you wish to enter a: \n` ):
		s := cat(s,sprintf ( `   1) metric [g(dn,dn)],\n` )):
		s := cat(s,sprintf ( `   2) line element [ds],\n` )):
		s := cat(s,sprintf ( `   3) non-holonomic basis [e(1)...e(n)], or\n` )):
		s := cat(s,sprintf ( `   4) NP tetrad [l,n,m,mbar]?\n` )):
		gtype := grF_makeg_input ( s, 1):
		if not member ( gtype, {1,2,3,4} ) then
			printf ( `Invalid input. Please enter a digit from 1...4.\n` ):
			gtype := 'gtype':
		fi:
	od:
RETURN ( gtype ):
end:

#-------------------------------------------------------------------
# getcoords.
#-------------------------------------------------------------------
grF_getcoords := proc ()
local coords, etype:
	coords := 'coords':
	while not assigned ( coords ) do
		coords := grF_makeg_input ( `Enter coordinates as a LIST (eg. [t,r,theta,phi]):`, [] ):
		etype := traperror ( type ( coords, list ) ):
		if etype = lasterror or not etype then
			printf ( `Invalid input. Coordinates must be in the form of a list. Try again.\n` ):
			coords := 'coords':
		fi:
	od:
RETURN ( coords ):
end:

#-------------------------------------------------------------------
# getsig.
#-------------------------------------------------------------------
grF_getsig := proc ( ndim )
local stsig:
	stsig := 'stsig':
	while not assigned ( stsig ) do
		stsig := grF_makeg_input( `Spacetime signature (eg. +2) [default=2]: `, 2 ):
		if not type ( stsig, integer ) then
			printf ( `Invalid input. The signature must be an integer.\n` ):
			stsig := 'stsig':
		elif stsig^2 > ndim^2 then
			printf ( `Invalid input. |sig| must be less than the number of dimensions of the spacetime. Please choose another value.\n` ):
			stsig := 'stsig':
		fi:
	od:
RETURN ( stsig ):
end:

#-------------------------------------------------------------------
# getmetricelement.
#-------------------------------------------------------------------
grF_getmetricelement := proc ( a, b, coord1, coord2 )
local s, val:
	s := sprintf ( `Enter g[%a,%a]:`, coord1, coord2 ):
	val := grF_makeg_input ( s, [] ):
RETURN ( val ):
end:

#-------------------------------------------------------------------
# getipelement.
#-------------------------------------------------------------------
grF_getipelement := proc ( a, b )
local s, val:
	s := sprintf ( `Enter eta[%a,%a]:`, a, b ):
	val := grF_makeg_input ( s, [] ):
RETURN ( val ):
end:

#-------------------------------------------------------------------
# grF_makeg_input
#-------------------------------------------------------------------
grF_makeg_input := proc (userprompt, default_value)
	return grF_input(userprompt, default_value, `makeg`):
end:

#-------------------------------------------------------------------
# grF_initip.
#-------------------------------------------------------------------
grF_initip := proc ( ndim, ip, gname )
global	gr_data:
local	ipu, ipd, a, b:
	ipu := linalg[matrix] ( ndim, ndim ):
	for a to ndim do 
		for b to ndim do
			ipu[a,b] := ip[a,b]:
		od:
	od:
	ipd := linalg[inverse] ( ipu ):
	for a to ndim do 
		for b from a to ndim do
			gr_data[etabupbup_,gname,b,a] := gr_data[etabupbup_,gname,a,b]:
			gr_data[etabdnbdn_,gname,b,a] := gr_data[etabdnbdn_,gname,a,b]:
			gr_data[etabupbup_,gname,a,b] := ipu[a,b]:
			gr_data[etabdnbdn_,gname,a,b] := ipd[a,b]:
		od:
	od:
	grF_assignedFlag ( eta(bdn,bdn), set, gname ):
	grF_assignedFlag ( eta(bup,bup), set, gname ):
end:

#-------------------------------------------------------------------
# grF_initbasisup.
#-------------------------------------------------------------------
grF_initbasisup := proc ( ndim, basis, gname, gtype, stsig )
global 	gr_data:
local	vname, oname, a, b:

	for a to ndim do
		for b to ndim do
			gr_data[ebdnup_,gname,a,b] := basis[a,b]:
		od:
	od:
	grF_assignedFlag ( e(bdn,up), set, gname ):

	if ndim = 4 then
		if gtype = grG_np then
			vname := [ NPlup_, NPnup_, NPmup_, NPmbarup_ ]:
			oname := [ NPl(up), NPn(up), NPm(up), NPmbar(up) ]:
		else
			vname := [ e1up_, e2up_, e3up_, e4up_ ]:
			oname := [ e1(up), e2(up), e3(up), e4(up) ]:
		fi:
		for a to 4 do
			for b to 4 do
				gr_data[vname[a],gname,b] := basis[a,b]:
			od:
			grF_assignedFlag ( oname[a], set, gname ):
		od:
	fi:
end:

#-------------------------------------------------------------------
# grF_initbasisdn.
#-------------------------------------------------------------------
grF_initbasisdn := proc ( ndim, basis, gname, gtype )
global 	gr_data:
local	vname, oname, a, b:

	for a to ndim do
		for b to ndim do
			gr_data[ebdndn_,gname,a,b] := basis[a,b]:
		od:
	od:
	grF_assignedFlag ( e(bdn,dn), set, gname ):

	if ndim = 4 then
		if gtype = grG_np then
			vname := [ NPldn_, NPndn_, NPmdn_, NPmbardn_ ]:
			oname := [ NPl(dn), NPn(dn), NPm(dn), NPmbar(dn) ]:
		else
			vname := [ e1dn_, e2dn_, e3dn_, e4dn_ ]:
			oname := [ w1(dn), w2(dn), w3(dn), w4(dn) ]:
		fi:
		for a to 4 do
			for b to 4 do
				gr_data[vname[a],gname,b] := basis[a,b]:
			od:
			grF_assignedFlag ( oname[a], set, gname ):
		od:
	fi:
end:

#-------------------------------------------------------------------
# grF_initg.
#-------------------------------------------------------------------
grF_initg := proc ( ndim, metric, gname )
global 	grG_calc, grG_fnCode, gr_data:
local	a, b:
	for a to ndim do
		for b from a to ndim do
			gr_data[gdndn_,gname,b,a] := gr_data[gdndn_,gname,a,b]:
			gr_data[gdndn_,gname,a,b] := metric[a,b]:
		od:
	od:
	grF_assignedFlag ( g(dn,dn), set, gname ):
	grG_calc := true:
	grG_fnCode := grC_CALC:
	grF_core ( ds, true ):
end:

#-------------------------------------------------------------------
# grF_checkbasisproblems
#-------------------------------------------------------------------
grF_checkbasisproblems := proc ( gdim, ip, up, dn )
local	a, b, c, ipu, ipd, btest, problem:
	ipu := linalg[matrix](gdim, gdim):
	for a to gdim do 
		for b to gdim do
			ipu[a,b] := ip[a,b]:
		od:
	od:
	ipd := linalg[inverse] ( ipu ):
	problem := false:
	for a to gdim while problem = false do 
		for b to gdim while problem = false do
			btest[a,b] := 0:
			for c to gdim  do
				btest[a,b] := btest[a,b] + up[a,c]*dn[b,c]:
			od:
			if btest[a,b] <> ipd[a,b] then
				problem := true:
			fi:
		od:
	od:
RETURN ( problem ):
end:

#----------------------------------------------------------------------
# grF_checkNullTetrad
#----------------------------------------------------------------------
grF_checkNullTetrad := proc ( gname )
local	nullt, ip, a, b:
global gr_data:

	nullt := true:
	if Ndim[gname]=4 and grF_checkIfAssigned ( eta(bup,bup), test ) then
		ip := array ( 1..4, 1..4, 
			[[0,1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,-1,0]] ):
		for a to 4 while nullt = true do
			for b to 4 while nullt = true do
				if gr_data[etabupbup_,gname,a,b] <> ip[a,b] then
					nullt := false:
				fi:
			od:
		od:
	else
		nullt := false:
	fi:
RETURN ( nullt ):
end:

#------------------------------------------------------------------------------
# grF_algfun2vector
#------------------------------------------------------------------------------
grF_algfun2vector := proc (gdim, vec, coord)
local clist, cmpt, a, b:
  clist := NULL:
  for a to gdim do
    cmpt := vec:
    for b to gdim do
      if b<>a then
        cmpt := subs (d[coord[b]]=0, cmpt):
      fi:
    od:
    if subs (d[coord[a]]=0, cmpt) <> 0 then
      RETURN (err):
    fi:
    clist := clist, subs (d[coord[a]]=1,cmpt):
  od:
  RETURN ([clist]):
end:

