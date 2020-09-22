extends RigidBody2D

var landed = false;

func _on_RigidBody2D_body_entered(body):
	var rbody : RigidBody2D = body as RigidBody2D;
	#rbody.emit_signal("fallen", rbody, self);
