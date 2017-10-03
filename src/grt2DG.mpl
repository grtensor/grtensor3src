#*********************************************************
# 
# GRTENSOR III MODULE: grt2DG.mpl
#
# Convert GRIII metric into DG init command
#
#*********************************************************

# convert e.g. name theta to dtheta
grF_dcoord := proc(coordName)
local s:

	s := cat("d",convert(coordName, string)):
    convert(s, symbol);
end:

#----------------------------------------
# grt2DG
# outut the expressions needed to use:
# DGsetup(coord, M);
# gmetric := evalDG(gexpr):
#
# To use the CM invariants in DG need a -2 metric
# so we flip the signature.
#----------------------------------------

grt2DG := proc({flip:=true})
#
# By default flip the signature
global grG_metricName, gr_data, Ndim, coord, gexpr;
local signFlip; 
	signFlip := 1; 
	if flip then
		signFlip := -1:
		printf("Signature has been flipped! [to avoid this do grt2DG(flip=false); ]\n"):
	else:
		printf("Signature has not been flipped! [to flip use grt2DG(), or grtDG(flip=true) ]\n"):
	fi:
	coord := [];
	gexpr := 0:
	for i to Ndim[grG_metricName] do
		coord := [op(coord), gr_data[xup_, grG_metricName,i]]:
		for j to Ndim[grG_metricName] do
			gexpr := gexpr + signFlip * gr_data[gdndn_,grG_metricName,i,j] * 
					cat(d,gr_data[xup_, grG_metricName,i])
					&t  cat(d,gr_data[xup_, grG_metricName,j]):
			od:
	od:
	printf("coord := %a\n", coord);
	DGsetup(coord, M);
	printf("gexpr := %a\n", gexpr);
	printf("DGSetup(coord) has been run, gexpr has been assigned with the metric for DG.\n"):

end:


#----------------------------------------
# cmcompare
# - confirm that GRT and CM invariants match
#----------------------------------------

# pairs of [ GRT, CM label] for those that can be directly compared

directCompare :=  [[ R1, "r1"], [R2, "r2"], [R3,"r3"], [M3, "m3"], [M4, "m4"]]:

signIssue := [[R2, "r2"], [M4, "m4"]];


complexCompare := [ [W1R, W1I, "w1"], [W2R, W2I, "w2"], [M1R, M1I, "m1"], [M2R, M2I, "m2"],
			[M5R, M5I, "m5"] ]: 

cmcompare := proc(cm_dg)
local d, c:
global cm_diff, cm_sum, grG_metricName, Ndim, gr_data:

	for d in directCompare do
		cm_diff[d[1]] := simplify(cm_dg[d[2]] - grcomponent(d[1]) ):
		print(d[1] = cm_diff[d[1]]):
	od:
	for d in complexCompare do
		cm_diff[d[1]] := simplify(subs(I=0,expand(cm_dg[d[3]])) - grcomponent(d[1])  ):
		cm_diff[d[2]] := simplify(subs(I=0,expand(-I*cm_dg[d[3]])) - grcomponent(d[2])  ):
		print(d[1] = cm_diff[d[1]]):
		print(d[2] = cm_diff[d[2]]):
	od:
	printf("Sum of invariants:"):
	for d in signIssue do
		cm_sum[d[2]] := simplify(cm_dg[d[2]] + grcomponent(d[1]) ):
		print(d[2] = cm_sum[d[2]]):
	od:
	cm_sum[M2I] := simplify(subs(I=0,expand(-I*cm_dg["m2"])) + grcomponent(M2I)  ):
	print(M2I = cm_sum[M2I]):
	printf("Special case M5I: CM(M5I) - 2*GRIII(M5I)"):
	cm_sum[M5I] := simplify(subs(I=0,expand(-I*cm_dg["m5"])) - 2* grcomponent(M5I)  ):
	print(M5I = cm_sum[M5I]):


end:


