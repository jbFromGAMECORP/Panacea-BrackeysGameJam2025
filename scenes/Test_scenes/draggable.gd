class_name Draggable 

extends Control

## This is the base class for all objects that will be draggable through the mouse. 
## Use 'extends Draggable' at the top of the script to add this to new objects.
## This should be extended onto a basic control node.
## Be sure to include super() in the inheriting script if you overwrite the _ready or _process function

signal drag_started(node)
signal drag_released(node)

@onready var area: Area2D = $"Draggable Detection"
@onready var parent : Node = get_parent()
var dummy : Node = null

# This searches for the first button under the node. You must include a button as a child to register clicks.
@onready var sprite = get_child(0)
@onready var sprite_offset = sprite.position
@onready var local_manager : Node  = connect_to_local_manager()

# Stores a rectangle representing the edges of the game window.
@onready var viewport_limits :Rect2= get_viewport().get_visible_rect()
@onready var original_position : Vector2 						# Used by 'POSITION' to know where to return to.
var mouse_offset:Vector2										# How far from the top left corner your mouse is when dragging.
const FLY_BACK_SPEED := 3000.0									# Pixels per second items will animate back to position
const RETURN_TYPE = DragZone.RETURN_TYPE
var persistent_properties = {"position":true,"rotation":true}	# Determine which properties are persisted.

var in_drag_zone = null											# Stores the currently hovered DragZone. Reparents to it upon release.

func _ready() -> void:
	#in_drag_zone = get_parent()
	add_to_group("Persistent")
	$ClickArea.gui_input.connect(parse_input_event)
	
	set_process_input(false) # We enable processing when dragging, disable when not.
	set_physics_process(false)

# TODO: Implement Draggable and Dragzone Handlers
func connect_to_local_manager():
	var manager = Transition.current_scene
	if manager is not InventoryManager:
		manager = manager.get("inventory_manager")
	if manager is InventoryManager:
		manager.connect_draggable_signals(drag_started,drag_released)
	return manager

# The object is dragged by updating position to the mouse every frame. Clamp limits the object to the game window.
func _physics_process(_delta: float=0) -> void:
	global_position = (get_global_mouse_position() + mouse_offset)#.clamp(viewport_limits.position,viewport_limits.end-size)
	
	

func parse_input_event(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				set_process_input(true)
				drag()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				print("released")
				set_process_input(false)
				release()


func drag():
	scale += Vector2(.3,.3)												# Small scale to help show it's 'picked up'
	original_position = position										# Stores where you picked it up from
	mouse_offset = global_position - get_global_mouse_position()		# Stores where on the objects area you grabbed
	reparent(local_manager)
	_physics_process()													# Start Dragging
	set_physics_process(true)											# Enables dragging
	drag_started.emit(self)												# This is picked up by the Dragzone Handler


func release():
	set_physics_process(false)											# Disables dragging
	drag_released.emit(self)											# This is picked up by the Dragzone Handler
	scale -= Vector2(.3,.3)												# Reset scale back down
	if in_drag_zone and in_drag_zone != parent:					
		change_drag_zone()
	else:
		reparent(parent)
	global_position = (get_global_mouse_position() + mouse_offset)
	if parent is not DragZone: return
	match parent.return_type:													# Match looks for the branch that matches it's value.
		RETURN_TYPE.NO_RETURN:
			pass
		RETURN_TYPE.POSITION:
			await place_back(get_parent().global_position)
		RETURN_TYPE.PARENT_AREA_RANDOM:
			await place_back(random_point_in_area())
		RETURN_TYPE.PARENT_AREA_CLOSEST:
			await place_back(closest_point_in_area())
		RETURN_TYPE.TELEPORT:
			position = original_position


		
	

func enter_zone(node,pos=null):
	if is_physics_processing():
		if in_drag_zone:
			if in_drag_zone.is_greater_than(node):
				return
		in_drag_zone = node
		
		if pos != null and node != parent:
			grab_sprite()


func grab_sprite():
	sprite.reparent(in_drag_zone,false)
	print("SPRITE BELONGS TO: ",sprite.get_parent())
	


func exit_zone():
	if is_physics_processing():
		await get_tree().physics_frame
		let_go_of_sprite()
		in_drag_zone = null
		
		var next_area = $"Draggable Detection".get_overlapping_areas()
		if dummy: next_area.append_array(dummy.area.get_overlapping_areas())
		next_area = next_area.get(0)
		
		if next_area:
			var drag_zone = next_area.get_parent() 
			if drag_zone is DragZone and drag_zone._subclass_criteria(self): 
				drag_zone._on_area_entered($"Draggable Detection")


func let_go_of_sprite():
	#sprite.top_level = false
	#sprite.position = sprite_offset
	sprite.reparent(self,false)
	print("SPRITE BELONGS TO: ",sprite.get_parent())
	
func random_point_in_area():
	var boundaries :Rect2 = parent.get_global_rect()						# Parent area is stored
	if boundaries.encloses(get_global_rect()):									# If already inside parent, just release.
		return global_position
	return Vector2(randf_range(boundaries.position.x, boundaries.end.x-size.x), # Generates random point inside the boundaries.
				   randf_range(boundaries.position.y, boundaries.end.y-size.y)) # We -size to margin to the object's bottom-right end.

func closest_point_in_area():
	var boundaries :Rect2 = parent.get_global_rect()
	return global_position.clamp(boundaries.position,boundaries.end-size) 		# clamp position to within boundaries


# Tween back to destination. Since we are top level we use global positions.
func place_back(global_dest:Vector2):
	var time = global_position.distance_to(global_dest)/FLY_BACK_SPEED
	await create_tween().tween_property(self,"global_position",global_dest,time).set_trans(Tween.TRANS_BACK).finished

	
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
		
## Overide this function to have requirement to enter a snap area
func _drop_area_criteria(_node):
	return true


	
func change_drag_zone():
	reparent(in_drag_zone)
	parent = in_drag_zone
	await get_tree().physics_frame
	let_go_of_sprite()
	var return_type = parent.return_type
	if  return_type == RETURN_TYPE.TELEPORT or \
		return_type == RETURN_TYPE.POSITION:
		position = Vector2.ZERO

func criteria():
	return is_physics_processing()
