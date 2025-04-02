class_name DragZone

extends Control
enum RETURN_TYPE{NO_RETURN, 									# Leave object where released
				POSITION,										# Return to original position
				PARENT_AREA_RANDOM,								# Return to random position inside parent's control area.
				PARENT_AREA_CLOSEST, 							# Return to closest position inside parent's control area.
				TELEPORT}
@onready var detection_area: Area2D = $"Draggable Detection"
@onready var sprite:CanvasItem = get_node("Color_box2")
@export var return_type:RETURN_TYPE = RETURN_TYPE.TELEPORT
@export var multiple_nodes:bool = false

var color : Color
var detect : bool = true


func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals():
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area:Area2D):
	var node = area.get_parent()
	if node is Draggable and node.detect:
		if multiple_nodes:
			node.enter_zone(self)
			print("ENTERED: ",name)
		elif get_child_count() == 1 or get_child(-1) == node:
			node.enter_zone(self,global_position)
			print("ENTERED: ",name)


func _on_area_exited(area:Area2D):
	var node = area.get_parent()
	if node is Draggable and node.detect:
		print("EXITED: ",name)
		node.exit_zone()

		
func assign_color(new_color: Color):
	sprite.color = new_color
