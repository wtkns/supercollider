<CsoundSynthesizer>

<CsOptions>
-odac
</CsOptions>

<CsInstruments>
sr=44100 
kr=4410 
ksmps=10 
nchnls=2 

;Reverberation unit 
;	gal  = global input from FOF instruments 
;	al  = reverb output 
;  	a2 = final output: scaled sum of reverb and dry signal 
;  	kl  = level of reverberation 
	instr 1 
gal	init 0 
kl 	linseg 0  ,14  ,0  ,5.5  ,.3  ,1.4  ,.3  ,2.4  ,.1  ,1.2  ,.1  ,.5  ,.6 ,p3-26.0 ,.6  ,.9  ,0 ,.1  ,0 
al  	reverb gal*kl ,2.0  ;reverb 
a2  = (gal+al)*.4 
	outs a2 ,a2 
gal  = 0 
	endin 



;FOF instruments ... variables (where used) 
;	gal = global output to reverb unit 
;	al  = FOF output 
;	a2 = formant frequency 
;	a3 = fundamental frequency 
;	k4 = acceleration factor 
;	k5 = bandwidth 
;	k6 = excitation attack time (skirtwidth) 
;	k7 = excitation duration 
;	k8 = amplitude 


;Stockhausen's Ex 3 
	instr 2 
k4  = 10 
a2 linseg  20 ,p3*.125 ,40  ,p3*.125 ,30 ,p3*.125 ,60  ,p3*.125 ,50 ,p3*.125 ,100 ,p3*.125 ,75 ,p3*.25 ,150 
a3  = 17.6 
;       xamp   xfund  xform  koct  kbnd   kris  	kdur    kdec  olps   fna  fnb  tdur 
al  fof 40000 ,a3*k4 ,a2*k4 ,0     ,70    ,.00015   ,.1    ,.007   ,20   ,1     ,2   ,p3 
gal  = gal + al 
	endin

;Stockhausen's Ex 4 
	instr 3 
k8 linseg 40000 ,p3 ,60000 
k6 linseg .00015 ,p3 ,.001 
k4 linseg 10 ,p3,  7 
a2 linseg 150 ,p3*.1 ,150 ,p3*.45 ,20 ,p3*.45 ,150 
a3 linseg  17.6 ,p3*.06 ,16.6 ,p3*.3 ,8 ,p3*.16 ,9.4  ,p3*.16  ,5.3  ,p3*.16 ,6.8 ,p3*.16 ,4.0 
;  	   xamp    xfund   xform   koct  kband   kris  kdur   kdec    olps  fna   fnb   tdur 
al  fof  k8     ,a3*k4  ,a2*k4  ,0     ,70    ,k6    ,.1    ,.007   ,20   ,1   ,2    ,p3 
gal  = gal + al 
	endin 


;Stockhausen's Ex 5 
	instr 4 
k6 linseg .001 ,p3 ,.012 
k8 linseg 60000 ,p3*.3 ,60000 ,p3*.7 ,15000 
k4 linseg 7, p3*.3,  3.6363,  p3*.7  , 3.6363 
a2 linseg  150 ,p3/14 ,200 ,p3/14 ,125 ,p3/14 ,75 ,p3/14  ,100  ,p3/14 ,50 ,p3/14  ,75  ,p3/14 ,54 ,p3/2 ,54 
a3 linseg 4.0 ,p3 ,.725 
k7 linseg .1 ,p3*.5 ,1 ,p3*.5 ,2 
k5 linseg 70 ,p3*.25 ,30 ,p3*.25 ,20 ,p3*.5  ,10 
;  xamp xfund  xform  koct  kband  kris  kdur  kdec  olps fia  fnb tdur 
al  fof k8  ,a3*k4  ,a2*k4 ,0  ,k5  ,k6  ,k7  ,.007  ,20  ,1  ,2 ,p3 
gal  = gal + al 
	endin 


;Stockhausen's Ex 6 
instr 5 
k8 	linseg 15000  ,p3*.25 ,20000 ,p3*.25 ,7000 ,p3*.25 ,2000 ,p3*.25 ,1000 
k6 	linseg .012 ,p3*.1 ,.005 ,p3*.3  ,.005  ,p3*.2 ,.05 ,p3*.4 ,.05 
k5 	linseg 10 ,p3*.16  ,10  ,p3*.01  ,100  ,p3*.07  ,5 ,p3*.46  ,.1  ,p3*.3  ,.1 
k4  = 3.6363 
a2 	linseg 54  ,3.5  ,54  ,.385  ,154.44  ,.175  ,63.18  ,.175  ,63.18  ,.2625 ,291.6  ,.6125  ,44.5  ,16.39  ,44.5 
a3 	linseg 1 ,3.5  ,.45  ,.2625  ,1.7  ,.2625  ,.58  ,.35  ,1.2  ,.7  ,.82  ,.7 ,.42  ,11.725  ,.11  ,4  ,.11 
k7 	linseg 2 ,p3*.6 ,1 ,p3*.4 ,15 
;  xamp  xfund  xform  koct kband kris kdur  kdec olps  fna  fib  tdur 
al  fof k8  ,a3*k4  ,a2*k4  ,0  ,k5  ,k6  ,k7  ,.1  ,20  ,1  ,2 ,p3 
gal  = gal+  al 
	endin 

;Final sustained note 
instr 6 
k8 linseg 1000 ,p3 ,10000 
;  xamp  xfund  xform koct kband kris  kdur kdec olps fna  fnb  tdur 
al  fof k8  ,.01  ,162  ,0  ,.05  ,.05  ,10  ,.1  ,20  ,1  ,2 ,p3 
gal  = gal+ al 
	endin

</CsInstruments>


<CsScore>
    
f 	1  	0 	4096  	10  	1 
f 	2 	0  	1024  	19  	.5 	.5 	270  	.5 
t 	0  	60 

; Reverb instrument plays throughout, levels varied in orchestra 
i 	1  	0 	54 

; These notes play Stockhausen's examples in succession as in Kontakte c N.B.  in the original the first note overlaps with other events. 
i 	2 	0	4.1 
i 	3 	4 	4.07 
i 	4 	8  	14.5 
i 	5 	21  	21.5 
i 	6 	41.5  12 

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>1105</x>
 <y>61</y>
 <width>196</width>
 <height>766</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{58ecbf60-1426-4cc2-8223-cce1610066e7}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 1105 61 196 766
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
