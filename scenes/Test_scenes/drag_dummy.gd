extends Control


## This is the base class for all objects that will be draggable through the mouse. 
## Use 'extends Draggable' at the top of the script to add this to new objects.
## This should be extended onto a basic control node.
## Be sure to include super() in the inheriting script if you overwrite the _ready or _process function




# This searches for the first button under the node. You must include a button as a child to register clicks. 

@onready var area: Area2D = $"Draggable Detection"
var follow_node : Node = null
var manager : InventoryManager
var mouse_offset : Vector2 = Vector2(0,0)
# Stores a rectangle representing the edges of the game window.


func _ready() -> void:
	connect_to_local_manager()
	set_physics_process(false)

func connect_to_local_manager():
	manager = get_tree().current_scene.get("inventory_manager")
	if manager is InventoryManager:
		print("INV MANGER FOUND")
		manager.object_taken.connect(drag)
		manager.object_placed.connect(release)


# The object is dragged by updating position to the mouse every frame. Clamp limits the object to the game window.
func _physics_process(delta: float=0) -> void:
	global_position = (get_global_mouse_position() + mouse_offset)

func drag(obj:Draggable):
	follow_node = obj
	scale += Vector2(.3,.3)												# Small scale to help show it's 'picked up'
	mouse_offset = obj.mouse_offset
	set_physics_process(true)											# Enables dragging

func release(obj:Draggable):
	follow_node = null
	scale -= Vector2(.3,.3)												# Reset scale back down
	set_physics_process(false)											# Disables dragging
	global_position = Vector2.ONE * -1000
	
func dummy():
	pass
