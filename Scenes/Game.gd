extends Node2D

const TIME_SEGMENT = 0.33;

const MAX_FREQ_IGNORED = 0.01;
const MAX_FREQ_DOWN = 0.4;

const SPACE_COEF= 0.1;

var time_passed = 0.0;
var space = 0.0;

func _process(delta):	
	time_passed += delta;
	
	if time_passed >= TIME_SEGMENT:
		var freq = $Listener.get_frequency();
		
		print_debug("freq = ", freq);
		
		var dx = time_passed * 100;
		
		if freq <= MAX_FREQ_IGNORED:
			space += dx * SPACE_COEF;
		else:
			var dy = (MAX_FREQ_DOWN - freq) * 100;
			$Road.build(Vector2(dx, dy), space, time_passed);
			space = 0;
				
		time_passed = 0;
