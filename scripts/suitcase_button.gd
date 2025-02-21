extends Button

var open_texture = preload("res://assets/Inventory/sci-fiSuitcaseFacingRight_open_cropped.PNG")
var closed_texture = preload("res://assets/Inventory/sci-fiSuitcase_closed_cropped.PNG")

var suitcaseState = ""

func _on_pressed() -> void:
	if suitcaseState != "open":
		set_button_icon(open_texture)
		suitcaseState = "open"
	else:
		print("CloseThisGuy")
		set_button_icon(closed_texture)
		suitcaseState = "closed"
