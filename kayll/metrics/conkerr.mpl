Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
g11_ := f(t)*(r^2+a^2*cos(theta)^2)/(r^2-2*m*r+a^2):
g22_ := f(t)*(r^2+a^2*cos(theta)^2):
g33_ := f(t)*sin(theta)^2*(r^2+a^2+(2*m*r*a^2*sin(theta)^2/(r^2+a^2*cos(theta)^2))):
g34_ := -f(t)*2*m*a*r*sin(theta)^2/(r^2+a^2*cos(theta)^2):
g44_ := -f(t)*(1-2*m*r/(r^2+a^2*cos(theta)^2)):
Info_:=`Kerr metric in Boyer-Lindquist coordinates.`:

