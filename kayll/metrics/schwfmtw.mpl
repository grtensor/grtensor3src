Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := 32*M^3/r*exp(-1/2*r/M):
g22_ := -32*M^3/r*exp(-1/2*r/M):
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(u,v),u) = 8*u*M^2/exp(1/2*r/M)/r, diff(r(u,v),v) = -8*v*M^2/exp(1/2*r/M)/r]:
Info_ := `Equation 31.14a, Schwarzschild, Misner-Thorne-Wheeler`:

