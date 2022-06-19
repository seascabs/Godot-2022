extends Line2D

var max_length = 40

var raw_points = []

func _physics_process(delta: float) -> void:
	if !PlayerService.player:
		return
	raw_points.push_front(PlayerService.player.global_position)
	if raw_points.size() > max_length:
		raw_points.pop_back()

	points = PoolVector2Array(raw_points)
