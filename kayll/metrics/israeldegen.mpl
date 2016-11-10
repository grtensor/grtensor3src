Ndim_ :=    4   :
x1_   :=   u   :
x2_   :=   w   :
x3_   :=   theta   :
x4_   :=   phi   :
sig_  :=2:
g11_   :=  -w*(12*u*r(u,w)^2*(u^2+1)-w*(w+3*u^2+3)*(w+u^2+1))/r(u,w)^2/(u^2+1)^2/3:
g12_   :=   1   :
g33_   :=   r(u,w)^2   :
g44_   :=   r(u,w)^2*sin(theta)^2   :
constraint_ :=   [r(u,w)= (w+u^2+1)/Lambda^(1/2)/(u^2+1)]   :
Info_:=`Generalized Israel coordinates (Degenerate case)`:
