extends RigidBody2D

var swing_amplitude = 20.0
var swing_speed = 0.5
var downward_speed = 30.0

var min_rotation = 345
var max_rotation = 375
var clockwise = true

func _ready():
	return

func _process(delta):
	if (rotation_degrees < 0.5):
		rotation_degrees += 360
	print(position.y)
	if (position.y < 0):
		position.y += downward_speed * delta * 1.0
	elif (position.y < -300):
		position.y += downward_speed * delta * 2.0
	
	
	
	if clockwise && rotation_degrees < min_rotation:
		clockwise = false
	elif !clockwise && rotation_degrees > max_rotation:
		clockwise = true
	
	if clockwise:
		rotation_degrees -= 45 * delta * swing_speed
	else: 
		rotation_degrees += 45 * delta * swing_speed
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	
