extends Control

@onready var default_position := global_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(default_position)
	print(get_global_mouse_position())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position().clamp(Vector2.ZERO,get_viewport_rect().end)
	var vector_offset = (mouse_position-default_position)*.01
	global_position = default_position - vector_offset 
