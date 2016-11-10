Ndim_ := 2:
x1_ := theta:
x2_ := phi:
complex_ := {}:
g11_ := 2*m^2*x(theta)/(x(theta)-1)^2:
g22_ := 2*m^2*sin(theta)^2*x(theta)+2*m^2*sin(theta)^4*A^2:
constraint_ := [x(theta) = 1-(1-A^2*cos(theta)^2)^(1/2)]:
Info_:=`Kerr SLS (two-dimensional cross-section).`:
