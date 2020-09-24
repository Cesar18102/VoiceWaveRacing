extends Node2D

signal landed(road);
signal crashed(obstacle);
signal boosted(bonus);
signal gain(money);
signal refueled(fuel)

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

#var old_body_position = null;
#
#func _physics_process(delta):
#
#
#	if old_body_position == null:
#		old_body_position = $Body.position;
#		return;
#
#	var dpoint = $Body.position - old_body_position;
#
#	$FrontWheel.position += dpoint;
#	$RearWheel.position += dpoint;
