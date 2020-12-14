//FINAL. Light intensity control, Maja Petric

var addr= NetAddr("127.0.0.1", 7770);

(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope;
		})
)

(
var score;

score = CtkScore.new;

n = CtkSynthDef( \send_control_signal_gesture, { arg attack, sustain, release, duration, light_id, send_rate = 50;
	var control_signal;
	control_signal = EnvGen.kr(
			Env([120, 12, 12, 120], [attack, sustain, release], \lin), 
			doneAction: 2; 			
		);
	SendReply.kr( Impulse.kr(send_rate), 'intensity', control_signal, light_id );
});

~instensity_bus1 = CtkControl.play(1);

// control signal - a state
m = CtkSynthDef( \send_control_signal_state, { arg attack, release, light_id, duration, flux_range = 0.5, flux_rate = 3, send_rate = 50, gate = 1;
	var fade_env, control_signal;
	
	fade_env = EnvGen.kr( 
				Env.new([0,1,0.1,0],[0.5,0.5,2], 'lin', 2, 0, releaseNode: 1), 
				gate: gate, // kill flag - 0 to kill
				doneAction: 2 ); // free the synth when finished

	// UGen used for controling levels
	control_signal = LFNoise2.kr(flux_rate).range( 10*flux_range, 10 ) * fade_env;
	SendReply.kr( 
			Impulse.kr(send_rate), 
			'intensity', 
			control_signal, // or [light_channel, control_signal]
			light_id );
});

p = CtkSynthDef( \send_control_signal_gesture, { arg attack, sustain, release, duration, light_id, send_rate = 50;
	var control_signal;
	control_signal = EnvGen.kr(
				Env.perc(1, 0.01, 1, 4); 
						);
	SendReply.kr( Impulse.kr(send_rate), 'intensity', control_signal, light_id );
});// create  more grainular, pulsating, random signal

//SCORE

//light_id_(1) is Splash light
//light_id_(2) is UV light
//light_id_(2) is Slim par light

score.add(

n.note.new(1.0,30.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(30); // blue fading in! for 30 secs
n.note.new(30.0,15.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(15); // blue starting to pulse steadily for 15 sec
n.note.new(45.0,15.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(15); // blue starting to pulse increasingly for 15 sec
n.note.new(60.0,5.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(5); // blue starting to pulse frantically for 5 sec
//nothing happens for 3 sec
n.note.new(68.0,5.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(3); // blue fading in! for 5 secs

n.note.new(73.0,22.0).attack_(1).sustain_(0.5).release_(3).light_id_(2).send_rate_(50).duration_(12); // uv light fading in! for 22 secs
n.note.new(92.0,4.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(4); // blue starting to pulse increasingly for 4 sec
n.note.new(96.0,6.0).attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).duration_(6); // blue starting to pulse frantically for 4 sec
n.note.new(99.0,3.0).attack_(1).sustain_(0.5).release_(3).light_id_(2).send_rate_(50).duration_(4); // blue starting to pulse frantically for 4 sec

m.note.new(170.0,68.0).attack_(3).release_(3.5).light_id_(1).flux_rate_(9).duration_(38);//spalsh light under m note for 38 sec
m.note.new(162.0,98.0).attack_(3).release_(3.5).light_id_(2).flux_rate_(9).duration_(38);//uv light under m note for 38 sec

p.note(130.0,2.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(2);//snippet of the "granular" red light which is incremental below
p.note(148.0,4.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(4);
p.note(158.0,6.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(6);
p.note(230.0, 40.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(40);//red light takes over 

p.note(130.0,2.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(2);//snippet of the "granular" red light which is incremental below
p.note(148.0,4.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(4);
p.note(158.0,6.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(6);
p.note(230.0, 40.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(40);//red light takes over 

p.note(240.0,2.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(2);//snippet of the uv light which is incremental below
p.note(248.0,4.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(4);
p.note(258.0,6.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(6);
p.note(270.0, 10.0).attack_(3).release_(3.5).light_id_(3).flux_rate_(9).duration_(10);//uv light takes over 

~state.gate_(0);  // fade out

// synchrony
//~gesture1 = n.note.attack_(1).sustain_(0.5).release_(3).light_id_(1).send_rate_(50).play;
//~gesture2 = n.note.attack_(1).sustain_(0.5).release_(3).light_id_(2).send_rate_(50).play;
//~gesture2 = n.note.attack_(1).sustain_(0.5).release_(3).light_id_(3).send_rate_(50).play;

//~state = m.note.attack_(3).release_(3.5).light_id_(1).flux_rate_(9).play;
//~state.gate_(0);  // fade out
//~state.release;  // fade out (same as kill argument in this case)
//~state.free // free immediate without fade

score.play;
))

////////////////////////
//////  Cross fade - 2 busses
////////////////////////

(
SendReply.kr( Impulse.kr(send_rate), 'intensity', control_signal, light_id );

~instensity_bus1 = CtkControl.play(1);

n = CtkSynthDef( \send_control_signal_gesture, { arg light_bus, attack, sustain, release, send_rate = 50;
	var control_signal;
	control_signal = EnvGen.kr(
			Env([0, 1, 1, 0], [attack, sustain, release], \lin), 
			doneAction: 2
		);
	Out.kr( light_bus, control_signal );
});

m = CtkSynthDef( \send_control_signal_state, { arg light_bus, attack, release, light_id = 1, flux_range = 0.5, flux_rate = 3, gate = 1;
	var fade_env, control_signal;
	
	fade_env = EnvGen.kr( 
				Env([0, 1, 0], [attack, release], \lin, releaseNode: 1), 
				gate: gate, // kill flag - 0 to kill
				doneAction: 2 ); // free the synth when finished

	// use any UGen for controling levels
	//control_signal = SinOsc.kr(flux_rate).range( 127*flux_range, 127 ) * fade_env;
	control_signal = LFNoise2.kr(flux_rate).range( 1*flux_range, 1 ) * fade_env;
	Out.kr( light_bus, control_signal );
});

~state = m.note.light_bus_(~intensity_bus).attack_(3).release_(3.5).light_id_(1).flux_rate_(9).play;
~state.gate_(0);  // fade out
~state.release;  // fade out (same as kill argument in this case)
~state.free // free immediate without fade


// crossfade
~gesture = n.note.light_bus_(~instensity_bus1).attack_(3.5).sustain_(5).release_(5).light_id_(2).send_rate_(50);

(
~state.release; // fade state out
~gesture.play  // fade gesture in
)


v = CtkSynthDef( \receive_control_signal, { arg light_bus, light_id = 1, send_rate = 50;
	var control_signal;
	control_signal = In.kr(light_bus);
	SendReply.kr( Impulse.kr(send_rate), 'intensity', control_signal, light_id );
})

// make one of these for each light bus
~relay_signal = v.note.light_bus_(~instensity_bus1).light_id_(1).play;
~relay_signal.free; // stop sending values
)

////////////////////////
//////  Responder : Do something with the values
////////////////////////

(
o.remove; 
o = OSCresponder(nil, 'intensity', 
		{ 
			|t, r, msg| 
			var light_id, intensity;
			// msg[0] = tag, msg[2] = light id, msg[3] = intensity value
			//msg.postln;
			intensity = msg[3];
			// which light to control?
			light_id = msg[2];
			switch ( light_id,
				1, { (addr.sendMsg("/dmx", 10, intensity)).postln },
				2, { (addr.sendMsg("/dmx", 13, intensity)).postln },
				3, { (addr.sendMsg("/dmx", 0, intensity)).postln }
				)
		}
	).add;
)


