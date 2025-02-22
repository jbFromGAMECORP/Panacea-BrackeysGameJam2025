extends Node2D

const FADE_DURATION = 1.25
const NEXT_SCENE = preload("res://scenes/ExplorationAreas/patientArea1.tscn")
@onready var default_position := global_position
@onready var button_container: MarginContainer = $"Button Container"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
var current_tween:= Tween.new() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("res://Dialogic_Items/Timelines/coldOpenScene.dtl")
	Dialogic.signal_event.connect(DialogicSignal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func DialogicSignal(arg: String):
	if arg == "timeline_ended":
		current_tween = create_tween()
	current_tween.tween_property(canvas_modulate,"color",Color.BLACK,FADE_DURATION)
	current_tween.tween_callback(func(): get_tree().change_scene_to_packed(NEXT_SCENE))
		
		
