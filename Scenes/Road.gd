extends Node2D

const MIN_BUILD_LEVEL = -0.1;

var road_texture = load("res://Materials/road.jpg");
var last_point : Vector2 = Vector2(0, 0);
var space : int = 0;

var is_fallen = false;
var player : RigidBody2D = null;

func _ready():
	player = get_parent().find_node("RigidBody2D", true, false);

func build(data, delta):
	var next_point = signalToPoint(data, 0, len(data), last_point);
	
	if next_point == null:
		return;
	
	if space != 0:
		last_point = Vector2(last_point.x + space, last_point.y);
		space = 0;
	
	var dpoint = next_point - last_point;
	var length = sqrt(dpoint.x * dpoint.x + dpoint.y * dpoint.y);
	
	var sprite = Sprite.new();
	sprite.texture = road_texture;
	
	var sprite_size = sprite.get_rect().size;
	sprite.scale = Vector2(1, 1) / sprite_size;
	
	var pos = (last_point + next_point) / 2;
	var angle = 0;
	
	if dpoint.x != 0:
		angle = atan(dpoint.y / dpoint.x);
	
	var road = RigidBody2D.new();
	road.add_user_signal("fallen", [ RigidBody2D, RigidBody2D ]);
	road.connect("fallen", self, "on_fallen");
	
	road.scale = Vector2(length, 5);
	road.position = pos;
	road.rotate(angle);
	
	road.set_collision_layer_bit(0, false);
	road.set_collision_layer_bit(1, true);
	
	road.set_collision_mask_bit(0, true);
	road.set_collision_mask_bit(1, false);
	
	road.can_sleep = false;
	road.mode = RigidBody2D.MODE_KINEMATIC;
	
	var collision_rect = RectangleShape2D.new();
	
	var collision = CollisionShape2D.new();
	collision.shape = collision_rect;
	collision.scale = Vector2(sprite_size.x / 20.0, 5) / sprite_size;
	
	road.add_child(collision);
	road.add_child(sprite);
	add_child(road);
	
	last_point = next_point;
	
func on_fallen(fallen, by):
	fallen.set_deferred("mode", RigidBody2D.MODE_RIGID);
	fallen.gravity_scale = by.gravity_scale;
	
	var sprite = fallen.get_child(1) as Sprite;
	sprite.scale *= Vector2(fallen.scale.x, 5.0);
	
	fallen.remove_child(fallen.get_child(0));
	is_fallen = true;

func _process(delta):
	#if not is_fallen:
		$Camera.position += (last_point - $Camera.position) * delta;
	#else:
	#	$Camera.position = player.position;
	
func signalToPoint(arr : Array, start : int, end : int, prev_point : Vector2):
	var rms = 0.0;
		
	for i in range(start, end):
		rms += pow(arr[i] / 128.0, 2.0);
			
	var dx = (end - start) / 8192;
	var dy = sqrt(rms / (end - start)) - 0.7;
	
	print_debug(dy);
		
	if dy >= MIN_BUILD_LEVEL:
		return Vector2(prev_point.x + dx * 10 + space, prev_point.y - dy * 100);
	else:
		space += dx * 5;
		return null;
