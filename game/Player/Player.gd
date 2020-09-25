extends KinematicBody2D

var max_speed = 80
var acceleration = 500
const FRICTION = 500
var stamina = 100
var mana = 100

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var staminaBar = $StaminaBar
onready var manaBar = $ManaBar

func _physics_process(delta):
	staminaBar.set_value(stamina)
	manaBar.set_value(mana)
	var input_vector = Vector2.ZERO
	
	if !Input.is_key_pressed(KEY_SHIFT):
		if stamina < 100:
			stamina += 0.25
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if Input.is_key_pressed(KEY_SHIFT):
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
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
