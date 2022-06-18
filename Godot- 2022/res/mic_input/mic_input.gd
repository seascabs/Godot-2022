extends Node

var sample_length: int = 10
var sensitivity: float = 1.0

var recording
var effect: AudioEffectRecord
var mic_bus_index: int
var volume: float = 0.0

var is_recording: bool = false
var last_start: int = 0
var last_end: int = 0
var last_samples = []

func _ready() -> void:
	mic_bus_index = AudioServer.get_bus_index('mic')
	effect = AudioServer.get_bus_effect(mic_bus_index, 0)
	effect.set_recording_active(true)
	effect.format = 0
	last_start = OS.get_ticks_msec()

func _process(delta: float) -> void:
	var power = AudioServer.get_bus_peak_volume_left_db(mic_bus_index, 0)
	power = clamp(db2linear(power) * sensitivity, 0.0, 1.0)

	last_samples.append(power)
	if last_samples.size() > sample_length:
		last_samples.pop_front()

func average_power() -> float:
	var avg = 0.0
	for sample in last_samples:
		avg += sample
	avg /= last_samples.size()
	return avg
