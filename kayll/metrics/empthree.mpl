Ndim_ := 3:
x1_ := y:
x2_ := x:
x3_ := phi:
sig_ := 3:
complex_ := {}:
g11_ := -1/A^2/(x-y)^2*F[x](x)*F[y](y)/G[y](y):
g22_ := 1/A^2/(x-y)^2*F[y](y)^2/G[x](x):
g33_ := 1/A^2/(x-y)^2*F[y](y)^2*G[x](x)/F[x](x):
constraint_:=[F[x](x)=1-x/xi[1],F[y](y)=1-y/xi[1],G[x](x)=nu*x^3-x^2+1,G[y](y)=nu*y^3-y^2+1]:
