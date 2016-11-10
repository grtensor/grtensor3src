Ndim_ :=    5   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   := delta:
sig_  :=3:
complex_ := {}:
g11_   :=  (w*(2*C*((u*w)-(r(u,w)-C)^(2))+r(u,w)*(u*w))/((3)*u*r(u,w)*C^(2)))^1:
g12_   :=   1  :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
g55_   :=   r(u,w)^2*sin(theta)^2*sin(phi)^2:
constraint_ :=   [r(u,w)= (d-3)*u/C^2*(3*M-C)*w+C]   :
Info_:=`Generalized Israel coordinates (Phys. Rev. 143,1016)`:
