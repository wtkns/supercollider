Rise{
	*move{
		arg this_anima, next_position;
		next_position = this_anima.position + this_anima.velocity;		if ( (next_position.x < 0).or(next_position.x > ~xDomain),
			{this_anima.velocity.x = this_anima.velocity.x * (-1);
			});
			
		if ( (next_position.y < (~yDomain - 5.rand)),
			{this_anima.velocity.y = this_anima.velocity.y + 1;
			});			

		if ( (next_position.y >= ~yDomain),
			{this_anima.velocity.y = -3.rand;
		});			

		if (this_anima.age%this_anima.rhythm==0, 			{this_anima.soundParameters.playSound(this_anima)});		
		this_anima.position = this_anima.position + this_anima.velocity;
		

 	}		
}