extends TextureRect

@onready var scrollContainer : ScrollContainer = $ScrollContainer

func _on_left_arrow_button_pressed() -> void:
	var value = scrollContainer.get_h_scroll()
	scrollContainer.set_h_scroll(value - 130)


func _on_right_arrow_button_pressed() -> void:
	var value = scrollContainer.get_h_scroll()
	scrollContainer.set_h_scroll(value + 130)


func _on_suitcase_button_pressed() -> void:
	self.visible = !self.visible
