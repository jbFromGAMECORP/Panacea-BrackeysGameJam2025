extends Control
@onready var scene_name = name
@onready var load: Button = $Load
@onready var save: Button = $Save
var exit_scene_and_return = func():
		print("SIGNAL FIRED")
		await Transition.get_tree().create_timer(1).timeout
		Transition.change_scene("res://scenes/Test_scenes/Draggable.tscn")
		
func _ready() -> void:

	prints("Persistent Objects:",get_tree().get_nodes_in_group("Persistent"))
	_on_load_pressed()


func _on_change_level_pressed() -> void:
	_on_save_pressed()
	Transition.change_scene("res://scenes/ExplorationAreas/patientArea1.tscn")
	Transition.transition_completed.connect(exit_scene_and_return,CONNECT_ONE_SHOT)
	#var node = load("res://scenes/ExplorationAreas/patientArea1.tscn")
	#var root :Node = get_tree().root
	#root.child_entered_tree.connect(exit_scene_and_return,CONNECT_ONE_SHOT)
	#get_tree().change_scene_to_packed(node)
	


func _on_save_pressed() -> void:
	var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	print(persistent_nodes)
	Persistence.save_scene(scene_name,persistent_nodes)


func _on_load_pressed() -> void:
	var persistent_nodes = get_tree().get_nodes_in_group("Persistent")
	Persistence.load_scene(scene_name,persistent_nodes)
