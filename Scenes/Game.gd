extends Node2D

const TIME_SEGMENT = 0.33;

const MAX_FREQ_IGNORED = 0.05;
const MAX_FREQ_DOWN = 0.3;
const MAX_FREQ_FLAT = 0.6;

const SPACE_COEF= 0.1;

var time_passed = 0.0;
var space = 0.0;

var is_landed : bool = false;

func _process(delta):	
	time_passed += delta;
	
	if time_passed >= TIME_SEGMENT:
		var freq = $Listener.get_frequency();
		
		print_debug("data = ", freq);
		
		var dx = time_passed * 100;
		
		if freq <= MAX_FREQ_IGNORED:
			space += dx * SPACE_COEF;
		else:
			var dy = 0;
			if freq <= MAX_FREQ_DOWN:
				dy = (MAX_FREQ_DOWN - freq) * 100;
			elif freq <= MAX_FREQ_FLAT:
				dy = rand_range(-5, 5);
			else:
				dy = (MAX_FREQ_FLAT - clamp(freq, MAX_FREQ_FLAT, 1.0)) * 100;
			$Road.build(Vector2(dx, dy), space, time_passed);
			space = 0;
			
		time_passed = 0;
		
	$Camera.position += ($Road.last_point - $Camera.position) * delta;
	$Layout.rect_global_position = $Camera.global_position;

func _on_Car_landed(road):
	is_landed = true;

func _on_Layout_gased(magnitude):
	$Car.add_gas(magnitude);
