Ndim_ := 4:
x1_ := v:
x2_ := w:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := -1/2+m/r:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(v,w),v) = 1/2/(1+2*m/(r-2*m)*ln(r-2*m)), diff(r(v,w),w) = -1/2/(1+2*m/(r-2*m)*ln(r-2*m))]:
Info_ := `Chapter 5.5, Page 153, Schwarzschild, Hawking and Ellis`:

