Ndim_ := 3 :
x1_ := r :
x2_ := theta :
x3_ := phi :
x4_ := t :
g11_ := diff(R(r,t),r)^2/(1 + f(r)) :
g22_ := R(r,t)^2 :
g33_ := R(r,t)^2*sin(theta)^2 :


constraint_ := [
]:
Info_:=`Tolman metric t=const`:

