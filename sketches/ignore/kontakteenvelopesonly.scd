n1 = 1.35 / playRate;
n2 = 4.07 / playRate;
n3 = 15.9 / playRate;
n4 = 2.5 / playRate;
n5 = 21.18;


.amp_(1) 
.amp_(CtkControl.env(Env([1, 1.5, 2.5, 3, 4], [0.15, 0.15, 0.20, 0.25], \sin), timeScale: n2)) 
.amp_(4) 
.amp_(CtkControl.env(Env([4, 2], [1], \sin), timeScale: n4)) 
.amp_(CtkControl.env(Env([2, 1, 0], [0.8, 0.2], \lin), timeScale: n5)) 

				
.fundFreq_(17.6)
.fundFreq_(CtkControl.env( Env([17.6, 16.6, 8, 10.4, 8.3, 4.8, 2.6], [0.06, 0.3, 0.1, 0.16, 0.16, 0.16], \sin), timeScale: n2))
.fundFreq_(CtkControl.env(Env([2.6, 0.725, 0.23], [0.75, 0.25], \exp), timeScale: n3))
.fundFreq_(CtkControl.env(Env([1.75, 1.25], [1], \sin), timeScale: n4))
.fundFreq_(CtkControl.env(Env([0.5, 0.1], [1], \sin), timeScale: n5))


.formFreq_(CtkControl.env(Env([75, 165, 155], [0.8, 0.2], \sin), timeScale: n1))
.formFreq_(CtkControl.env(Env([155, 180, 135, 140, 65, 95, 65, 55], [1/24, 1/12,  3/24, 2/12, 3/12, 2/12, 2/12], \sin), timeScale: n2))
.formFreq_(CtkControl.env(Env([54, 54, 120, 50, 45, 45], [0.15, 0.075, 0.025, 0.35, 0.4], \sin), timeScale: n3))
.formFreq_(CtkControl.env(Env([100, 140, 220, 180, 76], [1/5, 1/5, 1/5, 2/5], \step), timeScale: n4))
.formFreq_(76)


.accFactor_(10)
.accFactor_(CtkControl.env(Env([10, 6.5], [1], \sin), timeScale: n2)) 
.accFactor_(CtkControl.env(Env([7.5, 3,5, 3.6363], [2/8,5/8,1/8], \exp), timeScale: n3)) 
.accFactor_(3.6363)
.accFactor_(3.6363) 


.bandWidth_(40)
.bandWidth_(CtkControl.env(Env([40, 20, 10, 10], [0.15, 0.35, 0.5], \sin), timeScale: n2))
.bandWidth_(CtkControl.env(Env([10, 7, 10], [0.45,0.55], \exp), timeScale: n3))
.bandWidth_(6)
.bandWidth_(4)


.mix1_(CtkControl.env(Env([0.5, 0], [1], [\exp]), timeScale: n1))
.mix1_(CtkControl.env(Env([0.1,0.5,0.5], [0.15,0.85], \exp), timeScale: n4))
.mix1_(CtkControl.env(Env([0.1,0.5,0.5], [0.15,0.85], \exp), timeScale: n4))
.mix1_(CtkControl.env(Env([0.75, 0.85, 0.9], [0.25, 0.75], \exp), timeScale: n5))


.room1_(CtkControl.env(Env([0.5, 0], [1], [\exp]), timeScale: n1))
.room1_(0.75)
.room1_(0.75)
.room1_(CtkControl.env(Env([0.75, 0.95, 1], [0.25, 0.75], \exp), timeScale: n5))


.damp1_(0.75)	
.damp1_(0)	
.damp1_(CtkControl.env(Env([0.1, 0.5], [1], \sin), timeScale: n4)).damp1_(CtkControl.env(Env([0.5, 0.95, 1], [0.25, 0.75], \exp), timeScale: n5))

