extends Node

var scene_states = {
	"SceneName": {
		"ObjectName":{
			"Property1":Color("Red"),
			"Property2":Vector2(1,1)
			}
		}
	}
	

func save_scene(scene_name, persistent_objects) -> void:
	var scene_dict :Dictionary = scene_states.get_or_add(scene_name,Dictionary())
	prints("\nSaving:",scene_name)
	for object in persistent_objects:
		save_object(scene_dict,object)
	print("")


func load_scene(scene_name,persistent_objects) -> void:
	var scene_dict :Dictionary = scene_states.get(scene_name,Dictionary())
	prints("\nLoading:",scene_name)
	if scene_dict:
		for object in persistent_objects:
			load_object(scene_dict,object)
	else: print("No scene data, Nothing Loaded")
	print("")


func save_object(scene_dict, object:Node):
	if object.has_method("get_persistent_properties"):
		var prop_dict = object.get_persistent_properties()
		scene_dict[object.name] = prop_dict
		prints("--",object.name,prop_dict)
	else: prints("--Error: %s does not have method get_persistent_properties" % object.name)


func load_object(scene_dict,object:Node):
	if object.has_method("set_persistent_properties"):
		var prop_dict = scene_dict[object.name]
		object.set_persistent_properties(prop_dict)
		prints("--",object.name,prop_dict)
	else: prints("--Error: %s does not have method set_persistent_properties" % object.name)
