Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -t*f(r):
g22_ := t/f(r):
g33_ := t*r^2*f(r)^(1/a)/f(r):
g44_ := t*r^2*f(r)^(1/a)/f(r)*sin(theta)^2:
constraint_ := [f(r) = (1-2/r)^a]:
