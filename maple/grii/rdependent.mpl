

#
# wrapper for convert hostfile (since it's not supported in R4
# under Win32)
#
# This function is unused in the R6 version of GRTensor since backward
# compatibility with R3 is lost anyways.
#
grF_hostfile := proc(a)

  if grG_Release = 3 then
    convert(a, hostfile); 
  else
    a;
  fi:

end:
