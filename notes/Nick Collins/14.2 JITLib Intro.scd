
-----------------
// JITLib intro
// f@fredrikolofsson.com
// _version: 040330
// _req.classes: 
//-----------------------------------------------------------------------------------------------------------------------------------

//jitlib is a 3rd party library distributed with the standard supercollider server release. beautifully constructed by julian rohrhuber, it adds live coding facilities to sc lang.


//setup. this will take us into 'jitlib mode'. good habit to start your jitlib code documents with this line
p= ProxySpace.push(s);


//to get back to normal sc lang we can use
p.pop;


//notice post window feedback. jitlib is quite verbose and posts a lot of relevant info
p= ProxySpace.push(s);


//here is an empty slot or 'proxy'
~empty;


//and here is another
~empty2;


//in jitlib mode the tilde ~ + anyName indicates a placeholder for something (a NodeProxy). in this holder you can put ugen functions, static numbers, pbinds, lfos etc. jitlib makes it easy to connect these proxies together in different ways, patch and swap code around a lot more flexible than in normal sc lang. these proxies can also be reassign on the fly with or without crossfades.
//let us put something sounding into our empty proxy
~empty= {BrownNoise.ar(0.1)};


//again notice the post window that now tells us what proxies are present, their number of channels and playback rate. by default proxies are neutral ir(nil) but as soon as you put something into them they will adapt to that rate. see [the_lazy_proxy] for more.


//evaluate following line whenever to see a list of things you have defined in your proxyspace. by now we have one 1 channel audiorate proxy called 'empty' and one neutral called 'empty2'
p;


//monitor sound on/off. this plays whatever is in the proxy
~empty.play(0); //channel offset 0
~empty.stop;


//assign something to the 'empty2' proxy
~empty2= {Dust.ar(100, 0.2)};


//play both in different channels
~empty.play(0); ~empty2.play(1);
~empty.stop; ~empty2.stop;


//let us recall and do the above again for overview
p= ProxySpace.push(s); //clears and creates a new proxyspace. push it onto the server 's'
~empty= {BrownNoise.ar(0.1)}; //put an ugen function into a proxy
~empty2= {Dust.ar(100, 0.2)}; //put another ugen function into another proxy
~empty.play(0); //monitor the first proxy
~empty.stop;
~empty2.play(1); //monitor the second proxy in the right channel
~empty2.stop;


//--------------------------------------------------------------------------------
//now we will try reassigning while playing...
~empty.play(0);


//we replace what is currently in the proxy with a different ugen function. notice how this takes a tiny bit of time as jitlib, beneath the surface, recreates the synthdef for us, sends it to the server and then swap the synths. see [jitlib_efficiency] for indepth info.
~empty= {WhiteNoise.ar(0.1)};


//and with the following message we can set crossfade times
~empty.fadeTime= 2; //in seconds

~empty= {PinkNoise.ar(0.1)};
~empty= {BrownNoise.ar(0.1)};


//and fade out to silence is done like this
~empty.release;


//note that the proxy is still being monitored
~empty= {PinkNoise.ar(0.1)}; //fade in again
~empty.stop; //now brutally stop monitoring


//--------------------------------------------------------------------------------
//one way of organising your code is to have a main audio out and then mix proxies to that output. this output, which in turn is also a proxy, we explicitly create and initialise here with the .ar message
p= ProxySpace.push(s); //first let us start anew
~out.ar(2); //create a 2 channel main audio out proxy (shortcut for NodeProxy.audio(s, 2) )
~out.play; //and start monitoring


//we set fadeTime for smoother sounds
~out.fadeTime= 2.5;


//put a beating stereo sine ugenFunc into a proxy
~sineLow= {FSinOsc.ar([240, 242], 0, 0.2)};


//and patch the low sines into out to hear it
~out= ~sineLow;


//another proxy
~sineMed= {FSinOsc.ar([400, 404], 0, 0.1)};


//mix them together
~out= ~sineLow+~sineMed;


// a third sine proxy
~sineHigh= {FSinOsc.ar([600, 606], 0, 0.04)};


//and mix them all together
~out= ~sineLow+~sineMed+~sineHigh;


//reassign any of the proxies while playing
~sineMed= {FSinOsc.ar([480, 484], 0, 0.1)};
~sineMed= {FSinOsc.ar([500, 505], 0, 0.1)};
~sineMed= {FSinOsc.ar([400, 404], 0, 0.1)};


//notice that these changes occur instantly while the mixing we just did was done with crossfades. we need to explicitly set fadeTime for the proxy too
~sineMed.fadeTime= 3;
~sineMed= {FSinOsc.ar([580, 585], 0, 0.1)};
~sineMed= {FSinOsc.ar([400, 404], 0, 0.1)};


//and stop
~out.release;
~out.stop;


//if we investigate current proxyspace we'll see that there are 4 proxies - all stereo audiorate.
p;


//--------------------------------------------------------------------------------
//now ugen functions with arguments
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//proxy containing an ugen function with 2 arguments
~sine= {arg freq= 400, amp= 0.1; SinOsc.ar(freq, 0, amp)};


//patch to main output
~out= ~sine;


//change parameters with .set
~sine.set(\freq, 600);
~sine.set(\freq, 800);
~sine.set(\amp, 0.05);


//stop for a little while
~out.stop;


//recreate the proxy - overwrites old - and play again
~sine= {arg freq= 400, amp= 0.1; SinOsc.ar(freq, 0, amp)};
~out= ~sine;
~out.play;


//notice how jitlib remember settings! get back to defaults with
~sine.unset(\freq);
~sine.unset(\amp);


//also crossfades between settings is possible. check that you set fadeTime for the right proxy
~sine.fadeTime= 4;
~sine.xset(\freq, 700); //crossfade
~sine.set(\freq, rrand(400, 900)); //jump to random freq
~sine.xset(\freq, 700); //crossfade back
~sine.xset(\freq, 500); //crossfade
~sine.unset(\freq); //crossfade back to default
~out.stop;


//--------------------------------------------------------------------------------
//create and map controlrate proxies (lfo). following line puts a controller ugen into a proxy
~freak= {LFNoise2.kr(2, 500, 500)};


//post window tells us that 'freak' is a one channel proxy running in controlrate just as expected
p;


//start monitoring our old sine
~out.play;


//and now this will map (patch) the output of 'freak' to our sine proxy's freq parameter
~sine.map(\freq, ~freak);


//as .unset, .unmap removes the patching
~sine.unmap(\freq);


//of course we can exchange what is inside 'freak' with something else
~freak= {LFNoise0.kr(6, 300, 400)};
~sine.map(\freq, ~freak);


//and yet something different
~freak= {LFNoise0.kr(13, 100, 600).round(66.67)};


//a very cool thing is that controllers like these also can crossfade. time is set with .fadeTime
~sine.fadeTime= 4;


//so first we create another controller proxy
~freak2= {LFPar.kr(20, 0, 240, 300)};


//and then the crossfade is done like this
~sine.xmap(\freq, ~freak2);
~sine.xmap(\freq, ~freak);
~sine.unmap(\freq);
~sine.release;
~out.stop;


//--------------------------------------------------------------------------------
//quantising
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//the .clock message to the current proxyspace will force all proxies to start in sync to a clock
p.clock= TempoClock(1.0); //60bpm


//this will play a click once a second
~imp1= {Formlet.ar(Impulse.ar(1), 2000, 0.1, 0.2)};
~out= ~imp1;


//run this for another click twice a second
~imp2= {Formlet.ar(Impulse.ar(2), 8000, 0, 0.2)};
~out2.ar(2);
~out2.play;
~out2= ~imp2;


//and finally this three times faster than the first click but still in sync
~imp3= {Formlet.ar(Impulse.ar(3), 12000, 0.3, 0)};
~out3.ar(2);
~out3.play;
~out3= ~imp3;


//stop them all (could also be done with p.free)
~out.stop; ~out2.stop; ~out3.stop;


//--------------------------------------------------------------------------------
//one can also decide which proxies to quantise. following will mix two synced impulses in right channel and one non-quantised in the left channel
p= ProxySpace.push(s);
c= TempoClock(1.0);
~imp1.clock= c; //same clock for ~imp1
~imp2.clock= c; //as for ~imp2. ~imp3 gets no clock
~imp1= {Formlet.ar(Impulse.ar(1), 2000, 0.1, 0.2)};
~imp2= {Formlet.ar(Impulse.ar(2), 8000, 0, 0.2)};
~imp3= {Formlet.ar(Impulse.ar(1), 600, 0.4, 0)};
~outLeft= ~imp1+~imp2; //mix the two synced proxies in left channel
~outLeft.play(0); //start monitoring left channel
~outRight= ~imp3; //and play the non-synced in right
~outRight.play(1); //start monitoring right channel


//if we now reassign one of the synced impulses it'll still play in time. run this a few times
~imp1= {Formlet.ar(Impulse.ar(1), 1000.rrand(3000), 0.1, 0.2)};


//while the right channel impulse won't play in time with the left channel ones
~imp3= {Formlet.ar(Impulse.ar(1), 500.rrand(700), 0.4, 0)};


//stop both channels
~outLeft.stop; ~outRight.stop;


//--------------------------------------------------------------------------------
//using pbinds
SynthDescLib.read; //init. a must when working with patterns
p= ProxySpace.push(s);


//let us keep it all in sync
p.clock= TempoClock(1);


//this will start playing right away on a silent bus using the default pbind instrument
~pat= Pbind(\midinote, Pseq([67, 71, 74], inf), \dur, Prand([1/2, 1/4, 1/8], inf));
~pat2= Pbind(\midinote, Pseq([55, 59, 62], inf), \dur, Prand([1, 1/2], inf));
~pat3= Pbind(\midinote, Pseq([43, 47, 48, 50], inf), \dur, Pseq([2], inf));


//to listen we start monitoring
~pat.play;
~pat2.play;
~pat3.play;


//release one pbind and reassign
~pat.release;
~pat= Pbind(\midinote, Pseq([67, 72, 74], inf), \dur, Prand([1/2, 1/4, 1/8], inf));


//release all in turn
~pat.release;
~pat3.release;
~pat2.release;


//and stop monitoring
~pat.stop; ~pat2.stop; ~pat3.stop;

//see [NodeProxy] helpfile under 'using patterns - event streams' and [ProxySpace] for additional examples of pbinds with embedded proxies


//--------------------------------------------------------------------------------
//recording
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//start something sounding
~out= {RLPF.ar(WhiteNoise.ar(1), FSinOsc.kr([2, 3], 0, 500, 600))};


//then we create a RecNodeProxy
r= p.record(\out, "filteredNoiseTest.aif");
r.unpause; //start recording
r.pause; //pause recording
r.close; //stop recording
~out.stop;


//--------------------------------------------------------------------------------
//using synthdefs with jitlib
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//send a synthdef to the server as normal
(
SynthDef('jitlibtest', {arg out= 0, freq= 400;
 var z;
 z= Formant.ar(freq.dup, LFSaw.kr(1, 0, 100, 200), 0.3, 0.1);
 Out.ar(out, z);
}).send(s);
)


//and access it later in jitlib like this. just give the name of the synthdef as a symbol
~src= 'jitlibtest';
~out= ~src;
~src.set(\freq, 300);
~src.set(\freq, 200);
~out.stop;


//--------------------------------------------------------------------------------
//effects
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//create a mouseX controlled pulse. stable on the right - more chaotic on the left side
~src= {BrownNoise.ar(Decay.kr(Impulse.kr(FSinOsc.kr(MouseX.kr(0.54, 2.5), 0, 2, 2.5)), 0.7, 0.3))};


//patch to main out
~out= ~src;


//create a mouseY controlled effect. the src proxy is patched into the inlet of the filter with ~src.ar
~efx= {RLPF.ar(~src.ar, MouseY.kr(200, 8000, 'exponential'))};


//repatch effect to main out
~out= ~efx;


//get rid of effect and stop
~out= ~src;
~out.stop;


//or we could create the effect first just to show with which ease execution order is dealt with
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//sets up an effect with two not-yet-defined inputs. note in post window that jitlib will create reasonable proxies for us right away
~efx= {Resonz.ar(~src.ar, 4000, 0.1, 0.5)};


//patch effect to main out. i.e. play it but nothing will be heard as no sound comes into the effect
~out= ~efx;


//last create the source sound
~src= {GrayNoise.ar(Decay.kr(Impulse.kr([MouseX.kr(2, 14), MouseY.kr(2, 14)]), 0.4))};


//stop monitoring
~out.stop;


//--------------------------------------------------------------------------------
//careful though. execution order can't be ignored altogether. below is a badly designed example with the ampTracker only reading from one channel
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//set up the effect. here's the problem. ampTracker controller proxy is supposed to be 2 channels
~efx= {Resonz.ar(~src.ar, ~ampTracker.kr, 0.1, 0.5)};


//patch effect to main out
~out= ~efx;


//create the controller. notice jitlib warning in post window. ~src.ar defaults to 2 channels
~ampTracker= {Amplitude.kr(~src.ar, mul:5000)};


//last create the source sound. this won't work as expected only tracking amplitude on 1 channel
~src= {GrayNoise.ar(Decay.kr(Impulse.kr([MouseX.kr(2, 14), MouseY.kr(2, 14)].round(2)), 0.4))};


//to fix it we need to make sure the ampTracker proxy has 2 channels
~out.stop;
p= ProxySpace.push(s);
~out.ar(2);
~out.play;


//force ~ampTracker into 2 channels
~efx= {Resonz.ar(~src.ar, ~ampTracker.kr(2), 0.1, 0.5)};
~out= ~efx;
~ampTracker= {Amplitude.kr(~src.ar, mul:5000)};
~src= {GrayNoise.ar(Decay.kr(Impulse.kr([MouseX.kr(2, 14), MouseY.kr(2, 14)].round(2)), 0.4))};


//examine post window and read more in [the_lazy_proxy]
p;


//stop
~out.stop;


//--------------------------------------------------------------------------------
//synthdefs as effects
p= ProxySpace.push(s); //clear and create new
~out.ar(2);
~out.play;


//first send a synthdef effect to the server
(
SynthDef('lfoClip', {arg out, in, rate= 4;
 var z;
 z= InFeedback.ar(in, 2)*LFNoise0.kr(rate).min(0);
 Out.ar(out, z);
}).send(s);
)


//the sound that we want to run through the effect
~src= {SinOsc.ar([300, 303], 0, 0.4)};


//put the effect into a proxy
~efx= 'lfoClip';


//patch source sound to main out to hear it
~out= ~src;


//patch effect - still silent
~out= ~efx;


//but now change the effect's out parameter to match the sound's bus number
~efx.set(\out, 0, \in, ~src.bus.index);
~efx.set(\rate, 16);


//to mute the effect either route it to a silent bus or use ~efx.free;
~efx.set(\out, 99);


//and patch source sound back
~out= ~src;


//stop monitoring and clear the whole proxyspace
~out.stop;
p.free;


//--------------------------------------------------------------------------------
//more advanced example muting effects
p= ProxySpace.push(s); //clear and create new
~out.ar(2); //new main out proxy
~out.play; //start monitoring


//creates 4 effects
~dry= {arg mute= 1; ~input.ar*(1-mute)};
~ampmod= {arg mute= 1; ~input.ar*LFSaw.kr(LFNoise0.kr(5).round(0.5), 0, (1-mute)*2).abs};
~dist= {arg mute= 1; (~input.ar*2).clip2(0.4)*(1-mute)};
~dist2= {arg mute= 1; (~input.ar*8).wrap2(0.1)*(1-mute)};


//mix them on the same output
~out= ~ampmod+~dry+~dist+~dist2;


//and create a source sound
~src= {PMOsc.ar(200, [40, 45], LFSaw.kr(0.5, [0, pi], 0.5, 0.75), 0, 0.3)};


//set up a patchbay
~link.ar(2);
~link= {arg in, out= 128; Out.ar(out, InFeedback.ar(in, 2))};
~link.set(\in, ~src.index, \out, ~input.index);


//now mute and unmute
~dry.set(\mute, 0);
~dry.set(\mute, 1);
~ampmod.set(\mute, 0);
~ampmod.set(\mute, 1);
~dist.set(\mute, 0);
~dist.set(\mute, 1);
~dist2.set(\mute, 0);
~dist2.set(\mute, 1);


//--------------------------------------------------------------------------------
//this tutorial is just scratching a little on the surface of jitlib. find out more in julian's extensive helpfiles [JITLib]

