extends RigidBody2D

var swing_amplitude = 20.0
var swing_speed = 2.0
var downward_speed = 20.0

var angle_offset = 0.0

func _ready():
	return

func _process(delta):
	position.y += downward_speed * delta
	rotation_degrees += 45 * delta

#func _start_swing():
	#var tween = create_tween()
	#tween.interpolate_property(
		#self, "rotation_degrees", 
		#-swing_amplitude, swing_amplitude, 
		#swing_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT, -1
	#)
	#tween.start()
	#return
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	#_start_swing()
