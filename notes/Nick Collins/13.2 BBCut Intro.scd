
-----------------
'Breakbeat Science and BBCut'

Note- this introduction is based around BBCut1


BBCut = BreakBeat Cutting library (but works with any audio buffer or stream)

BBCut is a library of routines for automated audio cutting in SuperCollider. It provides algorithmic cutters working within a limited rhythmic model of cutting, and the rendering to support cutting any incoming audio stream or existing fixed buffer. 

To use BBCut, you need to download it separately from 

www.cus.cam.ac.uk/~nc272

It isn't a standard part of the SuperCollider distribution. Instructions on how to install it come with the download package. It is released under GNU GPL, so all the code is there and it's entirely possible to write your own extensions. 

CAUTION: these tutorial examples may require you to substitute filenames for soundfiles you have on your own machine. Note that you don't have to put "sounds/mysoundfile.aif", just "mysoundfile.aif" since sounds/ is the home directory for the SF3 helper class

( //source loop
var sf;

sf=SF3("break",8);

sf.loop;
)


( //BBCutProc11
var sf;

sf=SF3.array(["break"],[8]);

BBCut(BBCutSynthSF(sf.at(0)),BBCutProc11.new).tempo_(2.4).ar;
)

All BBCutters have a cut synthesiser and a cut composer: BBCutSynthSF is a class dealing with cutting up soundfiles based on instructions from the BBCutProc11 cutting routine, which is an algorithmic composer based on the classic 3+3(repeat)+2 syncopated figure. 









The software design aims for reusability- any cut synthesiser or cut composer class can be substituted without affecting the code to a major degree. The design supports both stream and fixed buffer cutting without needing to treat the objects as different. 

So I can substitute an Audio In stream cutter for a sample buffer cutter in the above code very quickly-

( //BBCutProc11 with AudioIn
BBCut(BBCSAudioIn.new,BBCutProc11.new).tempo_(2.4).ar;
)















You can also cut up the contents of any audio bus on the Server:

//run something, controlling execution graph so as soon as the first thing is available, 
//bbcut will be cutting it
(
var grp1, grp2;

grp1=Group.new; //make a new Group at head of Group(1)
grp2= Group.after(grp1);

{Out.ar(16, Saw.ar(SinOsc.kr(3.333*0.25, 0, 150, 200), 0.1))}.play(grp1);

BBCut.new(BBCG(BBCSAudioIn.newOnBus(16), grp2), 
BBCutProc11.new(phrasebars:1,stutterchance:1.0, stutterspeed:3,stutterarea:0.75)).tempo_(2.4).go;
)




Or play with files streamed off disk rather than short memory resident samples:

( //BBCutProc11 with DiskIns1
var di;
var grp1, grp2;

grp1=Group.new; //make a new Group at head of Group(1)
grp2= Group.after(grp1);

di=Buffer.cueSoundFile(s,"sounds/scsamp/acapella/pow.wav",0, 1);

//play on bus 16
SynthDef(\diskin,{Out.ar(16,DiskIn.ar(1,di.bufnum))}).play(grp1);

BBCut(BBCG(BBCSAudioIn.newOnBus(16, panfunc:{1.0.rand2}, pbsfunc:BBCSPlayback1({[0.87,0.98,1.0].wchoose([0.1,0.2,0.7])},{(1.neg)**(2.rand)}))
,grp2)
,WarpCutProc1.new).tempo_(2.3781212841855).ar;
)








There are many possible cut synthesisers and cut procedures to explore in BBCut. 

BBCutProc.dumpClassSubtree
[
 RecursiveCutProc1
 CampCutProc
 BBCutProc11
 SQPusher1
 MotifCutProc
 ChooseBlockProc
 BBCPRecall
 ThrashCutProc1
 WarpCutProc1
 ChooseCutProc
 [ StatBalProc2 StatBalProc ]
 OffsetCP1
 BBCPPermute
 RecCutProc
]


BBCutSynth.dumpClassSubtree
[
 BBCSStore
 BBCSData
 BBCSFilter1
 BBCSMessenger
 [
 BBCSFileOut
 [ BBCSOSCOut BBCSPost ]
 BBCSMIDIOut
 ]
 BBCSParam
 [
 BBCSAudioIn
 [ BBCSAudioIn2 ]
 BBCutSynthSF
 [ BBCSKnownOffsets BBCSOffsetFunc ]
 ]
 BBCSFinal
 BBCSFunc
 BBCSModulator1
 BBCSTest
]




For instance there is a cut composer which takes some inspiration from the drum programming tricks of Tom Jenkinson, aka Squarepusher. 

//demo of original source- show transcription
SF3(["/volumes/data/audio/gospastic8bar.aif"],[8]).play(len:32*(60/200));


( //SQPusher simulation
var sf;

sf=SF3.array([":Sounds:bogdan:dillbeat1"],[8]);

BBCut(BBCutSynthSF(sf.at(0),0.3, SQPushFXAmp.new(0.15),0.0,SQPushFXPitch.new(0.96,pbchance:0.8)),SQPusher1(0.4, 3, 0.4)).tempo_(3.4).ar;
)


( //SQPusher simulation vs SQPusher...
var sf;

sf=SF3("/volumes/data/audio/gospastic8bar.aif",64);

BBCut(BBCutSynthSF(sf,1.0, SQPushFXAmp.new(0.05),0.0,SQPushFXPitch.new(0.99,pbchance:0.9)),SQPusher1(0.4, 5, 0.4)).tempo_(3.33333).ar;
)
//...now recurse (see LMJ 13)



( //SQPusher Tango
var sf;

sf=SF3.array(["atmos:tango.wav"],[80]);

BBCut(BBCutSynthSF(sf.at(0),0.3, SQPushFXAmp.new(0.01),0.0,SQPushFXPitch.new(0.96,pbchance:0.8)),
SQPusher1(0.4, 3, 0.4) 
).tempo_(2.1979076268267).ar;
)




So perhaps you're convinced that there is fun to be had from the use of these generative cutters, particularly when you have some interactive control over them. Try running more than one cutter, synced to a common tempo clock. 


But I'm skimping over some of the difficulties- these examples work well because the sources are amenable to being rigidly and exactly cut up. In order to deal with human expressive timing, further preprocessing is necessary, to detect the best entry points for segments. 


Automation of that task is plausible particularly for strong percussive sources though the general case quickly turns into the sort of problem computer music must still overcome to attempt automatic transcription. 

OnsetDetectorUI.new 

[BBCSKnownOffsets] //this help file shows how you might use the onset data so gleaned

You can acheive things like changing groove, change of playback tempo without repitching. This will work with any cut composer immediately. 

//original
( 
var sf;

sf= SF3("break2",4);

sf.loop;
)

//original with standard cutting showing repitch
( 
var sf;

sf= SF3("break2",4);

BBCut(BBCutSynthSF(sf),BBCutProc11.new).tempo_(1.7).go;
)

//here's one I processed earlier
( 
var sf;

sf= SF3("break2",4);

sf.setKnown(
[ 0, 0.2561820471086, 0.43825503355705, 0.56711409395973, 0.63155948071284, 0.74832214765101, 0.86644295302013 ]*sf.numFrames
); //explicit onsets
sf.setGroove;
sf.grooveon=true;

BBCut(BBCSKnownOffsets(sf, relprop:0.5, curve:-6),SQPusher1.new).tempo_(1.7).go;
//BBCut(BBCSKnownOffsets(sf), ChooseCutProc(8.0,1)).tempo_(3).go; //straight playback
)
















There are many more things possible, and a lot under development I won't talk about. 

But here's one fun thing immediately demonstrable: rather than have a VJ do audio tracking of a bbcutter, why not pass the state information from the generative routines over to the VJ application? 

( //first protocol information demonstration
var sf;

sf=SF3.array([":Sounds:bogdan:dillbeat1"],[8]);

BBCut([BBCutSynthSF(sf.at(0),0.3, SQPushFXAmp.new,0.0,SQPushFXPitch.new(0.96,pbchance:0.8))
,BBCSPost.new
],SQPusher1(0.4, 3, 0.4)).tempo_(3.4).ar;
)


( //second demo
var sf;

sf=SF3.array([":Sounds:bogdan:dillbeat1"],[8]);

BBCut([BBCutSynthSF(sf.at(0),0.3, SQPushFXAmp.new,0.0,SQPushFXPitch.new(0.965,pbchance:0.8))
,BBCSPost.new
],WarpCutProc1(1.0,nil,[0.7,0.3,0.5])).tempo_(3.4).ar;
)

That was internal to SuperCollider- we can use MIDI or network messages (OSC= Open Sound Control) to pass the information over to a separate application. 























Hoped for benefits- 

All the audio cutting routines become available for video processing

The visual correlation can help to make sense of the rapid cuts, and 
demonstrates their live generation. 



The message reciever might be any app but a current gigging implementation uses MAX/MSP + jitter and nato.0+55 for the video rendering and SuperCollider with bbcut for the audio. 


Messages pass the bbcut rendering state during performance as soon as a cut decision is made.


A developing practical implementation supports both stream (live video feed), fixed buffer (frames capture or movie clips) cutting and cutting between multiple cameras





Some exciting rendering possibilities are- 

cutting up dancers as they dance to the music

cutting improvising musicians as audio and video events (obviously event detection capabilities assist this) 

The protocol can be passed to any visualiser- no need for video, it could be a generative graphics system. 

//quicktime movie demoes from klippav.org













 



















