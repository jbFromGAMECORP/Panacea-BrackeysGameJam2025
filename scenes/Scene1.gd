extends Node2D

@export var spawn_object = preload("res://scenes/Main Character.tscn")
#@export var scale_factor = Vector2(1, 1)

func _ready() -> void:
	spawn()

func spawn():
	var obj = spawn_object.instantiate()
	obj.position = Vector2(-55,-5)
	#obj.get_node("Animation").scale = scale_factor
	add_child(obj)
	
