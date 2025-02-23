class_name SaverLoader
extends Node

@onready var player = $"."

func save_game():
	var file = FileAccess.open("res://savegame.data", FileAccess.WRITE)
	file.store_var(player.global_position)
	file.store_var(GlobalSingleton.rock_health)
	file.close()

func load_game():
	var file = FileAccess.open("res://savegame.data", FileAccess.READ)
	player.global_position = file.get_var()
	GlobalSingleton.rock_health = file.get_var()
	file.close
