CtkSynthDef(\expHarm, {|
	cps = 200, cpsPow = 0.78, cpsLag = 0.1,
	leftAdd = 0.5, rightAdd = -0.5, panVal = 0, panLag = 0.25

	|

	var numHarms = 32;
	var signal = Mix.fill( numHarms, {|i|
		FSinOsc.ar((cps + (cps * i).pow(cpsPow) + [leftAdd, rightAdd]).lag(cpsLag))}) / (2 * numHarms);
	var panMix = Pan2.ar(signal, panVal.lag(panLag));
	Out.ar( 0, panMix )

});
