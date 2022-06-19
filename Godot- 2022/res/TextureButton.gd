extends TextureButton


func _ready():
	pass 
	
func _pressed ( ):
	get_tree().change_scene("res://res/game/game.tscn")
