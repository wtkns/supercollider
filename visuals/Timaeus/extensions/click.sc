Click{
	*playSound{arg this_anima;
		
		var noteObject, note;

		noteObject = CtkSynthDef(\sin, {arg freq = 440, pan = 0;
			Out.ar(0, Pan2.ar(
			SinOsc.ar(freq, 0, XLine.kr(0.2, 0.0001, 0.2)), pan))
		});		
		
		note = noteObject.note(0.1, 0.2).freq_(this_anima.position.y).pan_(((this_anima.position.x / ~xDomain) * 2 ) - 1).play; 
		
	}
}
