(
var graingen, sndBuffer, thisNote;
Server.default = s = Server.internal;
s.boot;

s.waitForBoot({
	sndBuffer = CtkBuffer.playbuf("~/samples/TrevorWishart.wav".standardizePath, channels:0);
	sndBuffer.load;
	s.sync;

	graingen = CtkSynthDef(\grain, {
					Out.ar(0, GrainBuf.ar(2, Impulse.ar(0.01), 1, sndBuffer, 1, 0.25, 4, 0) );
					});
					
	thisNote = graingen.note(0.1, 10.0).play;

	CmdPeriod.doOnce({sndBuffer.free;});
});	

)