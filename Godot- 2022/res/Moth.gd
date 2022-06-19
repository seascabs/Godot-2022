extends KinematicBody2D

enum {
	IDLE,
	WANDER
}

enum {
	NORTH = 0,
	SOUTH = 1,
	EAST = 2,
	WEST = 3
}

onready var ray = $RayCast2D

var velocity = Vector2.ZERO
var direction = 1
var countdown = 200
var wait = 0
var isLeftRight = 0

const countdownBase = 200
const waitBase = 40
const speed = 200
const randRange = 100

const MAX_PLAYER_DISTANCE = 900

onready var start_position = global_position
onready var target_position = global_position

func _physics_process(delta):
	if wait > 0:
		wait = wait - 1
		if(wait == 0):
			var num = randNum(0,3)
			direction = num
			countdown = countdownBase
	else:
		if countdown > 0:
			GetRandomMothVelocity()

			countdown = countdown - 1
			velocity = move_and_slide(velocity)
			CheckForWallCollision(velocity)

		else:
			wait = waitBase

	if PlayerService.player:
		ray.cast_to = PlayerService.player.global_position - global_position
		var collider = ray.get_collider()
		if collider and collider is Player and global_position.distance_to(PlayerService.player.global_position) < MAX_PLAYER_DISTANCE:
			var normal = ray.get_collision_normal()
			if abs(normal.x) > abs(normal.y):
				if normal.x < 0:
					direction = WEST
				else:
					direction = EAST
			else:
				if normal.y < 0:
					direction = SOUTH
				else:
					direction = NORTH


func randNum(from, to):
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var numRange = abs(to - from)
	var random_value = (random_generator.randi() % numRange) + from
	return random_value

func CheckForWallCollision(velocity):
	if(isLeftRight):
		if(velocity.x == 0):
			countdown = 0
	else:
		if(velocity.y == 0):
			countdown = 0

func GetRandomMothVelocity():
	match direction:
		NORTH:
			isLeftRight = 0
			velocity = Vector2(0, speed)
			velocity.x = randNum(randRange * -1, randRange)
		SOUTH:
			isLeftRight = 0
			velocity = Vector2(0, -1 * speed)
			velocity.x = randNum(randRange * -1, randRange)
		EAST:
			isLeftRight = 1
			velocity = Vector2(speed, 0)
			velocity.y = randNum(randRange * -1, randRange)
		WEST:
			isLeftRight = 1
			velocity = Vector2(-1 * speed, 0)
			velocity.y = randNum(randRange * -1, randRange)
