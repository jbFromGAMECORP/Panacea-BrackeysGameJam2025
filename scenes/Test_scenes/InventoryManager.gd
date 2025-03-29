class_name InventoryManager
extends Control

signal object_taken
signal object_placed
@onready var drag_holder: Control = $"Drag Holder"

var held_object : Draggable
var held_object_parent : Node

func connect_draggable_signals(_drag_started:Signal,_drag_released:Signal):
	_drag_started.connect(drag_started)
	_drag_released.connect(drag_released)
	
func drag_started(obj:Node):
	held_object = obj
	held_object_parent = obj.get_parent()
	#obj.reparent(drag_holder,false)
	
func drag_released(obj:Node):
	#obj.reparent(held_object_parent,false)
	held_object = null
	held_object_parent = null
	
	
