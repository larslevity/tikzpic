# -*- coding: utf-8 -*-
"""
Created on Tue Sep 11 15:51:29 2018

@author: AmP
"""


import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt


R = .35
l1 = .9
l0 = 1.


p1x = -l0/2.
p1y = 0
p4x = l0/2.
p4y = 0


def objective(x):
    beta1, beta2 = x
    return (
     (R*(np.cos(beta2) - np.cos(beta1))) /
     (l0 - R*(np.sin(beta1) - np.sin(beta2)))
     - np.tan(alpha))**2


def constraint(x):
    beta1, beta2 = x
    return np.sqrt(
        (p4x+R*np.sin(beta2)-(p1x+R*np.sin(beta1)))**2
        + (p4y+R*np.cos(beta2)-(p1y+R*np.cos(beta1)))**2) - l1**2


con1 = {'type': 'eq', 'fun': constraint}
cons = ([con1])



######################################

#alphaset = np.arange(-30, 30, 1)
#beta1set, beta2set = [], []
#
#for alphadeg in alphaset:
#    alpha = np.deg2rad(alphadeg)
#    solution = minimize(objective, [0, 0], method='SLSQP', constraints=cons)
#    x = solution.x
#    beta1, beta2 = x
#    beta1set.append(np.rad2deg(beta1))
#    beta2set.append(np.rad2deg(beta2))
#
#    p2x = p1x + R*np.sin(beta1)
#    p2y = p1y + R*np.cos(beta1)    
#    p3x = p4x + R*np.sin(beta2)
#    p3y = p4y + R*np.cos(beta2)
#    x = [p1x, p2x, p3x, p4x, p1x]
#    y = [p1y, p2y, p3y, p4y, p1y]
#    plt.plot(x, y)
#
#plt.figure('alpha-beta-relation')
#plt.plot(alphaset, beta1set, label='beta1')
#plt.plot(alphaset, beta2set, label='beta2')
#plt.legend()


######################################
plt.figure('FinRay')


N = 12
H = 3.
L = 1.


#alpha = np.deg2rad(0)

for alpha in [np.deg2rad(0), np.deg2rad(2), np.deg2rad(4)]:

    h_ = H/(N+1.)
    beta_ = np.arctan(L/(2.*H))
    R = h_/np.cos(beta_)
    
    # init
    l0 = L
    p1x = -l0/2.
    p1y = 0
    p4x = l0/2.
    p4y = 0
    
    #solution = minimize(objective, [0, 0], method='SLSQP', constraints=cons)
    #beta1, beta2 = solution.x
    #print beta_, beta1, beta2
    
    for n in range(N):
        l1 = L*(1. - (n+1)/float(N))
    #    l1 = l1 if round(l1*100)/100 > 0 else .01
        print n, l1, l0
    
        solution = minimize(objective, [beta_, -beta_], method='BFGS', constraints=cons)
        beta1, beta2 = solution.x
    
        p2x = p1x + R*np.sin(beta1-n*alpha)
        p2y = p1y + R*np.cos(beta1-n*alpha)
        p3x = p4x + R*np.sin(beta2-n*alpha)
        p3y = p4y + R*np.cos(beta2-n*alpha)
    
        x = [p1x, p2x, p3x, p4x, p1x]
        y = [p1y, p2y, p3y, p4y, p1y]
        plt.plot(x, y)
    
        l0 = l1
        p1x = p2x
        p1y = p2y
        p4x = p3x
        p4y = p3y

plt.axis('equal')
