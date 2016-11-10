Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := y:
x4_ := z:
complex_ := {}:
g11_ := (-u(x,y,z)+2*M)/u(x,y,z):
g22_ := (y^2*u(x,y,z)-2*M*y^2+u(x,y,z)*z^2-2*z^2*M+u(x,y,z)*x^2)/u(x,y,z)^2/(u(x,y,z)-2*M):
g23_ := 2*x*M*y/u(x,y,z)^2/(u(x,y,z)-2*M):
g24_ := 2*x*z*M/u(x,y,z)^2/(u(x,y,z)-2*M):
g33_ := (y^2*u(x,y,z)-2*z^2*M+u(x,y,z)*z^2-2*M*x^2+u(x,y,z)*x^2)/u(x,y,z)^2/(u(x,y,z)-2*M):
g34_ := 2*y*z*M/u(x,y,z)^2/(u(x,y,z)-2*M):
g44_ := (y^2*u(x,y,z)-2*M*y^2+u(x,y,z)*x^2+u(x,y,z)*z^2-2*M*x^2)/u(x,y,z)^2/(u(x,y,z)-2*M):
constraint_:= [u(x,y,z)=(x^2+y^2+z^2)^(1/2)]:
