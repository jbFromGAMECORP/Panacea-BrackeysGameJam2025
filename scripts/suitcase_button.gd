extends Button

var open_texture = preload("res://scenes/UI/Inventory/Assets/suitcase_icon_open.png")
var closed_texture = preload("res://scenes/UI/Inventory/Assets/suitcase_icon_closed_cropped.PNG")

var suitcaseState = "closed"

func _on_pressed() -> void:
	if suitcaseState != "open":
		set_button_icon(open_texture)
		suitcaseState = "open"
	else:
		print("CloseThisGuy")
		set_button_icon(closed_texture)
		suitcaseState = "closed"








func _on_area_2d_area_entered(area: Area2D) -> void:
	print("MOUSE")
	if area.get_parent() is Draggable and\
		suitcaseState == "closed":
			pressed.emit() # Replace with function body.
