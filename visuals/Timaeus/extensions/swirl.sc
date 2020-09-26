Swirl{
	*move{
		arg this_anima;

		if ( (this_anima.position.x <= (~xDomain/2)),
			{this_anima.velocity.x = (this_anima.velocity.x + 5.rand);
			});

		if ( (this_anima.position.x >= (~xDomain/2)),
			{this_anima.velocity.x = (this_anima.velocity.x -5.rand);
			});
			
		if ( (this_anima.position.y <= (~yDomain/2)),
			{this_anima.velocity.y = (this_anima.velocity.y + 5.rand);
			});

		if ( (this_anima.position.y >= (~yDomain/2)),
			{this_anima.velocity.y = (this_anima.velocity.y - 5.rand);
			});		
			
		this_anima.position = this_anima.position + this_anima.velocity;
		
		if (this_anima.age%this_anima.rhythm==0, 			{this_anima.soundParameters.playSound(this_anima)});

 	}		
}