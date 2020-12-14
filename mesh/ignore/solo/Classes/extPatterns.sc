Pbrownseed : Pattern {
	var <>seed, <>lo, <>hi, <>step, <>length;

	*new { arg seed, lo=0.0, hi=1.0, step=0.125, length=inf;
		^super.newCopyArgs(seed, lo, hi, step, length)
	}

	storeArgs { ^[seed,lo,hi,step,length] }

	embedInStream { arg inval;
		var cur;
		var loStr = lo.asStream, loVal;
		var hiStr = hi.asStream, hiVal;
		var stepStr = step.asStream, stepVal;

		loVal = loStr.next(inval);
		hiVal = hiStr.next(inval);
		stepVal = stepStr.next(inval);
		cur = seed;
		if(loVal.isNil or: { hiVal.isNil } or: { stepVal.isNil }) { ^inval };

		length.value(inval).do {
			loVal = loStr.next(inval);
			hiVal = hiStr.next(inval);
			stepVal = stepStr.next(inval);
			if(loVal.isNil or: { hiVal.isNil } or: { stepVal.isNil }) { ^inval };
			cur = this.calcNext(cur, stepVal).fold(loVal, hiVal);
			inval = cur.yield;
		};

		^inval;
	}

	calcNext { arg cur, step;
		^cur + step.xrand2
	}
}

Pbrowntrend : Pbrownseed {
	var <>seed, <>low, <>high, <>step, <>length;

	*new { arg seed, low=0.0, high=1.0, step=0.125, length=inf;

		var stepUp = ((high - seed) / length );
		var stepDown = ((seed - low) / length ).neg;
		var seriesDown = Pseries(
			start: seed,
			step: stepDown,
			length: length);
		
		var seriesUp = Pseries(
			start:seed,
			step: stepUp,
			length: length);

		^super.newCopyArgs(seed, seriesDown, seriesUp, step, length)
	}

	

	// var a = Pseq([
	// Pbrown(
	// 	lo: Pseries (
	// 		start: start,
	// 		step: stepDown,
	// 		length: length),

	// 	hi: Pseries (
	// 		start:start,
	// 		step: stepUp,
	// 		length: length),

	// 	step: brownstep,
	// 	length: length),

	// Pn(

	// 	Pbrownseed(
	// 		seed: a.next,
	// 		lo: low,
	// 		hi: high,
	// 		step: brownstep,
	// 		length: brownlength))],1);



}

