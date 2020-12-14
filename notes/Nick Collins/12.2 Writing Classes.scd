
-----------------
Using and Writing Classes in SuperCollider

Server.default=s=Server.internal;


What is Object Oriented Programming? 

Think of a jelly mould; it is a template from which we can make as many jellies as we have time and gelatinous matter. There is only one mould, but lots of jellies. 

In object oriented programming we call the mould a class, and the jellies we make from it objects or instances. 

A class is an abstract description of properties of some category. We can make a class for whatever concept we choose- if we made a class for Giraffe, it might descibe the potential for long necks and four long legs and a certain range of allowable stripiness. Using the class, we can instantiate actual giraffe objects, and make as many of them as we like, a whole herd. The individual giraffes might vary slightly in the length of their necks and legs, the stripiness of their bodies and how aggressive they are towards tourists, but they will basically conform to the category, the Giraffe class, describing giraffedom. 

There is more to Object Oriented Programming than that, but I'll reveal it slowly.






















SuperCollider is an Object Oriented Programming Language, and you should have noticed by now that words keep turning up with capital letters at the start:

SinOsc
LFSaw
LPF

These are the classes, the abstract descriptions for particular types of audio object. When we make objects from the recipes, we get particular instances of a sine oscillator, or a low frequency saw wave or a low pass filter. We can have as many sine oscillator objects as we like in our piece, but we create them from the SinOsc class.


{Mix.new([SinOsc.ar(440),SinOsc.ar(550),SinOsc.ar(660)])*0.3}.play


The way the SinOsc class is making each SinOsc object here is through a class method of the class, ar.

















A class method is just a function, but it is a function tied to a class. Typically, such class methods are the recipes for making objects. In fact, the most common one is new:

w=SCWindow.new("new window object", Rect.new(100,100,400,400));

which is used so commonly in SC, that there is a special shortcut of missing it out:

w= SCWindow("new window object", Rect.new(100,100,400,400));

w= SCWindow(); //accept defaults
























As well as class methods, we have instance methods. These are functions which any created instance (object) can respond to.

w.front; //make window appear by calling an instance method on the instance (object) we just made

//call an instance method (backColor_) on the view object belonging to the window object
w.view.backColor_(rgb(255,0,45));



Note how in the first case we called a function (using the dot) on a class name- SCWindow.new and in the second we called a function on a variable holding an individual object- w.front

































How do you know what the class methods and instance methods of any class are? You can see 
this as follows:

SCWindow //select the text and press cmd+d to get the Help file

SCWindow //select the text and press cmd+J to go to the code definition

new //select the text and press cmd+Y to see all the classes that respond to new

Try the last procedure with the following:

ar

backColor_

series



Whenever you see a response like Meta_SomeClass:, this is a class method
When you see SomeClass:, this is an instance method. 

If you go to the class definition file using cmd+J, you'll see lists of functions. Some have names that begin with a *, like *ar or *new- these are class methods. Some have names with no asterisk- these are instance methods. 














Now, a feature of SuperCollider is that every class you ever make has some position within a class hierarchy. This is a taxonomy of all the different things you can make, and how they relate to one another. 

For instance, a SinOsc is a type of UGen (unit generator). 

An Array is a type of ArrayedCollection. 

This relating of types allows classes to share common properties and avoids the programmer 
having to code lots of similar functions again and again- they can be kept in one place. 

Witness:


Collection.dumpClassSubtree //show all classes derived from Collection


for further information on querying the class hierarchy see:

["SC://Internal-Snooping"] //select the text within the brackets and press cmd+d














In fact, everything derives at root from a basic class, confusingly called Object. In SuperCollider, all other classes inherit the properties of the Object class. We say that all classes derive from Object.

Object.dumpClassSubtree //try running this to see the whole hierarchy

There is a big tree structure of classes. As we go down the hierarchy from Object, classes become increasingly specialised. Classes that specialise, that derive from something else, are called subclasses. The class they derive from is the superclass. 

When you create new classes you derive from an existing class using the colon. Hence

SinOsc : UGen //SinOsc is a subclass of UGen; UGen is the super class for SinOsc

This means that SinOsc is a more specialised UGen, one that deals exclusively with making sine waves. 

By default, you derive from Object, so if you don't specify any class to derive from explicitly, you are making a subclass of Object. 
























In making our own derivations, we start general and get more specific, hence we might have

SavannahBeast: SavannahHerbivore: Giraffe: AlbinoGiraffe

As part of our hierarchy, but we could have a more extensive set of categories. The tree might look like:

 SavannahBeast
 / \
SavannahCarnivore SavannahHerbivore 
 / \ / \
Lion Hyena Giraffe Thomson's Gazelle
 |
 AlbinoGiraffe




This is just hypothetical, and obviously real animals are much more complex than the simple models I'm suggesting here, but its enough for you to see the way we can go about classifying relationships between the categories we wish to work with. 



























As well as methods, classes and objects can have associated variables. This is because in Object Oriented programming the data is stored with the functions that act on that data. You can see this is common sense, for going back to our Giraffe class, we might want data to tell us how tall an individual giraffe is (held in an instance variable) or we might want data telling us the natural predators of the giraffe species (held in a class variable, since I assume it's the same for every giraffe). 

in the class definitions, 

var <>height; //is an instance variable

classvar <>predators; //is a class variable

in the client code (the code that uses my hypothetical Giraffe class) I might have:

g= Giraffe.new; 

g.height = 2.4; //set the height in metres of this particular Giraffe

Giraffe.predators = [\lion, \hyena, \man]; //set the predators of the entire giraffe species


Note how the instance variable is called from an instance stored in a variable, but the class variable is called via the class name. 









An important issue is that of access. Some data is only used internally in a class, for secret calculations that normal users don't need to know about; other data is freely available to people who use the class. 

This is shown by the < and > signs. 

< is the getter method, meaning that someone outside the class can read this data
> is the setter method, meaning that someone outside the class can write new values for this data.

If neither is there, nobody outside the class can access that data, but it is freely available to the code written for the class itself. 

So if we have the simple class definition: Giraffe { var <height; }

I can go 

g=Giraffe.new; 

h= g.height; //there is a getter, so I can read the current value

but I cannot go

g.height = 2.3; //there is no setter























Using extension libraries and recompiling the library

Go to the SCClassLibrary folder in the SuperCollider application directory. 

We can add or remove class definition files (those that end in .sc) from here, and then we recompile the library using cmd+K to update our class definitions. 


When you get hold of extension libraries for SuperCollider you're getting hold of lots of additional classes that people have written. Installing the third party library consists of you adding it into your SCClassLibrary so that it is compiled as part of SuperCollider. 


(note: you can also put the classes in a specific extensions directory on your system, which will be discussed with third party libraries next week)



















The claret symbol ^

We are in a position to make our own classes now. The final syntax you just need to be aware of is the use of the claret symbol ^, which is used in the methods (the functions) of the class to denote where a function returns.

In defining your own normal functions 

f= {arg a; a*a} //return the square of the argument 


In a method for a class, there's no need for an equals sign, this is defining an instance method called 'f':

f {arg a; ^a*a}

You are probably wondering why the claret is used at all; why bother? The reason is that a method can return at any point, or at multiple points based on the logic:

mymethod {arg a; if(a==4, ^7); a=(a*9)%7; ^if(a==6, 5, a)}

A normal function could not do this. 












Making a new class

NastySynth {
 classvar <>wackiness=200;
 
 *ar {arg wackymult=1; 
 
 ^CombN.ar(
 (SinOsc.ar(
 LFNoise0.ar(9, wackymult*wackiness, MouseY.kr(100,400)), 7, MouseX.kr(0.0,0.75)
 )%0.3)
 ,0.3,0.3, 5)
 }

}

Put this definition in a new window, save it as NastySynth.sc in the SCClassLibrary folder.
Recompile- the class count should go up. 
















Now run this client code one line at a time-

NastySynth.wackiness= 200; 
{NastySynth.ar}.play
{NastySynth.ar(0.01)}.play
{NastySynth.ar(SinOsc.kr(MouseX.kr(0,100)))}.play
NastySynth.wackiness= 4000; 
{NastySynth.ar}.play
{NastySynth.ar(0.01)}.play
{NastySynth.ar(SinOsc.kr(MouseX.kr(0,100)))}.play



















Finally, lets show the use of derived classes

Put the file SuperMario.sc in your DefaultLibrary and recompile. 

Now run this client code:

(
var sm;

sm=SuperMario(1.5);
SuperMario.companyaffiliation= \Nintendo;
sm.graspofItalian= 1.0; 
sm.dostuff;
)



(
u=UltraPlumber.new.height_(1.5);

UltraPlumber.dungareesupplier= \Levi;
SuperMario.companyaffiliation.postln;

u.graspofItalian= 0.7; 

u.dostuff;
)

//and you can run these lines whilst its playing
u.craftiness= 1500; 
u.height= 7.3; 
u.ubendification= 0.1;
u.sizeoftool=2.0;







