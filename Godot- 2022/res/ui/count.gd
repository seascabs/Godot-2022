extends Label

func _ready() -> void:
	GameService.connect('update_moth_points', self, 'update_points')

func update_points(value: int) -> void:
	text = 'x%s' % value
