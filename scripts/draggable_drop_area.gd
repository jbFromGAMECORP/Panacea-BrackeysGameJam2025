extends Control

@onready var current_scene = get_tree().current_scene
@onready var detection_area: Area2D = $"Draggable Detection"


func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals():
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area:Area2D):
	var node = area.get_parent()
	prints(node,"entered",self)
	if node is Draggable:
		var new_position = global_position + (size - node.size)/2.0
		node.enter_hover(self,new_position)

	
func _on_area_exited(area:Area2D):
	var node = area.get_parent()
	if node is Draggable:
		node.exit_hover()
