extends Node2D

signal crashed(obstacle);
signal boosted(bonus);
signal gain(money);
signal refueled(fuel);

var ACCELERATION_GAS : float = 300000.0;
var DECELERATION_BREAK : float = -150000.0;

const FUEL_TANK_VOLUME : float = 1000.0;
const ACCELERATION_FUEL_CAPACITY_PER_SECOND : float = 5.0;
const DECELERATION_FUEL_CAPACITY_PER_SECOND : float = 3.0;
const IDLE_FUEL_CAPACITY_PER_SECOND : float = 1.0;

const MAX_HP = 100;

var hp : float = MAX_HP;
var fuel : float = FUEL_TANK_VOLUME;

var is_acceleration : bool = false;
var is_deceleration : bool = false;

func _on_gased():
	$RearWheel.applied_torque = ACCELERATION_GAS;
	$FrontWheel.applied_torque = ACCELERATION_GAS;
	is_acceleration = true;
	
func _on_gas_release():
	$RearWheel.applied_torque = 0;
	$FrontWheel.applied_torque = 0;
	is_acceleration = false;
	
func _on_breaked():
	$RearWheel.applied_torque = DECELERATION_BREAK;
	$FrontWheel.applied_torque = DECELERATION_BREAK;
	is_deceleration = true;
	
func _on_break_release():
	$RearWheel.applied_torque = 0;
	$FrontWheel.applied_torque = 0;
	is_deceleration = false;

func _on_body_entered(body : Node2D):
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

func _process(delta):
	if is_acceleration:
		fuel -= ACCELERATION_FUEL_CAPACITY_PER_SECOND * delta;
	if is_deceleration:
		fuel -= DECELERATION_FUEL_CAPACITY_PER_SECOND * delta;
	if not is_acceleration and not is_deceleration:
		fuel -= IDLE_FUEL_CAPACITY_PER_SECOND * delta;
