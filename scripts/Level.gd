extends Node2D
class_name Level

@export var inventory_manager:InventoryManager
@export var level_music:AudioStream

@onready var save_button: Button = $CanvasLayer/GUI/SaveButton
@onready var load_button: Button = $CanvasLayer/GUI/LoadButton
@onready var save_slot_picker: OptionButton = $CanvasLayer/GUI/SaveSlotPicker
@onready var load_slot_picker: OptionButton = $CanvasLayer/GUI/LoadSlotPicker


var save_nodes = []
var save_slot = "Slot 1"
var load_slot = "Slot 1"

func _ready() -> void:
	save_button.pressed.connect(_save_game)
	load_button.pressed.connect(_load_game)
	save_slot_picker.item_selected.connect(_set_save_slot)
	load_slot_picker.item_selected.connect(_set_load_slot)

func _set_save_slot(index: int):
	save_slot = save_slot_picker.get_item_text(index)

func _save_game():
	save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		JsonSaveManager.save(save_slot)

func _set_load_slot(index: int):
	load_slot = load_slot_picker.get_item_text(index)
	
func _load_game():
	for node in save_nodes:
		JsonSaveManager.load(load_slot)


func get_music():
	
	return level_music
