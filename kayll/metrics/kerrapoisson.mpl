Ndim_ := 4:
x1_ := r:
x2_ := t:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := rho(r,theta)^2/Delta(r):
g22_ := -rho(r,theta)^2*Delta(r)/Sigma(r,theta)+Sigma(r,theta)*sin(theta)^2/rho(r,theta)^2*omega(r,theta)^2:
g24_ := -Sigma(r,theta)*sin(theta)^2/rho(r,theta)^2*omega(r,theta):
g33_ := rho(r,theta)^2:
g44_ := Sigma(r,theta)*sin(theta)^2/rho(r,theta)^2:
constraint_ := [rho(r,theta) = (r^2+a^2*cos(theta)^2)^(1/2), Delta(r) = r^2-2*M*r+a^2, Sigma(r,theta) = (r^2+a^2)^2-a^2*sin(theta)^2*Delta(r), omega(r,theta) = 2*M*a*r/Sigma(r,theta)]:
Info_ := `Equation 5.44, Kerr, Poisson, Copyright GRTensor.org`:


