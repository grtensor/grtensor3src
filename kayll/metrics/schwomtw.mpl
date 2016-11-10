Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := y:
x4_ := z:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*M/r-2*M^2/r^2:
g22_ := 1+2*M/r:
g33_ := 1+2*M/r:
g44_ := 1+2*M/r:
constraint_ := [diff(r(x,y,z),x) = 1/(x^2+y^2+z^2)^(1/2)*x, diff(r(x,y,z),y) = 1/(x^2+y^2+z^2)^(1/2)*y, diff(r(x,y,z),z) = 1/(x^2+y^2+z^2)^(1/2)*z]:
Info_ := `Equation 40.1b, Schwarzschild, Misner-Thorne-Wheeler`:

