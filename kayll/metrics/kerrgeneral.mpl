Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
g11_ := Sigma(r,theta)/Delta(r):
g22_ := Sigma(r,theta):
g33_ := sin(theta)^2*(r^2+a^2+(2*m*r*a^2*sin(theta)^2/(r^2+a^2*cos(theta)^2))):
g34_ := -2*m*a*r*sin(theta)^2/(r^2+a^2*cos(theta)^2):
g44_ := -Psi(r,theta)/Sigma(r,theta):
Info_:=`Kerr metric in Boyer-Lindquist coordinates.`:

