extends CanvasLayer

signal start_game

var tween: Tween

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Boba\nWizard"
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_milk_tea_level(percentage: float):
	if tween:
		tween.kill()  # Stop any ongoing tween
	tween = create_tween()
	tween.tween_property($MilkTeaLevel, "anchor_top", 1 - percentage, 0.5)  # 0.5 seconds duration

func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
