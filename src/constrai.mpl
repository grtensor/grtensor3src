#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: constrai.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: June 1, 1994
#
#
# Purpose: Handle constraints interactivly
#
# Revisions:
#
# Sept 16 1994  Add some parameter bullet proofing.
# Sept 19 1994  Only one type of constraints [pm]
# Oct   6 1994  One entry modifed should be returned as a list.
# Sept 16 1997  Removed R3 type specifiers in proc headers [dp]
# Aug  18 1999  Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug  20 1999  Changed use of " to ` for R4 compatibility [dp]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#*************************************************
#
# grconstraint
#
# User interface for constraint manipulation
#
#*************************************************

grconstraint := proc( metricName)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local a,b, cType, action, choice, s:

global grG_constraint:

 action[1] := grFc_add_constraint:
 action[2] := grFc_del_constraint:
 action[3] := grFc_mod_constraint:
 action[4] := grFc_display:

 while (choice <> 5) do
   #
   # which type of constraints have been defined ??
   #
   s := sprintf(`Constraint specification and manipulation\n`);
   s := cat(s, sprintf(`\nDo you wish to\n`));
   s := cat(s, sprintf(`1) Add a constraint to the metric\n`));
   s := cat(s, sprintf(`2) Remove a constraint from the metric\n`));
   s := cat(s, sprintf(`3) Modify a metric constraint\n`));
   s := cat(s, sprintf(`4) Display the existing constraints\n`));
   s := cat(s, sprintf(`5) Exit\n`));

   choice := 0:
   while not type(choice, integer) or choice < 1 or choice > 5 do
     choice := grF_input(s, [], `grconstraint`);
   od:
   if choice < 5 then
     action[choice](constraint, metricName):
   fi:
   Done:
 od:

end:



#*************************************************
# grFc_display
#
#*************************************************

grFc_display := proc(cType, metric)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

  grdisplay( cType[metric]);

end:


#*************************************************
# grFc_add_constraint
#
#*************************************************

grFc_add_constraint := proc( cType, metric)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local newEqn, s:

global grG_constraint, gr_data:

 #
 #
 s := sprintf(`Please enter the new constraint as an equation (of the form f(x,y) = g(x) + h(y), for example):\n`);

 newEqn := 1;
 while not type(newEqn, equation) do
   newEqn := grF_input(s, [], `grconstraint`)
 od:

 printf(`The new constraint equation is :\n`);
 print(newEqn);

 if assigned( grG_constraint[metric]) then
      grG_constraint[metric]  :=
            [op(grG_constraint[metric]),newEqn];
 else
   # assign to reference
   gr_data[constraint, metric] := grG_constraint[metric];
   grG_constraint[metric]  := [newEqn];
   grF_assignedFlag ( constraint, set ):
 fi:

end:

#*************************************************
# grFc_del_constraint
#
#*************************************************

grFc_del_constraint := proc(cType, metric)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local object, a, b, del_eqn:

 object := grG_||cType[metric]:
 if not type(object,list) then
   object := [object]:
 fi:

 if nops(object) = 1 then
   #
   # just unasign the constraint
   #

   grG_||cType := []:
 else
   a := grFc_select_constraint( object):
   #
   # find which one this is and remove it
   #
   grG_||cType[metric] := [seq( object[b], b=1..a-1),
                      seq( object[b], b=a+1..nops(object))]:
 fi:

end:

#*************************************************
# grFc_select_constraint
#
# - request the user select a particular eqn
#
#*************************************************

grFc_select_constraint := proc( object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local i, choice, ceqn,s :
 #
 # if there is more than one constraint, require the user
 # to select one
 #
 if nops( object ) > 1 then
   s := sprintf(`Multiple constraint equations exist. Please indicate\n`);
   s := cat(s, sprintf(`which one you wish to modify\n`)):
   for i to nops( object) do
     s := cat(s, sprint(`[`||i||`]`, op(i, object) )):
   od:

   #
   # ask for selection
   #
   choice := 0:
   while not type(choice, integer) or choice < 1 do
     choice := grF_readstat(s, [], `grconstraint`);
   od:
 else
   choice := 1:
 fi:

 RETURN(choice):
end:

#*************************************************
# grFc_mod_constraint
#
#*************************************************

grFc_mod_constraint := proc( cType, metric)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local a, object, ceqn, newEqn, choice, okay, i, elim, newList, s:

global grG_constraint:

 object := grG_||cType[metric]:
 if not type(object,list) then
   object := [object]:
 fi:

 choice := grFc_select_constraint(object):
 ceqn := object[choice]:

 okay := false:
 while not okay do
   s := sprintf(`Enter the term you wish to use the constraint to eliminate\n`):
   elim := eval(grF_input(s, [], `grconstraint`)):
   printf("elim=%a ceqn=%a\n", elim, ceqn);
   newEqn := solve( ceqn, elim):
   #
   # did we get a NULL solution, or multiple solutions ??
   #
   okay := true:
   if nops([newEqn]) > 1 then
     s := sprintf(`Solve returned multiple solutions. They are:\n`);
     for a to nops([newEqn]) do
       print(`[`||a||`]`, op(a, [newEqn])):
     od:
     s := cat(s, sprintf(`\nPlease select a solution.\n`));
     choice := 0:
     while not type(choice, integer) or choice < 1 or
           choice > nops([newEqn]) do
       choice := grF_input(s, [], `grconstraint`);
     od:
     newEqn := op(choice, [newEqn]):

   elif newEqn = NULL then
     printf(`solve() was unable to isolate %a.\n`, elim):
     choice := 0:
     okay := false:
   fi:
 od:
 #
 # now put the newEqn back into the list
 #
 if nops(object) > 1 then
   #
   # need to put into the new list
   #
   newList := [seq( object[a], a=1..choice-1), elim = newEqn,
        seq( object[a], a=choice+1..nops(object))]:

   grG_||cType[metric]  := newList:


 else
   grG_||cType[metric] := [elim = newEqn];

 fi:

end:



