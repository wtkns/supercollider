
-----------------
Graphical User Interface Classes for SC3

Server.default=s=Server.local;

GUI classes for SC3 include Range and 2D sliders, drag and drop facilities, drop down lists, multisliders and many more... 

press shift+cmd+N (on the Mac) to see a selection of the available GUI widgets. 

//GD_ToolboxWindow() //third party class showing GUI building

//For this tutorial SwingOSC users (this includes anyone on PsyCollider) will want to add J in front of any GUI code below
//Or use the alernative file (5.2b GUIs with SwingOSC)
//SwingOSC.default.boot;





















To make a window

//The Rect(angle) takes the initial screen position and the window size
//as screenx,screeny, windowwidth, windowheight, where y is 0 at the bottom
(
var w;

w=SCWindow("My Window", Rect(100,500,200,200)); 
//A 200 by 200 window appears at screen co-ordinates (100, 500)

w.front; //this line is need to make the window actually appear
)

Note that we count on the y axis from screen origin at bottom left, to the bottom left corner of the window.















We add controls to our window, defining any parameters of their use. We pass in the window we wish the control to appear in and use a Rect again to specify where in the window the control will appear and how large it is

(
var w, slid;

w=SCWindow("My Window", Rect(100,500,200,200)); 
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=SCSlider(w,Rect(10,10,150,40)); //a basic slider object 

slid.action_({slid.value.postln;}); //this is the callback- the function is called whenever you move the slider

w.front;
)

Note how the default slider range is from 0.0 to 1.0

















A ControlSpec is a helpful class which can be used to turn this into any desired range

(
var w, slid, cs;

w=SCWindow("My Window", Rect(100,500,200,200)); 
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=SCSlider(w,Rect(10,10,150,40));

//arguments minimum value, maximum value, warp (mapping function), stepsize, starting value 
cs= ControlSpec(20, 20000, 'exp', 10, 1000); 

slid.action_({cs.map(slid.value).postln;}); //map to the desired range

w.front;
)















//Demo of using 2D-Slider for synthesis

(
SynthDef(\filterme,
{arg freq=1000, rq=0.5;
Out.ar(0, 
Pan2.ar(
BPF.ar(Impulse.ar(LFNoise0.kr(15,500,1000),0.1, WhiteNoise.ar(2)),freq,rq)
))
}).load(s)
)

(
var w, slid2d, syn;

w=SCWindow("My Window", Rect(100,300,200,200)); 
slid2d= SC2DSlider(w,Rect(5,5,175,175));

syn=Synth(\filterme);

slid2d.action_({
[slid2d.x, slid2d.y].postln;
syn.set(\freq,100+(10000*slid2d.y),\rq,0.01+(0.09*slid2d.x)); //I'm doing my own mapping here rather than use a ControlSpec
});

w.front;

w.onClose={syn.free;};
)
















For further explorations:

For demos of Drag and Drop and other UI facilities open 

GUI examples.rtf //in the Examples folder for SC

Document.open("Examples/GUI examples.rtf"); //on a Mac this will open it straight away


(
// create a GUI window with some NumberBoxes.
// You can command click on a control to drag its value to another control
var w, n, f, s;
w = SCWindow("number box test", Rect(128, 64, 260, 80));
w.view.decorator = f = FlowLayout(w.view.bounds);

n = SCNumberBox(w, Rect(0,0,80,24));
n.value = 123;

n = SCNumberBox(w, Rect(0,0,80,24));
n.value = 456;

n = SCDragBoth(w, Rect(0,0,80,24));
n.object = 789;

f.nextLine;

s = SCSlider(w, Rect(0,0,240,24));

w.front;
)

There are also interesting help files for some other GUI objects:

credit- many of the more exciting GUI objects have been introduced into SuperCollider by Jan Trutzschler.

[SCMultiSliderView] //call the Help file

[SCEnvelopeView]

and some media viewing objects

[SCSoundFileView]

(
w = SCWindow.new("soundfile test", Rect(200, 200, 800, 400));
a = SCSoundFileView.new(w, Rect(20,20, 700, 60));

f = SoundFile.new;
f.openRead("sounds/a11wlk01.wav");

a.soundfile_(f);
a.read(0, f.numFrames);

a.gridOn_(false);

w.front;
)

[SCMovieView]

(
z = SCWindow.new.front;
z.view.decorator = FlowLayout(z.view.bounds);

a=SCMovieView(z,Rect(0,0, 300,300));

//you need to put a path to a video file on your hard drive
a.path_("/Volumes/data/video/icmc/klippav-duck_cutup.mov")
)

a.stepForward


As well as screen drawing facilities using the Pen class

(
var w, h = 400, v = 400, seed = Date.seed, run = true;
w = SCWindow("subdiv", Rect(40, 40, h, v));
w.view.background = Color.rand;
w.onClose = { run = false };
w.front;
w.drawHook = { var done, nextx, nexty, yellowness, penwidth;

nextx=0;
nexty=0;
yellowness=rrand(0.0,1.0);

penwidth=rrand(0.5,1.5);

//done=0;
 Pen.use {

 200.do({arg i; 
 var lastx,lasty;
 lastx=nextx;
 lasty=nexty;
 
 nextx=nextx+rrand(1,20);
 nexty=nexty+rrand(1,40);
 
 if(nextx>=h, {nextx=nextx%h});
 if(nexty>=v, {nexty=nexty%v});
 
 penwidth=(penwidth+(0.2.rand2))%8.0;
 
 Pen.width= penwidth;
 
 yellowness= (yellowness+(0.1.rand2))%2.0;
 
 Color.yellow(yellowness).set;
 
 Pen.beginPath;
 Pen.line(Point(lastx,lasty),Point(nextx,nexty));
 Pen.rotate(rand(i%40));
 Pen.line(Point(lastx,lasty),Point(nextx,nexty));
 Pen.rotate(rand(i%40));
 Pen.line(Point(lastx,lasty),Point(nextx,nexty));
 Pen.rotate(rand(i%40));
 Pen.line(Point(lastx,lasty),Point(nextx,nexty));
 Pen.stroke;
 
 //Pen.fillRect(Rect(h.rand,v.rand,rrand(1,50),rrand(1,50)))
 
 });
 };
 
};

//{ while { run } { w.refresh; 3.wait; } }.fork(AppClock)

)

Which you could use for text manipulation as well...


(
var linetext, drawletter;
var w, h = 800, v = 60, seed = Date.seed, run = true;
var time, name, sourcestring;
var yellowness, penwidth;

//name=[\s,\u,\p,\e,\r,\c,\o,\l,\l,\i,\d,\e,\r];

//sourcestring= "any lower case text";

sourcestring= "welcome to supercollider";

name=Array.fill(sourcestring.size,{arg i; sourcestring[i].asSymbol});


time=0;

linetext= (
'a':[[[0,1],[0.5,0]],[[0.5,0],[1,1]],[[0.25,0.5],[0.75,0.5]]],
'b':[[[0,1],[0,0]],[[0,1],[1,1]],[[0,0],[1,0]],[[0,0.5],[0.75,0.5]],[[0.75,0.5],[1,0.75]],[[0.75,0.5],[1,0.25]],[[1,0.75],[1,1]],[[1,0.25],[1,0]]],
'c':[[[0,1],[0,0]],[[0,0],[1,0]],[[0,1],[1,1]]],
'd':[[[0,1],[0,0]],[[0,0],[0.75,0]],[[0,1],[0.75,1]],[[0.75,1],[1,0.75]],[[0.75,0],[1,0.25]],[[1,0.25],[1,0.75]]],
'e':[[[0,0],[0,1]],[[0,0],[1,0]],[[0,1],[1,1]],[[0,0.5],[1,0.5]]],
'f':[[[0,0],[0,1]],[[0,0],[1,0]],[[0,0.5],[1,0.5]]],
'g':[[[0,1],[0,0]],[[0,0],[1,0]],[[0,1],[1,1]],[[1,1],[1,0.5]],[[0.5,0.5],[1,0.5]]],
'h':[[[0,1],[0,0]],[[0,0.5],[1,0.5]],[[1,1],[1,0]]],
'i':[[[0,0],[1,0]],[[0.5,0],[0.5,1]],[[0,1],[1,1]]],
'j':[[[0,0],[1,0]],[[0.5,0],[0.5,1]],[[0,1],[0.5,1]]],
'k':[[[0,1],[0,0]],[[0,0.5],[1,1]],[[0,0.5],[1,0]]],
'l':[[[0,1],[0,0]],[[0,1],[1,1]]],
'm':[[[0,1],[0,0]],[[0,0],[0.5,0.5]],[[0.5,0.5],[1,0]],[[1,0],[1,1]]],
'n':[[[0,1],[0,0]],[[0,0],[1,1]],[[1,1],[1,0]]],
'o':[[[0,1],[0,0]],[[0,0],[1,0]],[[0,1],[1,1]],[[1,0],[1,1]]],
'p':[[[0,0],[0,1]],[[0,0],[1,0]],[[0,0.5],[1,0.5]],[[1,0],[1,0.5]]],
'q':[[[0,0],[0,0.75]],[[0,0],[0.75,0]],[[0,0.75],[0.75,0.75]],[[0.75,0],[0.75,0.75]],[[0.5,0.5],[1,1]]],
'r':[[[0,0],[0,1]],[[0,0],[1,0]],[[0,0.5],[1,0.5]],[[1,0],[1,0.5]],[[0,0.5],[1,1]]],
's':[[[0,0],[0,0.5]],[[0,0],[1,0]],[[0,1],[1,1]],[[0,0.5],[1,0.5]],[[1,0.5],[1,1]]],
't':[[[0,0],[1,0]],[[0.5,0],[0.5,1]]],
'u':[[[0,1],[0,0]],[[0,1],[1,1]],[[1,0],[1,1]]],
'v':[[[0,0],[0.5,1]],[[0.5,1],[1,0]]],
'w':[[[0,0],[0.25,1]],[[0.25,1],[0.5,0.5]],[[0.5,0.5],[0.75,1]],[[0.75,1],[1,0]]],
'x':[[[0,0],[1,1]],[[0,1],[1,0]]],
'y':[[[0,0],[0.5,0.5]],[[0.5,0.5],[1,0]],[[0.5,0.5],[0.5,1]]],
'z':[[[0,1],[1,0]],[[0,0],[1,0]],[[0,1],[1,1]]],
(" ".asSymbol):[[[0,1],[1,1]],[[0,0.8],[0,1]],[[1,0.8],[1,1]]]
);

w = SCWindow("welcome", Rect(40, 500, h, v));
w.view.background = Color.blue(0.5);
w.onClose = { run = false };
w.front;

drawletter={arg which, startx, starty, xscale=100, yscale,prop=1.0;
var data;

yscale= yscale ? xscale;

data= linetext[which];

prop=(round((data.size)*prop).asInteger).max(1);

prop.do({arg i;
var val=data[i];

Pen.beginPath;
Pen.line(Point(startx+(xscale*val[0][0]),starty+(yscale*val[0][1])),Point(startx+(xscale*val[1][0]),starty+(yscale*val[1][1])));
Pen.stroke;

});

};


yellowness=rrand(0.7,0.9);

penwidth=rrand(2,3);

w.drawHook = {

 Pen.use {var xoscil, xsizoscil,yoscil, todraw, usedtime;

 Pen.width= penwidth;
 Color.yellow(yellowness).set;
 
 usedtime=time.min(1.0);
 
 todraw=(round((name.size)*usedtime).asInteger).max(1);
 
 todraw.do({arg j;
 
 xoscil= sin(2*pi*time+(j*pi*0.13))*140/(1+(10*time));
 
 yoscil= sin(2*pi*time+(j*pi*0.03))*200/(1+(200*time));
 
 xsizoscil= time*5+5;
 
 drawletter.value(name[j],50+(25*j)+(xoscil),10+yoscil,xsizoscil,xsizoscil,usedtime);
 
 });
 
 };
 
 
};

{ while { time<2.0 } { 

w.refresh; 
time=(time+0.025); //%2.0;
0.05.wait; } }.fork(AppClock)



)




