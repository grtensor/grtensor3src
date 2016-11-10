Ndim_ := 2:
x1_ := theta:
x2_ := phi:
g11_ :=m^2*(x^2+A^2*cos(theta)^2):
g22_ := m^2*(sin(theta)^2*(x^2+A^2+(2*x*A^2*sin(theta)^2/(x^2+A^2*cos(theta)^2)))):
constraint_ :=[x=1+(1-A^2)^(1/2)]:
Info_:=`Kerr Horizon (two-dimensional cross-section), x=r/m,A=a/m.`:

