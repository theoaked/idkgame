extends Node2D

func _proccess(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance()
		var world = get_tree().current_scence
		grassEffect.global_position = global_position
		queue_free()
