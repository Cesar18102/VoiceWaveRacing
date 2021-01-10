extends Control

signal gased;
signal gas_release;

signal breaked;
signal break_release;

signal counter_expired;

var counter_from = 0;
var counter_to = 0;
var counter_delta = 0;
var current_counter_value = 0;
var counter_iteration_duration = 0;
var counter_active = false;
var time_passed = 0.0;

func _on_GAS_mouse_entered():
	emit_signal("gased");

func _on_BREAK_mouse_entered():
	emit_signal("breaked");
	
func _on_GAS_mouse_exited():
	emit_signal("gas_release");
	
func _on_BREAK_mouse_exited():
	emit_signal("break_release");
	
func updateFuel(fuel):
	$FuelLabel.text = String(int(fuel)) + "%";

func updateHealth(health):
	$HpLabel.text = String(int(health));
	
func _process(delta):
	if not counter_active:
		return;
	
	time_passed += delta;
	if time_passed >= counter_iteration_duration:
		
		if current_counter_value == counter_to:
			counter_active = false;
			$Counter.visible = false;
			emit_signal("counter_expired");
			
		current_counter_value += counter_delta;
		$Counter.text = current_counter_value as String;
		time_passed = 0;

func count(from: int, to: int, delta: int, duration: int):
	counter_from = from;
	counter_to = to;
	counter_delta = delta;
	current_counter_value = from;
	counter_iteration_duration = duration;
	counter_active = true;
	
	$Counter.visible = true;
	$Counter.text = from as String;
