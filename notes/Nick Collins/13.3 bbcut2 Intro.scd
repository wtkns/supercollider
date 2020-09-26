
-----------------
An Introduction to BBCut2

BBCut has existed since 2001, and was originally developed to support experiments in algorithmic audio splicing. The original version 1 is described elsewhere; I'm going to concentrate on the latest manifestation. 

The purpose of this file is to introduce the experimental bbcut2, which supports some machine listening functionality and tighter scheduling and has necessarily changed the way in which code is called. 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
What is real-time algorithmic audio cutting?

//a breakbeat loaded to play

b = Buffer.read(s, "sounds/break2");
 
// now play it in a loop
(
x = SynthDef("help-Buffer",{ arg out = 0, bufnum;
 Out.ar( out,
 PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop:1)
 )
}).play(s,[\bufnum, b.bufnum ]);
)


//Strict loops are boring so now an algorithmic cut-up
(
var sf, clock, cutsynth, cutproc;

clock= ExternalClock(TempoClock(2.7725)); 
clock.play; 
 
Routine.run({
 
sf= BBCutBuffer("sounds/break2",4);

s.sync; //this forces a wait for the Buffer to load

cutsynth= CutBuf2(sf, 0.1,dutycycle: CutPBS1({rrand(0.8,1.0)}, 0));
cutproc=BBCutProc11(phrasebars:2, stutterchance:0.8, stutterspeed:{[2,8].wchoose([0.7,0.3])});

BBCut2(cutsynth,cutproc).play(clock);
});

)


//see
[CutBuf1]
[CutBuf2]
[CutBuf3]











//or on a live stream- for instance, on an audio input from a microphone
a=BBCut2(CutStream1.new).play;

a.end;

[CutStream1]
[CutStream2]
[CutStream3]

//dutycycle and envelope manipulations of first audio in channel
(
var buf, clock;

clock= ExternalClock(TempoClock(2.1)); 
clock.play; 
 
Routine.run({
 
buf= BBCutBuffer.alloc(s,44100,1);

s.sync; //this forces a wait for the Buffer to be allocated

BBCut2(CutStream1(s.options.numOutputBusChannels, buf, 0.5, 0.001, 0.5, -4), WarpCutProc1({[0.5,0.25].choose},{[4,8,16].choose})).play(clock);
});

)














Further examples:

//(reedhamremix), bbcut2 algorithmic fx unit swapping
(
var sf, clock;

clock= ExternalClock(TempoClock(3.151575787894)); 
clock.play; 
 
Routine.run({

//adding a Limiter before pressing s.record
SynthDef(\limiter,{ReplaceOut.ar(0,Limiter.ar(In.ar(0,2),0.99))}).play(Group.after(Node.basicNew(s,1)));
 
sf=BBCutBuffer("/Volumes/data/audio/toanalyse/reedham.wav",128);

s.sync; //this forces a wait for the Buffer to load

//0.3.coin chance of random offset starting position for cut playback
BBCut2(CutGroup([CutBuf1(sf,0.3),CutMixer(0,0.9),CutFXSwap1(3,0.5,0.8)],numChannels:2), 
WarpCutProc1({[0.5,1,1.5,2].wchoose([0.1,0.4,0.1,0.4])},{[4,8,12,16].wchoose([0.5,0.25,0.125,0.125])},probs:[0.2,0.25,0.5])).play(clock);
});
)







//Squarepusher cutting Squarepusher
(
var sf, clock;

clock= ExternalClock(TempoClock(3.3333)); 
 
clock.play; 
 
Routine.run({

//adding a Limiter to the output before record
SynthDef(\limiter,{ReplaceOut.ar(0,Limiter.ar(In.ar(0,2),0.99))}).play(Group.after(Node.basicNew(s,1)));
 
sf= BBCutBuffer("/Volumes/data/audio/gospastic8bar.aif",64);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutGroup([CutBuf2(sf,0.8,SQPushFXPitch2(0.99,pbchance:0.9)),CutMixer(0,0.9,SQPushFXAmp2(0.05)),CutFXSwap1(2,0.5,0.5)],numChannels:2), 
SQPusher1(0.4,5,0.4)).play(clock);

});

)




//sqpushertango
(
var sf, clock;

clock= ExternalClock(TempoClock(2.1979076268267)); 
 
clock.play; 
 
Routine.run({

//adding a Limiter to the output before record
SynthDef(\limiter,{ReplaceOut.ar(0,Limiter.ar(In.ar(0,2),0.99))}).play(Group.after(Node.basicNew(s,1)));
 
sf= BBCutBuffer("sounds/SCsamp/atmos/tango.wav",80);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutGroup([CutBuf2(sf,0.5,SQPushFXPitch2(0.96,pbchance:0.8)),CutMixer(0,0.9,SQPushFXAmp2(0.01))],numChannels:2), 
SQPusher1(0.4,3,0.4)).play(clock);

});

)











BBCut2:

Uses time stamped messaging control of the Server for greater accuracy rather than as-fast-as-possible rendering. You can compensate for latency, event perceptual attack time, expressive timing delays etc. 



Scheduling can also be driven from an external clock, to support beat tracking control of the algorithmic processes. Classes are also provided to run standard Patterns library material to external sync.



Further, BBCutBuffer now derives from the existing Buffer class and SF3 soundfile class is dropped. 



These capabilities have necessarily forced a change in the fundamental scheduling mechanisms and thus changed client code. 








How is this different to bbcut1? It actually takes more code in certain places. 

BBCut1
(
var sf;

sf=SF3("sounds/break2",4);

BBCut(BBCutSynthSF(sf),BBCutProc11.new).tempo_(2.7725).go
)



BBCut2
(
var sf, clock;

clock= ExternalClock(TempoClock(2.7725)); 
clock.play; 
 
Routine.run({ 
sf= BBCutBuffer("sounds/break2",4);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutBuf1(sf),BBCutProc11.new).play(clock);
});

)






The main feature of BBCut for reusability is retained- cutsynths which render cuts are separated from cutprocs which decide on the upcoming cuts. So the algorithmic composition is target independent as much as possible (in fact, messages are passed around under the surface, but the idea is to make it easy to substitute). 

Same cutting as above but with AudioIn

//BBCut1
BBCut(BBCSAudioIn(1),BBCutProc11.new).tempo_(2.7725).go

//BBCut2
BBCut2(CutStream1.new,BBCutProc11.new).play(2.7725);

This is a more equivalent code- the long-winded code in the previous example is making sure the soundfile loading is carried out properly. 

In BBCut2 I've tried to rationalise the names of classes somewhat- you'll cut up Buffers or Streams using the CutBuf or CutStream classes. 









//posting cut information

(
var sf, clock, synth;

s=Server.default;

clock= ExternalClock(TempoClock(2.1)).play; 
 
Routine.run({

sf= BBCutBuffer("sounds/break2",4);

s.sync;

BBCut2(CutBuf1(sf).trace_(CutTrace(1)), WarpCutProc1.new).play(clock);

});

)

//passing messages to other applications

~fredrik=NetAddr("169.254.29.94", 9999);


(
var sf, clock, synth;

s=Server.default;

clock= ExternalClock(TempoClock(2.1)).play; 
 
Routine.run({

sf= BBCutBuffer("/Volumes/data/audio/toanalyse/reedham.wav",128);

s.sync;

BBCut2(CutBuf2(sf,1.0).trace_(CutOSC(1,0.0,~fredrik)), ChooseCutProc(1.0,2)).play(clock);

});

)


///klipp av demo









//Machine Listening
//////////////////////////////////////////////////////////////////

//Automated Event Detection
//CutBuf3


//use the GUI to find onsets for a loaded sample- use post to output the data array 
Segmentation.new //also see the help file for this GUI


//you could substitute your data here, remember to change the sound filename too
(
~data=[ [ 380, 0.21049886621315, 0.005 ], [ 9663, 0.16013605442177, 0.005 ], [ 16725, 0.28975056689342, 0.005 ], [ 29503, 0.085555555555556, 0.005 ], [ 33276, 0.067482993197279, 0.005 ], [ 41243, 0.18616780045351, 0.005 ], [ 49453, 0.29065759637188, 0.005 ], [ 62271, 0.085532879818594, 0.005 ], [ 66043, 0.081360544217687, 0.005 ], [ 74014, 0.18480725623583, 0.005 ], [ 82164, 0.28897959183673, 0.005 ], [ 94908, 0.08421768707483, 0.005 ], [ 98622, 0.096734693877551, 0.005 ], [ 106492, 0.2931746031746, 0.005 ], [ 119421, 0.08562358276644, 0.005 ], [ 123197, 0.0740589569161, 0.005 ] ];
)

//passing in event data in general form 
(
var sf, clock;

clock= ExternalClock(TempoClock(1.8)); 
 
clock.play; 
 
Routine.run({
 
sf= BBCutBuffer("sounds/break",8, ~data);

s.sync; //this forces a wait for the Buffer to load

BBCut2(CutBuf3(sf,0.3,1.0, false, true), BBCutProc11.new).play(clock);
});
)










Events collected in realtime, on-the-fly

s=Server.default;

a=AnalyseEventsDatabase(10, 1, s);

//on my system bus 8 is the first audio in
a.analyse(8, 77); 

Post << a.list << nl; 

a.pause;
a.resume;

a.list.first


(
var data;

data= a.list.first;
Synth(\AEPlayBuf++(a.numChannels),[\outbus,0, \bufnum, a.soundbuf.bufnum, \startPos, data[1], \length, data[2]]);
)





//using the List in a Task
(
t=Task({ 
 var data;
 
 inf.do({ 
 
 data= a.list.choose; //use most recently collected
 
 4.do {if(data.notNil,{Synth(\AEPlayBuf++(a.numChannels),[\bufnum, a.soundbuf.bufnum, \startPos, data[1], \length, data[2]]);}); 0.125.wait;};
 
 }); 
});
)

t.start;
t.stop;


a.stop;













CutStream3- find events in an audio stream, put them in a database, playback events algorithmically under control of some splicing agent


//sing along to the beat and have the events found in the audio stream in time, auto quantised
(
var b,buf,e, clock;

clock= ExternalClock(TempoClock(2.1)).play;
 
e=AnalyseEventsDatabase.new;
e.analyse(clock:clock);
 
Routine.run({
b=BBCutBuffer("sounds/break",8);
s.sync; //this forces a wait for the Buffer to be allocated

//3 beats into the past
BBCut2(CutStream3(e,3,0.0,0.0, false, false), ChooseCutProc({[1.5,1.0].choose},2)).play(clock);
BBCut2(CutBuf1(b), BBCutProc11.new).play(clock);
});

)





This can be combined with simultaneous beat tracking and scheduling from the induced clock



////////////////////////////////////////////////////////////////
//beat tracking
//plus beat track controls pattern



//beat induction and event capture on an existing stereo track using CutStream3
(
var trackbus, trackgroup;

s.latency=0.05;

//clear any existing OSCresponder
OSCresponder.all.do({arg val; if(val.cmdName=='/tr',{OSCresponder.remove(val)}); });

//run a line at a time
~clock= ServerClock.new; 
 
~clock.play(100,s); //will wait on trigID 100
 
~database=AnalyseEventsDatabase(10,2,s); 
 
Routine.run({

//adding a Limiter before pressing s.record
SynthDef(\limiter,{ReplaceOut.ar(0,Limiter.ar(In.ar(0,2),0.99))}).play(Group.after(Node.basicNew(s,1)));

//choose a stereo file you want to track
//~source=Buffer.read(s,"/Users/nickcollins/Music/iTunes/iTunes Music/Squarepusher/Selection Sixteen/09 Snake Pass.wav");

~source=Buffer.read(s,"/Users/nickcollins/Music/iTunes/iTunes Music/Squarepusher/Squarewindow/02 talk about you and me.wav");
 
 
s.sync;
 
~trackbus=Bus.audio(s,2);

trackgroup= Group.before(Node.basicNew(s,1));

//run a beat tracker on the Server which sends the appropriate OSC message
~tracksynth= SynthDef(\beattrackingstereoremix,{arg vol=1.0, beepvol=0.0, lock=0;
var trackb,trackh,trackq,tempo;
var source, beep;

source= PlayBuf.ar(2,~source.bufnum,1.0,1,0,1);

//see AutoTrack help file
#trackb,trackh,trackq,tempo=AutoTrack.kr(Mix(source), lock);

beep= SinOsc.ar(1000,0.0,Decay.kr(trackb,0.1));

Out.ar(~trackbus.index,source);

Out.ar(0,(vol*source)+Pan2.ar((beepvol*beep),0.0));

SendTrig.kr(trackb,100,tempo); //sends with ID of 100 matching what clock expects

}).play(trackgroup);

//creates at tail of trackgroup
~database.analyse(~trackbus.index, 101, trackgroup, 0.34, ~clock); //trigID 101 is default

});

)




~tracksynth.set(\vol,0.0);

~tracksynth.set(\beepvol,0.0);

~database.threshold_(0.1); //make it more event trigger happy


g=BBCut2(CutGroup(CutStream1(~trackbus.index, nil),numChannels:2), ChooseCutProc(0.5,2)).play(~clock);


a=BBCut2(CutGroup(CutStream3(~database, 4, 0.0, 0.0,false,false, 1.0),numChannels:2), SQPusher1.new).play(~clock);

b=BBCut2(CutGroup(CutStream3(~database, 4, 0.0, 1.0,false,false),numChannels:2), WarpCutProc1.new).play(~clock);

c=BBCut2(CutGroup([CutBRF1.new,CutRev1.new,CutStream3(~database, 4, 0.0, 0.0,false,false)],numChannels:2), ChooseCutProc(0.5,4)).play(~clock);

d=BBCut2(CutGroup(CutStream1(~trackbus.index),numChannels:2), ChooseBlockProc(1,8)).play(~clock);

//I'm fun
e=BBCut2(CutGroup(CutStream1(~trackbus.index, nil),numChannels:2), BBCutProc11.new).play(~clock);

f=BBCut2(CutGroup(CutStream1(~trackbus.index, nil),numChannels:2), SQPusher1.new).play(~clock);

//pick me!
h=BBCut2(CutGroup(CutStream1(~trackbus.index, nil),numChannels:2), WarpCutProc1.new).play(~clock);


~database.threshold_(0.01); //make it extremely event trigger happy

a.end;
b.end;
c.end;
d.end;
e.end;
f.end;
g.end;
h.end;

~clock.stop;
~database.stop;



