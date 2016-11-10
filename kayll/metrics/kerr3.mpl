Ndim_ := 4:
x1_ := x:
x2_ := theta:
x3_ := phi:
x4_ := t:
g11_ := (x^2+A^2*cos(theta)^2)/(x^2-2*x+A^2):
g22_ := x^2+A^2*cos(theta)^2:
g33_ := sin(theta)^2*(x^2+A^2+(2*x*A^2*sin(theta)^2/(x^2+A^2*cos(theta)^2))):
g34_ := -2*A*x*sin(theta)^2/(x^2+A^2*cos(theta)^2):
g44_ := -(1-2*x/(x^2+A^2*cos(theta)^2)):
Info_:=`Kerr metric in dimensionless Boyer-Lindquist coordinates.`:





