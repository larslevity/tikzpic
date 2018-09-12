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


def tikz_makefile(name):
    header = """
\\documentclass[10pt]{standalone}
\\input{../../tikzpic_packages.tex}
\\begin{document}
\\begin{tikzpicture}
\\tikzset{
    scale=2,
    part/.style={line width = .3mm, color=black},
    joint/.style={line width = .3mm, color=black, fill=white},
    grid line/.style={gray},
    link/.style={line width=.3mm, color=black},
    baloon/.style={fill=red!20, draw=red!30, line width=.5mm}
    }
"""
    text_file = open(name, "w")
    text_file.write(header)
    return text_file


def tikz_closefile(text_file):
    footer = """
\\draw[baloon] (0,1.5) circle(.91);
\\end{tikzpicture}
\\end{document}
"""
    text_file.write(footer)
    text_file.close()


def tikz_drawfinray(p2s, p3s, text_file):
    header = """
\\draw[part] (%f, %f) coordinate(Llast) -- (%f, %f) coordinate(Rlast);
""" % (p2s[0][0], p2s[0][1], p3s[0][0], p3s[0][1])

    text_file.write(header)

    i = 0
    for p2, p3 in zip(p2s, p3s):
        if i != 0:
            elem = """
\\path (%f, %f) coordinate(L) -- (%f, %f) coordinate(R);
\\draw[part] (L)--(Llast) (R)--(Rlast);
""" % (p2[0], p2[1], p3[0], p3[1])
            text_file.write(elem)
            if i % 2 == 1 and i != 1:
                text_file.write("""
\\draw[joint] (Llast)circle(.04);
\\draw[joint] (Rlast)circle(.04);
\\draw[link] (Llast)--(Rlast);
\\draw[joint] (Llast)circle(.015);
\\draw[joint] (Rlast)circle(.015);
""")
            text_file.write("\\path (L)coordinate(Llast) (R)coordinate(Rlast);")
        i += 1

    footer = """
\\draw[part] (L)--(R);
"""
    text_file.write(footer)
    return text_file


######################################
plt.figure('FinRay')


N = 12
H = 3.
L = 1.


#alpha = np.deg2rad(0)

name = 'gripper_stiff.tex'
text_file = tikz_makefile(name)

for alpha, xshift in [(np.deg2rad(0), 1.2), (np.deg2rad(0), -1.2)]:

    h_ = H/(N+1.)
    beta_ = np.arctan(L/(2.*H))
    R = h_/np.cos(beta_)
    
    # init
    l0 = L
    p1x = xshift-l0/2.
    p1y = 0
    p4x = xshift+l0/2.
    p4y = 0

    p2, p3 = [(p1x, p1y)], [(p4x, p4y)]

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
        
        p2.append((p2x, p2y))
        p3.append((p3x, p3y))
    text_file = tikz_drawfinray(p2, p3, text_file)

tikz_closefile(text_file)



plt.axis('equal')
