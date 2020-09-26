(
// main variation variables:
		var variation = 1440;
		var piecelength = 400;

// main functions:
		var isEven = {arg n;
			(n%2==0);
		};

		var getDur = {arg dur, length;
			(dur / (variation / length));
		};


// boot server
//	Server.default = s =  Server.internal.boot;
	s.scope;
	s.waitForBoot({

		// prepare buffer
		var data, routFunction, sd, myBuffers, buffer1, buffer2, buffer3, cond;
		cond = Condition.new;

		buffer1 = CtkBuffer.buffer(8192, server: s).load;
		buffer2 = CtkBuffer.buffer(8192, server: s).load;
		buffer3 = CtkBuffer.buffer(8192, server: s).load;

		buffer1.sine1(0.0, 1, 1, 1, 1);
		buffer2.sine1(0.0, 1, 1, 1, 0.5, 0.8, 0.4, 0.2, 0.9);
		buffer3.sine1(0.0, 1, 1, 1, 1.0, 0.2, 0.7, 0.1, 0.6, 0.1, 0.8);

		s.sync(cond);
		"Buffers are loaded!".postln;

		myBuffers = [buffer1, buffer2, buffer3];

		CmdPeriod.doOnce({
			"Freeing Buffers".postln;
						myBuffers.do({arg thisBuffer;
				thisBuffer.free;
			})

		});


		// define SynthDef
		sd = CtkSynthDef(\note, {arg buffer, freq, amp, dur;
			var env;
			env = EnvGen.kr(
				Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin),
				timeScale: dur);
			Out.ar(0, Pan2.ar(
				Osc.ar(buffer, freq, 0, amp) * env
				)
			)
		});

		routFunction = {arg fundamental = variation, length = piecelength, buffer = buffer1, pause = 0, amp = 0.2;
			var routine;
			var partitions = getGoldbach.(fundamental);			routine = Routine({
				pause.wait;
				partitions.do({arg thisData, i;
					var freq, dur;
					#freq, dur = thisData;
					dur = getDur.value(dur, length);
					sd.note(0.2, dur).buffer_(buffer).freq_(freq).dur_(dur).amp_(amp).play;

				});
			});
			routine;
		};

		Routine.run({
			var factors, length, routine, pause;
			routFunction.value().play;
			factors = getFactors.value(variation);
					factors.do({arg thisData, i;
						var freq, dur;
						#dur, freq = thisData;
						freq.postln;
						dur.postln;
						routFunction.value(fundamental: freq, length: piecelength-dur, pause:dur, buffer: buffer2).play;
					});
		})
}) // end wait for boot
)

