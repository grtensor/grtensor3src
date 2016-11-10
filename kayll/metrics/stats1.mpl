Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
complex_ := {}:
g11_ := c(r):
g14_ := b(r)^(1/2):
g22_ := r^2:
g33_ := r^2*sin(theta)^2:
g44_ := -a(r):
constraint_ := [diff(a(r),r) = (b(r)+c(r)*a(r)-a(r))/r, diff(b(r),r) = (-b(r)*c(r)-c(r)^2*a(r)+c(r)*a(r)-a(r)*diff(c(r),r)*r)/r]:
