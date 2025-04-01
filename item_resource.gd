extends Resource
class_name ItemResource

@export var item_name : StringName
@export var item_description : String
@export var texture : Texture2D
@export var type : ITEM_TYPE


enum ITEM_TYPE{INVENTORY, TASK}

static func _static_init() -> void:
	print("This is static class")

func _to_string() -> String:
	return item_name
	
#func _init(_item_name:StringName, 
	#_item_description : String,
	#_texture : Texture2D,
	#_type : ITEM_TYPE) -> void:
	#
	#item_name = _item_name
	#item_description = _item_description
	#texture = _texture
	#type = _type
	#print("This is instancing")
	#
#
#static func test_tool():
	#const save_dir = "res://scenes/Test_scenes/Resources/Item_Resources/"
	#var dir = DirAccess.open("res://assets/Inventory/Inventory_Items/")
	#print(dir)
	#var files := dir.get_files() #as Array[String]
	#for file in files:
		#if file.contains(".import"): continue
		#print(save_dir,file)
		#var new_item_resource :ItemResource = construct_resource(dir,file)
		#ResourceSaver.save(new_item_resource,save_dir+file.trim_suffix(".png")+".tres")
		#
#
#static func construct_resource(dir:DirAccess,file:String) -> ItemResource:
	#var texture = load(dir.get_current_dir() + "/" + file)
	#print(texture)
	#return ItemResource.new(file.trim_suffix(".png"),"IDK",texture,ItemResource.ITEM_TYPE.INVENTORY)
	
