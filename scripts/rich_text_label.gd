extends RichTextLabel

@onready var letter_stamp_sfx: AudioStreamPlayer = $"Letter Stamp SFX"
var tween :Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0
	
func start_letters_tween():
	var loops = get_total_character_count()
	tween = create_tween().set_loops(loops)
	tween.tween_callback(plant_letter)
	tween.tween_interval(.12)
	return tween.finished
	
func plant_letter():
	letter_stamp_sfx.play()
	visible_characters += 1
	
