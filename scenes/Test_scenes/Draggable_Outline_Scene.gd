extends Control
@onready var scene_name = name
@onready var load: Button = $Load
@onready var save: Button = $Save
@onready var draggable_zone: Control = $"Draggable Zone"
@onready var drop_zone: Control = $DroppableZone
var held_object : Node
@onready var sprite_size = draggable_zone.get_child(-1).size
@export var cached: bool = false

var exit_scene_and_return = func():
		print("SIGNAL FIRED")
		await Transition.get_tree().create_timer(1).timeout
		Transition.change_scene("res://scenes/Test_scenes/my_scene.tscn")
		


func _ready() -> void:
	#if draggable_zone.get_child_count() > 1: return
	if cached : return
	prints("Persistent Objects:",get_tree().get_nodes_in_group("Persistent"))
	_on_load_pressed()
	var sprite_array = _get_sprite_filename_array()
	sprite_array.append_array(sprite_array)
	sprite_array.pop_back()
	print(sprite_array)
	_plot_to_points(_generate_points(len(sprite_array)))
	_connect_puzzle_signals()
	_set_puzzle_shapes(sprite_array)



func _on_change_level_pressed() -> void:
	_on_save_pressed()
	Transition.change_scene("res://scenes/ExplorationAreas/patientArea1.tscn")
	Transition.transition_completed.connect(exit_scene_and_return,CONNECT_ONE_SHOT)


func _on_save_pressed() -> void:
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save(packed_scene,"res://scenes/Test_scenes/my_scene.tscn")
	cached = true


func _on_load_pressed() -> void:
	pass

func _get_sprite_filename_array() -> Array[String]:
	var filename_array: Array[String]
	filename_array.assign(DirAccess.get_files_at("res://assets/Inventory/Inventory_Items/"))
	return filename_array.filter(func(x:String): return x.ends_with("png"))
	
func _on_goto_test_area() -> void:
	Transition.change_scene("res://scenes/Test_scenes/Scene_Builder_Test.tscn") # Replace with function body.

func _connect_puzzle_signals():
	for drop_area in drop_zone.get_children():
		var area: Area2D = drop_area.detection_area
		area.area_entered.connect(check_puzzle)
		area.area_exited.connect(check_puzzle)

func check_puzzle(node):
	var solved : bool= draggable_zone.get_children().all(func(x):return x is Draggable and x.is_correct_spot())
	if solved:
		print("solved!!")
		$Label.text = "✅"
	else:
		$Label.text = "❌"


func _generate_points(amount):
	print("amount",amount)
	var limits = draggable_zone
	const offset = Vector2(15,15)
	var x_max = mini(3,amount)
	var y_max = ceili(amount/3.0)
	var x_spacing = draggable_zone.size.x / (x_max)
	var y_spacing = draggable_zone.size.y / (y_max)
	var grid = []
	var debug_string :String
	for count in amount:
		var x = count % x_max
		var y = count / x_max
		var vector = (
			Vector2(x*x_spacing,y*y_spacing) + 
			Vector2(randfn(0,100),randfn(0,100)) + 
			offset)
		grid.append(vector.clamp(Vector2.ZERO,limits.size-sprite_size))
		if x == 2: print(grid.slice(-3))
	return grid


func _plot_to_points(points: Array):
	print(typeof(points))
	points.shuffle()
	var original = draggable_zone.get_child(-1)
	var original2 = drop_zone.get_child(0)
	original.position = points.pop_back()
	print("TESTTTTTTTTTT",draggable_zone.get_child(0).owner.name)
	var idx = 0
	while points:
		var new_node = original.duplicate()
		draggable_zone.add_child(new_node)
		new_node.name = "Draggable" + str(idx)
		recursive_owner(new_node)
		new_node.position = points.pop_back()
		var new_area = original2.duplicate()
		drop_zone.add_child(new_area)
		new_area.name = "DropZone" + str(idx)
		idx += 1
		recursive_owner(new_area)
	for node in draggable_zone.get_children():
		print(node.name)
	print(draggable_zone.name)
	
func _set_puzzle_shapes(texture_name_array):
	var droppables = drop_zone.get_children()
	var draggables :Array = draggable_zone.get_children()
	draggables.pop_front()
	draggables.shuffle()
	for i in len(draggables):
		var texture = _get_sprites(texture_name_array[i])
		for node in [draggables,droppables]:
			if node[i] is Area2D:continue
			node[i].set_shape_sprite(texture)
			node[i].set_id(texture_name_array[i])
			
	
	
func _get_sprites(texture_name):
	return load("res://assets/Inventory/Inventory_Items/"+texture_name)

func recursive_owner(new_node):
	new_node.set_owner(get_tree().current_scene)
	for child in new_node.get_children():
		recursive_owner(child)
	
