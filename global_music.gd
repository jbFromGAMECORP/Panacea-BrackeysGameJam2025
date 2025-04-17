extends Node

@onready var music_queue:Array[GlobalMusicPlayer] = [$Music1,$Music2]


#@export var pitch_slide_time :int = 12
func _ready() -> void:
	pass
	
func transition_music(new_song):
	var current_player = music_queue[0]
	var next_player = music_queue[1]
	if current_player.playing and current_player.stream == new_song:
		printerr(self," Same song, skipping change.")
		return
	next_player.change_song(new_song)
	current_player.set_fade_out()
	#await get_tree().create_timer(4).timeout
	next_player.set_fade_in()
	music_queue.reverse()

#func cycle_songs():
	#await get_tree().create_timer(3).timeout
	#await change_music(song2)
	#await get_tree().create_timer(4).timeout
	#await change_music(song3)
	#await get_tree().create_timer(4).timeout
	#await change_music(song1,12)
	#cycle_songs()
	
#func intensity_change(song,fade_time=6):
	#var current_player = music_queue[0]
	#var next_player = music_queue[1]
	#var pos = current_player.get_playback_position()
	#next_player.stream = song
	#set_fade_in(next_player,pos,fade_time)
	#var finished = set_fade_out(current_player,fade_time)
	#music_queue.append(music_queue.pop_front())
	#await finished
	#current_player.stop()
	#print("FINISHED")




func _on_song_1_pressed() -> void:
	transition_music(load("res://scenes/Test_scenes/assets/pyroxene.mp3"))


func _on_song_2_pressed() -> void:
	transition_music(load("res://scenes/Test_scenes/assets/Chiptune Vol5 Don't Call Me Main.wav"))
