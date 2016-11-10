Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1/rho(r,theta)^2*Delta(r)+1/rho(r,theta)^2*a^2*sin(theta)^2:
g14_ := -2*a*M*r*sin(theta)^2/rho(r,theta)^2:
g22_ := rho(r,theta)^2/Delta(r):
g33_ := rho(r,theta)^2:
g44_ := sin(theta)^2/rho(r,theta)^2*r^4+2*sin(theta)^2/rho(r,theta)^2*r^2*a^2+sin(theta)^2/rho(r,theta)^2*a^4-sin(theta)^4/rho(r,theta)^2*a^2*Delta(r):
constraint_ := [Delta(r) = r^2-2*M*r+a^2, rho(r,theta) = (r^2+a^2*cos(theta)^2)^(1/2)]:
Info_ := `Equation 11.64, Kerr, Schutz, Copyright GRTensor.org`:


