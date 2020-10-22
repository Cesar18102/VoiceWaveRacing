extends Control

signal gased(magnitude);

var gas_clicked : bool = false;

func _process(delta):
	if gas_clicked:
		emit_signal("gased", delta);

func _on_GAS_mouse_entered():
	gas_clicked = true;


func _on_Layout_mouse_exited():
	gas_clicked = false;
