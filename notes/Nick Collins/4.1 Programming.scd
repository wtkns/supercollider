
-----------------
SC Programming Hints


SuperCollider is a full programming language, and its helpful to see how to code some standard programming operations





























Syntax for SuperCollider as a Programming Language

SuperCollider is an object-oriented language based on Smalltalk. It has standard facilities of computer languages which I will outline for you here. 

Comments

//this is a comment

/* this is also a comment */




















Brackets

We usually group related bits of code together, and try to keep things neat and tidy. Your whole patch of code will typically be put within curly brackets

(
//my patch goes in here
)

but we also use brackets for other reasons-

( ) //for grouping expressions together or passing arguments to methods, ie SinOsc.ar(440)

{ } //function ie {arg a; a*a}

[ ] //array (list of data) ie [1,2,3,4]


SuperCollider code gets full of nested expressions- you look at the selections within brackets to check on the scope (level of nesting) of code fragments.

If you don't keep an eye on the tidiness of your code you'll get quickly confused about what goes with what. 












Try double clicking around any of the brackets in the following code:

(
//first block of code

 (
 //first nested block starts 

 (
 //second nested block
 )

 )

)















Variables and Assignment

In programming, we need to store our data somewhere, even if it's just data telling us the initial conditions for our calculations. For making music, because our programs run over time, we need to store information to keep track of the current state of affairs. 

(
var a,b,c; //variables always get defined first in a block of code

a=1; //assign some values to our variables
b=a;
c= b*5;

[a,b,c].postln;


a=4; //assign some new values to our variables
b=a+9;
c= c*5; //this is OK because c has a value already by now

[a,b,c].postln;
)

















This is fine:

(
var dave;

dave= 5;

dave.postln;
)

This is wrong and SuperCollider will complain:

(
dave=5;
dave.postln;
)






















Encapsulation

Another standard facility of programming languages is the ability to define your own functions, a 
process called encapsulation. 

Witness:

(
var myfunction;

myfunction= {arg a; a*a}; //define my own squaring function

myfunction.value(8).postln; //run my function with an input of 8 and post the result
)



This is useful because it stops us repeating similar code all over the place! 














Spot the difference in tidiness of code (don't worry about the fine detail of Array construction for now)

(
var scale, current; //code for making a random scale

current=60; 
scale= Array.fill(8, {var old; old=current; current=current+rrand(1,3); old}); //construct for making an Array to a recipe- explained more in the next part
scale.postln;

current=60; 
scale= Array.fill(8, {var old; old=current; current=current+rrand(1,3); old});
scale.postln;

current=60; 
scale= Array.fill(8, {var old; old=current; current=current+rrand(1,3); old});
scale.postln;
)










(
var makescale;

makescale= {var current; 
current=60; 
Array.fill(8, {var old; old=current; current=current+rrand(1,3); old;});
};

3.do({makescale.value.postln;});
)




[Functions] //select the text within brackets then press cmd+H to explore some more about control flow















Looping

The good thing about computers is that they follow instructions in a way that would be very monotonous for a human! They can do tasks very rapidly over and over because they are capable of looping. 

(
20.do({"over and over".postln;}) //the function here is the thing to call each time round the loop
)



(
var n;

n=0;

while({n<5}, {n=n+1; "keep going".postln;})
)












(
for(1, 5, {arg i; i.postln; }); //start at 1, step by 1 each time until you reach 5
)

(
forBy(1, 5, 2, {arg i; i.postln; }); //start at 1, step by 2 each time until you reach 5
)

You have to be careful that you don't set the computer to looping forever, which will crash your computer. 
























Conditional Execution

the control flow in SuperCollider is straight down the page:

(
"me first!".postln;
"now me!".postln;
"don't forget me!".postln;
)

Sometimes we want things to happen based upon whether something else has occured. To allow this,
programming languages have conditional execution- if some logical condition is met,do something. 


(
"me first!".postln;
"now me!".postln;
if(0.5.coin, {"don't forget me!".postln;},{"you forgot me!".postln});
//roll a dice- heads we do one thing, tails the second 
)











an if statement is used like this-

if (logical test which returns true or false, do this if true, do this if false) 

Run these lines one at a time:

if(true, "true!", "false!").postln;

if(false, "true!", "false!").postln;



(
var a,b;

a=5;

b= if(a==6, 11, 7);

b.postln;
)



["SC://Control-Structures"] //select the text within brackets then press cmd+d to explore some more about control flow





















Classes

Finally, in SuperCollider you have the possibility of writing your own functions as classes within the language- this means they are always available to you in your code. Such writing of classes is really helpful once you get to the stage of otherwise having very big long confusing files. You can break up your code over many files using classes. 

Classes are also a good conceptual tool for encapsulating functions and the data that function works with. This is part of good object oriented programming.

We'll return to this later in the course, but I'll point out that you've seen and used many classes already:

SinOsc
SCWindow
MouseX






















A note on object oriented programming in SuperCollider (you may want to come back to this later)


Text beginning with a capital letter is a class name

a dot then a function is a method of the object

LFSaw.ar //ar is the method

select the method and hit Cmd+Y to see any classes which respond to that method



You can see derived classes of a superclass by using the .dumpClassSubtree method

UGen.dumpClassSubtree

Everything derives from the Object class, so do Object.dumpClassSubtree to see the whole hierachy


You can add your own extensions to SuperCollider by writing your own classes.

When you want to add new classes, you add them as code in .sc files to the SCClassLibrary folder (we'll do this much later in the course)

Then you recompile the class library using Cmd+K : if there are syntax errors in your code, the library won't compile, but hopefully you'll see error messages that will help you identify the problem. 




























