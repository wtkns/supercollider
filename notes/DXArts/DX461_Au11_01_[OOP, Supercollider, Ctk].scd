/* Class 1 - Object-oriented programming, SuperCollider and Beethoven */

/* DOWNLOADS */
/*

For downloads for the SuperCollider language and synthesis server, go to:

	http://supercollider.sourceforge.net/downloads/

This link will give you basic downloads and instructions. For the time being, we will use SuperCollider 3.4.4. You will also want sc3-plugins and you will need to check out a version of the Quarks (much more on this later).

For Mac OS X you will probably want:

	http://sourceforge.net/projects/supercollider/files/Mac%20OS%20X/3.4.4/
	http://sourceforge.net/projects/sc3-plugins/files/OS_X_3.4.4_Binaries/

and read the Quarks helpfile to find out how to install Quarks. Use method 2 to install Quarks (svn repository).

For Linux - check the various package managers for your distributions.

For Windows - consider running a virtual Linux, using our lab, or go for the 3.4 alpha on the SF page.

Once you have checked out a version of Quarks, you will want to install the Ctk, Tendency and WarpExt Quarks. I suggest using the Quarks.gui command to choose Quarks to install.

*/

/*
Class environment / lab

All notes will be posted before class on the course website. Feel free to download before class and use on your own laptop during class.

A lab is available to the students in this class. You have 24/7 access. All software needed for the class is available on the lab computers.

***** I HIGHLY suggest you purchase a USB memory stick to save class work on, and that you back up the files on that memory stick regularly. While class notes are very small (4k usually) soundfiles can be quite large. I suggest at least an 8GB thumb drive. ******
*/

/*
Object-oriented programming and SuperCollider

Object-oriented programming stress data structures, and an interface for querying, setting and altering data stored in those structures.

Objects define how memory is set aside for data, and how that memory can be operated on. Think of them as an abstraction that gives certain parameters for what can be stored and how it can be used.

SuperCollider is an object-oriented language. EVERYTHING in SuperCollider is an Object. However, the language is very flexible, and you can use it in a similar fashion as you would use imperitive, functional and even event-driven programming environments.

SuperCollider is also an interpretive language, and it can interact with your computer at the system level.
*/

/*
Help System.

To access the main help menu (on the Mac) type command-d, or use the Help menu item.

You may also select a class name, and pressing command-d will open that classes helpfile (if available):

*/

SinOsc;

/*
Class files and definitions.

SuperCollider, as a language, is implemented as a group of C / C++ primitives. The rest of the language is constructed from these primitives. All Objects inherit from Object, and can be created with SuperCollider code. Looking at an Class's definition can often show you quite a bit about its interface and data structures. While this won't make much sense yet, as time goes on the class definitions will be very handy. Access these by highlighting and pressing command-y.

All classes begin with an uppercase letter - in the language, they colorize Blue by default. Classes are defined with a Function, and may inherit from a super class. If no super class is specified, then a class inherits from Object. Class methods (methods that work on the class itself) begin with an asterisk. Instance methods (methods that work on an instance of a class) are lowercase. Methods are defined as Functions (which are defined within curly braces).

*/

Object;

HelloWorld : Object {
	*classMethod { "Hello World!".postln }
	instanceMethod	{ "This is from an instance of HelloWorld".postln; }
}


/*
I suggest that you think about Classes as an abstraction. Instances are a specific item, and each instance has the characteristics of the Class, but holds its own information.
E.g. we can think of a Car as a class. All cars have certain things in common - wheels, an engine, seats, windows, headlights... but an instance of a Car has specific qualities. One instance may have a gasoline engine, 2 leather seats, automatic windows and halogen headlights. Another instance may have a diesel engine, 4 cloth seats, manual windows and christmas tree lights for headlamps.

As mentioned above, classes can inherit traits from other classes. In SuperCollider, everything inherits at least from Object, sometimes from many classes. If we take Car as a class, we might create other classes that still abstractions, but have more specificity. For example. We could have a class called SportsCar and another called FamilySedan. Like Car, they have doors, engines, seats, windows and headlights. But there may be other things about these sub-classes that are more particular. For instance, we might write a program that deals with racing, so we might want to use SportsCar which contains information about top speed and handling. Or we might want to write a program about moving kids to soccer practice, so FamilySedan may be more approriate for the job.
*/

/*
Objects, Instances, class methods and instance methods.
*/

// The '.' is the 'messenger' operator. It sends the message on the right to the
// object on the left. This sends the 'new' message to HelloWorld
// single, lowercase letters are pre-allocated 'environment' variables -
// you can think of them as 'global' variables, but should use them
// sparingly in your own code (they can make debugging VERY difficult). They
// are handy for short examples though ***WARNING*** 's' is special - we'll see
// that later...
/*
HelloWorld : Object {
	var name, <>lastName;

	*classMethod { "Hello World!".postln }
	instanceMethod	{ "This is from an instance of HelloWorld".postln; }

	name { ^name }
	setName {arg newName; name = newName}
}

*/
a = HelloWorld.new; // create a new Object;
a.postln; // send a message to the instance of Object you just created

HelloWorld.classMethod; // message the Class itself...
a.instanceMethod; // message the instance of a Class

a.setName("Josh"); // call an instance method to set a variable stored in the class
a.name; // call a method that returns the value of a variable in that class

b = HelloWorld.new; // create another instance
b.setName("Stelios");
a.name;
b.name;

a.lastName;
a.lastName = "Parmenter";
a.lastName_("Parmenter"); // this syntax _( ) lets you continue to add messages
a.lastName;

a.lastName_("Jones").setName("Bob");
a.lastName;
a.name;
a.dump; // inspect the instance and its variables!
b.dump

b = nil;

/*
An Introduction to SuperCollider (the language)
*/
/* SuperCollider is a large language. It is designed however in a very musical way. Various streams of information may run at the same time. It is dynamic. It performs well under real-time constraints for computing systems.
Some more technical details:
	Object-oriented
	Interpreted
	Real-time garbage collection
	Non-typed interaction with objects (for the most part!)
*/

/* language basics and colorization */
// comments - red
/* block comment - red */
Classes // blue
\symbols // green
'symbols' // green
"Strings" // grey
thisProcess // reserved keywords - also Blue - and these are rare.
10.0  // numbers stay black
SinOsc.new // as do methods!

// statements end with a semi-colon. Hit 'enter'
// to send code to the interpreter (not Return! On some
// keyboard, you need to do Control-Return to get 'enter')

"I am a statement".postln;

(
// parens delimit a code block. You can double click
// one to select all the code in between.
"I am in a code block".postln;
// the last thing evaluated in a code block is the value
// returned by that code block. It will post in the interpreter
10 + 20;
)

// Not ending a statement with a semi-colon will cause a parse
// error:

(
"I am in a code block".postln;
10 + 20;
)



// a code block also helps define scope for variables. Variables
// are declared at the head of a code block. Variables must start
// lowercase
(
var thirty;
thirty = 30;
"The value of thirty is: ".post;
thirty.postln;
)

thirty; // this is OUTSIDE the scope of the block above

// parens can also control the order of evaluation:
(
var value;
value = 3 + 10 * 2;
"value is now: ".post;
value.postln;
// you can change the value of a variable!
value = 3 + (10 * 2);
"value is now: ".post;
value.postln;
)

// Functions are shown with curly braces. You can assign
// them to variables. They can have arguments AND variables
(
var mulAdd, mulAddResult;

mulAdd = {arg val1, val2, val3;
	var value;
	value = (val1 * val2) + val3;
};

// send the 'value' message to a Function to evaluate it
mulAddResult = mulAdd.value(2, 3, 4);
("First result is:" ++ mulAddResult).postln;
mulAddResult = mulAdd.value(3, 4, 5);
("Second result is:" ++ mulAddResult).postln;
)

// SuperCollider can also interact with the operating system:
"ls".unixCmd;
"cp README READMECOPY".unixCmd;
"ls".unixCmd;
"rm READMECOPY".unixCmd;
"ls".unixCmd;

/*
An Introduction to scsynth (the synthesis server)
*/
/* scsynth is the second program we will be using (in a way). It is the 'synthesis server' that makes sound. The SuperCollider language, while able to describe a synthesis process, does not synthesize or process any sound. In the language, it is represented by the 'Server' object - and there are two servers that a 'pre-loaded' for you. We will mostly use the 'internal' server. This server is connected to the same memory space as the language, which gives us some nice features. By default, the single letter variable 's' is used for the server, and inside the Server class, there is a special variable for default Servers as well that many parts of the language look for. This line of code will be handy in your work:
*/

Server.default = s = Server.internal;

// start the server - tells it to start the scsynth process, and to
// start listening for commands from the language

s.boot;

// we can also quit it

s.quit;

/*
The server really knows nothing about the language. The language and the server communicate with each other using a network protocol (OSC). All synthesis processes need to be defined in the language, then sent over the network as an OSC message. The language does a lot of this for you, and provides a class called SynthDef to describe synthesis processes. The code below is a quick sample so you can make sound... don't worry about the details yet - THIS is a huge part of this class!
SynthDefs take a \symbol name and a Function
*/

// define a synthesis process
a = SynthDef(\mySynthDef, {arg freq;
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
});

// 'load' it to the Server s
a.load(s);

// send an OSC message to the server
s.sendMsg(\s_new, \mySynthDef, 1000, 0, 1, \freq, 540);
s.sendMsg(\n_free, 1000);

// OSC messages are a bit icky. There are other classes you will see
// that handle them for you

b = Synth(\mySynthDef, [\freq, 440]);
b.free;

// Function has a 'play' method that does a number of the above steps for you!
// great for prototyping and testing - not so good for performance

c = {Pan2.ar(SinOsc.ar(440, 0, 0.3))}.play;
c.free;

/*
The Composer's ToolKit (Ctk) and differences with the SuperCollider abstraction Objects.

We dont' have time right now to go into all the reasons why, but the class above (Synth) which is in MANY SuperCollider Help and references has a number of problems. The primary one being that it doesn't work very well if you have to render your materials off-line (in Non-Real-Time). As a result, there is a library of tools that have been built for you that are more flexible and are also more suited to the rest of the SuperCollider language. Ctk is an extension Quark that you will see all class examples in. However, here is a quick introduction to a couple Ctk tools that will help you if you look at Help files this weekend!
*/

// 'Normal' SuperCollider = SynthDef
a = SynthDef(\mySynthDef, {arg freq;
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
}).load(s);

// Ctk - CtkSynthDef - no need to load - it does it for you
a = CtkSynthDef(\mySynthDef, {arg freq;
	Out.ar(0, Pan2.ar(SinOsc.ar(freq, 0, 0.3)))
});

// create a 'Synth' - this is basically a formatter for OSC messages, nothing else
b = Synth(\mySynthDef, [\freqs, 440]); // plays automatically
b.set(\freq, 550);
b.free;

// Ctk - uses the CtkSynthDef as a prototype for the notes... send it the 'note' message
b = a.note;
b.freq_(550);
b.freq; // CtkNotes store info like other instance of a class
b.play;
// change a parameter by setting another value:
b.freq_(660);
b.free;

/*
Interaction between the language and the server - a quick demo
*/

// boot the server...
Server.default = s = Server.internal;
s.boot;
// turn on the scope... this shows the samples that are being written to the output
s.scope;

// now - execute this code block. It will create a 10 second sine tone
// you can move the mouse around to change pitch
Array
(
var synth, note;

synth = CtkSynthDef(\myTest, {
	Out.ar(0, Pan2.ar(
		SinOsc.ar(
			MouseX.kr(300, 600, \exponential)
			)
		)
	)
});

note = synth.note(0.0, 10.0).play;
)

/* READING FOR TUESDAY:

From Main Help
	Getting Help =>
		More On Getting Help
		How To Use The Interpreter
		Understanding Errors
	Language Reference =>
		Intro To Objects
		Method Calls
		Assignment
		Comments
		Expression Sequence
		Functions
		Scope
		Classes
		Polymorphism
	Extending SC =>
		Quarks

Dodge Chapters 1-3
SC Chapter 24


	*/