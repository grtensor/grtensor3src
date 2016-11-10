Ndim_ :=    5   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
sig_  :=3:
complex_ := {}:
g11_   :=  F(u,w)*E:
g12_   :=   E  :
g33_   :=   r(u,w)^2*E   :
g44_   :=   r(u,w)^2*sin(theta)^2*E   :
g55_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2*E:
constraint_ :=   [r(u,w)= (d-3)*u/C^2*(3*M-C)*w+C]   :
Info_:=`Generalized Israel coordinates (Phys. Rev. 143,1016)`:
