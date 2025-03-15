extends Control

@export var color_additive : Color
@onready var default_position = position
@onready var area: Area2D
@onready var OFF
@onready var sprite: TextureRect = $Sprite

var attached_to_mouse:= false
var moused_over:= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area = $Area
	area.mouse_entered.connect(entered)
	area.mouse_exited.connect(exited)
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - size/2
	
func entered():
	moused_over = true
	prints(name,"moused entered")
	
func exited():
	moused_over = false
	prints(name,"moused exited")
	
func pick_up():
	set_process(true)
func reset():
	set_process(false)
	position = default_position
	
