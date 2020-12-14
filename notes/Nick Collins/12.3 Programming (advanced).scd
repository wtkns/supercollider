
-----------------
SuperCollider the Programming Language (advanced)

SuperCollider is an object oriented interpreted language based upon the classic object oriented language Smalltalk, though also including C/Java syntax and further influences. 

There is an accompanying tutorial about classes in SuperCollider and what object oriented programming is. 

A good discussion of technical details for SC is found in: 

James McCartney, Rethinking the Computer Music Language: SuperCollider 
Computer Music Journal, 26:4, pp. 61-68, Winter 2002. 

And some topics are covered under the 'Language' section of the Main helpfile page.

I'll cover a few special features of the language below:

















The goal in SuperCollider is usually to construct a sound instrument as a network of unit generators. To create the signal processing chain, the user writes a function. This means that, unlike in graphical unit generator languages like Reaktor or MAX/MSP, the full facility of an algorithmic programming language is available:

(
{ //here is the UGen network creating function
var n, z;

n= 50; //but you can change this to whatever number you want! 

z= 1;

n.do({arg i; z= LFNoise0.ar(z*(i+1), rrand(0.1,2.5), 2.5); });

SinOsc.ar(30+(100*z),0, 0.1) 
}.play;
)


Of course we can construct user interfaces algorithmically too and do plenty more that is pretty awkward or impossible in more graphical selection based programs. 










Dynamic typing

(
var a;

a= 5;

a= "string"; 

a= \symbol;

a=MouseX.new;
)

(
//So we don't have to set types in variable declarations as in C:

double a;
float ** f; 
)












Memory management is automated, with a realtime garbage collector; there aren't any pointers to worry about. 

We can make References using the class Ref:

Ref.new([3,4,5]);

or shortcut:

`[3,4,5];

Which are sometimes useful for passing by reference in functions and to avoid MultiChannel expansion in UGens (see the Klank UGen) 












When using a function, the default is 'pass by value'

//passing by value
f= {|a,b| a=a+5; a+b};

(
c=8;

f.value(c,9).postln;

c //c has not been changed by function f - its value was copied into the argument to the function
)


//passing by reference (the argument to a function will be a reference to the original, not a copy)
f= {|a,b| a.value_(a.value+5); a.value+b};

(
c=Ref(8);

f.value(c,9).postln;

c //c has been changed within the function
)














Here are some special facilities of the Function class you may see in action: 

Variable length argument lists

(
f= {arg ...args; args.postln; };

f.value(9,10,"dave"); 

f.value([9,2,3,\dave],7, 789,34, 456, 678);
)
























Dynamic binding of arguments

(
f= {arg freq, penguin; [freq, penguin].postln; };

currentEnvironment.use(
{
~freq= 678;
~penguin=\chocolate;
 
f.valueEnvir;
});

)


















Calling methods of a class by name

(
a=Array.perform(\fill, 9, {arg i; i*i});
a.postln;
)


























A Note About Inheritance

For methods (functions defined in class files) single message dispatch is used. SC only allows single inheritance. 

Function overriding is used in derived classes but function overloading is never possible

MyClass
{

*one{arg x; }

*one{arg x, y; }

}

" ERROR: Method Meta_MyClass::one already defined.



























 