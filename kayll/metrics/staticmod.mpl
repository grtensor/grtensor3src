Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   1/(1-2*m(r)/r)  :
g22_   :=   r^2   :
g33_   :=   r^2*sin(theta)^2   :
g44_   :=   -exp(2*Phi(r))   :
constraint_ := [ m(r) = (Int(r*exp(Int((-2-4*diff(Phi(r),r)*r-P(r)+P(r)*diff(Phi(r),r)*r+2*P(r)*diff(Phi(r),`$`(r,2))*r^2+2*P(r)*diff(Phi(r),r)^2*r^2)/P(r)/r/(1+diff(Phi(r),r)*r),r))*(-2*diff(Phi(r),r)+P(r)*diff(Phi(r),r)+P(r)*diff(Phi(r),`$`(r,2))*r+P(r)*diff(Phi(r),r)^2*r)/P(r)/(1+diff(Phi(r),r)*r),r)+_C1)/exp(Int((-2-4*diff(Phi(r),r)*r-P(r)+P(r)*diff(Phi(r),r)*r+2*P(r)*diff(Phi(r),`$`(r,2))*r^2+2*P(r)*diff(Phi(r),r)^2*r^2)/P(r)/r/(1+diff(Phi(r),r)*r),r))]:
