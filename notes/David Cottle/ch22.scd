/*

22 - Collections, Arrays, Index Referencing, Array Messages

22.1. array math
*/

(
a = [1, 2, 3, 4]; //declare an array
b = (a + 12)*10; //add 12 to every item in the array, then multiply them
 //all by 10 and store the resulting array in b
b.postln;
)

/*

22.2. array.do and math
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
5.do(
 {
 a = a + 3;
 a.postln;
 }
)
)

22.3. array + each item

(
a = [60, 45, 68, 33, 90, 25, 10];
5.do(
 {arg item;
 a = a + item;
 a.postln;
 }
)
)

/*

22.4. two arrays
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
b = [2, 14, 19, 42, 3, 6, 31, 9];
b.do(
 {arg item;
 item.post; " plus ".post; a.post; " = ".post;
 a = a + item;
 a.postln;
 }
)
)

/*

22.5. testing an array
*/

(
a = [60, 45, 68, 33, 90, 25, 10];
b = [25, 14, 19, 42, 33, 6, 31, 9];

100.do(
 {arg item;
 if(a.includes(item), {item.post; " is in a ".postln});
 if(b.includes(item), {item.post; " is in b ".postln});
 }
)
)

/*

22.6. referencing an item in an array
*/

[12, 4, 871, 9, 23].at(3) //index 3 is "9"

[12, 4, 871, 9, 23].at(124) //wild pointer, will return nil

[12, 4, 871, 9, 23].wrapAt(124) //will wrap around and return 23


/*
Array messages

22.7. arrays messages
*/

a = [1, 2, 3, 4]; //assigns the array to the variable "a"

a.post; //prints the array 

a + 5; //adds five to each item in the array

a*3; //multiplies it, etc. 

a.do({arg item; function}) //iterates over each item passing each item
 //to the function

a.at(index) //refers to item at index number

// Here are some new ones. Run each of them to see what they do:

[1, 2, 3, 4].reverse.postln; //reverses the array

[1, 2, 3, 4].rand.postln;

[1, 2, 3, 4].scramble.postln; //scrambles the array

[1, 2, 3, 4].size.postln;// returns the size (number of items)

Array.fill(size, function); //fills an array with "size" _//number of arguments using 
function

a = Array.fill(5, {10.rand}); a.postln;

a = Array.rand(12, 0, 12)

[1, 2, 3, 4].add(34).postln; //adds an item to the array

//Note about add. You have to pass it to another array variable to _//make sure the 
item is added. So the code would have to be:

a = [1, 2, 3]; _b = a.add(10); _a = b;

[1, 2, 3, 4].choose; //chooses one of the values

[1, 2, 3, 4].put(2, 34).postln; //puts second argument at _//index of first argument

[1, 2, 3, 4].wrapAt(index) //returns item at index with a wrap

//example:

30.do({arg item; [1, 2, 3, 4].wrapAt(item).postln});

/*

22.8. array of legal pitches
*/

20.do({12.rand.postln;}) // random numbers 0 through 11

// random numbers chosen, but array reference returns only pitches
// from a major scale

20.do({[0, 2, 4, 5, 7, 9, 11].at(6.rand).postln}) 

// Be sure the rand range is not too large

20.do({[0, 2, 4, 5, 7, 9, 11].at(12.rand).postln}) 

// To protect against this, use array.size or wrapAt

a = [0, 2, 4, 5, 7, 9, 11];
20.do({a.at((a.size).rand).postln})

/*


22.9. Array index shorthand
*/

[45, 37, 99, 367, 9] @ 3 // "at" index 3

[45, 37, 99, 367, 9] @@ 25 // "wrapAt" index 25

[45, 37, 99, 367, 9] @|@ 25 // fold at index 25

[45, 37, 99, 367, 9] |@| 25 // clip at index 25

30.do({[0, 2, 4, 5, 7, 9, 11] @ (12.rand).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] @@ i).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] @|@ i).postln}) 

30.do({ |i| ([0, 2, 4, 5, 7, 9, 11] |@| i).postln}) 

/*

Practice, Bach Mutation

22.10. array of legal pitches
*/

// (engage midi)
(
var pitch;

r = Task({
// Try other versions
pitch = [12, 0, 2, 4, 2, 0, 7, 4, 12, 7, 4, 7, 5, 4, 5, 7, 0, 4, 7, 11] + 60;
inf.do({arg h, i;
 pitch.size.do({arg j;
 var n;
 //every one, then every other one, then every third, etc.
 n = pitch.wrapAt(j*(i+1));
 if((j%20 == 19), {n.postln}, {n.post; " ".post});
 m.noteOn(1, n, 100);
 thisThread.clock.sched(0.1, {m.noteOff(1, n, 100); nil});
 0.1.wait;
 });
});
})
)

r.start;
r.stop; 127.do({arg i; m.noteOff(1, i)});

/*
22. Exercises
*/
