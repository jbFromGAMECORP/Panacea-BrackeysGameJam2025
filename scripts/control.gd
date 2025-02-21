extends Control
const FADE_DURATION = 1.25
const MOUSE_OFFSET_RATIO = .015
const TEST_SCENE = preload("res://scenes/Test_Scene.tscn")
@onready var default_position := global_position
@onready var menu_hover_click: AudioStreamPlayer = $"Menu Hover Click"
@onready var button_container: MarginContainer = $"Button Container"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
var current_tween:= Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in button_container.get_children() as Array[Button]:
		button.button_sfx = menu_hover_click


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position().clamp(Vector2.ZERO,get_viewport_rect().end)
	var vector_offset = (mouse_position-default_position)*MOUSE_OFFSET_RATIO
	global_position = default_position - vector_offset

func start_pressed():
	if current_tween.is_valid():
		print("TWEENING DAWG!")
		return
	print("START BUTTON PRESSED") #TODO
	current_tween = create_tween()
	current_tween.tween_property(canvas_modulate,"color",Color.BLACK,FADE_DURATION)
	current_tween.tween_callback(func(): get_tree().change_scene_to_packed(TEST_SCENE))
	#start_game_menu() #TODO
	
func options_pressed():
	if current_tween.is_running():
		return
	print("OPTIONS BUTTON PRESSED") 
	#open_options_menu() #TODO
	
func quit_pressed():
	if current_tween.is_running():
		return
	get_tree().quit()
