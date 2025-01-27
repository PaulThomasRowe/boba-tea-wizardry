extends CanvasLayer

signal start_game

var tween: Tween

const NORMAL_COLOR = Color(0, 0, 0)
const WARNING_COLOR = Color(1, 0, 0)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout

func update_score(score):
	$ScoreLabel.text = str(score)
	if score <= 10:
		$ScoreLabel.add_theme_color_override("font_color", WARNING_COLOR)
	else:
		$ScoreLabel.add_theme_color_override("font_color", NORMAL_COLOR)
	
func update_milk_tea_level(percentage: float):
	if tween:
		tween.kill()  # Stop any ongoing tween
	tween = create_tween()
	tween.tween_method(set_milk_tea_level, $MilkTeaLevel.material.get_shader_parameter("fill_amount"), percentage, 0.5)

func set_milk_tea_level(value: float):
	$MilkTeaLevel.material.set_shader_parameter("fill_amount", value)
	
func hide_message():
	$MessageLabel.hide()

func update_straw():
	if tween:
		tween.kill()  # Stop any ongoing tween
	tween = create_tween()
	tween.tween_property($Straw, "anchor_top", 1, 0.5)  # 0.5 seconds duration

func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
