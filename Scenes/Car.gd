extends Node2D

signal landed(road);
signal crashed(obstacle);
signal boosted(bonus);
signal gain(money);
signal refueled(fuel);

var gas: float = 0.0;

func _process(delta):
	$RearWheel.rotation += 1;
	
func add_gas(gas: float):
	self.gas += gas;

func _on_body_entered(body):
	var is_road = body.get_collision_layer_bit(1);
	var is_obstacle = body.get_collision_layer_bit(2);
	var is_bonus = body.get_collision_layer_bit(3);
	var is_gain = body.get_collision_layer_bit(4);
	var is_fuel = body.get_collision_layer_bit(5);
	
	if is_road:
		emit_signal("landed", body);
	elif is_obstacle:
		emit_signal("crashed", body);
	elif is_bonus:
		emit_signal("boosted", body);
	elif is_gain:
		emit_signal("gain", body);
	elif is_fuel:
		emit_signal("refueled", body);

func _physics_process(delta):
	print_debug("gas ", gas);
	$RearWheel.apply_torque_impulse(gas * 100000);
	#$FrontWheel.apply_torque_impulse(gas * 1000);
	gas = 0;
