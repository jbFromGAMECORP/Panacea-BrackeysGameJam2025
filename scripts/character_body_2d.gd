extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED = 500.0
@export var ACCELERATION = 10
@export var DECELERATION = 200
const speed = 200.0
const JUMP_VELOCITY = -100.0

var player_state
var player_facing

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "Idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "Walk"
	
	velocity = direction * speed
	move_and_slide()
	
	play_anim(direction)

func play_anim(dir):
	
	if player_state == "Idle":
		if player_facing == "Right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Idle")
		elif player_facing == "Left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Idle")
	if player_state == "Walk":
		if dir.x == 1:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Walk")
			player_facing = "Right"
		if dir.x == -1:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Walk")
			player_facing = "Left"
			
func player():
	pass
