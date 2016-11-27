#************************************************
# jsave(sName, fileName)
#
# - save all the objects associated with a surface:
#     Sigma: g(dn,dn) x(up) K(dn,dn)
#         M: g(dn,dn) n(dn) n(up) xform(up) nsign x(up)
#
#************************************************

jsave := proc( sName, fileName)
 global grG_metricName;
 local oldDefault:

 if not member(sName, grG_metricSet) then
   ERROR(`Cannot find `,sName):
 elif not assigned( gr_data[partner_,sName] ) then
   ERROR(sName, ` does not reference an enveloping spacetime.`):
 fi:

 #
 # use grsaveobj to save the values for the Enveloping space
 #
 oldDefault := grG_default_metricName:
 grG_default_metricName := gr_data[partner_,sName]:
 grsaveobj( g(dn,dn), x(up), xform(up), n(dn), n(up), nsign):
 appendto(fileName);
 printf(`gr_data[partner_,grG_metricName] := %a:\n`,
           gr_data[partner_,grG_metricName]):
 #
 # now save the surface stuff
 #

 #
 # for each object, set the metric name and any operands
 # grF_saveObj is a dummy function. Check for this fn name
 # in grcomponent.
 #
 grG_postSeq := `[grG_surfaceName`: # used by grcomponent

 #
 # can't use grapply a second time, since it will
 # clear out the contents of the file
 #
 grG_metricName := sName:
 grG_fnCode := grF_saveObj:
 grG_applyParms := fileName,[]:
 grG_simp := false: # this must be before simpDecode
 grG_calc := false:
 grG_callComp := true:
 grF_core(g(dn,dn),true);
 grF_core(K(dn,dn),true);
 grF_core(x(up),true);

 grG_default_metricName := oldDefault:

 printf(`Saved the surface %a and spacetime %a in %s\n.`,
           sName, grG_partner_[sName], fileName):

end:
