Ndim_ := 4:
x1_ := U:
x2_ := V:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -1/2+M/r(U,V):
g33_ := r(U,V)^2:
g44_ := r(U,V)^2*sin(theta)^2:
constraint_ := [r(U,V) = 2*M*(LambertW(1/2*1/M*exp(-1/8*(-4*a^2*U+V+8*a*M)/a/M))+1)]:
Info_ := `Box 31.4 Equation 7, Misner-Thorne-Wheeler, Copyright GRTensor.org`:
