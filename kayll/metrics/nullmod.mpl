Ndim_ := 4:
x1_ := u:
x2_ := v:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g12_ := b(u,v):
g33_ := r(u,v)^2:
g44_ := r(u,v)^2*sin(theta)^2:
constraint_:=[diff(r(u,v),u,v)=-1/6*K*b(u,v)*r(u,v)]:
