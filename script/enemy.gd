extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
var speed = 50
var player = null
var can_move = true
var player_in = false
var death = false

func _physics_process(delta: float) -> void:
	if Global.enemy_health <= 0:
		death = true
		die()
		return
	if death:
		animP.stop()
	if !can_move:
		return
		
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()
		animP.play("Walk")
		anim.flip_h = dir.x < 0
	else:
		velocity = Vector2.ZERO
		animP.play("Idle")
func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
func die():
	can_move = false
	Global.enemy_health = 0
	animP.play("Death")
	await animP.animation_finished
	queue_free()
func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player = null
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.player_health -= 50
		print(Global.player_health)
func _on_zone_body_entered(body: Node2D) -> void:
	player_in = true
	attack()

func _on_zone_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in = false

func attack():
	while player_in:
		velocity = Vector2.ZERO
		can_move = false
		animP.play("Attack")
		await animP.animation_finished
	can_move = true
func shaking_true():
	Global.damage = true
func shaking_false():
	Global.damage = false
