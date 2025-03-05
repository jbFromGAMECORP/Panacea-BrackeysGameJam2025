extends Draggable

@export var color : Color
@onready var color_box: ColorRect = $Color_box


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_box.color = color
	super()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	pass
