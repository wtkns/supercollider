/*

31 - Graphic User Interface Starter Kit
Display

31.1. Display window
*/
(
Display.make({arg thisWindow, a, b, c;
 thisWindow.name_("Example");
}).show;
)
/*

31.2. header 
*/
(
Display.make({arg thisWindow, a, b, c, d;
 a.sp(5, 0, 10, 1); //start, low, high, increment, warp
 b.sp(400, 0, 4000, 0.1, 1);
 c.sp(0, -500, 500);
 d.sp(0.3, 0, 0.9);
 thisWindow.name_("Example");
}).show;
)
/*

31.3. Display with synthDef
*/
(
Display.make({arg thisWindow, sawFreq, sawOffset, sawScale, volume;
 sawFreq.sp(5, 0, 10, 1);
 sawOffset.sp(400, 10, 1000, 0.1, 1);
 sawScale.sp(0, -500, 500);
 volume.sp(0.3, 0, 0.9);
 thisWindow.name_("Example");
 thisWindow.synthDef_({arg sawFreq, sawOffset, sawScale, volume;
 Out.ar(0, 
 SinOsc.ar(
 abs(LFSaw.kr(sawFreq, mul: sawScale, add: sawOffset)), 
 mul: volume
 )
 )},
 [\sawFreq, sawFreq, \sawOffset, sawOffset, \sawScale, 
 sawScale, \volume, volume]
 );
}).show;
)
/*

31.4. Display shell
*/
(
Display.make({arg thisWindow, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
 // [Your variable defaults go here], e.g.
 a.sp(440, 100, 1000, 1, 1);
 thisWindow.synthDef_({arg a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
 Out.ar(0, 
 // [Your patch goes here with variables a, b, c, etc.], e.g.
 SinOsc.ar(a);
 )},
 [\a, a, \b, b, \c, c, \d, d, \e, e, \f, f, \g, g, \h, h, 
 \i, i, \j, j, \k, k, \l, l, \m, m, \n, n, \o, o, \p, p]
 );
 thisWindow.name_("Example");
}).show;
)
/*
Document
 
31.5. This Document
*/

d = Document.current;

d.title; // get the title
d.bounds; // get the bounds

d.title_("new title"); // set the title
d.bounds_(Rect(100, 100, 500, 500)); // set the bounds
d.background_(Color(0.5, 0.2, 0.7, 0.3)); // set color and visibility
d.background_(Color(0.9, 0.7, 0.7, 1)); // set color and visibility

/*

31.6. Flashing alpha
*/

~doc = Document.current;

Task({
100.do({
 ~doc.background_(Color(
 0.2, // red
 0.1, // green
 0.9, // blue 
 rrand(0.3, 0.9) // alpha, or transparancy
 ));
 0.1.wait;
})
}).play(AppClock)

// Each open document has an index number:

Document.allDocuments.at(1).front;

(
Document.new("Test one", "test text");
Document.new("Test two", "more text");
Document.new("Test three", "three");
Document.new("Four", "four");
 Task({
 Document.allDocuments.do({arg thisOne;
 // random
 thisOne.front;
 thisOne.background_(
 Color(rrand(0.1, 0.9), rrand(0.1, 0.9), rrand(0.1, 0.9)));
 0.4.wait;
 });

 }).play(AppClock)
)


/*

31.7. This Document to Front Action
*/

(
~doc.toFrontAction_({"bong".postln});
~doc.endFrontAction_({"bing".postln});
)

~doc.toFrontAction_({nil}); //turn action off
~doc.endFrontAction_({nil}); 

/*

31.8. This Document to front
*/

~randSineDoc = Document.current;
~randSineDoc.toFrontAction_({
 ~sine = {Mix.ar({SinOsc.ar(rrand(200, 900))}.dup(20))*0.01}.play
})

~randSineDoc.endFrontAction_({~sine.free})

/*

31.9. Mouse and Key Down
*/

(
~doc.keyDownAction_({arg thisDoc, key, mod, num;
 if(key == $j, /* or num == 106 */ {
 ~mySine = {SinOsc.ar(
 LFNoise0.kr(rrand(8, 15), mul: 500, add: 1000),
 mul: 0.2)*
 EnvGen.kr(Env.perc(0, 3))
 }.play;
 });
 if(key == $h, {
 ~randSine = {
 Mix.ar({SinOsc.ar(rrand(200, 900))}.dup(20))*0.01
 }.play
 });
 if(key == $k, {~randSine.free});
 if(num == 32, {s.freeAll}); // space bar
});
)

~doc.mouseDownAction_({s.freeAll});

/*
Keyboard Window

31.10. Keyboard Window From Examples (by JM?)

*/
(
var w; // window object
var courier; // font object

// an Array of Strings representing the key layout.
var keyboard = #["`1234567890-=", "QWERTYUIOP[]\\", 
 "ASDFGHJKL;'", "ZXCVBNM,./"];

// horizontal offsets for keys.
var offsets = #[42, 48, 57, 117];

var actions; // an IdentityDictionary mapping keys to action functions.
var makeKey; // function to create an SCDragSink for a key.

courier = Font("Courier-Bold", 14);

// an IdentityDictionary is used to map keys to functions so that
// we can look up the action for a key
actions = IdentityDictionary.new; // create actions dictionary

// define a function that will create an SCDragSink for a key.
makeKey = {|char, keyname, bounds|
 var v;

 keyname = keyname ? char.asString;
 bounds = bounds ? (24 @ 24);

 v = SCDragBoth(w, bounds);
 v.font = courier;
 v.string = keyname;
 v.align = \center;
 v.setBoth = false;
 v.acceptDrag = {
 SCView.currentDrag.isKindOf(Function)
 };
 v.action = { 
 ("added key action : " ++ keyname).postln;
 if (char.isAlpha) {
 actions[char.toUpper] = v.object;
 actions[char.toLower] = v.object;
 }{
 actions[char] = v.object;
 };
 w.front;
 };
};

w = SCWindow("keyboard", Rect(128, 320, 420, 150));

w.view.decorator = FlowLayout(w.view.bounds);

// define a function to handle key downs.
w.view.keyDownAction = {|view, char, modifiers, unicode, keycode|
 var result;
 
 // call the function
 result = actions[char].value(char, modifiers);
 
 // if the result is a function, that function becomes the 
 // new action for the key
 if (result.isKindOf(Function)) {
 actions[char] = result;
 };
};

// make the rows of the keyboard
keyboard.do {|row, i| 
 row.do {|key| makeKey.(key) };
 if (i==0) { makeKey.(127.asAscii, "del", 38 @ 24) };
 if (i==2) { makeKey.($\r, "retrn", 46 @ 24) };
 w.view.decorator.nextLine;
 w.view.decorator.shift(offsets[i]);
};

// make the last row
makeKey.($ , "space", 150 @ 24);
makeKey.(3.asAscii, "enter", 48 @ 24);

w.front;
)




////////////////////

// Drag these things to the keyboard to test it.

(
{
 var synth, original;
 original = thisFunction;
 synth = { SinOsc.ar(exprand(500,1200),0,0.2) }.play;
 { synth.free; original }
}
)


(
{
 { 
 Pan2.ar(
 SinOsc.ar(
 ExpRand(300,3000), 
 0,
 SinOsc.kr(ExpRand(1,15),0,0.05).max(0)), 
 Rand(-1,1)) 
 }.play;
}
)

{ s.sendMsg(\n_free, \h, 0); } // kill head

{ s.sendMsg(\n_free, \t, 0); } // kill tail

(
{{
 var eg, o, freq, noise;
 eg = EnvGen.kr(Env.linen(0.1,2,0.4,0.2), doneAction: 2);
 freq = Rand(600,1200);
 noise = {LFNoise2.ar(freq*0.1, eg)}.dup;
 o = SinOsc.ar(freq,0,noise);
 Out.ar(0, o);
}.play})


(
{{
 var in, sr;
 in = LFSaw.ar([21000,21001], 0, LFPulse.kr(ExpRand(0.1,1),0,0.3,0.2,0.02));
 sr = ExpRand(300,3000) + [-0.6,0.6];
 Out.ar(0, RLPF.ar(in * LFPulse.ar(sr, 0, MouseY.kr(0.01, 0.99)), sr * 
(LFPulse.kr(ExpRand(0.1,12),0,0.4,0.2,0.2) + LFPulse.kr(ExpRand(0.1,12),0,0.7,0.2)), 
0.1));
}.play;})

(
{{ var in;
 in = In.ar(0,2);
 ReplaceOut.ar(0, CombN.ar(in, 0.24, 0.24, 8, 1, in.reverse).distort);
}.play})

(
{{ var in;
 in = In.ar(0,2);
 ReplaceOut.ar(0, in * SinOsc.ar(MouseX.kr(2,2000,1)));
}.play})


/*

Windows and Buttons

31.11. Windows and Buttons
*/

(
v = SCWindow("Window v", Rect(20, 400, 400, 100));
v.front;
w = SCWindow("Window w", Rect(460, 400, 400, 100));
w.front; 

b = SCButton(v, Rect(20, 20, 340, 30));
b.states = [["Button b"]];
c = SCButton(w, Rect(20, 20, 340, 30));
c.states = [["Button c on", Color.black, Color.red], ["Button c off"]];
)

// When finished experimenting, close both:

v.close; w.close;

/*

31.12. States and Actions of Buttons
*/

(
v = SCWindow("Window v", Rect(20, 400, 400, 100));
v.front;
w = SCWindow("Window w", Rect(460, 400, 400, 100));
w.front; 

b = SCButton(v, Rect(20, 20, 340, 30));
b.states = [["Button b"]];
c = SCButton(w, Rect(20, 20, 340, 30));
c.states = 
 [["Start (State 0)", Color.black, Color.red], ["Stop (State 1)"]];

b.action = {w.view.background = Color(0.8, 0.2, rrand(0.2, 0.9))};
c.action = { | state | // shorthand for arg state;
 if(state.value == 0, {s.freeAll});
 if(state.value == 1, {{SinOsc.ar}.play})
};
)
 
// When finished experimenting, close both:

v.close; w.close;

/*
Slider

31.13. Slider
*/

(

SynthDef("WindowSine",
 {arg freq = 440, amp = 0.9;
 Out.ar(0, SinOsc.ar(freq, mul: amp))
 }).load(s);
 
w = SCWindow("Window w", Rect(460, 400, 600, 200));
w.front; 

w.view.decorator = FlowLayout(w.view.bounds);

c = SCButton(w, 500 @ 24);
c.states = [["Start (State 0)"], ["Stop (State 1)"]];

c.action = { | state | // shorthand for arg state;
 if(state.value == 0, {a.free});
 if(state.value == 1, {a = Synth("WindowSine")})
};
w.view.decorator.nextLine;
EZSlider(w, 500 @ 24, 
 "Frequency", ControlSpec(200, 1000, \exponential, 1), 
 {|ez| a.set(\freq, ez.value) });
w.view.decorator.nextLine;
EZSlider(w, 500 @ 24, 
 "Volume", ControlSpec(0.1, 1.0, \exponential, 0.01), 
 {|ez| a.set(\amp, ez.value) });

)
 
// When finished experimenting, close both:

v.close; w.close;

/*
30. Exercises
*/
