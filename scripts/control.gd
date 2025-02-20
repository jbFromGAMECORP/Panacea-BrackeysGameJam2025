extends Control

@onready var default_position := global_position
@onready var menu_hover_click: AudioStreamPlayer = $"Menu Hover Click"
@onready var button_container: MarginContainer = $"Button Container"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in button_container.get_children() as Array[Button]:
		button.button_sfx = menu_hover_click


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position().clamp(Vector2.ZERO,get_viewport_rect().end)
	var vector_offset = (mouse_position-default_position)*.015
	global_position = default_position - vector_offset 

func start_pressed():
	print("START BUTTON PRESSED") #TODO
	#start_game_menu() #TODO
	
func options_pressed():
	print("OPTIONS BUTTON PRESSED") 
	#open_options_menu() #TODO
	
func quit_pressed():
	get_tree().quit()
