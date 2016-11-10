Ndim_ := 4:
x1_ := t:
x2_ := phi:
x3_ := r:
x4_ := theta:
sig_ := 2:
complex_ := {}:
g11_ := -Delta(r)^2/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)+Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)*a^2*sin(theta)^2:
g12_ := -Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2*a*sin(theta)^2/Sigma(r,theta)*r^2-Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2*a^3*sin(theta)^2/Sigma(r,theta)+Delta(r)^2/((sin(theta)^2)^(1/(2*omega+3)))^2*a*sin(theta)^2/Sigma(r,theta):
g22_ := Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)*sin(theta)^2*r^4+2*Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)*sin(theta)^2*r^2*a^2+Delta(r)/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)*sin(theta)^2*a^4-Delta(r)^2/((sin(theta)^2)^(1/(2*omega+3)))^2/Sigma(r,theta)*sin(theta)^4*a^2:
g33_ := ((Delta(r)*sin(theta)^2)^(1/(2*omega+3)))^2*Sigma(r,theta)/Delta(r):
g44_ := ((Delta(r)*sin(theta)^2)^(1/(2*omega+3)))^2*Sigma(r,theta):
constraint_ := [Sigma(r,theta) = r^2+a^2*cos(theta)^2]:
