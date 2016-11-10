Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   exp(alpha(r,t))   :
g22_   :=   R(r,t)^2  :
g33_   :=   R(r,t)^2*sin(theta)^2   :
g44_   :=   -exp(mu(r,t))   :
constraint_ := [ diff(mu(r,t),r)=-(-2*diff(R(r,t),r,t)+diff(alpha(r,t),t)*diff(R(r,t),r))/diff(R(r,t),t)]:

