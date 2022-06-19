extends Control

func _on_sensitivity_slider_value_changed(value: float) -> void:
	MicInput.sensitivity = value

func _on_amplification_slider_value_changed(value: float) -> void:
	MicInput.amplification = value
