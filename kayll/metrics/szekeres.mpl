Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := p:
x4_ := q:
complex_ := {}:
g11_ := -1:
g22_ := 1/(epsilon+f(r))*diff(R(t,r),r)^2-2/(epsilon+f(r))*diff(R(t,r),r)*R(t,r)*diff(E(r,p,q),r)/E(r,p,q)+1/(epsilon+f(r))*R(t,r)^2*diff(E(r,p,q),r)^2/E(r,p,q)^2:
g33_ := R(t,r)^2/E(r,p,q)^2:
g44_ := R(t,r)^2/E(r,p,q)^2:
constraint_ := [diff(R(t,r),t)=sqrt(2*M(r)/R(t,r)+f(r)),diff(diff(R(t,r),t),r)=-1/2*(-2*diff(M(r),r)*R(t,r)+2*diff(R(t,r),r)*M(r)-diff(f(r),r)*R(t,r)^2)/((2*M(r)+f(r)*R(t,r))/R(t,r))^(1/2)/R(t,r)^2,diff(diff(R(t,r),t),t)=-M(r)/R(t,r)^2,diff(diff(diff(R(t,r),t),t),r)=diff(M(r),r)/R(t,r)^2-2*M(r)/R(t,r)^3*diff(R(t,r),r),E(r,p,q) = A(r)*(p^2+q^2)+2*B[1](r)*p+2*B[2](r)*q+C(r), A(r) = (1/4*epsilon+B[1](r)^2+B[2](r)^2)/C(r)]:
