extends Draggable # <-- Ctrl-click me to go to Draggable.gd



var puzzle_id: int
# Doing _ready() here overwrites draggable's _ready() function, so we call super() to run Draggable's _ready function too.
func _ready():
	super()
	sprite_pos = sprite.texture.get_size()/2

#Because we don't overwrite _process, it is run by draggable and so we don't have to call super()
#func _process(delta: float) -> void:
#	pass


func is_correct_spot():
	if drop_area_hover:
		return drop_area_hover.puzzle_id == puzzle_id
	return false
	
func set_shape_sprite(_texture):
	$Texture.texture = _texture
	pass

func set_id(id):
	puzzle_id = id
	
func release():
	get_tree().current_scene.held_object = null
	set_physics_process(false)													# Disables dragging
	if drop_area_hover:
		place_back(new_position-size/2)
		return
	match return_type:													# Match looks for the branch that matches it's value.
		RETURN_TYPE.NO_RETURN:
			place_back(global_position)
		RETURN_TYPE.POSITION:
			place_back(original_position)
		RETURN_TYPE.PARENT_AREA_RANDOM:
			place_back(random_point_in_area())
		RETURN_TYPE.PARENT_AREA_CLOSEST:
			place_back(closest_point_in_area())
