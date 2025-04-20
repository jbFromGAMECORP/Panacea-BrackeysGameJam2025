extends Node2D
@export var inventory_manager:InventoryManager
@onready var scene_name = name
@onready var load: Button = $Load
@onready var save: Button = $Save
@onready var draggable_zone: Control = $"Draggable Zone"
@onready var drag_zone_2: Control = $DragZone2
@onready var area: Area2D = $"DragZone2/Control/Draggable Detection"

var held_object : Node

var exit_scene_and_return = func():
		print("SIGNAL FIRED")
		await Transition.get_tree().create_timer(1).timeout
		Transition.change_scene("res://scenes/Test_scenes/Draggable.tscn")
		

func _ready() -> void:
	assert(inventory_manager, "Scene root does not have an Inventory Manager selected in editor for exported variable.")
	_on_load_pressed()
	_plot_to_points(_generate_points())
	_connect_puzzle_signals()
	_set_puzzle_colors()
	await get_tree().create_timer(.5).timeout
	prints("Persistent Objects:")
	for each in get_tree().get_nodes_in_group("Persistent"):
		print("\t",each)


func _on_change_level_pressed() -> void:
	_on_save_pressed()
	Transition.change_scene("res://scenes/ExplorationAreas/patientArea1.tscn")
	Transition.transition_completed.connect(exit_scene_and_return,CONNECT_ONE_SHOT)


func _on_save_pressed() -> void:
	return
	#var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	#print(persistent_nodes)
	#Persistence.save_scene(scene_name,persistent_nodes)


func _on_load_pressed() -> void:
	return
	#var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	#Persistence.load_scene(scene_name,persistent_nodes)


func _on_goto_test_area() -> void:
	Transition.change_scene("res://scenes/Test_scenes/Scene_Builder_Test.tscn") # Replace with function body.

func _connect_puzzle_signals():
	for node in drag_zone_2.get_children():
		node.detection_area.area_entered.connect(check_puzzle)
		node.detection_area.area_exited.connect(check_puzzle)

func check_puzzle(node):
	var solved : bool= draggable_zone.get_children().slice(1).all(func(x):return x.is_correct_spot())
	if solved:
		print("solved!!")
		$Label.text = "✅"
	else:
		$Label.text = "❌"
		
func _set_puzzle_colors():
	var zones = drag_zone_2.get_children()
	var pairs :Array = draggable_zone.get_children()
	pairs.pop_front()
	pairs.shuffle()

	var color = Color(1.0, 0.017, 0.0)
	color.h += randf()
	for i in len(pairs):
		pairs[i].assign_color(color)
		zones[i].get_child(1).color = color
		color.h = fmod(color.h+0.03,1.0)
	
func _generate_points():
	const x_count :float = 3.0
	const y_count :float = 4.0
	var x_spacing = draggable_zone.size.x / x_count
	var y_spacing = draggable_zone.size.y / y_count
	var grid = []
	var offset = $"Draggable Zone/Color1/Color_box".size/2
	for y in 4:
		for x in 3:
			grid.append(Vector2(x*x_spacing,y*y_spacing) + offset)
		print(grid.slice(-3))
	return grid

func _plot_to_points(points: Array):
	print(typeof(points))
	points.shuffle()
	var original = draggable_zone.get_child(1)
	var original2 = drag_zone_2.get_child(0)
	original.position = points.pop_back()
	while points:
		var new_node = original.duplicate()
		draggable_zone.add_child(new_node)
		new_node.position = points.pop_back()
		var new_area = original2.duplicate()
		drag_zone_2.add_child(new_area)
		
		
	
