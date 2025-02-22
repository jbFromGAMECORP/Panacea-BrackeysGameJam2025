extends Area2D
signal overlap_detected(body)

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	get_tree().call_deferred("change_scene_to_file", "res://scenes/scene_1.tscn")
func _on_body_exited(body):
	pass
