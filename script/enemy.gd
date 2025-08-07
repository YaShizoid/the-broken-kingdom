extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var hp_bar = $TextureProgressBar
@onready var animP = $AnimationPlayer
@onready var animDamage = $Node2D/take_damage
@onready var hp_damage = $Node2D/hp_damage
var speed = 50
var player = null
var can_move = true
var player_in = false
var death = false
var health = 100  # Начальное здоровье противника
var max_health = 100 # Максимальное здоровье
var is_dead = false
@export var death_effect : PackedScene # Префаб эффекта смерти

# Сигнал (можно использовать, чтобы уведомить другие части игры о смерти)
signal health_changed(new_health, max_health)
signal died

func _ready():
	emit_signal("health_changed", health, max_health)

func take_damage(damage_amount):
	if is_dead:
		return # Ничего не делаем, если противник уже мертв
	health -= damage_amount
	emit_signal("health_changed", health, max_health) # Оповещаем об изменении здоровья

	print("Противник получил ", damage_amount, " урона.  Здоровье: ", health)  # Отладочный вывод

	if health <= 0:
		health = 0
		die()  # Функция, обрабатывающая смерть

func _physics_process(delta: float) -> void:
	hp_damage.visible = false
	hp_bar.value = Global.enemy_health
	if Global.take_hit == true:
		hp_damage.text = "-" + str(Global.damage_to_display)
		hp_damage.visible = true
		animDamage.play("take_damage")
		hp_bar.visible = true
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
	hp_bar.visible = false
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


func _on_player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
