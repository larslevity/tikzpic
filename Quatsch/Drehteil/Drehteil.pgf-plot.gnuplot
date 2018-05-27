set table "Drehteil.pgf-plot.table"; set format "%.5f"
set samples 25; plot [x=0:4] (1.5+1*cos(x*2*3.1416/4))*(1-x*.5/4)
