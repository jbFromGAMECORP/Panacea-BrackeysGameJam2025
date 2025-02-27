class_name save_load
extends Control

@onready var player = $"."
@onready var save_button = $Save
@onready var load_button = $Load

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

func _on_save_pressed() -> void:
	save_game()

func _on_load_pressed() -> void:
	load_game()

static func save_game():
	pass
static func load_game():
	pass
