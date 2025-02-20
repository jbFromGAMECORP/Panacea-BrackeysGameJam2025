extends CharacterBody2D

const speed = 30.0
const JUMP_VELOCITY = -200.0
var current_state = SIDE_LEFT

var dir = Vector2.RIGHT

var is_roaming = true
var is_chatting = false

var player_in_area = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if player_in_area:
		print("I'm in the area!")
		if Input.is_action_just_pressed("e"):
			run_dialogue("testDialogue")
		
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("w-walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("e-walk")
	#if is_roaming:
	#	match current_state:
	#		IDLE:
	#			pass
	#		NEW_DIR:
	#			dir = choose([Vector2.RIGHT, Vector2.LEFT])
	#		MOVE:
	#			move(delta)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()

func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	Dialogic.start(dialogue_string)
	
func DialogicSignal(arg: String):
	if arg == "exit_rando":
		$Timer.stop()
		$Timer.wait_time = 1000
		dir = Vector2.LEFT
		current_state = MOVE
		is_chatting = false
		is_roaming = true
		await get_tree().create_timer(30.0).timeout
		self.queue_free()
		
func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

func _on_chat_detection_body_entered(body):
	print(body)
	if body.has_method("player"):
		player_in_area = true

func _on_chat_detection_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
