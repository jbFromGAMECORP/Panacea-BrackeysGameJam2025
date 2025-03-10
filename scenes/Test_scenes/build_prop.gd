class_name BuildProp
extends Resource

enum CHOICE{RANDOM_CHOICE,RANDOM_BETWEEN}
@export_enum("Random Choice","Random Between") var behavior
@export_enum(
	"name",
	"----RENDER----",
	"visible",
	"modulate",
	"self_modulate",
	"show_behind_parent",
	"top_level",
	"clip_children",
	"light_mask",
	"visibility_layer",
	"z_index",
	"z_as_relative",
	"y_sort_enabled",
	"use_parent_material",
	"----TRANSFORM----",
	"position",
	"rotation",
	"rotation_degrees",
	"scale",
	"skew",
	"transform",
	"----SPRITE----",
	"texture",
	"centered",
	"offset",
	"flip_h",
	"flip_v",
	"region_enabled",
	"region_rect",
	"region_filter_clip_enabled") var property : String
@export var values : Array
