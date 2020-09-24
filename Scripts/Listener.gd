extends AudioStreamPlayer

var spectrum : AudioEffectSpectrumAnalyzerInstance;

const MIN_FREQ = 100.0;
const MAX_FREQ = 4000.0;

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(
		AudioServer.get_bus_index("Record"), 0
	);
	#AudioServer.get_bus_effect(
	#	AudioServer.get_bus_index("Record"), 1
	#).set_recording_active(true);
	
func get_frequency():
	return spectrum.get_magnitude_for_frequency_range(MIN_FREQ, MAX_FREQ).x;
