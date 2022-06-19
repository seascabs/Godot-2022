extends KinematicBody2D

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO
var points = 0

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.collider
		if "Moth" in body.name:
			points = points + 1
			body.queue_free()
			print(points)
