extends Area2D

signal hit

# player const movement variables
const player_base_speed = 400
const player_base_rotation_speed = 7
const player_base_movement_modifier = 1

# player const movement variable for status effects
const player_speed_boost_modifier = 2

# player boosts times
var player_immunity_time = 2
var player_speed_time = 2

# player status effects
var player_immune = false
var player_speed_boost = false
var player_slow = false

# collision modifiers
var player_slowdown_speed_modifier = 0.4
var player_slowdown_rotation_modifier = 0.4

var milk_tea_level: Control
var left_boundary: float
var right_boundary: float
var top_boundary: float
var bottom_boundary: float

func _ready():
	$Trail.show_behind_parent
	hide()

func _process(delta):
	# rotation of the player
	var rotation_direction = Input.get_axis("move_left", "move_right")
	rotation = calculate_rotation(rotation_direction, delta)
	
	# forward motion of the player
	var player_direction = Input.get_axis("move_down", "move_up")
	var velocity = calculate_speed(player_direction, delta)

	# test power up
	if Input.is_action_just_pressed("test_immunity"):
		if not player_immune:  # Prevent overlapping immunity
			grant_immunity()
	
	if Input.is_action_just_pressed("test_speed"):
		if not player_immune:  # Prevent overlapping immunity
			grant_speed_boost()

	# This is probably the code for the player animation
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Calculate new position
	var new_position = position + velocity * delta

	# Clamp the player's position within the boundaries
	new_position.x = clamp(new_position.x, left_boundary, right_boundary)
	new_position.y = clamp(new_position.y, top_boundary, bottom_boundary)

	# Update position
	position = new_position
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"default"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$Trail.visible = true
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"default"
		rotation = PI if velocity.y > 0 else 0
		$Trail.visible = true
	else:
		$Trail.visible = false

func calculate_rotation(rotation_direction, delta):
	var player_rotation_modifier = player_base_movement_modifier
	if player_speed_boost:
		player_rotation_modifier *= player_speed_boost_modifier
	if player_slow and not player_immune:
		player_rotation_modifier *= player_slowdown_rotation_modifier
	rotation += (rotation_direction * player_base_rotation_speed * delta) * player_rotation_modifier
	return rotation

func calculate_speed(player_direction, delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	var player_speed_modifier = player_base_movement_modifier
	if player_speed_boost:
		player_speed_modifier *= player_speed_boost_modifier
	if player_slow and not player_immune:
		player_speed_modifier *= player_slowdown_speed_modifier
	velocity = (player_direction * (player_base_speed * player_speed_modifier) * transform.y) 
	return velocity

func start(pos, mtl: ColorRect, left: float, right: float):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	milk_tea_level = mtl
	left_boundary = left
	right_boundary = right
	update_vertical_boundaries()

func update_vertical_boundaries():
	var fill_amount = milk_tea_level.material.get_shader_parameter("fill_amount")
	top_boundary = milk_tea_level.global_position.y + milk_tea_level.size.y * (1 - fill_amount)
	bottom_boundary = milk_tea_level.global_position.y + milk_tea_level.size.y

func grant_immunity():
	player_immune = true
	print("Immunity granted for " + str(player_immunity_time) + " seconds!")
	await get_tree().create_timer(player_immunity_time).timeout
	player_immune = false
	print("Immunity finished!")
	
func grant_speed_boost():
	player_speed_boost = true
	print("speed boost granted for " + str(player_speed_time) + " seconds!")
	await get_tree().create_timer(player_speed_time).timeout
	player_speed_boost = false
	print("speed boost finished!")

# This function determines what happens if the player collides with 
func _on_body_entered(_body):
	print(_body)
		# Reset player movement back to normal
	if _body.is_in_group("falling_boba"):
		print("Player speed reduced because of collision!")
		player_slow = true
	if _body.is_in_group("straw"):
		hide() # Player disappears after being hit.
		get_parent().game_over()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred(&"disabled", true)

func _on_body_exited(_body):
	# Reset player movement back to normal
	if _body.is_in_group("falling_boba"):
		player_slow = false
		print("Player speed restored because of exiting collision!")

func push_from_explosion(explosion_position):
	var direction = global_position - explosion_position
	var distance = direction.length()
	var throw_distance = 100  # Distance threshold for throwing the player
	var throw_strength = 500  # Strength of the throw
	var push_strength = 3000  # Normal push strength
	
	if distance < throw_distance:
		# Player is close enough to be thrown
		var throw_vector = direction.normalized() * throw_strength
		var throw_duration = 0.5  # Duration of the throw in seconds
		
		# Calculate the target position
		var target_position = position + throw_vector
		
		# Clamp the target position within boundaries
		target_position.x = clamp(target_position.x, left_boundary, right_boundary)
		# Assuming you have top and bottom boundaries as well
		target_position.y = clamp(target_position.y, top_boundary, bottom_boundary)
		
		# Use a Tween to animate the throw
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", target_position, throw_duration)
		
		# Optional: Add a slight rotation for effect
		tween.parallel().tween_property(self, "rotation", randf_range(-PI/4, PI/4), throw_duration)
		
		# Reset rotation after throw
		tween.tween_property(self, "rotation", 0, 0.2)
	else:
		# Normal push if not close enough
		var push_vector = direction.normalized() * (push_strength / (distance + 1))
		position += push_vector
		
		# Clamp position immediately for normal push
		position.x = clamp(position.x, left_boundary, right_boundary)
		position.y = clamp(position.y, top_boundary, bottom_boundary)
