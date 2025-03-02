extends CharacterBody2D

const MAX_SPEED = 500.0			# How fast we can go
const ACCEL = 700.0				# How quickly we move up to max_speed
const DECEL = 1200.0			# How quickly we come to a stop
const TURN_DECEL = 2000.0		# How snappy turns are
const FIRST_STEP_BOOST = 100.0  # How quickly our walk starts
var player_state := "idle"


func _physics_process(delta):
	var direction := Vector2.RIGHT*Input.get_axis("left", "right")  # Will return Vector2 between (-1,0) and (1,0)
	if direction:													# If pushing a direction (if not (0,0))
		player_state = "walking"
		if is_turning(direction):									# If current velocity opposes directional velocity
			change_velocity(MAX_SPEED*direction,TURN_DECEL * delta)
		else:
			change_velocity(MAX_SPEED*direction,ACCEL * delta + boost_if_first_step())
	else:
		change_velocity(Vector2.ZERO,DECEL*delta)
		if not velocity: player_state = "idle"						# Return to idle if player is completely still
		
	var collision = move_and_slide()								# Read if we hit a wall
	if collision: player_state = "idle"								# Swap to idle if pushing against a wall
	play_anim()

func change_velocity(target:Vector2,amount:float):
		velocity = velocity.move_toward(target,amount)				# Attempts to reach target velocity, moving towards it by amount.
		
func is_turning(direction):
	return velocity and sign(velocity.x) != sign(direction.x)		# Return true if we are moving but our directions don't match.
	
func boost_if_first_step():
	return FIRST_STEP_BOOST if not velocity else 0.0				# Return boost if we are standing still
	
func play_anim():
	match player_state:
		"idle": 
			$AnimatedSprite2D.play("idle")
		"walking":
			$AnimatedSprite2D.flip_h = velocity.x < 0				# Look left is true if moving left (-1,0) is true
			$AnimatedSprite2D.play("e-walk")						# Only need 1 animation for now.
	set_animation_speed()											# Scale animation based on Velocity.
			
func set_animation_speed():
	match player_state:
		"idle":														# Don't adjust for Idle
			$AnimatedSprite2D.speed_scale = 1
		"walking":													# A eased scale from 0 to 1, based on our speed's factor between 0 and MAX_SPEED
			$AnimatedSprite2D.speed_scale = smoothstep(-150,MAX_SPEED,abs(velocity.x)) #NOTE: -150 should be 0, but I find the curve feels better with a higher standing point.
	pass
			
func player():
	pass
