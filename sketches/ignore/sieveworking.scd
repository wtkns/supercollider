
(

var fundamental = 200;


var isEven = {arg n;
	(n%2==0);
};
	
	
var getFactors = { arg n;
	if(n.even)
		{ 
		  forBy (2, sqrt(n), 2, 
		  	{ arg i; 
			  	if (n%i==0 && isEven.value(n/i))
			  	{factors = factors.add([i,n/i])}
			}
		  );				
		}
		{ "the number is odd"};
		factors
};


var getPrimes = { arg n;
	var p = Array.series(n, 2, 1); // fill array p with [2 through n]
	var tempPrimes = Array.new();
	while ( { p.size > 0 }, { 
		x = p[0];
		tempPrimes = tempPrimes.add(x);
		p.removeAllSuchThat({ arg item, i; item % x == 0 });
	 });
	 tempPrimes

};


var getGoldbach = { arg n;
	var testPrimes = Array.newFrom(primes);
	var results = Array.new();
	for (0, testPrimes.size-1, {arg i;
		if (testPrimes.includes(n-testPrimes[i]),
			{results = results.add([testPrimes[i], n-testPrimes[i]])}
		);
	});
	results 
};	

var factors = getFactors.(fundamental);
var primes = getPrimes.value(fundamental);
var goldbach = getGoldbach.(fundamental);

	("Fundamental = " + fundamental).postln;
	"".postln;
	("Even Factors = " + factors).postln;
	"".postln;
	("primes = " + primes).postln;
	"".postln;
	("goldbach = "+ goldbach).postln;
	"".postln;

"finished"
)

