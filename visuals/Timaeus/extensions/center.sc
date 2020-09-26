Center{
	*move{
		arg this_anima;
		this_anima.velocity = Point(0,0);

		if ( (this_anima.position.x <= (~xDomain/2)),
			{this_anima.velocity.x = (this_anima.velocity.x + 20.rand);
			});

		if ( (this_anima.position.x >= (~xDomain/2)),
			{this_anima.velocity.x = (this_anima.velocity.x - 20.rand);
			});
			
		if ( (this_anima.position.y <= (~yDomain/2)),
			{this_anima.velocity.y = (this_anima.velocity.y + 20.rand);
			});

		if ( (this_anima.position.y >= (~yDomain/2)),
			{this_anima.velocity.y = (this_anima.velocity.y - 20.rand);
			});		
			
		this_anima.position = this_anima.position + this_anima.velocity;
		
		if (this_anima.age%this_anima.rhythm==0, 			{this_anima.soundParameters.playSound(this_anima)});

 	}		
}