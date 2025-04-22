extends Node

const DEFAULT_TRANS_FADE = 4.0
const DEFAULT_FADE = 2.0
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
		
func transition_music(new_song:AudioStream,fade_time:float=DEFAULT_TRANS_FADE):
	var music_playing = is_music_playing()
	if start_music(new_song,fade_time) != OK:
		return OK
	if music_playing: 
		end_music(fade_time)


func start_music(new_song:AudioStream,fade_time:float=DEFAULT_FADE):
	if not new_song:
		push_error("No song provided - Change skipped.")
		return -1
	if new_song == current_player.stream:
		push_warning("Same Song - Change skipped.")
		return -1
	if next_player.playing:
		push_error(next_player, "Music already playing.")
		return -1
	next_player.change_song(new_song)
	next_player.set_fade_in(fade_time)
	music_queue.reverse()
	return OK
	
func end_music(fade_time=DEFAULT_FADE):
	current_player.set_fade_out(fade_time)

func change_volume(_volume:float): #TODO
	pass
	
func is_music_playing():
	return current_player.playing or next_player.playing

func get_current_song():
	for x in [current_player,next_player]:
		prints(x,"is","" if x.playing else "not","playing song:",x.stream)
	return current_player.stream

#region:Other features####
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
#endregion:Other features####
