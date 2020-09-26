(
~serverBoot = Routine{
	Server.killAll;
	s = Server.local;
	o = s.options;
	o.numOutputBusChannels = 4; // The next time it boots, this will take effect
	o.memSize = 2**20;
	s.waitForBoot{
		s.makeWindow;
		s.meter;
		s.plotTree;
	};
	this.yieldAndReset;
};

~serverBoot.play;
)