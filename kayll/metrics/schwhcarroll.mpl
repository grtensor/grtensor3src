Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -16*G^3*M^3*exp(-1/2*r/G/M)/r:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(u,v),u) = -4*v*G^2*M^2/exp(1/2*r/G/M)/r, diff(r(u,v),v) = -4*u*G^2*M^2/exp(1/2*r/G/M)/r]:
Info_ := `Equation 5.130, Schwarzschild, Carroll`:

