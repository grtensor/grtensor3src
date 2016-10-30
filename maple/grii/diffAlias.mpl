
#Procedure to alias functions and their partial derivatives up to 
#third order. Roberto Sussman, December 1994.
#Usage: 
#for S=S(t) write DifAlias(t,S)
#for S=S(t,x,y,z) write DifAlias([t,x,y,z], S)
#for S,U,V depending on t write DifAlias(t, [S,U,V])
#for S,U,V depending on t,x,y,z write DifAlias([t,x,y,z], [S,U,V])

diffAlias :=

proc(vars,funs)
local i,j,k,l,nvar,nfun;
option `Copyright 1994-95 Roberto Sussman. Used with permission.`;
#
# as in autoAlias the u=u(r) causes grief. So take it out for now [pm]
#
if type(vars,name) then
        if type(funs,name) then
            RETURN(alias(seq(
                funs[vars $ i] = diff(funs(vars),vars $ i),
                i = 1..3 )))
        fi
    fi;
    if type(vars,name) then
        if type(funs,list) then
            RETURN(alias(
              seq(seq(
              funs[i][vars $ j] = diff(funs[i](vars),vars $ j),
              i = 1 .. nops(funs)),j = 1 .. 3)))
        fi
    fi;
    if type(vars,list) then
        if type(funs,name) then
            RETURN(alias(
                seq(
                funs[vars[i]] = diff(funs(op(vars)),vars[i]),
                i = 1 .. nops(vars)),seq(seq(
                funs[vars[i],vars[j]] =
                diff(funs(op(vars)),vars[i],vars[j]),
                i = 1 .. nops(vars)),j = 1 .. nops(vars)), 
                 seq(seq(seq(
                funs[vars[i],vars[j],vars[k]] =
                diff(funs(op(vars)),vars[i],vars[j],vars[k]),
                i = 1 .. nops(vars)),j = 1 .. nops(vars)), k=1..nops(vars)) ))
        fi
    fi;
    if type(vars,list) then
        if type(funs,list) then
            RETURN(alias(seq(seq(
            funs[k][vars[i]] = diff(funs[k](op(vars)),vars[i]),
            i = 1 .. nops(vars)),k = 1 .. nops(funs)),seq(seq(
            seq(funs[k][vars[i],vars[j]] =
            diff(funs[k](op(vars)),vars[i],vars[j]),
            i = 1 .. nops(vars)),j = 1 .. nops(vars)),
            k = 1 .. nops(funs)), seq(seq(seq(
            seq(funs[k][vars[i],vars[j], vars[l]] =
            diff(funs[k](op(vars)),vars[i],vars[j], vars[l]),
            i = 1 .. nops(vars)),j = 1 .. nops(vars)),
            k = 1 .. nops(funs)),l=1..nops(vars) )))
        fi
    fi
end;
