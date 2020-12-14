Anima{
	var <>parent, <>position, <>velocity, <>strategy, <>age, <>visible, <>color, <>size, <>style, <>life, <>index, <>note;
	classvar <>strategies;

	*new{ 
		arg par, strat, pos, vel, col, siz, styl, lif, indx, vis, not;
		^super.new.init(par, strat, pos, vel, col, siz, styl, lif, indx, vis, not);
	}

	init{ arg par, strat, pos, vel, col, siz, styl, lif, indx, vis, not;
		
		//classvar
		strategies = Dictionary.new;
		strategies.add(
			\bounce -> 	{|part|
								var nextPos;
								nextPos =  part.position+part.velocity;
								
								if ((nextPos.x < 0),
									{part.velocity.x=part.velocity.x*(-1);
									 nextPos.x = nextPos.x*(-1);									part.play;
									part.color = Color.rand;								});
									  
								if ((nextPos.x > part.parent.bounds.x),
									{part.velocity.x=part.velocity.x*(-1);
									 nextPos.x = part.parent.bounds.x - (nextPos.x - part.parent.bounds.x );									part.play;
									part.color = Color.rand;								});
			
								if ((nextPos.y < 0),
									{part.velocity.y=part.velocity.y*(-1);
									nextPos.y = nextPos.y*(-1);									part.play;
									part.color = Color.rand;								});
									  
								if ((nextPos.y > part.parent.bounds.y),
									{part.velocity.y=part.velocity.y*(-1);
									nextPos.y = part.parent.bounds.y - (nextPos.y - part.parent.bounds.y );									part.play;
									part.color = (part.color).complementary;								});
			
								part.position= nextPos;
		});
		
		strategies.add(
			\wrap -> 	{|part|
							var nextPos;
								nextPos =  part.position+part.velocity;
								if ((nextPos.x < 0),
									{nextPos.x=nextPos.x + part.parent.bounds.x;
								}); 
			
								if ((nextPos.y < 0),
									{nextPos.y=nextPos.y + part.parent.bounds.y;
								});
								 
								if ((nextPos.x > part.parent.bounds.x),
									{nextPos.x=nextPos.x - part.parent.bounds.x;
								}); 
								
								if ((nextPos.y > part.parent.bounds.y),
									{nextPos.y=nextPos.y - part.parent.bounds.y;
								}); 
			
								part.position= nextPos;
		});
		
		strategies.add(
			\rotate -> 	{|part|
							var nextPos, center;
							center = Point.new(part.parent.bounds.x/2,part.parent.bounds.y/2);
							nextPos = part.position;// + part.velocity;
							nextPos =  (nextPos - center);
							nextPos = nextPos.rotate(0.05) + center ;
							
			
								part.position= nextPos;
		});
		
				strategies.add(
			\spiral -> 	{|part|
							var nextPos, center;
							center = Point.new(part.parent.bounds.x/2,part.parent.bounds.y/2);
							nextPos = part.position;// + part.velocity;
							nextPos =  (nextPos - center);
							nextPos = nextPos.rotate(part.index*0.0025) + center ;
							
			
								part.position= nextPos;
		});

		
		position = pos;
		velocity = vel;
		strategy = strat;
		parent = par;
		color = col;
		size = siz;
		style = styl;
		age = 0;
		life = lif;
		index = indx;
		visible = vis;
		note = not;
	}

	move{
		strategies[strategy].value(this);
		age = age+1;
	}
	
	play{
		this.note.play;
	}		
		
	
}