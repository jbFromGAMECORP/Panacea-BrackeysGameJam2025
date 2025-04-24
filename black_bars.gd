extends TextureRect

const IN :float = 1.0
const OUT :float = 1.1
const DEFAULT_TIME :float= 2.0

var tween:Tween = create_tween()

func _ready() -> void:
	tween.kill()
	await get_tree().create_timer(1).timeout
	slide_out()

func slide_in(duration:float=DEFAULT_TIME):
	tweener(IN,duration)

func slide_out(duration:float=DEFAULT_TIME):
	tweener(OUT,duration)
	
func tweener(end:float,duration:float):
	tween.kill()
	tween = create_tween()
	tween.tween_property(self,"scale:y",end,duration)
