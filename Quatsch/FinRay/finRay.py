# -*- coding: utf-8 -*-
"""
Created on Tue Sep 11 13:20:05 2018

@author: AmP
"""


import sympy


R = sympy.Symbol('R', positive=True)
l1 = sympy.Symbol('l1', positive=True)
l0 = sympy.Symbol('l0', positive=True)
#alpha = 0
alpha = sympy.Symbol('alpha')
beta1 = sympy.Symbol('beta1')
beta2 = sympy.Symbol('beta2')


alpha0 = 0

#p1x = sympy.Symbol('p1x')
#p1y = sympy.Symbol('p1y')
p1x = -l0/2
p1y = 0

p4x = l0/2
p4y = 0



p2x = p1x + R*sympy.sin(beta1)
p2y = p1y + R*sympy.cos(beta1)

p3x = p4x - R*sympy.sin(beta2)
p3y = p4y + R*sympy.cos(beta2)

#p4x = sympy.Symbol('p4x')
#p4y = sympy.Symbol('p4y')


eq1 = ((p2x - p1x)**2 + (p2y - p1y)**2)**(.5) - R
eq2 = ((p4x - p3x)**2 + (p4y - p3y)**2)**(.5) - R
eq3 = ((p3x - p2x)**2 + (p3y - p2y)**2)**(.5) - l1
eq5 = sympy.tan(alpha)*(p3x - p2x) - (p3y - p2y)
eq6 = sympy.tan(alpha0)*(p4x - p1x) - (p4y - p1y)
eq7 = sympy.tan(beta2)*(p4y - p3y) - (p4x - p3x)
eq8 = p2x + sympy.cos(alpha)*l1 - p3x
eq9 = p2y + sympy.sin(alpha)*l1 - p3y



#print sympy.solve([eq1, eq2, eq3, eq5, eq6, eq7, eq8, eq9], alpha, quick=True)


eq10 = (l0-R*(sympy.sin(beta1)+sympy.sin(beta2)))**2 + R*(sympy.cos(beta2)-sympy.cos(beta1))**2 - l1**2

sympy.solve(eq10, beta1)