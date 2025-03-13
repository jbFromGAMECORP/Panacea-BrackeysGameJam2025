extends Draggable # <-- Ctrl-click me to go to Draggable.gd


@export var color : Color
@onready var color_box: ColorRect = $Color_box

var persistent_properties_append = ["color"]

# Doing _ready() here overwrites draggable's _ready() function, so we call super() to run Draggable's _ready function too.
func _ready() -> void:
	color_box.color = color					# Sets color rect to color chosen in editor
	super() 								# or super()._ready()

#Because we don't overwrite _process, it is run by draggable and so we don't have to call super()
#func _process(delta: float) -> void:
#	pass

func assign_color(new_color :Color):
	color = new_color
	color_box.color = color

func is_correct_spot():
	if drop_area_hover:
		return drop_area_hover.color == color
	return false
