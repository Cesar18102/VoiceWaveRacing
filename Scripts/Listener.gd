extends AudioStreamPlayer

var spectrum : AudioEffectSpectrumAnalyzerInstance;

const MIN_FREQ = 100;
const MAX_FREQ = 5000;

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(
		AudioServer.get_bus_index("Record"), 0
	);
	
func get_frequency():
	return spectrum.get_magnitude_for_frequency_range(MIN_FREQ, MAX_FREQ).x;	
