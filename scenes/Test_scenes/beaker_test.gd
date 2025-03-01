extends Node2D

## Color Mixing MiniGame ##
## The player will have 3 colored vials each with a psuedo chemical name.
## They willa main beaker with white or transparent liquid which they can mix the 3 colors in.
## They will have a notepad with a picture a beaker with the goal color.
## They will have to add/mix different colors until they reach the goal color


@onready var additive_colors: Control = $"Additive Colors"
@onready var main_beaker: ColorRect = $"Main Beaker"
@onready var goal_beaker: ColorRect = $"GOAL BEAKER"
@onready var beaker_color: Label = $"Beaker Color"
@onready var goal_color: Label = $"Goal Color"
@onready var color_difference: Label = $"Color Difference"
const GOAL_DIFFERENCE = .17

var temp_color_store = Color.BLACK

var color_currently_pouring = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_new_color_request_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	beaker_color.text = "Beaker color:\n" + str(main_beaker.color)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				for color_node in additive_colors.get_children():
					if color_node.moused_over:
						color_node.pick_up()
			if event.is_released():
				for color_node in additive_colors.get_children():
					color_node.reset()
					
func _on_area_2d_area_entered(area: Area2D) -> void:
	var color_node = area.get_parent()
	color_currently_pouring = color_node.color_additive
	$Timer.start()


func _on_area_2d_area_exited(area: Area2D) -> void:
	color_currently_pouring = null
	$Timer.stop()


func _on_timer_timeout() -> void:
	if color_currently_pouring is Color:
		#var color:Color = color_currently_pouring.inverted().darkened(.98)
		#color.a = 0
		#main_beaker.color -= color
		var color = color_currently_pouring
		color.a = .03
		#main_beaker.color += color
		main_beaker.color = main_beaker.color.blend(color)
		#prints("adding",color)
		prints("new main beaker",main_beaker.color) # Replace with function body.
		
	var diff = 0
	diff += abs(main_beaker.color.b - goal_beaker.color.b)
	diff += abs(main_beaker.color.g - goal_beaker.color.g)
	diff += abs(main_beaker.color.r - goal_beaker.color.r)
	color_difference.text = "Color Difference:\n" +str(diff)
	if diff < GOAL_DIFFERENCE:
		$"Success?".text = "✅"
	else:
		$"Success?".text = "❌"


func _on_empty_beaker_pressed() -> void:
	main_beaker.color = Color.WHITE # Replace with function body.
	

func _on_new_color_request_pressed() -> void:
	var random_colour := Color(randf(),randf(),randf(),).clamp(Color(0, 0, 0, 0),  Color(.60, .60, .60, 1))
	goal_beaker.color = random_colour
	goal_color.text = "Goal color:\n" + str(random_colour) # Replace with function body.
	_on_timer_timeout()
