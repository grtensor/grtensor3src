#-----------------------------------------
#
# Output reports.
#
#-----------------------------------------

PetrovReport := proc()
local	a, ptype, gname:
global grG_metricName, gr_data;

  gname := grG_metricName:

  if assigned ( gr_data[Petrov_,gname] ) then 
    ptype := gr_data[Petrov_,gname]:
  elif assigned ( grG_NPPetrov_[gname] ) then 
    ptype := grG_NPPetrov_[gname]:
  else
    ERROR ( `The Petrov type has not been calculated.` ):
  fi:

  if not assigned ( grG_reportSize ) or grG_reportSize = 0 then
    print ( `No report has been generated.` ):
  else
    print ( `The conclusion 'Petrov type = `.ptype.`'` ):
    print ( `for the `.gname.` metric` ):
    print ( `was based on the following results:` ):

    for a to grG_reportSize do
      print ( grG_reportLine[a] ):
    od:

    print ( `---> Therefore the metric is Petrov `.ptype.`.` ):

    print ( `-------------------------------------------------------` ):

    print ( `The quantities that could not be evaluated to zero are: ` ):
    for a to grG_reportVsize do
      print ( grG_reportVline[a] ):
    od:
  fi:
end:

#------------------------------------------
#
# Generate an `= 0` or `is not zero` line 
# for a report.
#
#-------------------------------------------

grF_report := proc ( vname, str, value )
global grG_reportLine, grG_reportSize, grG_reportVline, grG_reportVsize:

if value = 0 then
  grG_reportSize := grG_reportSize + 1:
  if vname <> `` then
    grG_reportLine[grG_reportSize] := vname = str.` = 0`:
  else
    grG_reportLine[grG_reportSize] := str = 0:
  fi:
else
  grG_reportSize := grG_reportSize + 1:
  grG_reportVsize := grG_reportVsize + 1:
  if vname <> `` then
    grG_reportLine[grG_reportSize] := vname = str.` could not be evaluated to zero.`:
  else 
    grG_reportLine[grG_reportSize] := ``.str.` could not be evaluated to zero.`:
  fi:
  if vname <> `` then
    grG_reportVline[grG_reportVsize] := vname = value:
  else 
    grG_reportVline[grG_reportVsize] := str = value:
  fi:
fi:

end:
