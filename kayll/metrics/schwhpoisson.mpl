Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -1/2+M/r(u,v):
g33_ := r(u,v)^2:
g44_ := r(u,v)^2*sin(theta)^2:
constraint_ := [r(u,v) = 2*M*(LambertW(1/2*1/M*exp(-1/8*(-4*a^2*u+v+8*a*M)/a/M))+1)]:
Info_ := `Equation 5.6, Schwarzschild, Poisson, Copyright GRTensor.org`:
