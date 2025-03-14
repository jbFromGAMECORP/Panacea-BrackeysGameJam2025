extends CharacterBody2D

var player_in_area = false
var is_chatting = false

#Change with dialogic timelines for Lundy
func _ready():
	Dialogic.preload_timeline(load("res://Dialogic_Items/Timelines/interactWithLundyTip.dtl"))
	preload("res://Dialogic_Items/Styles/textBubbleStyle.tres").prepare()
	randomize()
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta):
	if player_in_area:
		print_debug("Player is in area")
		if Input.is_action_just_pressed("e"):
			run_dialogue("drLundyTestDialogue")
			
func run_dialogue(dialogue_string):
	is_chatting = true
	Dialogic.start(dialogue_string)
	
func DialogicSignal(arg: String):
	if arg == "exit_rando":
		$Timer.stop()
		$Timer.wait_time = 1000
		is_chatting = false
		await get_tree().create_timer(30.0).timeout
		self.queue_free()
		
func _on_chat_detection_body_entered(body):
	print("Detected")
	if body.has_method("player"):
		player_in_area = true
	var layout = Dialogic.Styles.load_style("textBubbleStyle") # Use the name of the STYLE here
	layout.register_character(load("res://Dialogic_Items/Characters/drLundy.dch"), $".")
	Dialogic.start("interactWithLundyTip")

func _on_chat_detection_body_exited(body):
	print("Player left0")
	if body.has_method("player"):
		player_in_area = false
