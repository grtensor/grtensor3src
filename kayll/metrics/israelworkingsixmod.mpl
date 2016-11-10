Ndim_ :=    6   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
x6_   := epsilon:
sig_  :=5:
complex_ := {}:
g11_   :=  F(u,w):
g12_   :=   1  :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
g55_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2:
g66_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
constraint_ :=   [r(u,w)= (d-3)*u/C^2*(3*M-C)*w+C]   :
Info_:=`Generalized Israel coordinates (Phys. Rev. 143,1016)`:
