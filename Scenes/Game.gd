extends Node2D

const TIME_SEGMENT = 0.4;

const MAX_FREQ_IGNORED = 0.05;
const MAX_FREQ_DOWN = 0.4;
const MAX_FREQ_FLAT = 0.7;

const SPACE_COEF= 0.1;

var time_passed = 0.0;
var space = 0.0;

var is_over : bool = false;
var timer_passing : bool = false;

func _on_Car_crashed(obstacle):
	is_over = true;

func _process(delta):
	if is_over:
		if handleGameOver():
			var a = 0;
			#GO TO MAIN MENU
		return;
	
	if checkGameOver() and not timer_passing:
		timer_passing = true;
		$Layout.count(3, 1, -1, 1);
		$Layout.connect("counter_expired", self, "onGameOverTimerFinished");
		return;
		
	time_passed += delta;
	
	if time_passed >= TIME_SEGMENT:
		var freq = $Listener.get_frequency();
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
	
func checkCarFallen():
	var rear_pos = $Car/RearWheel.global_position;
	var front_pos = $Car/FrontWheel.global_position;
	var body_pos = $Car/Body.global_position;
	
	if rear_pos.x > $Road.last_point.x:
		return true;
	
	if $Road.get_child_count() == 0 or rear_pos.x < 0:
		return false;
	
	for point in $Road.points:
		if point != null and point.y > body_pos.y:
			return false;
	
	return true;

func checkCarBehindCamera():
	return not $Car/Body/VisibilityNotifier2D.is_on_screen();
	
func checkCarStuck():
	return false;
	
func checkGameOver():
	return is_over or checkCarFallen() or checkCarBehindCamera() or checkCarStuck();

func handleGameOver():
	if $Layout/GameOverLabel.percent_visible == 1.0:
		return true;
	$Layout/GameOverLabel.percent_visible += 0.1;

func onGameOverTimerFinished():
	is_over = checkGameOver();
