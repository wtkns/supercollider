// run these three lines of code if you hit cmd-. - or when starting
s.boot;

{Out.kr(10,ÊLFNoise2.kr(10).range(100, 300))}.play;

z = CtkControl(bus: 10, server: s);

// run this code block to plot once a second
(
var y, w;
y = [];
w;

Routine.run({
	loop({
		z.get({arg bus, val;Ê
			y = y.add(val);
			(y.size > 99).if({
				{	w.postln;
					w.notNil.if({w.parent.close});
					w = y.plot2(minval: 100, maxval: 300);
					y.postln;
					y = [];
				}.defer;
				});
		});
		0.01.wait;
		});
}, clock:AppClock)
)