Ndim_ := 4:
x1_ := t:
x2_ := phi:
x3_ := r:
x4_ := theta:
complex_ := {}:
g11_ := -1+2*M*r/rho(r,theta)^2:
g12_ := -2*M*a*r*sin(theta)^2/rho(r,theta)^2:
g22_ := Sigma(r,theta)*sin(theta)^2/rho(r,theta)^2:
g33_ := rho(r,theta)^2/Delta(r):
g44_ := rho(r,theta)^2:
constraint_ := [rho(r,theta) = (r^2+a^2*cos(theta)^2)^(1/2), Delta(r) = r^2-2*M*r+a^2, Sigma(r,theta) = (r^2+a^2)^2-a^2*sin(theta)^2*(r^2-2*M*r+a^2)]:
Info_ := `Equation 5.44, Kerr, Poisson (Inefficient form)`:

