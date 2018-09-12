# -*- coding: utf-8 -*-
"""
Created on Wed Sep 12 15:36:41 2018

@author: AmP
"""


L = .130        # m
B = .050        # m
H = .002        # m

rho = (1.05+1.6)/2 * (100)**3   # Dichte Elasosil g/m**3
rhomin = 1.05 * (100)**3
rhomax = 1.60 * (100)**3


V = L*B*H       # m**3
Vml = V*10**6   # ml
print Vml
m = V*rho       # g
print m

mmin = V*rhomin
mmax = V*rhomax

print mmin
print mmax
