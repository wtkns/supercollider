Pspawner({ |sp|

	var limiter, drone1, drone2, drone1ID, drone2ID;

	limiter = sp.par(
		Pmono(\limiter,
			\dur, 0.2,
			\limit, 0.75
	).collect{|event| ~limitID = event[\id]; event});

	sp.wait(1.0);

	drone1 = sp.par(
		Pmono(\expHarm,
			\dur, Pexprand(10, 20),
			\cps, Pbrown(60.0, 120, 10, inf)).collect{
			|event| drone1ID = event[\id]; event});

	sp.wait(1.5);

	sp.par(
		Pbindef(\expHarm1,
			\dur, Pexprand(0.125, 2),
			\instrument, \expHarm,
			\id, drone1ID,
			\type, \set,
			\args, #[],
			\cps, Pbrown(50.0, 200, Pbrown(5.0, 200, 10, inf), inf),
			\cpsLag, Pkey(\dur),
			\cpsPow, Pbrown(0.125, 1.25, 0.1, inf),
			\panVal, Pwhite(-0.75, 0.75),
			\panLag, Pkey(\dur)
		)
	);

	sp.wait(5.0);

	drone2 = sp.par(
		Pmono(\expHarm,
			\dur, Pexprand(10, 20),
			\cps, Pbrown(60.0, 600, 10, inf)).collect{
			|event| drone2ID = event[\id]; event});

	sp.wait(1.5);

	sp.par(
		Pbindef(\expHarm2,
			\dur, Pexprand(0.125, 2),
			\instrument, \expHarm,
			\id, drone2ID,
			\type, \set,
			\args, #[],
			\cps, Pbrown(50.0, 200, Pbrown(5.0, 200, 10, inf), inf),
			\cpsLag, Pkey(\dur),
			\cpsPow, Pbrown(0.125, 1.25, 0.1, inf),
			\panVal, Pwhite(-0.75, 0.75),
			\panLag, Pkey(\dur)
		)
	);

	sp.wait(30.0);

	sp.suspendAll;


});