set table "Bild_04.x.table"; set format "%.5f"
set samples 25; plot [x=0:1] 0.04452-(exp(-3.284*x)).*(-0.03089*x**3+-2.564*x**2+1.197*x+0.05752)
