extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED = 500.0
@export var ACCELERATION = 10
@export var DECELERATION = 200

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = clamp (direction * ACCELERATION + velocity.x, -SPEED, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
	move_and_slide()

	if direction < 0.0:
		$AnimatedSprite2D.play("Left")
		animated_sprite_2d.flip_h = false
	if direction > 0.0:
		animated_sprite_2d.flip_h = true
		$AnimatedSprite2D.play("Left")
	if direction == 0.0: 
		$AnimatedSprite2D.play("Idle")
	$AnimatedSprite2D.speed_scale = abs (velocity.x)/SPEED
