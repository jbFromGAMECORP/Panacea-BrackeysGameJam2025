class_name InventoryManager
extends Control

signal object_taken
signal object_placed
@export var player : PlayerResource
enum SPREAD_TYPE {RANDOM,DISTRIBUTE}
@export var spread_type :SPREAD_TYPE = 0
var held_object : Node
var held_object_parent : Node
@onready var drag_inventory: DragZone = %Drag_Inventory


func _ready() -> void:
	create_items(player.inventory)
	spread_items()
	pass
	
	# Called from created draggables, they pass their signals in.
func connect_draggable_signals(_drag_started:Signal,_drag_released:Signal):
	_drag_started.connect(drag_started)
	_drag_released.connect(drag_released)
	
func drag_started(obj:Node):
	print("this is working")
	held_object = obj
	held_object_parent = obj.get_parent()
	#obj.reparent(drag_holder,false)
	object_taken.emit(obj)
	
func drag_released(obj:Node):
	#obj.reparent(held_object_parent,false)
	held_object = null
	held_object_parent = null
	object_placed.emit(obj)
	

func create_items(inventory:Array[ItemResource]):
	const item_base = preload("res://scenes/Test_scenes/Resoure_scens/item_base.tscn")
	for item in inventory:
		if item:
			var item_object:Draggable = item_base.instantiate()
			item_object.item = item
			drag_inventory.add_child(item_object)

func spread_items():
	prints("drag inventory size:::",drag_inventory.size)
	match spread_type:
		SPREAD_TYPE.RANDOM:
			pass
		SPREAD_TYPE.DISTRIBUTE:
			pass
	arrange_items_to_points(drag_inventory)

func arrange_items_to_points(area):
	var nodes = area.get_children().slice(1)
	var points :Array= _generate_points(area,len(nodes))
	points.shuffle()
	points = points.map(_distribute_point)
	
	for node in nodes:
		node.position = points.pop_front()

func _generate_points(area,count) -> Array[Vector2]:
	var offset = 48
	var x_count :float = max(ceili(sqrt(count)),2)
	var y_count :float = max(count/x_count,2)
	var x_spacing =(area.size.x-offset*2) / (x_count-1.0)
	var y_spacing = (area.size.y-offset*2) / (y_count-1.0)
	var grid: Array[Vector2]= []
	for x in x_count:
		for y in y_count:
			grid.append(Vector2(x*x_spacing,y*y_spacing)+Vector2(offset,offset))
		print(grid.slice(-3))
	print("aaa",grid)
	return grid

func _distribute_point(point : Vector2):
	const distr = 100
	return (point + Vector2(randfn(0,distr),randfn(0,distr))).clamp(Vector2.ZERO,drag_inventory.size)
