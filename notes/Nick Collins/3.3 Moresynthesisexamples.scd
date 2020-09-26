
-----------------
Fat Chorus

I'll use what we've looked at to create a chorusing effect. We make an array of oscillators slightly detuned from one another, mixed to keep them in mono.

{Mix(Saw.ar([440,443,437],0.1))}.scope //chorusing


//more complicated sound combining AM, FM, chorusing and envelopes
(
{
Mix(
 Resonz.ar( //The Resonz filter has arguments input, freq, rq=bandwidth/centre frequency 
 Saw.ar([440,443,437] + SinOsc.ar(100,0,5*200)), //frequency modulated sawtooth wave with chorusing
 XLine.kr(10000,10, 10, doneAction:2), //vary filter bandwidth over time
 Line.kr(1,0.05, 10), //vary filter rq over time
 mul: LFSaw.kr(Line.kr(13,17,3),0.5,0.5)*Line.kr(1,0,10) //AM
 )
)
}.scope
)



Sample playback rate modulation

modulation of sample playback by an oscillator.

Soundfiles will be explained properly in a future week, though see the PlayBuf and Buffer help files if you want to look ahead. 

//run me first to load the soundfiles
(
b=Buffer.read(s,"sounds/a11wlk01.wav");
)


//now me!
(

{
var modf, ind, modulator;
var b1; 

b1= b.bufnum;

modf= MouseX.kr(1,4400, 'exponential');
ind=MouseY.kr(0.0,1.0, 'linear');

modulator= SinOsc.kr(modf,0,10*modf*ind, 440); 

PlayBuf.ar(1,b1, BufRateScale.kr(b1)* (modulator/440), 1, 0, 1)

}.scope;
) 
 






Return to the bell

We are now in a position to return to the additive bell sound and add some modulation effects to make it a richer, more vibrant sound

I won't explain everything here right now, but it's the sort of thing that should become much clearer and decipherable as you gain SC experience. 


//richer bell patch
(
var numpartials, spectrum, amplitudes, modfreqs1, modfreqs2, decaytimes; 

spectrum = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];

amplitudes= [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];

numpartials = spectrum.size;

modfreqs1 = Array.rand(numpartials, 1, 5.0); //vibrato rates from 1 to 5 Hz 

modfreqs2 = Array.rand(numpartials, 0.1, 3.0); //tremolo rates from 0.1 to 3 Hz 

decaytimes = Array.rand(numpartials, 2.5,7.5); //decay from 2.5 to 7.5 seconds

{
Mix.fill(spectrum.size, {arg i; 
var amp, freq; 

freq= (spectrum[i]+(SinOsc.kr(modfreqs1[i],0,0.005)))*500; 
amp= 0.1* Line.kr(1,0,decaytimes[i])*(SinOsc.ar(modfreqs2[i],0,0.1,0.9)* amplitudes[i]);

Pan2.ar(SinOsc.ar(freq, 0, amp),1.0.rand2)});
}.scope

)












