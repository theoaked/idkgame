extends KinematicBody2D

const FRICTION = 500
const ROLL_SPEED = 1.25

var max_speed = 80
var acceleration = 500
var stamina = 100
var mana = 100
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var staminaBar = $StaminaBar
onready var manaBar = $ManaBar

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	staminaBar.set_value(stamina)
	manaBar.set_value(mana)
	
	var input_vector = Vector2.ZERO
	
	if !Input.get_action_strength("run"):
		if stamina < 100:
			stamina += 0.25
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if Input.get_action_strength("run"):
			if stamina > 0:
				stamina -= 1
				max_speed = 180
				acceleration = 800
			else:
				max_speed = 80
				acceleration = 500
		else :
			max_speed = 80
			acceleration = 500
		
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("Roll"):
		if stamina > 36:
			stamina -= 35
			state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func roll_state(delta):
	velocity = roll_vector * max_speed * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	animationState.travel("Attack")
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finish():
	state = MOVE
