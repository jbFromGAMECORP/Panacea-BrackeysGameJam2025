extends Node

@onready var music_queue:Array[GlobalMusicPlayer] = [$Music1,$Music2]
@onready var current_player :GlobalMusicPlayer= music_queue[0]:
	get():
		return music_queue.get(0)
@onready var next_player :GlobalMusicPlayer= music_queue[1]:
	get():
		return music_queue.get(1)

func _ready() -> void:
	if get_tree().current_scene == self:
		print("Disabling Duplicate")
		self.queue_free()
		
func transition_music(new_song,fade_time=6):
	if current_player.playing and current_player.stream == new_song:
		printerr(self," Same song, skipping change.")
		return
	next_player.change_song(new_song)
	current_player.set_fade_out(fade_time)
	next_player.set_fade_in(fade_time)
	music_queue.reverse()

func change_volume(volume:float):
	pass
	
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
