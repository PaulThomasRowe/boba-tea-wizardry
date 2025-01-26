extends RigidBody2D

var swing_amplitude = 20.0
var swing_speed = 0.5
var downward_speed = 45.0

var min_rotation = 345
var max_rotation = 375
var clockwise = true

func _ready():
	return

func _process(delta):
	if (rotation_degrees < 0.5):
		rotation_degrees += 360
	print(position.y)
	if (position.y < -10):
		position.y += downward_speed * delta * 0.25
	if (position.y < -200):
		position.y += downward_speed * delta * 0.5
	elif (position.y < -400):
		position.y += downward_speed * delta * 0.8
	elif (position.y < -500):
		position.y += downward_speed * delta * 0.9
	elif (position.y < -600):
		position.y += downward_speed * delta * 1.0
	
	
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
	
