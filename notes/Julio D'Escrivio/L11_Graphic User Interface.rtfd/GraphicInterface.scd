
-----------------
Anglia Ruskin University
Creative Music Technology
Tutor: Julio d'Escriván
j.d'escrivan@anglia.ac.uk
01223 363271 ext 2978

Sound and Synthesis
MUB2004
Week 12
Lesson 11 


In Class we will have covered the following topics: User interfaces, windows, buttons and sliders.


CAVEAT
The following tutorial is only meant as an accompaniment to the class delivered by the tutor as part of the course in basic sound and synthesis, MUB2004 delivered at Anglia Ruskin University, Cambridge. It can still be of help to people who are not taking the course, but it may not serve as a standalone tutorial to supercollider if you are using it on its own. On the other hand if you have initiative and you use the other supercollider tutorials available on the net, this can be a good starter into Sound and Synthesis for newbies. It tries not to presuppose any computer programming experience. It often explains the seemingly obvious (to advanced users). If you are a newbie and not afraid to admit it, then WELCOME I wrote this for us ;)

ThE GraphiC UsEr InterfaCe.

We have left this lesson for the end because it is meant to prepare you for the next module rather than this one, but still if you get the hang of it, you may be able to use it for the synthdefs you have made in the last couple of weeks. A graphic user interface is the collection of graphic elements, i.e. windows, buttons, sliders, that a user can use to get the software to work. The transport bar in your favourite music sequencer is no more than a window with a bunch of buttons that hide some code, not unlike you have been writing this semester. Of course, the Graphic user interface is not essential for synthesis, but when it comes time to share our synthdefs, it is easier for other users if all they see are buttons and sliders as opposed to lines of codes... now, everybody uses the word 'interface' but few people actually know what it really means. Let's consult the trusty dictionary.com:


in·ter·face    (ibreve.gif nprime.gif tschwa.gif r-famacr.gif slprime.gif )
n.
1. A surface forming a common boundary between adjacent regions, bodies, substances, or phases.
2. A point at which independent systems or diverse groups interact: the interface between crime and politics where much of our reality is to be found (Jack Kroll).
3. Computer Science.
1. The point of interaction or communication between a computer and any other entity, such as a printer or human operator.
2. The layout of an application's graphic or textual controls in conjunction with the way the application responds to user activity: an interface whose icons were hard to remember.

Usage Note: The noun interface has been around since the 1880s, meaning a surface forming a common boundary, as between bodies or regions. But the word did not really take off until the 1960s, when it began to be used in the computer industry to designate the point of interaction between a computer and another system, such as a printer. The word was applied to other interactions as wellmdash.gif between departments in an organization, for example, or between fields of study. Shortly thereafter interface developed a use as a verb, but it never really caught on outside its niche in the computer world, where it still thrives. The Usage Panel has been unable to muster much enthusiasm for the verb. Thirty-seven percent of Panelists accept it when it designates the interaction between people in the sentence The managing editor must interface with a variety of freelance editors and proofreaders. But the percentage drops to 22 when the interaction is between a corporation and the public or between various communities in a city. Many Panelists complain that interface is pretentious and jargony. Certainly, it has no shortage of acceptable synonyms; cooperate, deal, exchange information, interact, and work present themselves as ready substitutes.


Now, a way to remember all this would be to consider the word 'fascia' which could be the latin word on which 'interface' is built. Fascia means 'band' or 'bandage', something that connects something to something else !

So there we have it a user interface connects the user, with our software code. It creates a 'face' for our code. It is like looking at a handsome person and seeing their face, but not the frontal lobe of their brain !!!

Ok, by now I think you probably understand this word, interface. :)

You may be thinking that was excessive but someday you will thank me for taking the time, heh.


So... how does this happen in supercollider? We need a 'face' to put in front of our codes for other users. From our computing experience we know windows, buttons and sliders. Lets have a look at them.




Windows:

This is the command to make a window and bring it to the 'front' by displaying it (there is no 'back' actually, the method 'front' makes it appear as well as bring it to the front of other windows:

SCWindow("my first window", Rect(100, 800, 400, 450)).front;

let's break it down:

'SCWindow' is the class from which windows are made. The first thing we can do is give it a title, that goes in inverted commas: "my first window". Then we create a rectangle with four indications: 

-distance in pixels from the left side of the screen (in this case 100 pixels);
-distance in pixels from the bottom of the screen (in this case 800 pixels);
-width of the window (in this case 400 pixels)
-Height of the window (in this case 450 pixels)

(by the way, a pixel is the smallest dot your computer screen can make for you to see)

... and then we make it visible 
There are other arguments you can give it, but for now that's enough, except that I like this one, it is called alpha and between 0 and 1 you can give a degree of transparency, watch:

SCWindow("my first window", Rect(100, 800, 400, 450)).front.alpha_(0.1)


I just think that's cool ! you don't have to use it but maybe you will?

anyway the simplest thing we can do is make a window and bring it to the front

SCWindow("my first window", Rect(100, 800, 400, 450)).front;

Now, you could just spend a few minutes making windows and placing them in different places on the screen to get a feel for them, after that, we can look at buttons !

Buttons

Buttons are any boxes that when you click on them with the mouse, something happens, this something is what we will call the 'action'. Also the button changes its appearance to show it has been clicked (or 'pressed'), this change we will call the 'state'.

What we would like to do now is to put a button in a window and use it for something to see how it works. SCButton is the object we want. This is our task:

1. to create a window in which to place our button.
2. to create a button inside that window.
3. to define for the button a number of states (on, off for example, or a series of toggles).
4. to define for each state an action to be done

here it goes then:

( //double click here
var myWindow, myButton;
myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later
myWindow.front; // bring the window into existence (the 'front')

myButton = SCButton(myWindow, Rect(20,20,340,30) ); // create the button with the dimensions of Rect

myButton.states = [ //we assign some states to the button 
 ["go on... click here", Color.white, Color.black], // the name, font color, background color
 ["oooops !!!", Color.red, Color.yellow], 
 ["this computer will autodestroy in 5 secs", Color.blue, Color.red]

 ];

myButton.action = { arg hal; hal.value.postln;}; // every time you click, show what value is being sent.
) 


ok, let's do something more useful... ;)

How about just playing a sinewave? heh.


first we need to make a SynthDef and send it to the internal server:


SynthDef.new(\sinus, { Out.ar(0, SinOsc.ar(261));} ).send(Server.internal);

then we test it to see that it works:

x = Synth(\sinus); // assign it to a variable

x.free; // so we can send the message 'free' to switch it off !


ok, let's re-use some of our button making code:

but first let's make sure the Internal server is the default server:

Server.default = s = Server.internal.boot;



( //double click here, I'm going to give meaningful names to the variables so this code almost looks like real english !!!

var resultingSound, myWindow, myButton; // we will use this below !
myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later
myWindow.front; // bring the window into existence (the 'front')

myButton = SCButton(myWindow, Rect(20,20,340,30) ); // create the button with the dimensions of Rect

myButton.states = [ //we assign some states to the button, when you click on each state you cycle through the numebrs 0,1,2, etc according to how many states you define. 
 ["load the Synth", Color.white, Color.black], // state 0, name, font color, backg. color
 ["make it play", Color.red, Color.yellow], //state 1
 ["switch it off", Color.blue, Color.red] // state 2

 ];

myButton.action = { var buttonState, mySynth ; //we assign some actions to each state of the button
 
 mySynth = SynthDef.new(\sinus, { Out.ar(0, SinOsc.ar(261));} ); //put the synthdef in a variable
 
 buttonState = myButton.value.postln; // we are assigning here the value sent by the button
 
 case //an explanation of this will follow below !
 { buttonState == 1 } { mySynth.send(Server.internal) } // send the Synthdef when the state sent is 1
 { buttonState == 2 } { resultingSound = Synth(\sinus).postln } // play it when the state sent is 2
 { buttonState == 0 } { resultingSound.free }; // switch it off when the state sent is 0
 };
) 
 

The only thing I had not explained to you in the exampe above is the object called 'case'. I used it because it closely resembles the way we assign states to the button, and to show you that a button can have more than one state... because, no doubt, most of the buttons we encounter are on/off switches.

Also notice that when the window comes up, the button is already in 'state 0', so clicking it will take you to 'state 1' and therefore send the value '1', clicking it again will take you to 'state 2' and send '2', then again to state 0 and send '0', then 1, then 2, then 0, then 1 and so on.

I'll show you how the object 'case' works, although maybe you can understand it intuitively just by looking at the example above...

'case' tells supercollider that you are about to propose a few options of things to be done if something is true. It takes this form:

case
{something no.1} {do this if something no. 1 is true}
{something no.2} {do this if something no. 2 is true}
{something no.3} {do this if something no. 3 is true};
// notice the syntax: no commas anywhere, just a ';' at the end !!

Whenever 'case' is visited it makes a choice. Above we used button states and we made them coincide with some actions so that when the button said:

"load the Synth" , clicking it would send the value '1' (this is because when you first make the button appear, it is already in state '0' and it comes ready to change to state 1. When you click you get the value of the state that's coming up !! )


"make it play" , clicking it would send the value '2' 

"switch it off" , clicking it would send the value '0' (because we only have three states, 0,1, 2 and we started at 1 and we are cycling around !)

Anyway, before you go on, I suggest you try and do this from scratch a few times, you won't really understand it till you have tried it and made a few mistakes... use a simple SynthDef like the one I used, but with a different ugen just for fun !


Sliders

Sliders are good because we can send continuous values, like the volume of a sound (amplitude) or the frequency... They are programmed in a similar way as buttons, but the have no 'states', they send a value between 0 and 1 every time you slide them up or down, so you will have to scale this number to adapt to the different things you may want to send with it. Let's have a look:



( //double click here
var myWindow, mySlider;
myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later
myWindow.front; // bring the window into existence (the 'front')

mySlider = SCSlider(myWindow, Rect(20,20,340,30) ); // create the slider with the dimensions of Rect
)


ok, now for some action ;)

( //double click here
var myWindow, mySlider;
myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later
myWindow.front; // bring the window into existence (the 'front')

mySlider = SCSlider(myWindow, Rect(20,20,340,30) ); // create the slider with the dimensions of Rect

mySlider.action ={
 mySlider.value.postln; //this will just post the value of the slider for you to see
 };
 )


As you can see, we get values between 0 and 1. If we wanted to send out frequency values, we would need to scale it to produce numbers between 0 and 20.000... let's do it:

( //double click here
var myWindow, mySlider;
myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later
myWindow.front; // bring the window into existence (the 'front')

mySlider = SCSlider(myWindow, Rect(20,20,340,30) ); // create the slider with the dimensions of Rect

mySlider.action ={
 (mySlider.value*20000).postln; //this will just post the value of the slider for you to see
 };
 )


ok, so before we can use the slider with our synth, we need to make it so that our synth's frequency can change, so let's modify the synthdef:



SynthDef.new(\sinus, { arg myFreq = 0; Out.ar(0, SinOsc.ar(myFreq));} ).send(Server.internal);

then we test it to see that it works:

Synth(\sinus, ["myFreq" , 261]); // assign the value 261 to the argument 'myFreq'

ok, so presumably if I now sent slider values to myFreq I would be able to change it, right? These values should be between 0 and 20000. (well between 20 and 20000 but I don't want to show you that in case you would like to solve the offset thing yourself... see below !)

let's re-use the code

Server.internal = s = Server.default;



( //double click here


var myWindow, mySlider, mySynth, resultingSound ; 

Server.internal = s = Server.default; //make sure the internal server si the default to ehare the synthdef will go, see below...

myWindow = SCWindow.new; // make the window and assign it to a handy variable we can use later

myWindow.front; // bring the window into existence (the 'front')

mySlider = SCSlider(myWindow, Rect(20,20,340,30) ); // create the slider with the dimensions of Rect

mySynth = SynthDef.new(\sinus, { arg myFreq = 0; Out.ar(0, SinOsc.ar(myFreq));} ).send(Server.internal); //send my new SynthDef to the internal server.

resultingSound = Synth(\sinus); // make an instance of the synth, but with no frequeny value...

mySlider.action = {var sliderValue;
 sliderValue = (mySlider.value*20000); //this will just post the value of the slider for you to see
 resultingSound.set("myFreq" , sliderValue); //the method set passess the values to the synth
 };
)

the sound is a bit rough and we get 'zipper' noise, but you can see how making a slider works... ok, let's integrate buttons and sliders ...

This is what we will do:

1. make a window
2. make a button in that window
3. assign the button states and actiond
4. make a slider in the window
5. assign the slider action
6. run the patch as a whole.

This should be easy as we have done all the work already ! All we have to do is copy and paste the code and change a few details:


( //double click here, notice that we reused everything, put our variables at the top if they are common, like myWindow and then used the last synthdef we made that allowed us to change freqency...

//declare variables that are used throughout
var resultingSound, myWindow, myButton, mySlider, mySynth; 

// just in case, make the server a default
Server.internal = s = Server.default; 

//make the window
myWindow = SCWindow.new; 
myWindow.front; 

//make the synth
mySynth = SynthDef.new(\sinus, { arg myFreq = 0; Out.ar(0, SinOsc.ar(myFreq));} ); 

//make the button, states and actions.
myButton = SCButton(myWindow, Rect(20,20,340,30) ); 
myButton.states = [  
 ["load the Synth", Color.white, Color.black], ["make it play", Color.red, Color.yellow], 
 ["switch it off", Color.blue, Color.red] 
 ];
myButton.action = { var buttonState ; 
 
 buttonState = myButton.value.postln; 
 case 
 { buttonState == 1 } { mySynth.send(Server.internal) } 
  { buttonState == 2 } { resultingSound = Synth(\sinus).postln } 
 { buttonState == 0 } { resultingSound.free }; };

//make the slider, be sure to put it lower down in the window, notice the values in Rect !!
mySlider = SCSlider(myWindow, Rect(20,100,340,30) ); 

mySlider.action = {var sliderValue;
 sliderValue = (mySlider.value*20000); resultingSound.set("myFreq" , sliderValue); };
)

ok, now for the cosmetic section:

- to give the window a background colour, we use an instruction like this: 
myWindow.view.background=Color.blue(alpha:0.3); 
'alpha' is a transparency value between, yes you guessed it, 0 and 1.

- to give the knob of a slider a color, we do this:
mySlider.knobColor = Color.black;

-to give a slider's background some color we could use an instruction like this:
SCSlider.background_(Color.white)

-but far nicer is to give the slider background a 'gradient ' of color... with an instruction like this:
SCSlider.background_(Gradient(Color.blue(alpha: 0), Color.blue(alpha: 0.2, \h,20) ) );

-If you want to design your own colors you can do that too... just check out the Color helpfile, you could use this type of command:
myWindow.view.background=Color.new255(0, 197, 205) which is turqouise !!! 

so I'm now going to paste the window-button-slider demo code above but add these cosmetic instructions included.

( // dbl click here ! (well just before the parenthesis, actually !)

//declare variables that are used throughout
var resultingSound, myWindow, myButton, mySlider, mySynth; 

// just in case, make the server a default
Server.internal = s = Server.default; 
s.boot;

//make the window
myWindow = SCWindow.new; 
myWindow.front; 
myWindow.view.background = Color.blue(alpha:0.3); //WINDOW BACKGROUND

//make the synth
mySynth = SynthDef.new(\sinus, { arg myFreq = 0; Out.ar(0, SinOsc.ar(myFreq));} ); 

//make the button, states and actions.
myButton = SCButton(myWindow, Rect(20,20,340,30) ); 
myButton.states = [  
 ["load the Synth", Color.white, Color.black], ["make it play", Color.red, Color.yellow], 
 ["switch it off", Color.blue, Color.red] 
 ];
myButton.action = { var buttonState ; 
 
 buttonState = myButton.value.postln; 
 case 
 { buttonState == 1 } { mySynth.send(Server.internal) } 
  { buttonState == 2 } { resultingSound = Synth(\sinus).postln } 
 { buttonState == 0 } { resultingSound.free }; };

//make the slider, be sure to put it lower down in the window, notice the values in Rect !!
mySlider = SCSlider(myWindow, Rect(20,100,340,30) ); 
mySlider.knobColor = Color.black; //SLIDER KNOB COLOR
mySlider.background_(Gradient(Color.blue(alpha: 0), Color.blue(alpha: 0.2), \h,20) ) ;
//SLIDER BACKGROUND COLOR
mySlider.action = {var sliderValue;
 sliderValue = (mySlider.value*20000); resultingSound.set("myFreq" , sliderValue); };
)


And finally,lets put this whole chunk of code in an application which will produce the GUI window as soon as we double click it. This saves having to find the parenthesis to double click and all that... opening the file gets your GUI upfront (well if you like that sort of thing... many others prefer to look at code directly, but at least you have the option !!)

do this:
1. open a new blank supercollider page (file !).
2. type this as the first line on that page: /*RUN*/
3. paste the code we made above.
4. save it with a name you like (whatever).
5. close the file.


Are you ready for your first, almost 'standalone' app? :)))

Open the file you just made (double click it or choose open from SuperCollider>File>Open... )

et voilà !!

ok...

At the end of this section you should be able to:


1. Explain in your own words the following concepts:
Graphic User Interface, Windows, Buttons, Sliders.

2. Create lines of code using the following UGens/objects:
SCWindow, SCButton, SCSlider, Rect, Color.

3. Use the following messages/methods: 
states, action, case, set, knobColor, view, background.




Do the following practice:

1. Make a window with a button that has 5 witty states :)
1.a (optional) Make a button that returns random text everytime you click it...
2. Make a window with a slider that sends midi values for velocity
2.a. (optional) Make a window with a slider that sends values between 20 and 20000 only. Hint: you need to use an offset.
3. Make a GUI for a synth of your choice with at least 1 button and 1 slider to control the synth.








