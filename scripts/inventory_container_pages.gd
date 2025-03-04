extends TextureRect

@onready var dots_container: Control = $Dots
@onready var scrollContainer : ScrollContainer = $ScrollContainer
@onready var h_box_container: HBoxContainer = $ScrollContainer/HBoxContainer
@onready var suitcase: Button = $"../SuitcaseButton"

const ITEMS_PER_PAGE = 7 							# How many items fit on a single page
const SIZE_OF_ITEM = 119 							# Amount of pixels to scroll to each item.
const sizeofpage = SIZE_OF_ITEM*ITEMS_PER_PAGE 
@onready var _default_scale := scale
const MINIMIZED_SCALE := Vector2(0,.3)				# Target scale for disappearing into case
const ANIMATION_SPEED = .18 						# Base speed for Tweens.

var current_page = 0: 								# Current page being viewed
	set(value):
		current_page = clamp(value,0,max_page-1) 	# setter clamps to pages available.
var max_page := 1 									# How many pages it takes to fit current inventory amount
var tween := Tween.new() 							# Tween holder, new tweens can either wait or replace a already running tween

func _ready() -> void:
	hide()
	init_inventory()
	connect_signals_for_item_amount_change()
	print(max(0, $ScrollContainer/HBoxContainer.get_rect().size.x - scrollContainer.get_rect().size.x))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
			# If scrolling with mouse wheel, check position, and update page to match
			update_scroll_position()

func update_max_page(node:Node = null):
	var slot_count = h_box_container.get_child_count()
	max_page = ceilf(slot_count/7.0)
	var idx = 0
	for x in dots_container.get_children():
		x.visible = idx < max_page
		idx +=1
	for buttons in [dots_container,$LeftArrowButton,$RightArrowButton]:
		buttons.visible = max_page != 1
	update_page_indicators()
	
func update_scroll():
	if tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(scrollContainer,"scroll_horizontal",current_page*sizeofpage,ANIMATION_SPEED*2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func update_page_indicators():
	var dot = dots_container.get_child(current_page)
	dot.set_pressed(true)
	
	
func _on_suitcase_button_pressed() -> void:
	if tween.is_valid():
		tween.kill()
		
	var suitcase_is_openning = process_suitcase_state()
	var start_scale:Vector2
	var end_scale:Vector2
	if suitcase_is_openning:
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
		close_suitcase()

func close_suitcase():
	visible = false
	suitcase.set_button_icon(suitcase.closed_texture)
	init_inventory()
	
func open_suitcase():
	visible = true
	suitcase.set_button_icon(suitcase.open_texture)
	init_inventory()

func process_suitcase_state() -> bool:
	if suitcase.suitcaseState != "open":
		open_suitcase()
		suitcase.suitcaseState = "open"
		return true
	else:
		suitcase.suitcaseState = "closed"
		return false
		
func _on_left_arrow_button_pressed() -> void:
	current_page -= 1
	update_scroll()
	update_page_indicators()

func _on_right_arrow_button_pressed() -> void:
	current_page += 1
	update_scroll()
	update_page_indicators()

func _on_sub_pressed() -> void:
	print(max(0, $ScrollContainer/HBoxContainer.get_rect().size.x - scrollContainer.get_rect().size.x))
	if h_box_container.get_child_count()-1:
		h_box_container.get_child(-1).queue_free() # Replace with function body.


func _on_add_pressed() -> void:
	var node = h_box_container.get_child(0)
	if node:
		var new_node = node.duplicate()
		h_box_container.add_child(new_node)
		new_node.get_child(-1).text = str(h_box_container.get_child_count())
		
	pass # Replace with function body.

func init_inventory():
	current_page = 0
	update_max_page()
	
func connect_signals_for_item_amount_change():
	# Lambda with await for node to free before recounting items in inventory.
	h_box_container.child_exiting_tree.connect(func(node):await node.tree_exited; update_max_page()) 
	h_box_container.child_entered_tree.connect(update_max_page)

func update_scroll_position():
	const MARGIN_OF_ERROR = 20 # Helps to snap to next page if we are close enough
	# NOTE: We have to calculate max scroll position, Godot doesn't provide.
	var max_scroll_position :float = $ScrollContainer/HBoxContainer.size.x - scrollContainer.size.x
	var scroll_position = scrollContainer.scroll_horizontal+MARGIN_OF_ERROR
	# Set page to last page if we hit max scroll.
	if scroll_position < max_scroll_position:
		current_page = int(scroll_position/sizeofpage)
	else:
		current_page = max_page
	update_page_indicators()
