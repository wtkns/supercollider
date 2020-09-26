
-----------------
Sound Synthesis in SuperCollider (wk 3, modulation synthesis)


Server.default=s=Server.internal;
s.boot;

//This uses Lance Putnam's Frequency Scope. I shall keep this running in the background for spectral plotting of the sounds we explore. 
FreqScope.new
//to use this yourself you will have to download it- but the tutorials still work without it. 



In modulation synthesis one wave, the carrier, is influenced (modulated) by a second, the modulator.

Depending on how the carrier and modulator are plugged together there are a variety of methods in common use.

Modulation synthesis is easy to implement, providing computationally efficient shortcuts to complex dynamic spectra. The methods have their own unique sounds too, which can be musically useful. 

In this tutorial I will use some small GUIs to give controls for the parameters of the synthesis. 


























Ring Modulation

A straight multiplication of two signals. 

carrier * modulator


(
{
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= SinOsc.ar(carrfreq,0,0.5);
modulator= SinOsc.ar(modfreq,0,0.5);

carrier*modulator;
}.scope
)
















For simple sine waves, the spectrum ends up with two frequencies (two sidebands), at C+M and C-M, where C is the carrier frequency and M is the modulator frequency.

For more complex waves than sines, we get many more components to the spectrum of the multiplied signals. 

But if C and M are harmonic, the sidebands are also harmonic. 

For those who want to see some proof, it all follows from the mathematical relation

cos(C)*cos(M) = 0.5*(cos(C-M) + cos(C+M))























Amplitude Modulation (AM)

We've seen AM already- using amplitude envelopes, or having a tremolo, are forms of AM

AM is like ring modulation but with a subtle difference: the modulator is unipolar, that is, always positive. 


{SinOsc.ar(440,0,0.5)}.scope //bipolar, -0.5 to 0.5

{SinOsc.ar(440,0,0.5,0.5)}.scope //unipolar, 0 to 1 (0.5 plus or minus 0.5)



(
{
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= SinOsc.ar(carrfreq,0,0.5);
modulator= SinOsc.ar(modfreq,0,0.25, 0.25);

carrier*modulator;
}.scope
)















The spectrum ends up with the sum and difference frequencies we saw in ring modulation, at C+M and C-M, as well as the original carrier frequency C. 

The maths is now: 

cos(C)*(1+cos(M)) = cos(C)+ 0.5*(cos(C-M) + cos(C+M))





























Frequency Modulation (FM)

FM was applied to sound synthesis by John Chowning in 1967, though he published his results in 1973. Yamaha licensed the patents and in 1983 released the Yamaha DX7 synthesiser, which went on to sell 300,000 units, the most commercially successful synthesiser of all time. 

You might know the 'slow version' of FM already: a vibrato. 

Rather than plugging the modulator into the amplitude of the carrier, we're going to plug the modulator into the carrier frequency. There will be three parameters, the carrier frequency C, the modulation frequency M, and the modulation depth or frequency deviation D. 
























Because there are three variables I'm going to use a GUI rather than the 2-dimensional mouse. I'll explain GUIs properly at a later stage of this course. 

[This is Mac GUI code- if you desparately want to try it on Windows, add a J in front of everything


(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w=SCWindow("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, moddepth=0.01; 
SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez| synth.set(\moddepth, ez.value)});

w.front;
)














In the spectrum now, there are an infinite number of sidebands, but of varying strength. Based on the values we choose for the parameters C, M and D we can make very thick spectrums, or only a light modulation effect. The sidebands turn up at 

C + kM where k is any integer, ie. C. C+M, C-M, C+2M, C-2M, ...

By changing the modulation frequency and depth, you can see how the energy in the sidebands is redistributed; the actual formulas for this use Bessel functions and are outside the scope of this lecture- but see the Roads Computer Music Tutorial if you're curious. 
















There is a much more musically effective way to control FM, through the modulation index I, defined as:

I= D/M

The ratio of frequency deviation to modulation frequency. If I is small there is little audible FM effect. The higher I is, the stronger the energy in the sidebands. 


(
var w, carrfreqslider, modfreqslider, modindexslider, synth;

w=SCWindow("frequency modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, modindex=0; 
SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez| synth.set(\modindex, ez.value)});

w.front;
)



//or via mouse control
(
{
var modf, ind;

modf= MouseX.kr(1,440, 'exponential');
ind=MouseY.kr(0.0,10.0);

SinOsc.ar(SinOsc.ar(modf,0,modf*ind, 440),0,0.25)
}.scope
)













Phase Modulation

If you have a input for a phase control you could modulate phase too. 

(recall the arguments for a sine, SinOsc.ar(freq, phase, mul, add))

(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w=SCWindow("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, moddepth=0.01; 
SinOsc.ar(carrfreq, 2pi*(moddepth*SinOsc.ar(modfreq)),0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez| synth.set(\moddepth, ez.value)});

w.front;
)




(
var w, carrfreqslider, modfreqslider, modindexslider, synth;

w=SCWindow("frequency modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, modindex=0; 
SinOsc.ar(carrfreq, (modindex*modfreq*SinOsc.ar(modfreq)),0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez| synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez| synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 10, 'linear', 0.01, 0.0), {|ez| synth.set(\modindex, ez.value)});

w.front;
)



//or via mouse control
(
{
var modf, ind;

modf= MouseX.kr(1,440, 'exponential');
ind=MouseY.kr(0.0,10.0);

SinOsc.ar(440, SinOsc.ar(modf,0,modf*ind),0.25)
}.scope
)



The rate of change of phase is frequency. So phase modulation is related to frequency modulation. 

[PMOsc] //A dedicated phase modulation oscillator

In fact, anything you could control can be modulated, that is, changed over time by some oscillator or other signal. 


