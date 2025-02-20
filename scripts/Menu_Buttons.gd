extends Button
var button_sfx: AudioStreamPlayer
const HOVER_VOL := -18.0
const CLICK_VOL := -12.0

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_button_click)
	
func _on_mouse_entered():
	button_sfx.volume_db = HOVER_VOL
	button_sfx.play(.02)
	
func _on_button_click():
	button_sfx.volume_db = CLICK_VOL
	button_sfx.play()
