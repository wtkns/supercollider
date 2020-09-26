/*

25 - Aesthetics of Computer Music
Why Computers?
Fast
Accurate 
Complex and Thorough: I Dig You Don't Work

25.1. I Dig You Don't Work
*/

var text;
text = ["I", "DON'T", "DIG", "YOU", "WORK"];
121.do({arg i; i.post; text.permute(i).postln;})

// Or


Task({
i = 0; t = ["i ", "don't ", "dig ", "you ", "work"];
{
u = ""; 
t.permute(i).do({|e| u = u ++ e}); 
u.speak; 
i = i + 1; 
3.0.wait
}.loop
}).play


/*
Obedient and Obtuse
Escaping Human Bias
"The key to real freedom and emancipation from local dependence [human bias] is 
through scientific method. . . . Originality is the product of knowledge, not 
guesswork. Scientific method in the arts provides an inconceivable number of ideas, 
technical ease, perfection and, ultimately, a feeling of real freedom, satisfaction and 
accomplishment." Joseph Schillinger from the Scientific Basis for the Arts
Integrity to the System
25. Exercises

*/
