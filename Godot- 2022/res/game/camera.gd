extends Camera2D

export (NodePath) var target_node
onready var target: Node2D = get_node(target_node) as Node2D

func _process(delta: float) -> void:
	global_position = target.global_position
