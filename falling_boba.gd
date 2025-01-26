#Falling boba at random positions from the top of the cup

extends RigidBody2D

@export var min_fall_speed: float = .001
@export var max_fall_speed: float = .1

func _ready():
	# Set random fall speed
	var fall_speed = randf_range(min_fall_speed, max_fall_speed)
	linear_velocity = Vector2(0, fall_speed)

func _process(delta):
	# Remove the object when it's below the bottom of the screen
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()
