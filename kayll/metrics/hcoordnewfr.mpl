Ndim_ := 5:
x1_ := w:
x2_ := t:
x3_ := r:
x4_ := theta:
x5_ := phi:
sig_ := 5:
complex_ := {}:
g11_ := A*(1/r)^alpha:
g22_ := B*(1/r)^delta:
g33_ := 1/f(r)/S(r)^4/r^4:
g44_ := 1/f(r)/S(r)^2:
g55_ := 1/f(r)/S(r)^2*sin(theta)^2:
constraint_:=[alpha^2+delta^2+alpha*delta-1=0]:
