extends Node2D

const FADE_DURATION = 1.25
const NEXT_SCENE = preload("res://scenes/ExplorationAreas/patientArea1.tscn")
var song1 = preload("res://scenes/Test_scenes/assets/Chiptune Vol5 Don't Call Me Intensity 1.wav")
var song2 = preload("res://scenes/Test_scenes/assets/Chiptune Vol5 Don't Call Me Intensity 2.wav")
var song3 = preload("res://scenes/Test_scenes/assets/Chiptune Vol5 Don't Call Me Main.wav")
@onready var default_position := global_position
@onready var button_container: MarginContainer = $"Button Container"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
@onready var panels: Node2D = $ComicPanel/Panels
@onready var music: AudioStreamPlayer = $Music
@onready var music_2: AudioStreamPlayer = $Music2
@onready var music_queue = [music,music_2]
@onready var default_db = music.volume_db
var current_tween:= Tween.new() 
var current_panel:=0
const transition_type_data = []
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	panels.show()
	Dialogic.start("res://scenes/Test_scenes/cold_open_comic_test.dtl")
	Dialogic.signal_event.connect(DialogicSignal)
	Dialogic.text_signal.connect(DialogicSignal)
	_apply_anchor_settings()
	await get_tree().create_timer(2).timeout
	await set_fade_in(music,12)
	cycle_songs()

func _apply_anchor_settings():
	await get_tree().create_timer(.12).timeout
	var layout : DialogicLayoutBase = Dialogic.get_subsystem("Styles").get_layout_node()
	var textbox = layout.get_node("VN_TextboxLayer")
	textbox.position += Vector2(0,-450)

func cycle_songs():
	await get_tree().create_timer(3).timeout
	await change_music(song2)
	await get_tree().create_timer(4).timeout
	await change_music(song3)
	await get_tree().create_timer(4).timeout
	await change_music(song1,12)
	cycle_songs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func DialogicSignal(arg: String):
	if arg == "timeline_ended":
		current_tween = create_tween()
		current_tween.tween_property(canvas_modulate,"color",Color.BLACK,FADE_DURATION)
		current_tween.tween_callback(func(): get_tree().change_scene_to_packed(NEXT_SCENE))
	else:
		
		var args = arg.split(",")
		next_panel(int(args.get(0)),int(args.get(1)))
		
			
		
func next_panel(duration = 4,delay = 1):
	var panel = panels.get_child(current_panel)
	create_tween().tween_property(panel,"scale",Vector2(panel.scale.x,0),duration).set_delay(1)
	current_panel +=1

func change_music(song,fade_time=6):
	var current_player = music_queue[0]
	var next_player = music_queue[1]
	var pos = current_player.get_playback_position()
	next_player.stream = song
	set_fade_in(next_player,pos,fade_time)
	var finished = set_fade_out(current_player,fade_time)
	music_queue.append(music_queue.pop_front())
	await finished
	current_player.stop()
	print("FINISHED")
	
	

func set_fade_in(music_player:AudioStreamPlayer,pos = 0.0,fade_time=6):
	prints("Fading in:",music_player.name,"-",music_player.stream.resource_path)
	music_player.volume_linear = 0.001
	music_player.play(pos)
	return create_tween().tween_property(music_player,"volume_db",default_db,fade_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	
func set_fade_out(music_player:AudioStreamPlayer,fade_time):
	return create_tween().tween_property(music_player,"volume_linear",0.001,fade_time).set_delay(1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).finished

	
