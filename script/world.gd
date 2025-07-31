extends Node2D
@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var hp_bar = $"CanvasLayer/hp-bar"
var days_count = -1



func _process(delta: float) -> void:
	if Global.player_health <= 0:
		hp_bar.value = Global.player_health
		animP.stop()
	else:
		animP.play("day-night")
		days.text = str(days_count) + " DAY"
		hp_bar.value = Global.player_health


func days_plus():
	days_count += 1
