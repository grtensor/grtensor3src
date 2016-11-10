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
g11_   :=   -2*w^2/m/(2*m-r(U,w))^2*(-r(U,w)^(-d+3)*2^d*m^d+8*d*m^3-4*d*r(U,w)*m^2-16*m^3+12*r(U,w)*m^2):
g12_   :=   4*m   :
g33_   :=   r(U,w)^2   :
g44_   :=   r(U,w)^2*sin(theta)^2   :
g55_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2:
g66_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
g77_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2*sin(epsilon)^2:
g88_   :=   r(U,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2*sin(epsilon)^2*sin(iota)^2:
constraint_ :=   [r(U,w) = 2*m+(d-3)*U*w]   :

