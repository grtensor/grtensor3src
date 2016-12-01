(*

Multi-field prompt for defining a surface in a 
spacetime.
*)

#-------------------------------------------------------------------
# define_surface
#-------------------------------------------------------------------
#
# TODO: a version with  bunch of xform=[  ], coord=[  ] etc, as input functions
# (useful to to do that FIRST as a pre-cursor to a Maplet version)
#
grsurface := proc ()

	use Maplets in 
		use Elements in 
			maplet := Maplet(Window('title'="Define a surface",
			  [
				["Surface co-ordinates: ",TextField['SCoord']("")],
				["Surface parameter (blank if none)",TextField['SP']("")],
				["Co-ord relations e.g. r=R(tau), theta=theta etc",TextField['Srel']("")],
				["Normal Vector Type: ",DropDownBox['Ntype'](["Timelike","Null","Spacelike"])],
				["Use u^a u_a as constraint?: ",DropDownBox['Uc'](["No","Yes"])],
				[Button("OK",Shutdown(['SCoord','SP', 'Srel', 'Ntype', 'Uc'])),
				   Button("Cancel",Shutdown())]
			  ]))
		end use; 
		result := Display(maplet) 
	end use:

	if result <> [] and result[3] <> "" then 
		try 
			n := parse(result[1]) 
		end try; 
		if type(n, 'integer') then 
			ExportMatrix(result[3], LinearAlgebra:-HilbertMatrix(n, outputoptions = ['datatype' = float[8]]), 'target' = convert(result[2], 'symbol')) 
		end if 
	end if;

end proc:


sample := proc ()

	use Maplets in 
		use Elements in 
			maplet := Maplet(Window('title'="Hilbert Matrix",
				[["Dimension: ",TextField['TB1']("10")],
				["Target format: ",DropDownBox['DDB1'](["MATLAB","MatrixMarket","delimited"])],
				["File name:",TextField['TB2']("hilmat")],
				[Button("OK",Shutdown(['TB1','DDB1','TB2'])),
				Button("Cancel",Shutdown())]])) 
		end use; 
		result := Display(maplet) 
	end use:

	if result <> [] and result[3] <> "" then 
		try 
			n := parse(result[1]) 
		end try; 
		if type(n, 'integer') then 
			ExportMatrix(result[3], LinearAlgebra:-HilbertMatrix(n, outputoptions = ['datatype' = float[8]]), 'target' = convert(result[2], 'symbol')) 
		end if 
	end if;

end proc:


