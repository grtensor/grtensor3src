Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -exp(-2*Phi_[0])*exp(A1(r)):
g22_ := exp(B1(r)):
g33_ := exp(B1(r))*r^2:
g44_ := exp(B1(r))*r^2*sin(theta)^2:
constraint_ := [A1(r) = int(2*(-x*diff(z(x),x))^(1/2)/(1-z(x)*x^2),x = 0 .. r), B1(r) = int(-2*((-x*diff(z(x),x))^(1/2)-2*x*z(x))/(1-z(x)*x^2),x = 0 .. r)]:
