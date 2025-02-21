extends CharacterBody2D


const speed = 200.0

var player_state
var player_facing



func _physics_process(delta):
		
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	
	velocity = direction * speed
	move_and_slide()
	
	play_anim(direction)

func play_anim(dir):
	
	if player_state == "idle":
		if player_facing == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("idle")
		elif player_facing == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.x == 1:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("e-walk")
			player_facing = "right"
		if dir.x == -1:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("w-walk")
			player_facing = "left"
			
func player():
	pass
