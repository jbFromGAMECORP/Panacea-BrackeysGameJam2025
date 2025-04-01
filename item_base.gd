extends Draggable

var item : ItemResource

func _ready() -> void:
	if item:
		$Sprite.texture = item.texture
	super()
