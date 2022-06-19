extends Control

var currentScreen = 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		next()

func next():
	if currentScreen < 12:
		currentScreen += 1
		get_node('Inst%s' % currentScreen).visible = true
		return
	get_tree().change_scene("res://res/game/game.tscn")
