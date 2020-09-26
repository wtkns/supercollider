(

p = Pmono(
	\default,
    \degree, Pseq([0, 1, 2, 0]), \dur, 0.5
).collect { |event| ~id = event[\id];
    event }.play;

)

~id.post