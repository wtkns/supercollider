SynthDef(\click, {
    var click;
    click = Impulse.ar(0);
    DetectSilence.ar(click,doneAction:2);
    OffsetOut.ar(0, click * 0.5);
},

metadata: (
	\vertexType: \PSynth,
	\author: "james watkins",
	\outBusAr: 2,
))