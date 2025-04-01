class_name DropArea
extends Control

@onready var current_scene = get_tree().current_scene
@onready var detection_area: Area2D = $"Draggable Detection"
@onready var sprite:CanvasItem = get_node("Color_box2")
@onready var area: Area2D = $"Draggable Detection"


var node_in_slot : Control
var color : Color




func _ready() -> void:
	node_in_slot = find_children("*","Draggable").get(0)
	print(node_in_slot)
	_connect_signals()
	
	
func _connect_signals():
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area:Area2D):
	if not node_in_slot:
		var node = area.get_parent()
		if node is Draggable:
			print("Entered %s" % name)
			var new_position :Vector2= global_position #+ (size-node.size)/2
			node.enter_hover(self,new_position)
			node_in_slot = node

	
func _on_area_exited(area:Area2D):
	if node_in_slot:
		var node = area.get_parent()
		if node == node_in_slot:
			print("Exited %s" % name)
			node.exit_hover()
			node_in_slot = null
		
func assign_color(new_color: Color):
	sprite.color = new_color
