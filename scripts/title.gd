extends Control
@onready var rich_text_label: RichTextLabel = $UIManager/RichTextLabel
@onready var panacea_logo: TextureRect = $PanaceaLogo
@onready var button_container: MarginContainer = $"UIManager/Button Container"

func _ready():
	
	initialize_child_transparency()
	await get_tree().create_timer(.45).timeout
	fade_elements_in()

func fade_elements_in():
	rich_text_label.start_letters_tween()
	start_logo_tween()
	start_button_tween()
	
func initialize_child_transparency():
	panacea_logo.modulate = Color.TRANSPARENT
	button_container.modulate = Color.TRANSPARENT
	
func start_logo_tween():
	var tween = create_tween()
	tween.tween_property(panacea_logo,"modulate",Color.WHITE,1.2).set_ease(Tween.EASE_OUT)
	return tween.finished
	
func start_button_tween():
	var tween = create_tween()
	tween.tween_property(button_container,"modulate",Color.WHITE,1.2).set_ease(Tween.EASE_OUT)
	return tween.finished
