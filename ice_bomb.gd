#Falling boba at random positions from the top of the cup

extends RigidBody2D

@export var min_fall_speed: float = 0.001
@export var max_fall_speed: float = 0.1
var left_boundary: float
var right_boundary: float
var explosion_timer: Timer

signal exploded(position)

func _ready():
	# Set random fall speed
	var fall_speed = randf_range(min_fall_speed, max_fall_speed)
	linear_velocity = Vector2(0, fall_speed)
	
	explosion_timer = Timer.new()
	explosion_timer.connect("timeout", Callable(self, "_on_explosion_timer_timeout"))
	add_child(explosion_timer)
	explosion_timer.start(2.0)

func _process(delta):
	# Check if the boba has reached the left or right boundary
	if position.x <= left_boundary:
		position.x = left_boundary
		linear_velocity.x = 0
	elif position.x >= right_boundary:
		position.x = right_boundary
		linear_velocity.x = 0
	
	# Remove the object when it's below the bottom of the screen
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()

func _integrate_forces(state):
	# Add a small random horizontal velocity for more interesting movement
	if state.linear_velocity.x == 0:
		state.linear_velocity.x = randf_range(-20, 20)

func set_boundaries(left: float, right: float):
	left_boundary = left
	right_boundary = right

func _on_explosion_timer_timeout():
	var flash_duration = 0.1
	var flash_count = 5
	
	for i in range(flash_count):
		modulate = Color(1, 0, 0)  # Change to red color
		await get_tree().create_timer(flash_duration).timeout
		modulate = Color(1, 1, 1)  # Change back to white (normal color)
		await get_tree().create_timer(flash_duration).timeout
	
	explode()

func explode():
	emit_signal("exploded", global_position)
	queue_free()
