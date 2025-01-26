extends Node

@export var mob_scene: PackedScene
var score
var milk_tea_level = 1.0  # 1.0 is full, 0.0 is empty

func _ready():
	$ScoreTimer.wait_time = 0.5  # Update every half second instead of every second

func game_over():
	pass
	#$ScoreTimer.stop()
	#$MobTimer.stop()
	#$HUD.show_game_over()
	#$Music.stop()
	#$DeathSound.play()

func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	milk_tea_level = 1.0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_milk_tea_level(milk_tea_level)
	$HUD.show_message("Get Ready")
	fade_music_in()

func fade_music_in() -> void:
	const fade_time = 2.0
	const default_music_db = -10.0

	$Music.volume_db = -90.0 # Mute the player
	$Music.play() # Start playing
	# Use tweens for transition:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Music, "volume_db", default_music_db, fade_time)

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress = randi()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	milk_tea_level -= 0.01  # Decrease by 1% each time 
	milk_tea_level = max(milk_tea_level, 0)  # Ensure it doesn't go below 0
	$HUD.update_milk_tea_level(milk_tea_level)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _process(delta):
	# TODO: implement game over in another PR
	if milk_tea_level <= 0:
		game_over()
