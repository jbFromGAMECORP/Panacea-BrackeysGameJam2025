class_name InventoryManager
extends Control

signal object_taken
signal object_placed
@export var inventory : Array[ItemResource]
var held_object : Draggable
var held_object_parent : Node


func _ready() -> void:
	create_items()
	
func connect_draggable_signals(_drag_started:Signal,_drag_released:Signal):
	_drag_started.connect(drag_started)
	_drag_released.connect(drag_released)
	
func drag_started(obj:Node):
	print("this is working")
	held_object = obj
	held_object_parent = obj.get_parent()
	#obj.reparent(drag_holder,false)
	
func drag_released(obj:Node):
	#obj.reparent(held_object_parent,false)
	held_object = null
	held_object_parent = null
	

func create_items():
	for item in inventory:
		if item:
			var item_object:Draggable = load("res://scenes/Test_scenes/Resoure_scens/item_base.tscn").instantiate()
			item_object.item = item
			$"Page Inventory/InventoryContainer_pages/Panel5/Draggable Area/DragArea".add_child(item_object)
