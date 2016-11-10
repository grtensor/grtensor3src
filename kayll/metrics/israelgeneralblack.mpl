Ndim_ :=    5  :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_   :=   x   :
sig_  :=4:
g11_   :=  w*(2*C*(u*w-(r(u,w)-C)^2)+r(u,w)*u*w)/(3*u*r(u,w)*C^2):
g12_   :=   1   :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
g55_   :=   f(x)   :
constraint_ :=   [r(u,w)= u/C^2*(3*M-C)*w+C]   :
Info_:=`Black string and Lambda`:
