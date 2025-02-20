extends RichTextLabel

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var panacea_logo: TextureRect = $"../../PanaceaLogo"
var tween :Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panacea_logo.modulate = Color.TRANSPARENT
	visible_ratio = 0
	
	await get_tree().create_timer(.45).timeout
	start_letters_tween()
	start_logo_tween()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_letters_tween():
	var loops = get_total_character_count()
	tween = create_tween().set_loops(loops)
	tween.tween_callback(plant_letter)
	tween.tween_interval(.12)
	return tween.finished


func start_logo_tween():
	tween = create_tween()
	tween.tween_property(panacea_logo,"modulate",Color.WHITE,1.5).set_ease(Tween.EASE_OUT)
	return tween.finished
	
func plant_letter():
	$AudioStreamPlayer.play()
	visible_characters += 1
	
