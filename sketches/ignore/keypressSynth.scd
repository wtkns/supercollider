(
SynthDef("sine", {arg freq=440;
	var x;
	x = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, x);
	}).load(s);
)

s.boot

(
	z = Array.newClear(128);
	w = Window.new;
	c = Slider(w,Rect(0,0,100,30));
	c.keyDownAction = { arg view,char,modifiers,unicode,keycode;
		if ( z.at(unicode).isNil,
			{
				unicode.postln;
				z.put(unicode,
					Synth("sine",
						[\freq, unicode*4]
						)
					);
			},
			{
				z.at(unicode).free;
				z.put(unicode, nil);
			}
		);
	};
	w.front;
)

GUI.current