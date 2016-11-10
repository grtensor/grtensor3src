Ndim_ := 4:
x1_ := u:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*m/r+Omega(r)^2*r^2*sin(theta)^2:
g12_ := -1:
g14_ := -Omega(r)*r^2*sin(theta)^2:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [Omega(r) = R^2/r^3]:
