Ndim_ :=   4   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
complex_ := {}:
g11_   :=   2*w/u+(4*m/u)^2*((2*m/r(u,w))^(N-3)-1+2*Lambda*r(u,w)^2/((N-1)*(N-2))) :
g12_   :=   1   :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
constraint_ :=   [r(u,w) = (2*m+(1/(4*m))*(u*w))^1]   :
Info_:=`Israel coordinates (Phys. Rev. 143,1016)`:
