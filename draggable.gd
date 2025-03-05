class_name Draggable
extends Control

enum RETURN_TYPE{STAY,POSITION,PARENT_AREA}
@export var return_on_release:RETURN_TYPE
@onready var button: TextureButton = find_children("*","TextureButton").front()
const fly_back_speed := 3000.0
enum STATE{IDLE,HOVER,DRAG}
var state = STATE.IDLE
var mouse_offset:Vector2
var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.mouse_entered.connect(entered)
	button.mouse_exited.connect(exited)
	button.button_down.connect(drag)
	button.button_up.connect(release)
	set_process(false)
	pass # Replace with function body.


func _process(delta: float) -> void:
	global_position = get_global_mouse_position() +mouse_offset
	
func entered():
	prints(name,"moused entered")
	match state:
		STATE.IDLE:
			state = STATE.HOVER
		STATE.HOVER:
			print("Error - Entered when already hovering?")
		STATE.DRAG:
			pass
	
func exited():
	prints(name,"moused exited")
	match state:
		STATE.IDLE:
			print("Error - Entered when already hovering?")
		STATE.HOVER:
			state = STATE.IDLE
		STATE.DRAG:
			pass
	
func drag():
	move_to_front()
	prints(name,"dragging start")
	mouse_offset = global_position - get_global_mouse_position()
	original_position = global_position
	top_level = true
	set_process(true)
	
func release():
	prints(name,"dragging stop")
	set_process(false)
	match return_on_release:
		RETURN_TYPE.POSITION:
			place_back(original_position)
		RETURN_TYPE.PARENT_AREA:
			place_back(random_point_in_area())
	#position = default_position

func random_point_in_area():
	var boundaries :Rect2 = get_parent().get_global_rect()
	if boundaries.encloses(get_global_rect()):
		return global_position
	return Vector2(randf_range(boundaries.position.x, boundaries.end.x-size.x),
					   randf_range(boundaries.position.y, boundaries.end.y-size.y))
					
func place_back(dest:Vector2):
	var time = dest.distance_to(global_position)/fly_back_speed
	var tween = create_tween()
	tween.tween_property(self,"global_position",dest,time).set_trans(Tween.TRANS_BACK)
	await tween.finished
	var temp = global_position
	top_level = false
	global_position = temp
