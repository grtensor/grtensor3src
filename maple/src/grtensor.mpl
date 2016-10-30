#==============================================================================
# grtensor - print banner and search for grtensor.ini files.
#==============================================================================
grtensor := proc()
option `Copyright 1994,1995,1996 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, file, invlibname:
global grG_Release:

  grG_Release := grF_checkRelease():

  print( ``||grG_Version||` (R`||grG_Release||`)` );
  print( ``||grG_Date );
  print(`Developed by Peter Musgrave, Denis Pollney and Kayll Lake`):
  print(`Copyright 1994-2000 by the authors.`);
  print(
 `Latest version available from: http://grtensor.phy.queensu.ca/`
  ):
  #
  # look for GRTensor defaults. Start with each path in
  # libname
  #
  if nargs = 0 or args[1] then
    invlibname := NULL:
    for a in libname do
      invlibname := a,invlibname:
    od:
    for a in invlibname do
      file := convert( cat(a,`/grtensor.ini`), name):
      if not traperror( grF_testRead(file)) = lasterror then
         print(`Defaults read from `||file):
      fi:
    od:
    if not traperror( grF_testRead(`grtensor.ini`)) = lasterror then
      print(`Defaults read from the local grtensor.ini`):
    fi:
  fi:
end:

#------------------------------------------------------------------------------
# checkRelease - check for MapleV Release 3, 4, or 5. Default to 4.
#------------------------------------------------------------------------------
grF_checkRelease := proc()
local ver:

  ver := traperror ( interface(version) ):
  if ver = lasterror then
    RETURN(4):
  else
    if searchtext ( `Release 3`, ver ) <> 0 then
      RETURN(3):
    elif searchtext ( `Release 4`, ver ) <> 0 then
      RETURN(4):
    elif searchtext ( `Release 5`, ver ) <> 0 then
      RETURN(5):
    elif searchtext ( `Maple 6`, ver ) <> 0 then
      RETURN(6):
    else
      RETURN(4):
    fi:
  fi:
end:

#------------------------------------------------------------------------------
# initial help screen for ?grtensor
#------------------------------------------------------------------------------
`help/text/grtensor` := TEXT(
`In order to conserve RAM, the online help library for GRTensorII is not`,
`loaded by default.`,
``,
`To load the help library, use the command:`,
``,
`   > readlib ( griihelp ):`,
``,
`and then type ?grtensor.`,
``,
`To have the online help library load automatically with GRTensor,`,
`add the above readlib() command to you grtensor.ini file.`
):

#==============================================================================
