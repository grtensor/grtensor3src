Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := theta:
x4_ := phi:
sig_ := -2:
complex_ := {}:
g11_ := 16*m^2*exp(-1/2*r/m)/r:
g22_ := -16*m^2*exp(-1/2*r/m)/r:
g33_ := -r^2:
g44_ := -r^2*sin(theta)^2:
constraint_ := [diff(r(x,t),x) = 4*x*m/exp(1/2*r/m)/r, diff(r(x,t),t) = -4*t*m/exp(1/2*r/m)/r]:
Info_ := `Equation 17.7, Kruskal, D'Inverno`:

