extends Control
@onready var scene_name = name
@onready var load: Button = $Load
@onready var save: Button = $Save
@onready var draggable_zone: Control = $"Draggable Zone"
@onready var drag_zone_2: Control = $DragZone2
var held_object : Node

var exit_scene_and_return = func():
		print("SIGNAL FIRED")
		await Transition.get_tree().create_timer(1).timeout
		Transition.change_scene("res://scenes/Test_scenes/Draggable.tscn")
		


func _ready() -> void:
	prints("Persistent Objects:",get_tree().get_nodes_in_group("Persistent"))
	_on_load_pressed()
	_plot_to_points(_generate_points())
	_connect_puzzle_signals()
	_set_puzzle_colors()


func _on_change_level_pressed() -> void:
	_on_save_pressed()
	Transition.change_scene("res://scenes/ExplorationAreas/patientArea1.tscn")
	Transition.transition_completed.connect(exit_scene_and_return,CONNECT_ONE_SHOT)


func _on_save_pressed() -> void:
	var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	print(persistent_nodes)
	Persistence.save_scene(scene_name,persistent_nodes)


func _on_load_pressed() -> void:
	var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	Persistence.load_scene(scene_name,persistent_nodes)


func _on_goto_test_area() -> void:
	Transition.change_scene("res://scenes/Test_scenes/Scene_Builder_Test.tscn") # Replace with function body.

func _connect_puzzle_signals():
	for drop_area in drag_zone_2.get_children():
		var area: Area2D = drop_area.get_child(0)
		area.area_entered.connect(check_puzzle)
		area.area_exited.connect(check_puzzle)

func check_puzzle(node):
	print("Checking!")
	var solved : bool= draggable_zone.get_children().all(func(x):return x.is_correct_spot())
	if solved:
		print("solved!!")
		$Label.text = "✅"
	else:
		$Label.text = "❌"
		
func _set_puzzle_colors():
	var zones = drag_zone_2.get_children()
	var pairs :Array = draggable_zone.get_children()
	pairs.shuffle()

	var color = Color(1.0, 0.017, 0.0)
	color.h += randf()
	for i in len(pairs):
		pairs[i].assign_color(color)
		zones[i].assign_color(color)
		color.h = fmod(color.h+0.03,1.0)
	
func _generate_points():
	const x_count = 3
	const y_count = 4
	var x_spacing = draggable_zone.size.x / (x_count+1)
	var y_spacing = draggable_zone.size.y / (y_count+1)
	var grid = []
	for y in 4:
		for x in 3:
			grid.append(Vector2(x*x_spacing,y*y_spacing))
		print(grid.slice(-3))
	return grid

func _plot_to_points(points: Array):
	print(typeof(points))
	points.shuffle()
	var original = draggable_zone.get_child(0)
	var original2 = drag_zone_2.get_child(0)
	original.position = points.pop_back()
	while points:
		var new_node = original.duplicate()
		draggable_zone.add_child(new_node)
		new_node.position = points.pop_back()
		var new_area = original2.duplicate()
		drag_zone_2.add_child(new_area)
		
		
	
