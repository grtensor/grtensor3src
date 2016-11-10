Ndim_ := 4:
x1_ := t:
x2_ := u:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -exp(lambda(u,theta))^2:
g22_ := a^2*exp(nu(u,theta))^2/exp(lambda(u,theta))^2*sinh(u)^2+a^2*exp(nu(u,theta))^2/exp(lambda(u,theta))^2*sin(theta)^2:
g33_ := a^2*exp(nu(u,theta))^2/exp(lambda(u,theta))^2*sinh(u)^2+a^2*exp(nu(u,theta))^2/exp(lambda(u,theta))^2*sin(theta)^2:
g44_ := a^2/exp(lambda(u,theta))^2*cosh(u)^2*cos(theta)^2:
constraint_ := [lambda(u,theta) = -M/(a^2*(cosh(u)^2-1+cos(theta)^2))^(1/2), nu(u,theta) = -1/2*M^2*cosh(u)^2*cos(theta)^2/a^2/(cosh(u)^2-1+cos(theta)^2)^2]:
