extends Node2D

@export var FIREBALL:PackedScene

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		var fireball:FireBall = FIREBALL.instantiate()
		fireball.global_postition = $player.global_position
		fireball.target_global_position = get_global_mouse_position()
		add_child(fireball)
		
		pass
