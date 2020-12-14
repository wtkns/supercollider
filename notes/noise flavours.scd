(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope;
	f = FreqScope.new(400, 200, 0);
	})
)

// White noise
{WhiteNoise.ar(0.5)}.play

// Pink noise, or 1/f noise, or fractal noise: a psychoacoustically balanced noise
{PinkNoise.ar(0.5)}.play

// brownian motion (e.g of gas particles)
{BrownNoise.ar(0.5)}.play

// gray noise (a digital flavour): low-frequency heavy
{GrayNoise.ar(0.5)}.play

// binary noise
{ClipNoise.ar(0.5)}.play
