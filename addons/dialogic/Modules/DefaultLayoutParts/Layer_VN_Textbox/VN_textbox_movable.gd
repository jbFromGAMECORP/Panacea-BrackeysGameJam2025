extends "res://Dialogic_Items/Styles/VisualNovelTextbox/vn_textbox_layer.gd"

var goto_position

## Override function... super() runs original function from "vn_textbox_layer.gd" then runs our function.
func _ready() -> void:
	super()
	_apply_anchor_settings()

## Applies the position which should be have already been set from in-game script
func _apply_anchor_settings():
	if goto_position: $Anchor.position = goto_position
	else: printerr(name,": No position provided for textbox. Please use DH.set_position(layout,Vector2) before starting timeline")

## Called from in-game script to pass the character's global_position or a marker2D's position.
func set_goto_position(pos:Vector2):
	goto_position = pos
