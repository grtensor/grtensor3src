Ndim_ :=  6  :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
x6_   := epsilon:
complex_ := {}:
g11_   :=   w^2/((a)*m*r(u,w)^2)*(r(u,w)):
g12_   :=   1   :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
g55_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2:
g66_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
constraint_ :=   [r(u,w) = u*w/(2*m)+2*m]   :

