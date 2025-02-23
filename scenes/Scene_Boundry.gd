class_name SceneBoundry
extends Area2D

signal overlap_detected(body)

@export var target_scene : String

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print(get_tree().change_scene_to_packed(load(target_scene)))
	print("Woohoo")
func _on_body_exited(body):
	pass
