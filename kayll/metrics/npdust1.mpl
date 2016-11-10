Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:
eta12_ := 1:
eta34_ := -1:
bd11_ := -diff(R(r,t),r)^2/(1+f(r)):
bd14_ := diff(R(r,t),r)/(1+f(r))^(1/2):
bd21_ := 1/2:
bd24_ := 1/2/diff(R(r,t),r)*(1+f(r))^(1/2):
bd32_ := -1/2*I*2^(1/2)*R(r,t):
bd33_ := -1/2*2^(1/2)*R(r,t)*sin(theta):
bd42_ := 1/2*I*2^(1/2)*R(r,t):
bd43_ := -1/2*2^(1/2)*R(r,t)*sin(theta):
constraint_ := [diff(diff(R(r,t),r),t) = 1/2*(2*diff(m(r),r)/R(r,t)-2*m(r)*diff(R(r,t),r)/R(r,t)^2+diff(f(r),r))/(2*m(r)/R(r,t)+f(r))^(1/2), diff(R(r,t),t) = (2*m(r)/R(r,t)+f(r))^(1/2), diff(diff(R(r,t),t),t) = -m(r)/R(r,t)^2, diff(diff(diff(R(r,t),r),t),t) = -diff(m(r),r)/R(r,t)^2+2*m(r)*diff(R(r,t),r)/R(r,t)^3]:
Info_ := `The Tolman dust solution (Proc. Nat. Acad. Sci. 20, 169,1934)`:

