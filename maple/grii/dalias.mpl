###########################
# dalias.mpl
###
# Converted from 5.2 to 5.3
###########################

# grDalias: set up a series of aliases for those pesky D[2](c)(r,v)
# forms that Maple is so fond of

grDalias := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
# input: a list of functions, varList
#      i.e. grDalias(c(r,v), m(r,v), r,`'`,v,`^`)
# also wish to allow the user to specify aliases in a non-interative way
#
local a,b,c,d, lastF, str, varSet, varStr;

# first build a list of all unique variables and prompt for the
# symbol to denote diff
varSet := {};
for a to nargs while type(args[a],function) do
    varSet := varSet union {op(args[a])}:
od:

lastF := a-1; # point to name of last function

# now read the list of string
for b from a by 2 to nargs do
  if not (type(args[b+1],name) and type(args[b],name)) then
       ERROR(`Error in parameters expecting ,name,string after `||args[b-1]);
  fi:
  if not member (args[b],varSet) then
       ERROR(cat(`Variable `,eval(args[b]),` does not appear in coord lists`));
  fi:
  # as each variable string found remove it from the set, should be
  # empty when done
  varSet := varSet minus {args[b]}:
  varStr[args[b]] := args[b+1]:
od:
if varSet <> {} then
  ERROR(`Strings for `||varSet||` not specified`);
fi:

# now build aliases for all of them
for a to lastF do  # for each function
  for b to 2 do  # for up to second derivitives
     for c to nops(args[a]) do # for each coordinate of the function
	# do all first derivitives (both styles)
	str := convert( cat(op(0,args[a]),varStr[op(c,args[a])]), name);
	# first derivitive (MapleV style)
	alias(str = D[c](op(0,args[a]))(op(args[a])) );
	# MapleV2 style
	alias(str = diff( args[a], op(c,args[a]) )):
	# now do all partials
	for d from c to nops(args[a]) do
	   str := convert(cat(op(0,args[a]),varStr[op(c,args[a])],
				varStr[op(d,args[a])]), name);
	   # don't need to do in other order since Maple always sorts so
	   # first number is lower
	   # format for MapleV
	   alias(str = D[c,d](op(0,args[a]))(op(args[a])) );
	   # format for MapleV2 (use same order for both)
	   alias(str = diff(diff( args[a], op(c,args[a]) ), op(d,args[a])) );
	   alias(str = diff(diff( args[a], op(d,args[a]) ), op(c,args[a])) );
	od:
      od:
    od:
od:
printf ("Aliases created\n");
end:
