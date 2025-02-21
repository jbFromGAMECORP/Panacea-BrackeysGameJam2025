@tool

extends VBoxContainer

var my_class_name
var itempanel = preload("res://addons/inventory_slot_plugin/scenes/dock/item_panel.tscn")


func load_items() -> void:
	for child in get_children():
		child.queue_free()
	
	if InventoryFile.is_json(Inventory.ITEM_PANEL_PATH):
		for child in get_children():
			child.queue_free()
		
		var file = FileAccess.open(Inventory.ITEM_PANEL_PATH,FileAccess.READ)
		var all_class = JSON.parse_string(file.get_as_text())
		
		file.close()
		
		for _class in all_class:
			if _class == my_class_name:
				if all_class.get(_class) is float: continue
				
				for items in all_class.get(_class):
					var new_item = all_class.get(_class).get(items)
					
					var new_panel = itempanel.instantiate()
					
					add_child(new_panel)
					
					new_panel.start(items,new_item)


func _on_class_change_item() -> void:
	for child in get_children():
		child.queue_free()
	
	var file = FileAccess.open(Inventory.ITEM_PANEL_PATH,FileAccess.READ)
	var all_class = JSON.parse_string(file.get_as_text())
	
	file.close()
	
	for _class in all_class:
		if _class == my_class_name:
			for items in all_class.get(_class):
				var new_item = all_class.get(_class).get(items)
				
				var new_panel = itempanel.instantiate()
				
				add_child(new_panel)
				
				new_panel.start(items, new_item)
