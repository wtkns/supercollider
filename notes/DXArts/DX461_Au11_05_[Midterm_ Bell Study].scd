/*

Midterm assignment!

a) Read Dodge 4.7 about additive synthesis
b) Read Dodge 7.3 about Jonathan Harvey's 'Mortous Plango, Vivos Vovo' ... we will listen to this piece on Thursday, October 20!
c) create a visual map of the first four minutes of the piece. Decide how you want to represent sonic events. While how you depict things is up to you, I DO suggest you at least think of the x axis in your diagrams as time. Decide what aspects of the piece deserve representation (pitch? timbre? how events are enveloped?).

d) using the data on page 105, create a code block that will play a single Risset bell I suggest using the last two code blocks above as a starting template (you will want a Function that will create a single bell for you... and you will also want to use \simpleSineWEnv CtkSynthDef for better envelope control).

	*** hints ***
	- your bell function will take amplitude as db input, as does your CtkSynthDef.
	Notice in the table that amplitude values are scaled with multipliers! This 
	implies that at some point, you will need to scale your amplitudes in a 
	linear way. I suggest doing this inside your function, converting from db to amp, 
	scaling, then converting BACK to db to pass values into your note.
	
	- partials R2 and R4 create 'beating' tones (these are partials that are closely
	tuned to another partial, but with an added freq offset). In your bell Function 
	where you parse data, you can use this bit of code to conditionally check which 
	partial you are on, and add the beating frequency as needed:
	
		partialAmps.size.do({arg i; // simply a counter passed in
			var thisAmp, thisFreq, thisDur;
			...
			thisFreq = freqScale[i] * freq;
			(i == 2).if({
				thisFreq = thisFreq + 1;
			});
			(i == 4).if({
				thisFreq = thisFreq + 1.7;
			});
			...
		});
		
e) bell study - create a 2-3 minute piece based on the ideas presented in Jonathan Harvey's 'Mortous Plango, Vivos Voco'. Consider the kinds of transformations that happen in the piece, and the kinds of change you can effect in your bell sounds. Use the 'bell' function in part 'd' as the basis for your piece. Then, consider creating other Functions that treat your basic sound differently (play with attacks, other frequencies, etc.). Also - consider making different versions of your basic \simpleSineWEnv CtkSynthDef... perhaps frequency values can also have envelopes applied to them, or perhaps you want to start using other types of control (for instance, look at the Pan2 helpfile, and see if you can add panning to your sound... or dynamic panning?).

Start by conceptually thinking about what you want to do with your piece and how you want to organize different parameters (time, pitch, etc.). Map these out visually (like you do for problem 'c') and also write a short bit of prose that explains what you want to set out to do. Keep it simple, and keep in mind the compositional ideas we have already presented - repetition, memory, etc.

Then - compose your piece using the tools presented in class so far. The piece should run in a single code block that we can execute all at once. Though our computers are very fast, CPU resources are NOT infinite (be aware of how much CPU you system is using!). Also, watch for amplitudes out of range. This Thursday and next week, Stelios and I will give you some strategies for dealing with global amplitude... until then, use the amplitude controls you have at your disposal to watch for signals that are too loud. Your ears and your speakers will appreciate this.

Due before class on Nov. 3!

*/