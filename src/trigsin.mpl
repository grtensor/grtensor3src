
`trigsin/normal` := proc(a)
local p,s,x;
options remember,system,`Copyright 1993 by Waterloo Maple Software`;
    p := readlib(`trig/polynom`)(a);
    if p = FAIL then RETURN(`trigsin/ident`(a)) fi;
    x := p[2];
    s := p[3];
    p := p[1];
    if has(p,cos) then p := prem(p,cos(x)^2+sin(x)^2-1,cos(x)) fi;
    if has(p,cosh) then p := prem(p,cosh(x)^2-sinh(x)^2-1,cosh(x)) fi;
    subs(x = x/s,p)
end:

`simplify/trigsin` :=

 proc(a)
 local c0,c1,f,f1,n,n1,d,d1,s,S,Strig;
 options remember,system,`Copyright 1993 by Waterloo Maple Software`;
     if type(a,ratpoly(rational)) then RETURN(a)
     elif type(a,{'equation','range','list','set'}) then RETURN(map(`simplify/trig`,a))
     fi;
     f := convert(a,sincos);
     f := `simplify/trigsin/recurse`(f);
     f := `simplify/normal`(f);
     n := frontend(expand,[numer(f)]);
     d := frontend(expand,[denom(f)]);
     n := `trigsin/normal`(n);
     d := `trigsin/normal`(d);
     f := frontend(`simplify/normal`,[n/d]);
     d := denom(f);
     n := numer(f);
     S := indets(d,'name') minus indets(select(type,indets(d,'RootOf'),'algfun'),'name');
     Strig := indets(d,'trig');
     Strig := select(y -> member(op(0,y),{'cos','cosh'}),Strig);
     for s in Strig do
         if type(d,polynom('anything',s)) then
             d1 := collect(d,s);
             if degree(d1,s) = 1 then
                 c1 := coeff(d1,s,1);
                 c0 := coeff(d1,s,0);
                 if testeq(c1*s-c0) <> false then
                     if not type(s,constant) and type(c1,polynom('algfun',S)) and
                         type(c0,polynom('algfun',S)) then
                         if traperror(evala(Expand(1/(c1*s-c0)))) = lasterror then next fi
                     else next
                     fi
                 fi;
                 if op(0,s) = 'cos' then d1 := simplify(c1^2*(1-sin(op(1,s))^2)-c0^2)
                 else d1 := simplify(c1^2*(sinh(op(1,s))^2+1)-c0^2)
                 fi;
                 n1 := simplify(n*(c1*s-c0),'trigsin');
                 f1 := frontend(`simplify/normal`,[n1/d1]);
                 if length(f1) < length(f) then f := f1; d := denom(f); n := numer(f) fi
             fi
         fi
     od;
     f
 end:

`simplify/trigsin/recurse` :=
     proc(x)
     local a,n;
     options `Copyright 1993 by Waterloo Maple Software`;
         if type(x,function) then n := op(0,x); a := map(`simplify/trigsin`,[op(x)]); n(op(a))
         elif type(x,`^`) and not type(op(2,x),integer) then
             `simplify/trigsin`(op(1,x))^`simplify/trigsin`(op(2,x))
         elif type(x,{`+`,`*`,`^`}) then map(procname,x)
         else x
         fi
     end:

`trigsin/ident` := proc(a)
 local x;
 options remember,system,`Copyright 1993 by Waterloo Maple Software`;
     if not has(a,'[sin,cos,sinh,cosh]') then a
     elif type(a,`*`) then
         x := frontend(expand,[map(`trigsin/ident`,a)]); if x = a then x else `trigsin/ident`(x) fi
     elif type(a,`^`) then
         if not type(op(2,a),integer) then a
         elif type(op(1,a),function) and op(0,op(1,a)) = cos then
             subs(_X = op(1,op(1,a)),`trigsin/cos`(op(2,a)))
         elif type(op(1,a),function) and op(0,op(1,a)) = cosh then
             subs(_X = op(1,op(1,a)),`trigsin/cosh`(op(2,a)))
         else a
         fi
     elif type(a,`+`) then map(procname,a)
     else a
     fi
 end:

`trigsin/cos` := proc(n)
     options remember,`Copyright 1993 by Waterloo Maple Software`;
         expand((1-sin(_X)^2)*`trigsin/cos`(n-2))
     end:

`trigsin/cos`(0) := 1:
`trigsin/cos`(1) := cos(_X):

`trigsin/cosh` := proc(n)
     options remember,`Copyright 1993 by Waterloo Maple Software`;
         expand((sinh(_X)^2+1)*`trigsin/cosh`(n-2))
     end:

`trigsin/cosh`(0) := 1:
`trigsin/cosh`(1) := cosh(_X):




