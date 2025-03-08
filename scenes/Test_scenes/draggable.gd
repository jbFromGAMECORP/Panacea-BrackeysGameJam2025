class_name Draggable 
extends Control

## This is the base class for all objects that will be draggable through the mouse. 
## Use 'extends Draggable' at the top of the script to add this to new objects.
## This should be extended onto a basic control node.
## Be sure to include super() in the inheriting script if you overwrite the _ready or _process function

# This searches for the first button under the node. You must include a button as a child to register clicks.
@onready var button: TextureButton = find_children("*","BaseButton").front() 

# Stores a rectangle representing the edges of the game window.
@onready var viewport_limits :Rect2= get_viewport().get_visible_rect()
var mouse_offset:Vector2										# How far from the top left corner your mouse is when dragging.
enum RETURN_TYPE{NO_RETURN, 									# Leave object where released
				POSITION,										# Return to original position
				PARENT_AREA_RANDOM,								# Return to random position inside parent's control area.
				PARENT_AREA_CLOSEST} 							# Return to closest position inside parent's control area.
@export var return_type:RETURN_TYPE = RETURN_TYPE.POSITION		# Select the type of return to position for draggable
@onready var original_position : Vector2 = global_position		# Used by 'POSITION' to know where to return to.
const fly_back_speed := 3000.0									# Pixels per second items will animate back to position

var persistent_properties = {"position":true,"rotation":true}				# Determine which properties are persisted.


func _ready() -> void:
	add_to_group("Persistent")
	button.button_down.connect(drag)
	button.button_up.connect(release)
	# We enable processing when dragging, disable when not.
	set_process(false)

# The object is dragged by updating position to the mouse every frame. Clamp limits the object to the game window.
func _process(delta: float) -> void:
	global_position = (get_global_mouse_position() + mouse_offset).clamp(viewport_limits.position,viewport_limits.end-size)
	
	
func drag():
	prints(name,"dragging start")
	mouse_offset = global_position - get_global_mouse_position()		# Stores where on the objects area you grabbed
	top_level = true 													# Assures the object will layer above all else.
	set_process(true)													# Enables dragging

	
func release():
	set_process(false)													# Disables dragging
	match return_type:													# Match looks for the branch that matches it's value.
		RETURN_TYPE.NO_RETURN:
			place_back(global_position)
		RETURN_TYPE.POSITION:
			place_back(original_position)
		RETURN_TYPE.PARENT_AREA_RANDOM:
			place_back(random_point_in_area())
		RETURN_TYPE.PARENT_AREA_CLOSEST:
			place_back(closest_point_in_area())


func random_point_in_area():
	var boundaries :Rect2 = get_parent().get_global_rect()						# Parent area is stored
	if boundaries.encloses(get_global_rect()):									# If already inside parent, just release.
		return global_position
	return Vector2(randf_range(boundaries.position.x, boundaries.end.x-size.x), # Generates random point inside the boundaries.
				   randf_range(boundaries.position.y, boundaries.end.y-size.y)) # We -size to margin to the object's bottom-right end.


func closest_point_in_area():
	var boundaries :Rect2 = get_parent().get_global_rect()
	return global_position.clamp(boundaries.position,boundaries.end-size) 		# clamp position to within boundaries

# Tween back to destination
func place_back(dest:Vector2):
	var time = dest.distance_to(global_position)/fly_back_speed
	var tween = create_tween()
	tween.tween_property(self,"global_position",dest,time).set_trans(Tween.TRANS_BACK)
	await tween.finished
	# Disabling top_level causes it to inherit the parents transforms again, moving it. So we store position and restore afterwards.
	var temp = global_position
	top_level = false
	global_position = temp

func get_persistent_properties():
	var the_dict = {}
	for prop in persistent_properties:
		var value = get(prop)
		if value != null:
			the_dict[prop] = get(prop)
	return the_dict
	
func set_persistent_properties(prop_dict:Dictionary):
	for prop in prop_dict:
		set(prop,prop_dict[prop])
