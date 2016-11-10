Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
eta11_ := -1:
eta22_ := 1:
eta33_ := 1:
eta44_ := 1:
bd11_ := exp(1/2*A1(r)):
bd22_ := exp(1/2*B1(r)):
bd33_ := exp(1/2*B1(r))*r:
bd44_ := exp(1/2*B1(r))*r*sin(theta):
constraint_ := [A1(r) = int(2*epsilon*(-x*diff(z(x),x))^(1/2)/(1-z(x)*x^2),x = 0 .. r), B1(r) = int(-2*(epsilon*(-x*diff(z(x),x))^(1/2)-2*x*z(x))/(1-z(x)*x^2),x = 0 .. r),epsilon^2=1]:
