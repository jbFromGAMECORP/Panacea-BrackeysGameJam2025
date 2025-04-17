extends Node

## Dialogic helper is for storing things like string names of styles, timelines, and characters. 
## So we don't have to load them with strings everywhere. It will also be used for preloading all 
## the styles and timelines in a scene upon load.
## NOTE: I didn't just add this to the Dialogic Singleton incase it ever updates and erases any changes we make to it.

var current_char = null


const styles :Array = [
	preload("res://Dialogic_Items/Styles/GameNarrationCustom1Style/customGameInfoStyle1.tres"),
	preload("res://Dialogic_Items/Styles/GameNarrationCustom1Style/customGameInfoStyle1.tres"),
	preload("res://Dialogic_Items/Styles/customPatientStyle1.tres"),
	preload("res://Dialogic_Items/Styles/customGameNattationStyle1.tres"),
	preload("res://Dialogic_Items/Styles/customPatientStyle1.tres"),
	preload("res://Dialogic_Items/Styles/customScientistStyle1.tres"),
	preload("res://Dialogic_Items/Styles/testCustomStyle.tres"),
	preload("res://Dialogic_Items/Styles/textBubbleStyle.tres"),
	]

@onready var portrait_system = Dialogic.get_subsystem("Portraits")
@onready var text_system = Dialogic.get_subsystem("Text")

## Inner class named "STYLE", mostly just for grouping all used styles in to const variables for easy access. 
class STYLE:
	const FLOAT_DIALOG = "customGameInfoStyle1"
	const BUBBLE = "testBubbleStyle"
	const SCIENTIST = "customScientistStyle1"
	const PATIENT = "customPatientStyle1"


# TODO: Make sure all styles are in one folder, so we can just parse the folder instead. see commented code below
func _ready() -> void:
	preload_styles()
	preload_timelines()
	connect_signals()


func preload_styles():
	for style in styles: style.prepare()


func preload_timelines():
	for filename in DirAccess.get_files_at("res://Dialogic_Items/Timelines/"):
		if filename.ends_with("dtl"):
			Dialogic.preload_timeline(load("res://Dialogic_Items/Timelines/"+filename))

 
func connect_signals():
	Dialogic.get_subsystem("Text").text_started.connect(speaker_changed)
	Dialogic.timeline_ended.connect(func():print("TIMELINE ENDED"))


## Simple helper that will find the textbox and pass the desired textbox position.
func set_position(layout,pos):
	print("SETTING POSITION")
	var textbox = layout.get_node("VN_TextboxLayer")
	if textbox: textbox.set_goto_position(pos)
	else: printerr("Dialogic Helper | set_position(): Cannot find node 'VN_TextboxLayer', \
Make sure you called 'Dialogic.Styles.load_style(DH.STYLE.FLOAT_DIALOG)`.")

# Used to animate or highlight the character speaking when it changes. Called by Dialgoic signal speaker_changed.
func speaker_changed(new_speaker):
	var new_character :DialogicCharacter = new_speaker["character"]
	if not current_char or new_character != current_char: 
		current_char = new_speaker["character"]
		portrait_system.animate_character(new_character, "Tada", .2,)
		get_namebox_side(new_character)
	
	
	#TODO: extend the scripts for scientist and patient and have them call this function instead.
func get_namebox_side(new_character):
	return # Comment to enable
	var portraits_info = portrait_system.get_character_info(new_character)
	if not portraits_info["joined"]: print("NO PORTRAIT");return
	print("NEW SPEAKER: ",current_char, " || Side: ",portrait_system.get_character_info(new_character)["position_id"])
	var char_position:String = portraits_info["position_id"]
	var namebox_side = 0.0 if char_position.contains("left") else 0.5 if char_position.contains("center") else 1.0
	var layout : DialogicLayoutBase = Dialogic.get_subsystem("Styles").get_layout_node()
	var textbox = layout.get_node("VN_TextboxLayer")
	if not textbox: print("NO TEXTBOX");return
	var name_label: PanelContainer = textbox.get_node("%NameLabelPanel")
	name_label.anchor_left = namebox_side
	name_label.anchor_right = namebox_side
	name_label.grow_horizontal = 1-int(namebox_side)
