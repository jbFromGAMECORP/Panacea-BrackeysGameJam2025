extends Button

var open_texture = preload("res://scenes/UI/Inventory/Assets/suitcase_icon_open.png")
var closed_texture = preload("res://scenes/UI/Inventory/Assets/suitcase_icon_closed_cropped.PNG")
@onready var inventory_container: TextureRect = $"../InventoryContainer_pages"

var suitcaseState = "closed"

func _on_pressed() -> void:
	if suitcaseState != "open":
		set_button_icon(open_texture)
		suitcaseState = "open"
	else:
		print("CloseThisGuy")
		set_button_icon(closed_texture)
		suitcaseState = "closed"


func connect_to_inventory_exit(detect_area) -> void:
	var error = detect_area.area_exited.connect(close_inventory)
	assert(error == OK,"print Failed!")


func close_inventory(area):
	var node = area.get_parent()
	if node is Draggable:
		if suitcaseState == "open" and node.criteria() and not inventory_container.tween.is_running():
			inventory_container._on_suitcase_button_pressed()
	
		
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("MOUSE")
	var node = area.get_parent()
	if node.has_method("dummy"): node=node.follow_node
	if node is Draggable:
		if node.criteria() and suitcaseState == "closed" and not inventory_container.tween.is_running():
			pressed.emit() # Replace with function body.
