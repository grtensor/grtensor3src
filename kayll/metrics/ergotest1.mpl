Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
g11_ := 2*(1+sin(theta))/sin(theta)^2:
g22_ := 2*m^2+2*m^2*sin(theta):
g33_ := 2*sin(theta)^2*m^2+2*m^2*sin(theta)^4+2*m^2*sin(theta)^3:
g34_ := -m*sin(theta)^2:
Info_ := `Kerr metric in Boyer-Lindquist coordinates.`:

