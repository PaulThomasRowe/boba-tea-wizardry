extends Area2D

signal hit

# player movement variables
const player_base_speed = 400
const player_base_movement_modifier = 1
var player_movement_modifier = player_base_movement_modifier
var player_rotation_speed = 7

# player boosts variables
var player_immune = false
var player_immunity_time = 2
var player_speed_boost_modifier = 2
var player_speed_time = 2

# collision modifiers
var player_slowdown_modifier = 0.4

# TODO: Why is this here????
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# rotation of the player
	var rotation_direction = Input.get_axis("move_left", "move_right")
	rotation += rotation_direction * player_rotation_speed * delta * player_movement_modifier
	
	# forward motion of the player
	var player_direction = Input.get_axis("move_down", "move_up")
	velocity = player_direction * player_base_speed * transform.y * player_movement_modifier

	# test power up
	if Input.is_action_just_pressed("test_immunity"):
		if not player_immune:  # Prevent overlapping immunity
			grant_immunity()
	
	if Input.is_action_just_pressed("test_speed"):
		if not player_immune:  # Prevent overlapping immunity
			grant_speed_boost()

	# This is probably the code for the player animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * player_base_speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		rotation = PI if velocity.y > 0 else 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func grant_immunity():
	player_immune = true
	print("Immunity granted for " + str(player_immunity_time) + " seconds!")
	if player_base_movement_modifier >  player_movement_modifier:
		print("Immunity granted so restoring player movement!")
		player_movement_modifier = player_base_movement_modifier
	await get_tree().create_timer(player_immunity_time).timeout
	player_immune = false
	print("Immunity finished!")
	
func grant_speed_boost():
	player_movement_modifier = player_speed_boost_modifier * player_base_movement_modifier
	print("speed boost granted for " + str(player_speed_time) + " seconds!")
	await get_tree().create_timer(player_speed_time).timeout
	player_movement_modifier = player_base_movement_modifier
	print("speed boost finished!")

# This function determines what happens if the player collides with 
func _on_body_entered(_body):
	if not player_immune:
		print("Player speed reduced because of collision!")
		player_movement_modifier = player_slowdown_modifier * player_base_movement_modifier
	"""
	Old code that kills the player
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)
	"""
	
func _on_body_exited(_body):
	# Reset player movement back to normal
	if not player_immune:
		player_movement_modifier = player_base_movement_modifier
		print("Player speed restored because of exiting collision!")
