extends Node2D

@export var spawn_character = load("res://scenes/Main Character.tscn")
#@export var scale_factor = Vector2(1, 1)
@export var spawn_save_load = load("res://scenes/saver_loader.tscn")

func _ready() -> void:
	spawn_char()
	spawn_sav

func spawn_char():
	var char = spawn_character.instantiate()
	char.position = Vector2(-55,-5)
	#obj.get_node("Animation").scale = scale_factor
	add_child(char)
func spawn_sav():
	var sav = spawn_save_load.instantiate()
	sav.position = Vector2(0,0)
	add_child(sav)
