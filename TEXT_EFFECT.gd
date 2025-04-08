@tool
extends RichTextEffect
class_name RichTextGhost

# Syntax: [ghost freq=5.0 span=10.0][/ghost]

# Define the tag name.
var bbcode = "ghost"

func _process_custom_fx(char_fx:CharFXTransform):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("freq", 100.0)
	var hold_time = char_fx.env.get("span", 200.0)

	var duration = char_fx.elapsed_time*speed-char_fx.relative_index
	if duration > 1 and duration < hold_time:
		char_fx.color.a = duration*.01
	elif duration > hold_time:
		char_fx.color.a = (hold_time*2 - duration)*.01
	else:
		char_fx.color.a = 0
		
	return true
