extends Node2D

const BONUS_TYPES = [ "speedx2", "builderx2" ];
const OBSTACLE_TYPES = [ "speedx05", "builderx05", "vlc", "corona"];

var road_texture = load("res://Materials/road.jpg");
var fuel_texture = load("res://Materials/fuel.png");

var speedx2_texture = load("res://Materials/speed.png");
var builderx2_texture = load("res://Materials/builder.png");

var bonus_textures = [ speedx2_texture, builderx2_texture ];

var speedx05_texture = load("res://Materials/snail.png");
var builderx05_texture = load("res://Materials/clock.png");

var vlc_texture = load("res://Materials/vlc.png");
var corona_texture = load("res://Materials/corona.png");

var obstacle_textures = [ 
	speedx05_texture, builderx05_texture,
	vlc_texture, corona_texture
];

var last_point : Vector2 = Vector2(0, 0);
var points : Array = [ last_point ];

const FUEL_MIN_SPACE = 2000;
const FUEL_INIT_PROBABILITY = 0.2;
const FUEL_PROBABILITY_COEFF = 1.05;

const OBSTACLE_MIN_SPACE = 1000;
const OBSTACLE_INIT_PROBABILITY = 0.2;
const OBSTACLE_PROBABILITY_COEFF = 1.1;

const BONUS_MIN_SPACE = 3000;
const BONUS_INIT_PROBABILITY = 0.2;
const BONUS_PROBABILITY_COEFF = 1.02;

var fuel_probability = FUEL_INIT_PROBABILITY;
var fuel_delta = 0;
var last_fuel = 0;

var obstacle_probability = OBSTACLE_INIT_PROBABILITY;
var obstacle_delta = 0;
var last_obstacle = 0;

var bonus_probability = BONUS_INIT_PROBABILITY;
var bonus_delta = 0;
var last_bonus = 0;

func build(delta_point, space, delta):
	if space != 0:
		last_point = Vector2(last_point.x + space, last_point.y);
		points.append(null);
		points.append(last_point);
		
	var next_point = last_point + delta_point;

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

	road.scale = Vector2(length, 5);
	road.position = pos;
	road.rotate(angle);

	road.set_collision_layer_bit(0, false);
	road.set_collision_layer_bit(1, true);

	road.set_collision_mask_bit(0, true);
	road.set_collision_mask_bit(1, false);

	road.can_sleep = false;
	road.mode = RigidBody2D.MODE_KINEMATIC;

	var collision = CollisionShape2D.new();
	collision.shape = RectangleShape2D.new();
	collision.scale = Vector2(sprite_size.x / 20.0, 5) / sprite_size;

	road.add_child(collision);
	road.add_child(sprite);
	add_child(road);

	last_point = next_point;
	points.append(next_point);
	
	if try_add_obstacle(road, delta) or try_add_fuel(road, delta) or try_add_bonus(road, delta):
		fuel_probability = FUEL_INIT_PROBABILITY;
		bonus_probability = BONUS_INIT_PROBABILITY;
		obstacle_probability = OBSTACLE_INIT_PROBABILITY;

func try_add_fuel(road : RigidBody2D, delta):
	fuel_delta += delta;
	if last_point.x - last_fuel >= FUEL_MIN_SPACE :
		if randf() <= fuel_probability:
			add_item(5, fuel_texture, road, null);
			last_fuel = last_point.x;
			return true;
		elif fuel_delta >= 1:
			fuel_probability *= FUEL_PROBABILITY_COEFF;
			fuel_delta -= 1;
	return false;

func try_add_bonus(road : RigidBody2D, delta):
	bonus_delta += delta;
	if last_point.x - last_bonus >= BONUS_MIN_SPACE :
		if randf() <= bonus_probability:
			var bonus = randi() % len(BONUS_TYPES);
			add_item(
				3, bonus_textures[bonus], 
				road, BONUS_TYPES[bonus]
			);
			last_bonus = last_point.x;
			return true;
		elif bonus_delta >= 1:
			bonus_probability *= BONUS_PROBABILITY_COEFF;
			bonus_delta -= 1;
	return false;
	
func try_add_obstacle(road : RigidBody2D, delta):
	obstacle_delta += delta;
	if last_point.x - last_obstacle >= OBSTACLE_MIN_SPACE :
		if randf() <= obstacle_probability:
			var obstacle = randi() % len(OBSTACLE_TYPES);
			add_item(
				2, obstacle_textures[obstacle], 
				road, OBSTACLE_TYPES[obstacle]
			);
			last_obstacle = last_point.x;
			return true;
		elif obstacle_delta >= 1:
			obstacle_probability *= OBSTACLE_PROBABILITY_COEFF;
			obstacle_delta -= 1;
	return false;

func add_item(collision_bit, texture, road, type):
	var item = RigidBody2D.new();

	item.set_collision_layer_bit(0, false);
	item.set_collision_layer_bit(collision_bit, true);
	
	item.set_collision_mask_bit(0, true);
	item.set_collision_mask_bit(collision_bit, false);

	item.can_sleep = false;
	item.mode = RigidBody2D.MODE_KINEMATIC;
	
	var sprite = Sprite.new();
	sprite.texture = texture;

	var sprite_size = sprite.get_rect().size;
	sprite.scale = Vector2(30, 30) / sprite_size;
	
	item.position = Vector2(
		road.global_position.x + rand_range(200, 500),
		road.global_position.y + rand_range(-300, 300)
	);
	
	var collision = CollisionShape2D.new();
	collision.shape = RectangleShape2D.new();

	item.add_child(sprite);
	item.add_child(collision);
	
	if type != null:
		item.name = type;
	
	add_child(item);
