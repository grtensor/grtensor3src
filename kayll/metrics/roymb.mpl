Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1:
g22_ := 1/(K*r^2)*diff(R(t,r),r)^2:
g33_ := R(t,r)^2:
g44_ := R(t,r)^2*theta^2:
constraint_ := []:
Info_ := `Roy and Singh metric with viscosity. plane symmetric`:
Ref_ ["Roy, S.R., Singh, J.P., ijpam, v13, p1285, (1982)"]:
Archive4_ := `(2.15.1) p95`:
