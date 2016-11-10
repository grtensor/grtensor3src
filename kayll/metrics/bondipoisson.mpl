Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -exp(psi(t,r))^2*f(t,r):
g22_ := 1/f(t,r):
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [f(t,r) = 1-2*m(t,r)/r]:
