extends Control

var currentScreen = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(5.0), "next")
	pass # Replace with function body.

func next():
	if(currentScreen == 1):
		get_node("Inst2").visible = true
