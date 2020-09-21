extends Node2D

var time_passed = 0.0;
const TIME_SEGMENT = 0.5;

func _process(delta):	
	time_passed += delta;
	
	if time_passed >= TIME_SEGMENT:
		var data = $Listener.get_data();
		
		if data == null:
			return;
			
		$Road.build(data, time_passed);
			
		time_passed = 0;
