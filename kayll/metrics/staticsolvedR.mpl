Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   1/(1-2*m(r)/r)  :
g22_   :=   R(r)^2:
g33_   :=   R(r)^2*sin(theta)^2   :
g44_   :=   -exp(2*Phi(r)):
constraint_:=[m(r) = (Int(-r*exp(-Int((2*R(r)*diff(R(r),r)*diff(Phi(r),r)*r+R(r)*diff(R(r),r)-2*R(r)*diff(R(r),`$`(r,2))*r-2*diff(Phi(r),`$`(r,2))*r*R(r)^2-2*diff(Phi(r),r)^2*r*R(r)^2+2*diff(R(r),r)^2*r+diff(Phi(r),r)*R(r)^2)/R(r)/r/(diff(R(r),r)+diff(Phi(r),r)*R(r)),r))*(diff(R(r),r)^2+R(r)*diff(R(r),r)*diff(Phi(r),r)-R(r)*diff(R(r),`$`(r,2))-1-diff(Phi(r),r)^2*R(r)^2-diff(Phi(r),`$`(r,2))*R(r)^2)/R(r)/(diff(R(r),r)+diff(Phi(r),r)*R(r)),r)+_C1)*exp(Int((2*R(r)*diff(R(r),r)*diff(Phi(r),r)*r+R(r)*diff(R(r),r)-2*R(r)*diff(R(r),`$`(r,2))*r-2*diff(Phi(r),`$`(r,2))*r*R(r)^2-2*diff(Phi(r),r)^2*r*R(r)^2+2*diff(R(r),r)^2*r+diff(Phi(r),r)*R(r)^2)/R(r)/r/(diff(R(r),r)+diff(Phi(r),r)*R(r)),r))]:
