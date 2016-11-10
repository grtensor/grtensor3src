Ndim_ := 4:
x1_ := w:
x2_ := y:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -A(w,y)^2:
g12_ := A(w,y)*B(w,y):
g33_ := C(w,y)^2:
g44_ := C(w,y)^2*sin(theta)^2:
constraint_:=[diff(B(w,y),w)=-diff(A(w,y),y)]:
