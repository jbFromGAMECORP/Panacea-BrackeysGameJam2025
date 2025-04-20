extends CharacterBody2D

#region Player Movement
@export var MAX_SPEED = 500.0			# How fast we can go
@export var MAX_WALKING_ANIMATION = 500.0			# How fast we can go
@export var ACCEL = 700.0				# How quickly we move up to max_speed
@export var DECEL = 1200.0			# How quickly we come to a stop
@export var TURN_DECEL = 2000.0		# How snappy turns are
@export var FIRST_STEP_BOOST = 100.0  # How quickly our walk starts
#endregion 

#region Camera Constants
const VELOCITY_CAMERA_FACTOR = 0.2 # Factor by which velocity pushes the camera left or right
const CAMERA_PUSH_DEFAULT = 75.0 # How far the camera pushes in the direction player is facing
#endregion

var player_state := "idle"

func _physics_process(delta):
	var direction := Vector2(Input.get_axis("left","right"),Input.get_axis("up","down"))  # Will return Vector2 between (-1,0) and (1,0)
	if direction:													# If pushing a direction (if not (0,0))
		player_state = "walking"
		if is_turning(direction):									# If current velocity opposes directional velocity
			change_velocity(MAX_SPEED*direction,TURN_DECEL * delta)
		else:
			change_velocity(MAX_SPEED*direction,ACCEL * delta + boost_if_first_step())
	else:
		change_velocity(Vector2.ZERO,DECEL*delta)
		if not velocity: player_state = "idle"						# Return to idle if player is completely still
		
	var _collision = move_and_slide()								# Read if we hit a wall
	var moved = get_position_delta().length()
	if moved <0.12:
		velocity *= 0
		player_state = "idle"
	#scale = Vector2.ONE*remap(position.y,966,1070,.95,1.05)
	play_anim()
	
	var cam_target = velocity.x*VELOCITY_CAMERA_FACTOR + (-CAMERA_PUSH_DEFAULT if $AnimatedSprite2D.flip_h else CAMERA_PUSH_DEFAULT)
	if direction.x: 
		$Camera2D.position.x = lerp($Camera2D.position.x,cam_target,delta*2)
	else:
		$Camera2D.position.x = lerp($Camera2D.position.x,cam_target,delta)
		pass


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
			if velocity.x < -1.0:
				$AnimatedSprite2D.flip_h = true
			elif velocity.x > 1.0:
				$AnimatedSprite2D.flip_h = false   				# Look left is true if moving left (-1,0) is true
			$AnimatedSprite2D.play("e-walk")						# Only need 1 animation for now.
	set_animation_speed()											# Scale animation based on Velocity.
			
func set_animation_speed():
	match player_state:
		"idle":														# Don't adjust for Idle
			$AnimatedSprite2D.speed_scale = 1
		"walking":													# A eased scale from 0 to 1, based on our speed's factor between 0 and MAX_SPEED
			$AnimatedSprite2D.speed_scale = smoothstep(-150,MAX_WALKING_ANIMATION,abs(velocity.length())) #NOTE: -150 should be 0, but I find the curve feels better with a higher standing point.
	pass
			
func player():
	pass
