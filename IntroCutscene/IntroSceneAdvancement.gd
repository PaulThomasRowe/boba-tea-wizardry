extends Node2D

# Array of images (TextureRects) in the cutscene
var images = []
var current_image_index = 0

func _ready():
	# Gather all TextureRect nodes into the images array
	for child in get_children():
		if child is Sprite2D:
			images.append(child)
			child.visible = false  # Hide all images initially
			
	
	# Show the first image
	if images.size() > 0:
		images[0].visible = true

func _input(event):
	if event.is_action_pressed("start_game"):  # Default "Space" is mapped to "ui_accept"
		advance_cutscene()

func advance_cutscene():
	# Hide the current image
	if current_image_index < images.size():
		images[current_image_index].visible = false
	
	# Move to the next image
	current_image_index += 1
	
	# If there are more images, show the next one
	if current_image_index < images.size():
		print("advancing to image " + str(current_image_index) + " out of " + str(images.size()))
		images[current_image_index].visible = true
	else:
		# End of the cutscene, optionally do something
		print("Cutscene finished!")
		load_main_scene()

func load_main_scene():
	# Use SceneTree.change_scene() to switch scenes
	get_tree().change_scene_to_file("res://main.tscn") 
