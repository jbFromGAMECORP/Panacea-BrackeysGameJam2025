extends Node

signal scene_changed(old_scene: Node, new_scene: Node)
signal transition_started
signal transition_completed

var current_scene: Node = null
var is_transitioning: bool = false

# Cache for preloaded scenes
var _scene_cache: Dictionary = {}

# Configuration
@export_category("Transition Settings")
@export var enable_transitions: bool = true
@export var transition_duration: float = .75
@export var fade_color: Color = Color.BLACK

@export_category("Loading Screen")
@export var enable_loading_screen: bool = true
@export var min_load_time: float = .01  # Minimum time to show loading screen

# Internal nodes
var _transition_layer: CanvasLayer
var _fade_rect: ColorRect
var _loading_screen: Control

func _ready() -> void:
	#Set up transition layer
	_setup_transition_layer()
	
	#get scene
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	if current_scene is Level:
		load_level_music(current_scene.get_music())
	
func _setup_transition_layer() -> void:
	_transition_layer = CanvasLayer.new()
	_transition_layer.visible = false
	_transition_layer.layer = 100  # Ensure it's above other layers
	add_child(_transition_layer)
	
	# Setup fade rectangle
	_fade_rect = ColorRect.new()
	_fade_rect.color = fade_color
	_fade_rect.color.a = 0  # Start transparent
	_fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_transition_layer.add_child(_fade_rect)
	
	# Setup loading screen
	_setup_loading_screen()

func _setup_loading_screen() -> void:
	_loading_screen = Control.new()
	_loading_screen.visible = false
	_loading_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_transition_layer.add_child(_loading_screen)
	
	# Add loading indicator (you can customize this)
	var loading_label = Label.new()
	loading_label.text = "Loading..."
	loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loading_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	loading_label.set_anchors_preset(Control.PRESET_CENTER)
	_loading_screen.add_child(loading_label)

func change_scene(scene_path: StringName, transition: bool = true) -> void:
	if is_transitioning:
		push_warning("Scene transition already in progress")
		return
	
	load_level_music(get_audio_track(scene_path))
	
	is_transitioning = true
	if transition and enable_transitions:
		transition_started.emit()
		await _fade_out()
	
	var new_scene = await _load_scene(scene_path)
	if new_scene == null:
		is_transitioning = false
		push_error("Failed to load scene: " + scene_path)
		return

	# Store old scene reference for signal
	var old_scene = current_scene
	
	#if current_scene != get_tree().current_scene and get_tree().current_scene:
		#printerr("Transitioner and SceneTree had different current scenes. This is likely due to using get_tree().change_scene...(). Aligning Transitioner to SceneTree.")
		#current_scene = get_tree().current_scene
		
	# Remove current scene
	if current_scene != null:
		current_scene.free()

	# Add new scene
	current_scene = new_scene
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	# Emit signal
	scene_changed.emit(old_scene, new_scene)
	
	if transition and enable_transitions:
		await _fade_in()
		transition_completed.emit()
	
	is_transitioning = false

func _load_scene(scene_path: StringName) -> Node:
	if enable_loading_screen:
		_loading_screen.visible = true
	
	# Check cache first
	if scene_path in _scene_cache:
		var cached_scene = _scene_cache[scene_path]
		await _minimum_load_time()
		_loading_screen.visible = false
		return cached_scene.instantiate()
	
	# Load scene
	var scene_resource: PackedScene
	
	# Use ResourceLoader for better loading control
	if ResourceLoader.exists(scene_path):
		scene_resource = load(scene_path) as PackedScene
	else:
		# Start loading in background
		var status = ResourceLoader.load_threaded_request(scene_path)
		if status != OK:
			push_error("Failed to start loading scene: " + scene_path)
			return null
		
		# Wait for load completion
		while true:
			var load_status = ResourceLoader.load_threaded_get_status(scene_path)
			match load_status:
				ResourceLoader.THREAD_LOAD_LOADED:
					scene_resource = ResourceLoader.load_threaded_get(scene_path) as PackedScene
					break
				ResourceLoader.THREAD_LOAD_FAILED:
					push_error("Failed to load scene: " + scene_path)
					return null
				_:
					await get_tree().create_timer(0.1).timeout
	
	if scene_resource == null:
		push_error("Failed to load scene resource: " + scene_path)
		_loading_screen.visible = false
		return null
	
	# Cache the loaded resource
	_scene_cache[scene_path] = scene_resource
	
	await _minimum_load_time()
	_loading_screen.visible = false
	
	return scene_resource.instantiate()

func _minimum_load_time() -> void:
	if min_load_time > 0:
		await get_tree().create_timer(min_load_time).timeout

func _fade_out() -> void:
	_transition_layer.visible = true
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 1.0, transition_duration)
	await tween.finished

func _fade_in() -> void:
	var tween = create_tween()
	tween.tween_property(_fade_rect, "color:a", 0.0, transition_duration)
	await tween.finished
	_transition_layer.visible = false

func preload_scene(scene_path: StringName) -> void:
	if scene_path in _scene_cache:
		return
	
	var scene_resource = load(scene_path) as PackedScene
	if scene_resource != null:
		_scene_cache[scene_path] = scene_resource

func clear_cache() -> void:
	_scene_cache.clear()

func get_current_scene() -> Node:
	return current_scene
	
func load_level_music(next_song:AudioStream):
	if not next_song:
		push_error("No exported song set for Level node.")
		return -1
		
	# Skip if the song is already playing.
	if next_song == Music.get_current_song():
		return OK

	
	Music.change_music(next_song)
	
func get_audio_track(scene_path) -> AudioStream:
	preload_scene(scene_path)
	var state:SceneState = _scene_cache[scene_path].get_state()
	var property_list = state.get_node_property_count(0)
	
	for i in range(property_list):
		var prop = state.get_node_property_name(0, i)
		if prop == "music":
			return state.get_node_property_value(0, i)
	return null
