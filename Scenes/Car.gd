extends Node2D

signal crashed(obstacle);
signal boosted(bonus);
signal gain(money);
signal refueled(fuel);

var acceleration_gas : float = 300000.0;
var deceleration_break : float = -300000.0;

var damage_per_hit : float = 33.0;

var fuel_tank_volume : float = 100.0;
var fuel_capacity_per_second : float = 5.0;

var HP : float = 100.0;
var fuel : float = 100.0;

func _on_gased():
	$RearWheel.applied_torque = acceleration_gas;
	$FrontWheel.applied_torque = acceleration_gas;
	
func _on_GAS_BREAK_idle():
	$RearWheel.applied_torque = 0;
	$FrontWheel.applied_torque = 0;
	
func _on_breaked():
	$RearWheel.applied_torque = deceleration_break;
	$FrontWheel.applied_torque = deceleration_break;

func _on_body_entered(body):
	var is_road = body.get_collision_layer_bit(1);
	var is_obstacle = body.get_collision_layer_bit(2);
	var is_bonus = body.get_collision_layer_bit(3);
	var is_gain = body.get_collision_layer_bit(4);
	var is_fuel = body.get_collision_layer_bit(5);
	
	if is_obstacle:
		emit_signal("crashed", body);
	elif is_bonus:
		emit_signal("boosted", body);
	elif is_gain:
		emit_signal("gain", body);
	elif is_fuel:
		emit_signal("refueled", body);
