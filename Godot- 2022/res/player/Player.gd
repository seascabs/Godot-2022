extends KinematicBody2D

const LIGHT_TEXTURE = preload('res://res/player/local_light.png')

var number_of_rays: int = 10
var ray_length: float = 2000

var default_main_light_scale: Vector2 = Vector2.ONE * 0.75
var default_ray_light_energy: float = 1.0

var acceleration = 20
var drag = 0.03
var speed = 300  # speed in pixels/sec
var velocity = Vector2.ZERO
var points = 0

func _ready() -> void:
	init_rays()

func init_rays() -> void:
	var step = 2 * PI / number_of_rays
	for i in range(number_of_rays):
		var ray = RayCast2D.new()
		$rays.add_child(ray)
		ray.add_exception(self)
		ray.cast_to = Vector2(ray_length, 0).rotated(step * i)
		ray.enabled = true

		var ray_light = Light2D.new()
		ray_light.scale = Vector2.ONE * 0.8
		ray_light.mode = Light2D.MODE_MIX
		ray_light.range_height = 40
		ray_light.enabled = true
		ray_light.texture = LIGHT_TEXTURE
		$ray_lights.add_child(ray_light)

func update_lights() -> void:
	$main_light.scale = default_main_light_scale + Vector2.ONE * MicInput.power
	for i in range($rays.get_child_count()):
		var ray = $rays.get_children()[i]
		var light = $ray_lights.get_children()[i]

		if (ray as RayCast2D).get_collider():
			light.global_position = ray.get_collision_point()
			light.energy = default_ray_light_energy * MicInput.power
		else:
			light.energy = 0

func get_input() -> Vector2:
	var move = Vector2.ZERO
	if Input.is_action_pressed('right'):
		move.x += 1
	if Input.is_action_pressed('left'):
		move.x -= 1
	if Input.is_action_pressed('down'):
		move.y += 1
	if Input.is_action_pressed('up'):
		move.y -= 1
	# Make sure diagonal movement isn't faster
	move = move.normalized() * acceleration

	if velocity.length():
		var target = atan2(velocity.y, velocity.x) + PI/2
		$AnimatedSprite.rotation = lerp_angle($AnimatedSprite.rotation, target, 0.3)

	return move

func _physics_process(delta):
	var move = get_input()
	velocity += move
	velocity = velocity.clamped(speed)
	velocity *= 1.0 - drag
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.normal)
		var body = collision.collider
		if "Moth" in body.name:
			points = points + 1
			body.queue_free()
			if(points > 2):
				get_tree().change_scene("res://res/EndScreen.tscn")
			$AnimatedSprite.play('eat')

	update_lights()
	update_echo()

func update_echo() -> void:
	$echo.scale = Vector2.ONE * MicInput.power

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation != 'default':
		$AnimatedSprite.play('default')
