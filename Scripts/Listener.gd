extends AudioStreamPlayer

var effect : AudioEffectRecord;

# Called when the node enters the scene tree for the first time.
func _ready():
	effect = AudioServer.get_bus_effect(
		AudioServer.get_bus_index("Record"), 0
	);
	effect.set_recording_active(true);	
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Record"), 24
	);
	
func get_data():
	
	var recording = effect.get_recording();
	
	if recording == null:
		return null;
	
	var data = recording.get_data();
	
	effect.set_recording_active(false);
	effect.set_recording_active(true);
	
	return data;
