class_name InventoryManager
extends Control

signal object_taken
signal object_placed
@export var player : PlayerResource
var held_object : Draggable
var held_object_parent : Node
@onready var drag_inventory: DragZone = $"Page Inventory/InventoryContainer_pages/Panel5/Draggable Area/Drag_Inventory"


func _ready() -> void:
	create_items(player.inventory)
	#spread_items()
	
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
	for item in inventory:
		if item:
			var item_object:Draggable = load("res://scenes/Test_scenes/Resoure_scens/item_base.tscn").instantiate()
			item_object.item = item
			drag_inventory.add_child(item_object)

#func spread_items()
#_generate_points($".",Player.inventory)

#func _generate_points(area,items):
	#var count = len(items)
	#const x_count :float = 3.0
	#const y_count :float = 4.0
	#var x_spacing = area.size.x / x_count
	#var y_spacing = area.size.y / y_count
	#var grid = []
	#var offset = $"Draggable Zone/Color1/Color_box".size/2
	#for y in 4:
		#for x in 3:
			#grid.append(Vector2(x*x_spacing,y*y_spacing) + offset)
		#print(grid.slice(-3))
	#return grid
#
#func _plot_to_points(points: Array):
	#print(typeof(points))
	#points.shuffle()
	#var original = draggable_zone.get_child(1)
	#var original2 = drag_zone_2.get_child(0)
	#original.position = points.pop_back()
	#while points:
		#var new_node = original.duplicate()
		#draggable_zone.add_child(new_node)
		#new_node.position = points.pop_back()
		#var new_area = original2.duplicate()
		#drag_zone_2.add_child(new_area)
