Ndim_ := 5:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
x5_   :=   l   :
sig_:=4:
g11_ := (r^2+a^2*cos(theta)^2)/(r^2-2*m*r+a^2):
g22_ := r^2+a^2*cos(theta)^2:
g33_ := sin(theta)^2*(r^2+a^2+(2*m*r*a^2*sin(theta)^2/(r^2+a^2*cos(theta)^2))):
g34_ := -2*m*a*r*sin(theta)^2/(r^2+a^2*cos(theta)^2):
g44_ := -(1-2*m*r/(r^2+a^2*cos(theta)^2)):
g55_   := r^2*sin(theta)^2*sin(l)^2:
Info_:=`Kerr metric in Boyer-Lindquist coordinates.`:

