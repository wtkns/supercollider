
-----------------
//In this example code, a sound file can be made to loop at any selection in the graphical display


//load soundfile onto Server
b = Buffer.read(s,"sounds/a11wlk01.wav");


//SynthDef (making Synth straight away) which has arguments for the loop points 
c= SynthDef(\loopbuffer, {arg start=0, end=10000; Out.ar(0,Pan2.ar(BufRd.ar(1, 0, Phasor.ar(0, BufRateScale.kr(b.bufnum), start, end),0.0)))}).play(s);
//*BufFrames.ir(b.bufnum) //this wasn't needed since the GUI gives us positions directly in samples



( // make a simple SCSoundFileView
w = SCWindow.new("soundfiles looper", Rect(10, 700, 750, 100));
w.front;
a = SCSoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead("sounds/a11wlk01.wav");

a.soundfile = f; // set soundfile
a.read(0, f.numFrames); // read in the entire file.
a.refresh; // refresh to display the file.

//set a function which is called when the mouse is let go, i.e. just after dragging out a selection in the window
a.mouseUpAction_({arg view; 
var where;

where= (view.selections[0]); //get the latest selection (assuming no other selections going on)

where.postln; //post where - start sample and length in samples of selection

c.set(\start,where[0], \end, where[0]+where[1]); //convert to start and end samples for loop area
});
)


