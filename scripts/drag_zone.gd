class_name DragZone

extends Control
enum RETURN_TYPE{NO_RETURN, 									# Leave object where released
				POSITION,										# Return to original position
				PARENT_AREA_RANDOM,								# Return to random position inside parent's control area.
				PARENT_AREA_CLOSEST, 							# Return to closest position inside parent's control area.
				TELEPORT}
@onready var detection_area: Area2D = $"Draggable Detection"
@export var return_type:RETURN_TYPE = RETURN_TYPE.TELEPORT
@export var multiple_nodes:bool = false

var color : Color
var detect : bool = true


func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			detection_area = child
	assert(detection_area,str(get_path()) + " requires an area2D")
		
		
	_connect_signals()
	
func _connect_signals():
	assert(detection_area.area_entered.connect(_on_area_entered) == OK,"BAD CONENCT")
	assert(detection_area.area_exited.connect(_on_area_exited)== OK,"BAD CONENCT")
	
func _on_area_entered(area:Area2D):
	var node = area.get_parent()
	var pos = get_canvas_transform()*global_position
	if node.has_method("dummy"): node=node.follow_node
	if node is Draggable and node.criteria() and _subclass_criteria(node):
		print(area.get_parent().name,"\tEntered\t",self)
		if multiple_nodes:
			node.enter_zone(self)
		elif not has_draggable_child() or is_draggable_child(node):
			node.enter_zone(self,pos)
		_subclass_enter_effects()

func _subclass_enter_effects(): # Overwrite in subclasses
	pass

func _on_area_exited(area:Area2D):
	var node = area.get_parent()
	if node.has_method("dummy"): node=node.follow_node
	if node is Draggable and node.criteria() and self == node.in_drag_zone and _subclass_criteria(node):
		print(area.get_parent().name,"\tLeft\t",self)
		node.exit_zone()
		_subclass_exit_effects()

func _subclass_exit_effects(): # Overwrite in subclasses
	pass
	
func _subclass_criteria(_node:Draggable): # Overwrite in subclasses
	return true

func has_draggable_child():
	return (get_child(-1) is Draggable)

func is_draggable_child(node):
	return get_child(-1) == node
