extends Control

var currentScreen = 1

func _ready():
	while currentScreen < 12:
		yield(get_tree().create_timer(2.0), 'timeout')
		next()
	get_tree().change_scene("res://res/game/game.tscn")


func next():
	currentScreen += 1
	get_node('Inst%s' % currentScreen).visible = true
