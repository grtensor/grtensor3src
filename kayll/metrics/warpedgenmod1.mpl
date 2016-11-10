Ndim_ := 4:
x1_ := x1:
x2_ := x2:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -a(x1,x2):
g12_ := b(x1,x2):
g22_ := c(x1,x2):
g33_ := R(x1,x2)^2:
g44_ := R(x1,x2)^2*sin(theta)^2:
constraint_:=[diff(R(x1,x2),x1,x2)=1/2*(diff(a(x1,x2),x2)*diff(R(x1,x2),x1)*c(x1,x2)+diff(c(x1,x2),x1)*diff(R(x1,x2),x2)*a(x1,x2))/a(x1,x2)/c(x1,x2)]:
