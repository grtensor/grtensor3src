Ndim_ :=    4   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
g11_   :=  1/3*w*(2*u*w*C-2*C*r(u,w)^2+4*r(u,w)*C^2-2*C^3+r(u,w)*u*w)/u/r(u,w)/C^2 :
g12_   :=   1   :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
constraint_ :=   [r(u,w)= u/C^2*(3*M-C)*w+C]   :
Info_:=`Israel coordinates (Phys. Rev. 143,1016)`:
