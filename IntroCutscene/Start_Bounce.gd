extends Sprite2D

var base_position = self.position.y
var move_up = false # if this is false it will begin moving down and true it will move up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_up_and_down()

# In the Sprite's script:
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(event.position)):
			get_parent().get_parent().advance_cutscene()

func move_up_and_down():
	while true:
		await get_tree().create_timer(0.05).timeout
		if move_up:
			self.position.y += 1
		else:
			self.position.y -= 1
		
		if (self.position.y > base_position + 10):
			move_up = false
		elif (self.position.y < base_position - 10):
			move_up = true
