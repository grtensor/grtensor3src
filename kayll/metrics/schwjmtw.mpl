Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -16*M^3/r*exp(-1/2*r/M):
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(u,v),u) = -4*v*M^2/exp(1/2*r/M)/r, diff(r(u,v),v) = -4*u*M^2/exp(1/2*r/M)/r]:
Info_ := `Equation 10a, Box 31.2, Page 832, Schwarzschild, Misner-Thorne-Wheeler`:

