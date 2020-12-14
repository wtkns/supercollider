/* Object-oriented programming */

/*

In SuperCollider, everything is an Object. Objects are defined by there Class definitions. You can take any Object's Class, and inspect how it is defined by looking directly at the class definition.

*/

String; // highlight, and press cmd-y

/* 

For many basic types in SuperCollider (numbers, strings, symbols) you do not need to create them with the 'new' class method. You can just type them right into your code, and assign them to variables. Variables in SuperCollider do not care about type, so you can assign anything to any variable.

*/

a = "This is a String";		// a String
b = 10; 					// an Integer
c = 10.2; 				// a Float
d = \test; 				// a Symbol
e = {}; 					// a Function

/*

The above assigns instances of those basic classes to some of the global variables in the environment. 

Like ALL instances of Classes in SuperCollider, you can now send messages to those instances. The messages that you can send are defined in an instance's class definition

*/

c.class; 					// see what the Class is => Float
Float; 					// browse the methods defined for Float AND its superclasses
						// also, a class's Help file is a good introduction to how
						// it is used.
						
/*

The first 'primitive' class that we are going to take a good look at is Function. Functions allow you to define a small program that will calculate something for you, and possibly return a useful result. All Functions are delimited with curly braces: {}

Functions can take arguments, contain their own variables, and will evaluate all code line by line. The last thing evaluated in your Function is ALWAYS returned from that Function, but unless the result of your Function is being stored to a variable, the return value does not need to be a concern.

Like variables, arguments to a Function also do not care about type, it is up to you to use the arguments properly.

*/

// a simple Function - it takes an argument, posts it in the interpreter AND also returns the 
// result of that final line
z = {arg aString, aNumber = 30;
	var aNewFunc;
	aNewFunc = {"Hello!!! I'm inside z".postln};
	aNewFunc.value;
	aString.postln;
	
	10 + aNumber;
};

z.class;

z.value("Hello World!", 90);

y = z.value("See, I also return the String!");


z;		// The Function
y; 		// the return result

// CAREFUL! Especially when using these global variables, it is easy to reassign them

z = z.value("Ack! I have lost my Function!");

z; 		// ooops!

/*

Functions can be quite elaborate, and can also create other objects for you and return them. While there won't be anything in these first few weeks that will require you to be very complex, as the course goes on it is important to remember that Functions will often be the basis of much of your algorithmic work and thinking. BUT - unlike Objects and instances of Objects, they don't retain memory or data. They simply process instructions and return a result. It can be as simple as a mathmatical process, or as complex as generating large-scale sound structures. We'll use Functions more later today to help abstract other ideas...

Next - Object creation beyond the basic primitive types above.

Arrays are a very basic type of arranging data in most programming languages. There are two ways to create Arrays in SuperCollider... 
*/

a = Array.new;	// using a typical language syntax
b = [10, 12, 13];				// a shortcut.
a == b;

/* 

Square brackets show up quite a bit when you are dealing with Arrays - both for creation and for referencing data. 

Arrays are really not 'mutable' (or changeable). But there are a large number of methods that work on Arrays and return new Arrays as a result. You will see a lot of re-assignment to variables with Arrays as a result.
*/

a = [];			// create an Array - has space for one object
a.add(10);		// add 10 to it BUT the add method also 
					// returns a new Array
a;					// the array now contains the integer 10
a.add(20);		// add another object
a;					// a didn't change!
b = a.add(20);// assign that new Array to the var 'b'
b;					// b contains the 'a' Array with the new
					// member
b == a;			// But a and b are NOT the same object
a = a.add(20);// often - you will see lots of code where
					// you simply reassign to your variable
a = a.add(30);
a;

/*

Usually, Arrays in most languages contain the same types of data. While this is good programming practice, SuperCollider doesn't make you do this:

*/
a = a.add([40, 50, 60]); // adds an Array of numbers to 'a'

/*

accessing values in the array: You can query an Array with an index to get an Object out of the Array. Indexes are 0 based (so - the 0th element is the 'first' element:

*/

z = a.at(3);	// => 10
z;
a;					// this doesn't change the Array!

/*

you can also use square brackets to index an Array!

*/

z = a[0]; // same as saying a.at(0);

/*

when you access the object in an Array, you can use that instance just like you would any other instance of that Object:

*/

z = a[0] + 45;
a[0];		// doesn't alter the value!

a[0] = a[0] + 45; // changes the Object of a[0]
a
a[0];

a[3]; // this is the array we added
a[3][0]; // access an element of the Array in the Array
a.at(3).at(0);
a[3][0] = a[3][0] * 123; // reassign that memory slot

a;
/*

This Array has a size of 4... this means you can access elements with the indices 0 through 3:

*/

a[0];
a[1];
a[2];
a[3];
a[4]; // blah - nothing
a.size;

/*

Iteration

Often the data you have stored in an Array is data that you are going to want to use - and iterating over that data is a common way to go about doing that. You can send the 'do' message to an array to go through each of the Array's items. The 'do' method takes, as an argument, a Function, and this function is passed in two arguments. The first argument is the Object itself that is being iterated over, the second argument is a counter (which tells you where in the Array you are). The 'do' method returns the Array that you iterated over (which is why you will see it post in the post window when we run the code below).
*/

a;
(
a.do({arg theObject, counter; 
	theObject.postln;
	counter.postln;
	});
)
/* 

You can name the arguments whatever variable name you want... I often use 'i' for the counter...

*/
(
a.do({arg theObject, i;
	// place both items in an Array, and post the Array:
	[theObject, i].postln;
});
)

/*

Now - for a sound example. Let's create a CtkSynthDef that plays a sine tone, and takes as an argument a frequency. We will then add frequency data into an array, and iterate over the Array to play notes.

*/

// first - start the server and assign Server variables:

Server.default = s = Server.internal.boot;
s.scope;
// first - without an Array or iteration - make each note
// and play them
(
var sd, freqData, note1, note2, note3, note4;

sd = CtkSynthDef(\myNote, {arg freq;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

note1 = sd.note(0.1, 2.0).freq_(440);
note2 = sd.note(0.1, 2.0).freq_(876);
note3 = sd.note(0.1, 2.0).freq_(882);
note4 = sd.note(0.1, 2.0).freq_(1762);

note1.play;
note2.play;
note3.play;
note4.play;
)

// now, using an Array to store frequency data, and 
// iterating over that Array to create the notes
(
var sd, freqData;

sd = CtkSynthDef(\myNote, {arg freq;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

freqData = [440, 876, 882, 1762];

freqData.do({arg thisFreq, i;
	var aNote;
	aNote = sd.note(0.1, 2.0).freq_(thisFreq);
	aNote.play;
});

)


// now - using the first approach, to create more
// notes, you need to add new lines of code...
// this is not very flexible... 
// instead, use the Array approach, and just add freq 
// values:

(
var sd, freqData;

sd = CtkSynthDef(\myNote, {arg freq;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

freqData = [440, 876, 882, 1762, 220, 442, 60];

freqData.do({arg thisFreq, i;
	var aNote;
	aNote = sd.note(0.1, 2.0).freq_(thisFreq);
	aNote.play;
});

)

/*

Creating timed events with Routine

A 'Routine' is an Object that can be used timing purposes (there are many!). For instance, what if we want to play the above notes, one per second, until we are done with the notes? We can still iterate over the Array to do this using a Task, with 'wait' messages in the 'do' loop:

*/


(
var sd, freqData, routine;

sd = CtkSynthDef(\myNote, {arg freq;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

freqData = [440, 876, 882, 1762, 220, 442, 60].scramble;

// Routine takes a Function to execute as its first argument (there 
// is a second argument you can ignore for now.)
// within this Function, you may use Number.wait to pause execution

routine = Routine.new({
	freqData.do({arg thisFreq, i;
		var aNote;
		aNote = sd.note(0.1, 2.0).freq_(thisFreq);
		aNote.play;
		(1.0 + (i * 0.1)).wait;
	});
});

routine.play;

)

// the wait time inside the Routine is local to that Routine - so you can have two 
// running at the same time. 

(
var sd, freqData, routine1, routine2;

sd = CtkSynthDef(\myNote, {arg freq;
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	Out.ar(0, Pan2.ar(sin));
}).send(s);

freqData = [440, 876, 882, 1762, 220, 442];

// *NOTE* - If you call a class without a class method, the 
// *new class method is assumed. The following Task({}) call
// is the same as Task.new({})

routine1 = Routine({
	freqData.do({arg thisFreq, i;
		var aNote;
		aNote = sd.note(0.1, 2.0).freq_(thisFreq);
		aNote.play;
		1.0.wait;
	});
});

routine2 = Routine({
	// wait before this loop begins!
	1.5.wait;
	freqData.do({arg thisFreq, i;
		var aNote;
		aNote = sd.note(0.1, 2.0).freq_(thisFreq * 2); // multiply thisFreq * 2
		aNote.play;
		1.23.wait;
	});
});

routine1.play;
routine2.play;
)

/*

For Thursday - read Chapter 18 in SC book if you haven't already, and the Help files for:

Routine and the helpfile for Task, Array and its superclasses (the 'inherits from' list in the Help file). 

*/
