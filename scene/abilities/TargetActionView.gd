extends Node
class_name TargetActionView


signal spawn_animation
signal move_animation
signal hit_animation

@export var spawn_time = 0.2
@export var move_time = 1.0
@export var hit_time = 2.0

var target_global_position:Vector2

func _ready():
	spawn_animation.emit()
	await get_tree().create_timer(spawn_time).timeout
	pass

func move_to_target():
	move_animation.emit()
	var tween = create_tween()
	tween.tween_property(self, 'global_position', target_global_position, move_time)
	tween.tween_callback(_hit_target)
	
	pass

func _hit_target():
	hit_animation.emit()
	await get_tree().create_timer(hit_time).timeout
	queue_free()
	
	pass
