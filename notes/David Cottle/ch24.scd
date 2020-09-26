/*
24 - More Random Numbers
Biased Random Choices

24.1. loaded dice
*/

[60, 60, 65, 69, 54].choose

/*

24.2. high bias calculation
*/

n = 100; n.do({arg i; i = i + 1; ((i*2-1)/(n.squared)).postln})

/*

24.3. bias float
*/

max(6.0.rand.round(0.01), 6.0.rand.round(0.01));

/*

24.4. bias
*/

min(100.0.rand, 100.0.rand);

/*

24.5. bias
*/

max(200.0.rand, 100.rand);

/*

24.6. bias
*/

(100.rand + 100.rand)/2

/*

24.7. test bias
*/

[0, 1, 0.5, 0.178, 0.9, 0].plot; // plots an array

(
a = Array.fill(100, {0}); //fill an array with 0s
1000.do( //do 1000 iterations; more choices, smoother graph
 {
 b = 100.rand; //pick a random number between 0 and 999
 a.put(b, a.at(b) + 1); //increment that position
 //in the array
 }
);
a.plot; //plot the results.
)

/*

24.8. Test float bias
*/

(
a = Array.fill(100, {0}); //fill an array with 0s
1000.do( //do 1000 iterations
 {
 b = (100.rand + 100.rand)/2.div(1);
 a.put(b, a.at(b) + 1); 
 }
);
a.plot; //plot the results.
)

/*

24.9. rand tests
*/

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.rand; // 0 and this, rand2 does negative values (-this to this)
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.linrand; // linear distribution, bilinrand adds - values
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = rrand(30, 75); // random range
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = 100.exprand(1).div(1); 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = max(100.rand, 100.rand) 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
b = max(100.rand, 100.rand, 100.rand); 
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

(
a = Array.fill(100, {0}); 
1000.do({
//this.coin returns true this percent of the time
b = if(0.2.coin, {max(20.rand, 20.rand)}, {min(80.rand, 80.rand) + 20});
 a.put(b, a.at(b) + 1); 
});
a.plot;
)

/*

24. Exercises
*/
