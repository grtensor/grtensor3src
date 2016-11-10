Ndim_ :=   8  :
x1_   :=   U   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
x6_   := epsilon:
x7_   := iota:
x8_   := alpha:
complex_ := {}:
g11_   :=   40*m*w^2/r(U,w)^5*(r(U,w)^4+(8/5)*m*r(U,w)^3+(12/5)*m^2*r(U,w)^2+(16/5)*m^3*r(U,w)+(16/5)*m^4):
g12_   :=   4*m   :
g33_   :=   r(U,w)^2   :
g44_   :=   r(U,w)^2*sin(theta)^2   :
g55_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2:
g66_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
g77_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2*sin(epsilon)^2:
g88_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2*sin(epsilon)^2*sin(iota)^2:
constraint_ :=   [r(U,w) = 2*m+5*U*w]   :

