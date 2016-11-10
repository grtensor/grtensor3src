Ndim_ :=   5   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
complex_ := {}:
g11_   :=   -(2*w^2/m/(2*m-r(u,w))^2*(-r(u,w)^(-d+3)*2^d*m^d+8*d*m^3-4*d*r(u,w)*m^2-16*m^3+12*r(u,w)*m^2))/(4*m)^2:
g12_   :=   1  :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
g55_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2:
constraint_ :=   [r(u,w) = 2*m+(d-3)*u*w/(4*m)]  :

