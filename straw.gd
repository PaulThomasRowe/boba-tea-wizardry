extends RigidBody2D

var swing_amplitude = 20.0
var swing_speed = 2.0
var downward_speed = 20.0

var min_rotation = 110
var max_rotation = 160
var clockwise = false

func _ready():
	return

func _process(delta):
	position.y += downward_speed * delta
	if clockwise && rotation_degrees < min_rotation:
		clockwise = false
	elif !clockwise && rotation_degrees > max_rotation:
		clockwise = true
	
	if clockwise:
		rotation_degrees -= 45 * delta
	else: 
		rotation_degrees += 45 * delta
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
