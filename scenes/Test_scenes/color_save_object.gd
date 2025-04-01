extends Control

var color_resource : Resource
const path = "user://color_resource.tres"

func _on_color_picker_button_color_changed(color: Color) -> void:
	print("Saving ", color)
	color_resource.color = color # Replace with function body.
	ResourceSaver.save(color_resource,path)
	
func _ready():
	if not ResourceLoader.exists(path):
		prints(path,"does not exist, creating.")
		color_resource = load("res://scenes/Test_scenes/Resources/save_resource_base.tres").duplicate()
		ResourceSaver.save(color_resource,path)
	else:
		prints(path," found, using.")
		color_resource = load(path)
	get_child(0).color = color_resource.color
	
