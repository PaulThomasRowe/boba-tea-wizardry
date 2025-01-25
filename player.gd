extends Area2D

signal hit

var player_speed = 400
var rotation_speed = 7
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	# rotation of the player
	var rotation_direction = Input.get_axis("move_left", "move_right")
	rotation += rotation_direction * rotation_speed * delta
	
	# forward motion of the player
	var player_direction = Input.get_axis("move_down", "move_up")
	velocity = player_direction * player_speed * transform.y

	# This is probably the code for the player animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * player_speed
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


func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)
