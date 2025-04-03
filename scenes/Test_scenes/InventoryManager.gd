class_name InventoryManager
extends Control

signal object_taken
signal object_placed
@export var player : PlayerResource
var held_object : Draggable
var held_object_parent : Node
@onready var drag_inventory: DragZone = $"Page Inventory/InventoryContainer_pages/Panel5/Drag_Inventory"


func _ready() -> void:
	create_items(player.inventory)
	spread_items()
	
	# Called from created draggables, they pass their signals in.
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
	

func create_items(inventory:Array[ItemResource]):
	const item_base = preload("res://scenes/Test_scenes/Resoure_scens/item_base.tscn")
	for item in inventory:
		if item:
			var item_object:Draggable = item_base.instantiate()
			item_object.item = item
			drag_inventory.add_child(item_object)

func spread_items():
	prints("drag inventory size:::",drag_inventory.size)

	arrange_items_to_points(drag_inventory)

func _generate_points(area,count) -> Array[Vector2]:
	var x_count :float = ceili(sqrt(count))
	var y_count :float = count/x_count
	var x_spacing = area.size.x / (x_count -1)
	var y_spacing = area.size.y / (y_count -1)
	var grid: Array[Vector2]= []
	for x in x_count:
		for y in y_count:
			grid.append(Vector2(x*x_spacing,y*y_spacing))
		print(grid.slice(-3))
	return grid

func arrange_items_to_points(area):
	var nodes = area.get_children().slice(1)
	var points :Array[Vector2]= _generate_points(area,len(nodes))
	#points.shuffle()
	
	for node in nodes:
		node.scale = Vector2.ONE * .25
		node.position = points.pop_front()
