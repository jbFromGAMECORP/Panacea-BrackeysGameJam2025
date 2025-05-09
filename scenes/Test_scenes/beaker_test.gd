extends Node2D

## Color Mixing MiniGame ##
## The player will have 3 colored vials each with a psuedo chemical name.
## They willa main beaker with white or transparent liquid which they can mix the 3 colors in.
## They will have a notepad with a picture a beaker with the goal color.
## They will have to add/mix different colors until they reach the goal color


@onready var additive_colors: Control = $"Additive Colors"
@onready var main_beaker: Sprite2D = $"Main Beaker/Liquid"
@onready var goal_beaker: Sprite2D = $"Goal Beaker/Liquid"
@onready var beaker_color: Label = $"Beaker Color"
@onready var goal_color: Label = $"Goal Color"
@onready var color_difference: Label = $"Color Difference"
var goal_difference = .18

var temp_color_store = Color.BLACK

var color_currently_pouring = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_new_color_request_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	beaker_color.text = "Beaker color:\n" + format_color(main_beaker.modulate)

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
	var vial = area.get_parent()
	vial.sprite.rotation = 90
	color_currently_pouring = vial.color_additive
	$Timer.start()


func _on_area_2d_area_exited(area: Area2D) -> void:
	var vial = area.get_parent()
	color_currently_pouring = null
	vial.sprite.rotation = 0
	$Timer.stop()


func _on_timer_timeout() -> void:
	if color_currently_pouring is Color:
		#var color:Color = color_currently_pouring.inverted().darkened(.98)
		#color.a = 0
		#main_beaker.modulate -= color
		var color = color_currently_pouring
		color.a = .03
		#main_beaker.modulate += color
		main_beaker.modulate = main_beaker.modulate.blend(color)
		#prints("adding",color)
		prints("new main beaker",main_beaker.modulate) # Replace with function body.
		update_succes()


func update_succes():
	var diff = 0
	diff += abs(main_beaker.modulate.b - goal_beaker.modulate.b)
	diff += abs(main_beaker.modulate.g - goal_beaker.modulate.g)
	diff += abs(main_beaker.modulate.r - goal_beaker.modulate.r)
	color_difference.text = "Color\nDifference:\n" +str(snappedf(diff,.01))
	if diff < goal_difference:
		$"Success?".text = "✅"
		$"Success Button".show()
	else:
		$"Success?".text = "❌"
		$"Success Button".hide()


func _on_empty_beaker_pressed() -> void:
	main_beaker.modulate = Color.WHITE # Replace with function body.
	

func _on_new_color_request_pressed() -> void:
	var random_colour := Color(randf_range(0.3,.8),randf_range(0.3,.8),randf_range(0.3,.8))
	goal_beaker.modulate = random_colour
	goal_color.text = "Goal color:\n" + format_color(random_colour) # Replace with function body.
	_on_timer_timeout()

func format_color(color:Color):
	var r = "R:" + str(snappedf(color.r,.01))
	var g = "G:" + str(snappedf(color.g,.01))
	var b = "B:" + str(snappedf(color.b,.01))
	return "%s, %s, %s" % [r,g,b]
	

func _on_success_button_pressed() -> void:
	_on_new_color_request_pressed()
	_on_empty_beaker_pressed()
	update_succes()
