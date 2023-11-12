# 使用指南
[TOC]
## 求导
* 一阶导
~~~matlab
syms x y z;
diff(x^2+log(y)+sqrt(z))
~~~
* n阶导
~~~matlab
diff(x^2+log(y)+sqrt(z),2)  %2阶
diff(x^2+log(y)+sqrt(z),3)  %3阶
~~~
## 求偏导
~~~matlab
syms x y z;
diff(x^2+log(y)+sqrt(z),x)
~~~
* n阶偏导
~~~matlab
syms x y z;
diff(x^2+log(y)+sqrt(z),y,4)    %4阶偏导
~~~
## 解方程
* 单一方程
~~~matlab
eqn=9*u^2==56*45;
S=solve(eqn,var)
~~~
解等式eqn关于自变量var的解
* 解方程组
~~~matlab
Y=solve(eqns,vars)
%Y写成[ s o l 1 , s o l 2 , . . . ] [sol1,sol2,...][sol1,sol2,...]的形式
%eqns是方程组的符号向量，即[ e q n 1 , e q n 2 , . . . ] [eqn1,eqn2,...][eqn1,eqn2,...]
~~~