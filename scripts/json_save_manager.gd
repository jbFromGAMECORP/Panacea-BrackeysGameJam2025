extends Node2D

func save(save_slot : String) -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	print("Saving in slot ", save_slot)
	print(JSON.stringify(save_dict))
	
	return save_dict

func load(save_slot: String) -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	print("Loading slot ", save_slot)
	print(JSON.stringify(save_dict))
	return save_dict
