extends Control
const FADE_DURATION = 1.25
const MOUSE_OFFSET_RATIO = .015
const NEXT_SCENE = preload("res://scenes/VisualNovelStuff/ColdOpen.tscn")
@onready var default_position := global_position
@onready var menu_hover_click: AudioStreamPlayer = $"Menu Hover Click"
@onready var button_container: MarginContainer = $"Button Container"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
var current_tween:= Tween.new() # Use to know when we are already transitioning.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in button_container.get_children() as Array[Button]:
		button.button_sfx = menu_hover_click


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset_menu_by_mouse()

# Visual effect that gives the title screen interactive float.
func offset_menu_by_mouse():
	var mouse_position = get_global_mouse_position().clamp(Vector2.ZERO,get_viewport_rect().end)
	var vector_offset = (mouse_position-default_position)*MOUSE_OFFSET_RATIO
	global_position = default_position - vector_offset


#NOTE: This is a simple version. Ultimately we'll need a Scene Handler Script (as an Autoload/Singlton) that this function will call to instead.
func start_pressed():
	if current_tween.is_valid():
		print("ALREADY TWEENING DAWG!")
		return
	print("START BUTTON PRESSED") #TODO
	current_tween = create_tween()
	current_tween.tween_property(canvas_modulate,"color",Color.BLACK,FADE_DURATION)
	current_tween.tween_callback(func(): get_tree().change_scene_to_packed(NEXT_SCENE))


# This will instantiate a window scene with a bunch of options to tweak.
func options_pressed():
	if current_tween.is_running():
		print("ALREADY TWEENING DAWG!")
		return
	print("OPTIONS BUTTON PRESSED")
	#open_options_menu() #TODO

func quit_pressed():
	if current_tween.is_running():
		print("ALREADY TWEENING DAWG!")
		return
	print("Exit Pressed")
	get_tree().quit()
