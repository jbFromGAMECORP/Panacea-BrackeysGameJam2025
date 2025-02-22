extends TextureRect

@onready var scrollContainer : ScrollContainer = $"ScrollContainer" \
	if name == "InventoryContainer2" \
	else $SpriteMask/ScrollContainer

@onready var suitcase: Button = $"../SuitcaseButton2"\
	if name == "InventoryContainer2" \
	else  $"../SuitcaseButton"
	
@onready var timer: Timer = $"../ArrowHeldTimer"

enum {PRESS, HOLD}
const PRESS_INTERVAL = 0.35
const PRESS_VALUE = 119
const HOLD_INTERVAL = 0.01
const HOLD_VALUE = 3

var timer_window := PRESS # Determines monitors wether click is inside press or hold time frame.

enum {LEFT = -1, RIGHT = 1}
var arrow_held :int
@onready var _default_scale := scale
const MINIMIZED_SCALE := Vector2(0,.2)
const ANIMATION_SPEED = .18
var tween := Tween.new()

	
func _on_suitcase_button_pressed() -> void:
	
	var suitcase_is_openning = process_suitcase_state()
	if tween.is_valid():
		print("TWEEN STILL DAWG!")
		return
	var start_scale:Vector2
	var end_scale:Vector2
	if suitcase_is_openning:
		visible = true
		start_scale = MINIMIZED_SCALE
		end_scale = _default_scale 
	else:
		start_scale = _default_scale
		end_scale = MINIMIZED_SCALE
	tween = create_tween()
	tween.tween_property(self,"scale",end_scale,ANIMATION_SPEED).from(start_scale)
	prints("tweening from",start_scale,"to",end_scale)
	await tween.finished
	if not suitcase_is_openning:
		visible = false
		suitcase.set_button_icon(suitcase.closed_texture)

func process_suitcase_state() -> bool:
	if suitcase.suitcaseState != "open":
		suitcase.set_button_icon(suitcase.open_texture)
		suitcase.suitcaseState = "open"
		return true
	else:
		suitcase.suitcaseState = "closed"
		return false
	
		
func _on_left_arrow_button_pressed() -> void:
	arrow_pressed(LEFT)
func _on_right_arrow_button_pressed() -> void:
	arrow_pressed(RIGHT)
func _on_left_arrow_button_up() -> void:
	arrow_released(LEFT)
func _on_right_arrow_button_up() -> void:
	arrow_released(RIGHT)


func arrow_pressed(direction):
	arrow_held = direction
	timer.start(PRESS_INTERVAL)
	
	
func arrow_released(direction):
	if timer_window == PRESS:
		snap_box(PRESS_VALUE*direction)
	else:
		timer_window = PRESS
	timer.stop()
	
	
func _on_timer_timeout() -> void:
	if timer_window == PRESS:
		timer_window = HOLD
		timer.start(HOLD_INTERVAL)
		
	var direction = arrow_held
	if arrow_held:
		scroll_box(HOLD_VALUE*direction)

func snap_box(value):
	scrollContainer.scroll_horizontal = snapped(scrollContainer.scroll_horizontal+value,value)
	
func scroll_box(value):
	print(value)
	scrollContainer.scroll_horizontal += value
