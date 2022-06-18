extends Node

var sensitivity: int = 10
var amplification: float = 1.0

var recording
var effect: AudioEffectRecord
var mic_bus_index: int
var volume: float = 0.0

var is_recording: bool = false
var last_start: int = 0
var last_end: int = 0
var last_samples = []

var power: float

func _ready() -> void:
	mic_bus_index = AudioServer.get_bus_index('mic')
	effect = AudioServer.get_bus_effect(mic_bus_index, 0)
	effect.set_recording_active(true)
	effect.format = 0
	last_start = OS.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	var sample_power = AudioServer.get_bus_peak_volume_left_db(mic_bus_index, 0)
	sample_power = clamp(db2linear(sample_power) * amplification, 0.0, 1.0)

	last_samples.append(sample_power)
	if last_samples.size() > sensitivity:
		last_samples.pop_front()

	power = average_power()

func average_power() -> float:
	var avg = 0.0
	for sample in last_samples:
		avg += sample
	avg /= last_samples.size()
	return avg
