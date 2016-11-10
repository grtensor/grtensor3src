Ndim_ :=   7   :
x1_   :=   U   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
x6_   := epsilon:
x7_   := iota:
complex_ := {}:
g11_   :=   32*m*w^2/r(U,w)^4*(r(U,w)^3+(3/2)*m*r(U,w)^2+2*m^2*r(U,w)+2*m^3):
g12_   :=   4*m   :
g33_   :=   r(U,w)^2   :
g44_   :=   r(U,w)^2*sin(theta)^2   :
g55_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2:
g66_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
g77_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2*sin(epsilon)^2:
constraint_ :=   [r(U,w) = 2*m+4*U*w]   :

