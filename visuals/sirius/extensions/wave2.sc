Wave2{
	*move{
		arg this_anima, next_position;
		next_position = this_anima.position + this_anima.velocity;		if (next_position.x < 0,
			{this_anima.position.x = this_anima.position.x + ~width;
			});
		if (next_position.x > ~width,
			{this_anima.position.x = this_anima.position.x - ~width;
			});
		if (next_position.y < 0,
			{this_anima.position.y = this_anima.position.y + ~height;
			});			
		if (next_position.y >~height,
			{this_anima.position.y = this_anima.position.y - ~height;
			});			
		
		this_anima.position = this_anima.position + this_anima.velocity;
		

 	}		
}