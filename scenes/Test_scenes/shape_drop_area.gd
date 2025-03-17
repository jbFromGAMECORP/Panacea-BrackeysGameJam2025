extends Control

@onready var current_scene = get_tree().current_scene
@onready var detection_area: Area2D = $"Draggable Detection"
@onready var sprite:CanvasItem = get_child(0)

var node_in_slot : Control
var puzzle_id :int


func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals():
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)
	
func _on_area_entered(area:Area2D):
	if not node_in_slot:
		var node = area.get_parent()
		if node is Draggable and _drop_area_criteria(node):
			var new_position = sprite.global_position
			node.enter_hover(self,new_position)
			node_in_slot = node
			sprite.self_modulate = Color(0.0, 0.0, 0.0, 0.8)

	
func _on_area_exited(area:Area2D):
	if node_in_slot:
		var node = area.get_parent()
		if node is Draggable and _drop_area_criteria(node):
			node.exit_hover()
			node_in_slot = null
			sprite.self_modulate = Color(0.0, 0.0, 0.0, 0.545)
		

func set_shape_sprite(_texture):
	sprite.texture = _texture
	pass

func set_id(id):
	puzzle_id = id
	
	
func _drop_area_criteria(node):
	return puzzle_id == node.puzzle_id
