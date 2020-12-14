 Drift{ 
	*move{
		arg this_anima,next_position;
		next_position = this_anima.position + Point(this_anima.velocity.x.rand2,this_anima.velocity.y.rand2);
		
		if ( (next_position.x < 0).or(next_position.x > ~xDomain),
			{next_position = Point((~xDomain/2),(~yDomain/2));
			});
			
		if ( (next_position.y < 0).or(next_position.y > ~yDomain),
			{next_position = Point((~xDomain/2),(~yDomain/2));
			});			

		this_anima.position = next_position;

		if (this_anima.age%this_anima.rhythm==0, {this_anima.soundParameters.playSound(this_anima)});

 	}		
}