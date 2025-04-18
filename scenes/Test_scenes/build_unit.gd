@icon("res://assets/icons/builder.png")
class_name BuildUnit
extends Sprite2D
enum CHOICE{RANDOM_CHOICE,RANDOM_BETWEEN}

static var debug_lines:bool = false #Set to true to see lines in game
@export var random_visibility : bool
@export var random_frame : bool

@export_group("Random Modulate", "modulate_")
@export var modulate_enabled : bool
@export var modulate_type : CHOICE = CHOICE.RANDOM_BETWEEN
@export var modulate_points: PackedColorArray = [Color("White"),Color("Black")]

@export_group("Random Position","position_")
## Enable or disable random position based on points.\n\n Note: The Line2d should be a child of the Node.
@export var position_enabled : bool
## Choice: Picks 
@export var position_type : CHOICE = CHOICE.RANDOM_BETWEEN
## Line2D used to represent either a range between or selection among the points for random vector.
@export var position_points : Line2D 

@export_group("Random Rotation","rotation_")
@export var rotation_enabled : bool
@export var rotation_type : CHOICE = CHOICE.RANDOM_BETWEEN
@export var rotation_points_degrees : Array[float] = [-30.0,30.0]

@export_group("Random Scale", "scale_")
@export var scale_enabled : bool
@export var scale_type : CHOICE = CHOICE.RANDOM_BETWEEN
@export var scale_points : Array[float] = [.5,1.5]

static var seed : int
static var seed_float_x : float
static var seed_float_y : float


static func _static_init() -> void:
	choose_new_seed()

	
static func choose_new_seed():
	var temp = seed
	seed = randi()
	seed_float_x = randf()
	seed_float_y = randf()
	print("--------------------------------------------------------Choosing New Seeds: from %s to %s" % [str(temp),str(seed)])
	
func _ready() -> void:
	pass
	$"Random_Placement".visible = debug_lines
	build_props()


func build_props():
	if random_visibility:
		visible = seed % 2
		
	if random_frame:
		frame = (frame + seed) % hframes

	if modulate_enabled:
		if modulate_points:
			modulate.h = get_hue_per_seed(modulate_points,seed_float_x)
		else:
			push_error("Modulate")

	if position_enabled:
		if position_points:
			var new_xy := Vector2(get_value_per_seed(position_points.points,seed_float_x).x,
								  get_value_per_seed(position_points.points,seed_float_y).y)
			global_position = new_xy
		else:
			var line = find_children("*","Line2D")
			if line:
				position_points = line
				var new_xy := Vector2(get_value_per_seed(position_points.points,seed_float_x).x,
								  get_value_per_seed(position_points.points,seed_float_y).y)
				global_position = new_xy
			push_error("Position")
		
	if rotation_enabled:
		if rotation_points_degrees:
			var new_rotation:float = get_value_per_seed(rotation_points_degrees,seed_float_x)
			rotation_degrees = new_rotation
		else:
			push_error("Rotation")

	if scale_enabled:
		if scale_points:
			var new_scale:float = get_value_per_seed(scale_points,seed_float_y)
			scale *= new_scale
		else:
			push_error("Scale")


func get_value_per_seed(points,seed:float):
	#prints("--",points[0],points[-1])
	return lerp(points[0],points[-1],seed)
	
func get_hue_per_seed(points:Array[Color],seed:float):
	#print(points[0].h,points[-1].h)
	return lerp(points[0].h,points[-1].h,seed)

func push_error(prop:String):
	printerr("%s - Cannot Randomize %s, no points were provided" %[name,prop])
