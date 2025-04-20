extends AudioStreamPlayer
class_name GlobalMusicPlayer

@onready var default_db:float = volume_db
var fade_tween:Tween = create_tween()

func _ready():
	fade_tween.kill()
	
func change_song(new_stream:AudioStream):
	if playing:
		push_warning("Song changed while playing.")
	if new_stream == stream:
		push_warning("Same Song - Change skipped.")
	stream = new_stream
	

func new_pitch():
	var pitch = randfn(1,0.2)
	var pitch_slide_time = randfn(10,3)
	print(pitch_scale," ----> ", pitch)
	await create_tween().tween_property(self,"pitch_scale",pitch,pitch_slide_time).finished
	prints("pitch change done")
	new_timer()
	
	
func new_timer():
	var timer = randi_range(8,12)
	prints("new_timer:",timer)
	get_tree().create_timer(timer).timeout.connect(new_pitch)

	
func set_fade_in(fade_time,pos = 0.0):
	if playing:
		push_error(self, "set_fade_in failed: Music already playing.");return
	
	prints("Fading IN:",name,"-",stream.resource_path)
	volume_db = -70.0
	play(pos)
	fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(self,"volume_db",default_db,fade_time)\
						 .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func set_fade_out(fade_time):
	if not playing:
		push_error(self, "set_fade_out failed: Music is not playing.");return
	prints("Fading OUT:",name,"-",stream.resource_path)
	fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(self,"volume_db",-70.0,fade_time)\
			  .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await fade_tween.finished
	stop()
