Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g12_ := b(u,v):
g33_ := r(u,v)^2:
g44_ := r(u,v)^2*sin(theta)^2:
constraint_:=[diff(r(u,v),u,v)=1/2*(diff(b(u,v),u,v)*b(u,v)*r(u,v)^2-diff(b(u,v),u)*diff(b(u,v),v)*r(u,v)^2-b(u,v)^3+2*b(u,v)^2*diff(r(u,v),u)*diff(r(u,v),v))/b(u,v)^2/r(u,v)]:
