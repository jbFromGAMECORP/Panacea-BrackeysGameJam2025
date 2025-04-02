extends DragZone

@onready var current_scene = get_tree().current_scene
@onready var sprite: Sprite2D = $"Draggable Detection/Shape_box"

var puzzle_id :String


func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals():
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)


func  _subclass_enter_effects():
	sprite.self_modulate = Color(0.0, 0.0, 0.0, 0.8)

func _subclass_exit_effects():
	sprite.self_modulate = Color(0.0, 0.0, 0.0, 0.545)

func set_shape_sprite(_texture):
	sprite.texture = _texture
	pass

func set_id(id):
	puzzle_id = id
	
func _subclass_criteria(node:Node):
	return node.get("puzzle_id") and puzzle_id == node.puzzle_id
