extends Node

## Dialogic helper is for storing things like string names of styles, timelines, and characters. 
## So we don't have to load them with strings everywhere. It will also be used for preloading all 
## the styles and timelines in a scene upon load.

## NOTE: I didn't just add this to the Dialogic Singleton incase it ever updates and erases any changes we make to it.

## Inner class named "STYLE", mostly just for grouping all used styles in to const variables for easy access. 

var current_char = null
# Example: "DH.STYLE.FLOAT_DIALOG"
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
class STYLE:
	const FLOAT_DIALOG = "customGameInfoStyle1"
	const BUBBLE = "testBubbleStyle"
	const SCIENTIST = "customScientistStyle1"
	const PATIENT = "customPatientStyle1"
	
func _ready() -> void:
	# preloads all styles
	# TODO: Make sure all styles are in one folder, so we can just parse the folder instead. see commented code below
	for style in styles:
		style.prepare()
		
	# preload all timelines
	for filename in DirAccess.get_files_at("res://Dialogic_Items/Timelines/"):
		if filename.ends_with("dtl"):
			Dialogic.preload_timeline(load("res://Dialogic_Items/Timelines/"+filename))
			
	#for filename in DirAccess.get_files_at("res://Dialogic_Items/Styles/"):
		#load("res://Dialogic_Items/Styles/"+filename).prepare()
	print(Dialogic.get_subsystem("Text").text_started.connect(speaker_changed)) 

## Simple helper that will find the textbox and pass the desired textbox position.
func set_position(layout,pos):
	var textbox = layout.get_node("VN_TextboxLayer")
	if textbox: textbox.set_goto_position(pos)
	else: printerr("Dialogic Helper | set_position(): Cannot find node 'VN_TextboxLayer', \
Make sure you called 'Dialogic.Styles.load_style(DH.STYLE.FLOAT_DIALOG)`.")

func speaker_changed(info):
	if not current_char: 
		print("Dialog Started!!")
	elif info["character"] != current_char:
		print("SPEAKER CHANGED!!\n",info)
	else: return
	current_char = info["character"]
	var portraits = Dialogic.get_subsystem("Portraits")
	portraits.animate_character(current_char, "Tada", .2,)
	#portraits.
	#animate_character(character: DialogicCharacter, animation_path: String, length: float, repeats := 1, is_reversed := false)
