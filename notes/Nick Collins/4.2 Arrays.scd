
-----------------
Arrays

SuperCollider has lots of collection classes, but for simple tasks you can often just define arrays of data within square brackets:

a= [5,6,7,8,9,10]; 

Sometimes we need to be more explicit about how to build the list of data, and we can write our own functions to generate data:

a= Array.fill(6, {arg i; i+5}); 


You'll gradually pick up the use of the Collection classes like Array, but I'll show you a few more tricks right now as a taster. 














Some different ways of making Arrays (try each in turn):

Array.series(10,1,1) //arguments to series are number of elements, start element, and add

(1..10) //this is a shortcut for the same thing

Array.series(10,1,2) 

(1,3..20) //again a shortcut


Array.geom(10, 1, 1.1); //geometric rather than arithmetic series: arguments number of elements, start element, grow ratio

Array.geom(10, 1, 10); //be careful, the law of compound interest can make these numbers expand very fast! 



Array.rand(10, 0.7,2.4); //make 10 random numbers drawn from a linear distribution between 0.7 and 2.4


















Some different ways of manipulating arrays: just try each line out in turn and see what gets posted to the post window!


a = [1,3,5,6];

a+5

a*8

a**2 //take to power of 2

a.squared //same thing

a.sqrt

a.scramble //run me multiple times!

a.rotate(1)

a.rotate(-1)

a-10

(a-10).abs

a>4

a.reverse



















Indexing elements in arrays

b=[2,3,4,7]

b.at(3) //get the element at index 3 (meaning the fourth element)

b.at(4) //won't return anything because the array isn't big enough! nil is a placeholder for 'no response possible' and will lead to trouble when it crops up

b.put(2,50) //put 50 into the slot at index 2 (replace third element)

b //note that b itself has been changed

b.put(14,90) //crash- won't work, no space to put the 90 in, array only has four element slots

You can also use Java array notation

b[0] //get first element

b[0]= 74 //set first element

b //was changed














There are further types of Collection class we may deal with later. 
you may wish to explore the various class help files: be warned that there is a class hierarchy in operation here so a method won't necessarily be in the Array class itself

[Collections]
[SequenceableCollection]
[ArrayedCollection]
[Array]
























A note about efficiency

You will occasionally see 

#[1,2,3] //makes a totally fixed (non-dynamic) Array and is slightly cheaper, especially where you're not going to change the Array once you make it

rather than 

[1,2,3] //a dynamic array 

To show the difference

a= #[1,2,3];

a[0] //works

a[0] = 8 //fails, because it can't be changed


















More about Mix and Arrays


Let's now look at using an Array with fill to help prepare a UGen network- for this case it's easy to use the automatic channel expansion method we saw already, but you'll find this alternative helpful in more complex cases, say where you're mixing a hundred varied voices at once! 

( //you'll only hear the first two of four frequencies if you have just a stereo output
{
var freqs,array;

freqs= [440,443,447,455.7];
 
array=Array.fill(4, //4 elements will go into this array
{arg i; //this function is the recipe to make each element 
SinOsc.ar(freqs.at(i), 0, 0.1)
});

array
}.scope
)




















//We can use Mix to make this one channel

( 
{
var freqs,array;

freqs= [440,443,447,455.7];
 
array=Array.fill(4, //4 elements will go into this array
{arg i; //this function is the recipe to make each element 
SinOsc.ar(freqs.at(i), 0, 0.1)
});

Mix(array)
}.scope
)



















//There is a shortcut using Mix.fill

( //you'll hear the first two of four frequencies if you only have a stereo output
{
var freqs,array;

freqs= [440,443,447,455.7];
 
Mix.fill(4, //4 elements will go into this array
{arg i; //this function is the recipe to make each element 
SinOsc.ar(freqs.at(i), 0, 0.1)
});

}.scope
)













