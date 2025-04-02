extends Draggable # <-- Ctrl-click me to go to Draggable.gd



var puzzle_id: String
# Doing _ready() here overwrites draggable's _ready() function, so we call super() to run Draggable's _ready function too.
func _ready():
	super()

#Because we don't overwrite _process, it is run by draggable and so we don't have to call super()
#func _process(delta: float) -> void:
#	pass


func is_correct_spot():
	if in_drag_zone:
		return in_drag_zone.puzzle_id == puzzle_id
	return false
	
func set_shape_sprite(_texture):
	$Texture.texture = _texture
	pass

func set_id(id):
	puzzle_id = id
	
