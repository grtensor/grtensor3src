#==============================================================================
# symlist
#
# Create a list of symmetries based on an index list.
#
# Created by: Denis Pollney
# Date:       18 October 1995
#==============================================================================

grG_indices := {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,
		A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z }:
grG_braces := {`(`, `)`, `[`, `]`, `|`}:

#------------------------------------------------------------------------------
# symlist
#------------------------------------------------------------------------------

grF_determineIndexSymmetries := proc ( tensorDefStr )
local	indexStr, indexList, updnList, upList, dnList, upSymSets, dnSymSets,
	symSet, asymSet, startpos, endpos:

startpos := searchtext ( `{`, tensorDefStr ):
endpos   := searchtext ( `}`, tensorDefStr ):

if startpos > 0 and endpos > startpos then
	indexStr := substring ( tensorDefStr, startpos+1 .. endpos ):
fi:

indexList := grF_stringify ( indexStr ):

indexList := grF_numberIndices ( indexList ):
indexList := grF_removeBasisBrackets ( indexList ):

if grF_noSymmetrizations ( indexList ) = true then
	RETURN ( [{},{}] ):
fi:

updnList := grF_sortUpDnLists ( indexList ):

upList := updnList[1]:
dnList := updnList[2]:

upSymSets := grF_createSymSets ( upList ):
dnSymSets := grF_createSymSets ( dnList ):

symSet  := upSymSets[1] union dnSymSets[1]:
asymSet := upSymSets[2] union dnSymSets[2]:

RETURN ( [symSet,asymSet] ):
end:

#------------------------------------------------------------------------------
# extractSymmetries
#------------------------------------------------------------------------------

grF_extractSymmetries := proc ( tensorNameStr )
local i, j, tensorName, newtensorName, newtensorNameStr:

tensorName := grF_stringify ( tensorNameStr ):
j := 1:
for i to tensorName[0] do
    if not member ( tensorName[i], grG_braces ) then
        newtensorName[j] := tensorName[i]:
        j := j + 1:
    elif tensorName[i] = `(` then
        if tensorName[i+2] =`)` or 
            (tensorName[i+1] = `^` and tensorName[i+3] = `)` ) then
            newtensorName[j] := `(`:
            j := j + 1:
        fi:
    elif tensorName[i] = `)` then
        if tensorName[i-2] = `(` or 
            ( tensorName[i-2] = `^` and tensorName[i-3] = `)` ) then
            newtensorName[j] := `)`:
            j := j + 1:
        fi:
    fi:
od:

newtensorNameStr := ``:
for i to j-1 do
    newtensorNameStr := ``||newtensorNameStr||(newtensorName[i]):
    if newtensorName[i] <> `(` 
      and newtensorName[i] <> `^`
      and newtensorName[i+1] <> `)` then
        newtensorNameStr := ``||newtensorNameStr||` `:
    fi:
od:

RETURN ( newtensorNameStr ):
end:

#------------------------------------------------------------------------------
# sortUpDnLists
#------------------------------------------------------------------------------

grF_sortUpDnLists := proc ( symList )
local	upList, dnList, i, j, updnList:

upList := []:
dnList := []:
for i to symList[0] do
	if type ( symList[i], numeric ) then
		if symList[i] < 0 then
			dnList := [op(dnList), -1*symList[i]]:
		else
			upList := [op(upList), symList[i]]:
		fi:
	elif member ( symList[i], grG_braces ) then
		if symList[i] = `(` or symList[i] = `[` 
		  or symList[i] = `|` then
			for j from i to symList[0] while not type ( symList[j], numeric ) do od:
			if symList[j] < 0 then
				dnList := [op(dnList), symList[i]]:
			else
				upList := [op(upList), symList[i]]:
			fi:
		elif symList[i] = `)` or symList[i] = `]` then
			for j from i to 1 by -1 while not type ( symList[j], numeric ) do od:
			if symList[j] < 0 then
				dnList := [op(dnList), symList[i]]:
			else
				upList := [op(upList), symList[i]]:
			fi:
		fi:
	fi:
od:
upList := array ( 0..nops(upList), [nops(upList), op(upList)] ):
dnList := array ( 0..nops(dnList), [nops(dnList), op(dnList)] ):

updnList := [upList, dnList]:
RETURN ( updnList ):
end:

#------------------------------------------------------------------------------
# numberIndices
#------------------------------------------------------------------------------

grF_numberIndices := proc ( indexList )
local	indexNbr, i, updn, tmpList:

indexNbr := 1:
tmpList := []:
for i to indexList[0] do
	if member ( indexList[i], grG_indices ) then
		if indexList[i-1] = `^` then
			updn := 1:
		else
			updn := -1:
		fi:
		tmpList := [op(tmpList), updn*indexNbr]:
		indexNbr := indexNbr + 1:
	elif member ( indexList[i], grG_braces ) then
		tmpList := [op(tmpList), indexList[i] ]:
	fi:
od:
tmpList := array ( 0..nops(tmpList), [nops(tmpList), op(tmpList)] ):

RETURN ( tmpList ):
end:

#------------------------------------------------------------------------------
# removeBasisBrackets
#------------------------------------------------------------------------------

grF_removeBasisBrackets := proc ( symList )
local	i, tmpList:

tmpList := []:
for i to symList[0] do
	if symList[i] = `(` then
		if symList[i+2] <> `)` then
			tmpList := [op(tmpList),symList[i]]:
		fi:
	elif symList[i] = `)` then
		if symList[i-2] <> `(` then
			tmpList := [op(tmpList),symList[i]]:
		fi:
	else
		tmpList := [op(tmpList), symList[i]]:
	fi:
od:
tmpList := array ( 0..nops(tmpList), [nops(tmpList), op(tmpList)] ):

RETURN ( tmpList ):
end:

#------------------------------------------------------------------------------
# noSymmetrizations
#------------------------------------------------------------------------------

grF_noSymmetrizations := proc ( indexList )
local	i, noSym:

noSym := true:
for i to indexList[0] while noSym = true do
	if member ( indexList[i], grG_braces ) then
		noSym := false:
	fi:
od:
RETURN ( noSym ):
end:

#------------------------------------------------------------------------------
# createSymSets
#------------------------------------------------------------------------------

grF_createSymSets := proc ( indexList )
local	symNbr, currentSymNbr, symIn, symType, i, symList, symSet, asymSet:

symNbr := 0:
currentSymNbr := 0:
symIn[0] := 0:
symType[symNbr] := `none`:

for i to indexList[0] do
	if indexList[i] = `(` then
		symNbr := symNbr + 1:
		symType[symNbr] := `sym`:
		symIn[symNbr] := currentSymNbr:
		currentSymNbr := symNbr:
	elif indexList[i] = `[` then
		symNbr := symNbr + 1:
		symType[symNbr] := `asym`:
		symIn[symNbr] := currentSymNbr:
		currentSymNbr := symNbr:
	elif indexList[i] = `)` then
		if symType[currentSymNbr] <> `sym` then
			ERROR ( `Invalid symmetry specification on left-hand side of tensor definition.` ):
		fi:
		currentSymNbr := symIn[currentSymNbr]:
	elif indexList[i] = `]` then
		if symType[currentSymNbr] <> `asym` then
			ERROR ( `Invalid symmetry specification on left-hand side of tensor definition.` ):
		fi:
		currentSymNbr := symIn[currentSymNbr]:
	elif indexList[i] = `|` then
		if symType[symNbr] <> `none` then
			symNbr := symNbr + 1:
			symType[symNbr] := `none`:
			symIn[symNbr] := currentSymNbr:
			currentSymNbr := symNbr:
		else
			currentSymNbr := symIn[currentSymNbr]:
			if symType[currentSymNbr] = `none` then
				ERROR ( `Invalid symmetry specification on left-hand side of tensor definition.` ):
			fi:
		fi:
	elif type ( indexList[i], numeric ) then
		if not assigned ( symList[currentSymNbr] ) then
			symList[currentSymNbr] := [indexList[i]]:
		else
			symList[currentSymNbr] := [op(symList[currentSymNbr]),indexList[i]]:
		fi:
	fi:
od:
if currentSymNbr > 0 then
	ERROR ( `Unmatched braces on left-hand side of tensor definition.` ):
fi:

symSet := {}:
asymSet := {}:
for i to symNbr do
	if symType[i] = `sym` then
		symSet := symSet union { symList[i] }:
	elif symType[i] = `asym` then
		asymSet := asymSet union { symList[i] }:
	fi:
od:

RETURN ( [symSet, asymSet] ):

end:

