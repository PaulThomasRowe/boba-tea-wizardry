extends StaticBody2D

var swing_amplitude = 20.0
var swing_speed = 0.5
var downward_speed = 45.0

var max_rotation = 15
var clockwise = true

func _ready():
	return

func _process(delta):
	#if (fmod(rotation_degrees, 360) < 1):
	#	rotation_degrees += 360
	#print(position.y)
	
	if (position.y < -10):
		position.y += downward_speed * delta * 0.3
	elif (position.y < -200):
		position.y += downward_speed * delta * 0.5
	elif (position.y < -400):
		position.y += downward_speed * delta * 0.7
	elif (position.y < -500):
		position.y += downward_speed * delta * 0.9
	elif (position.y < -600):
		position.y += downward_speed * delta * 1.2
	
	if (abs(fmod(rotation_degrees, 360)) > max_rotation):
		clockwise = !clockwise
	
	if clockwise:
		rotation_degrees -= 45 * delta * swing_speed
	else: 
		rotation_degrees += 45 * delta * swing_speed
	
func start(pos):
	#position = pos
	#show()
	$CollisionShape2D.disabled = false
	#$AnimatedSprite2D.play()
	#var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	#$AnimatedSprite2D.animation = mob_types.pick_random()
	
