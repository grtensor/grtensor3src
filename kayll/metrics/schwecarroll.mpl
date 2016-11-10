Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -1/2+G*M/r:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(u,v),u) = -1/2*r/(r+2*G*M), diff(r(u,v),v) = r/(r+2*G*M)]:
Info_ := `Equation 5.116, Schwarzschild, Carroll`:

