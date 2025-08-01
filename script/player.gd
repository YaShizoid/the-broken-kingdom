extends CharacterBody2D

enum {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

@onready var anim = $AnimatedSprite2D

@onready var animP = $AnimationPlayer

@onready var timer = $"../Timer"

@onready var stamina_bar = $"CanvasLayer/stamina-bar"

@onready var hp_bar = $"CanvasLayer/hp-bar"

var speed = 100

var idle_dir = DOWN

var can_move = true

var can_attack = true

var attack_cooldown = 0.85

var stamina = 100

var max_stamina = 100

var stamina_minus = 20

var stamina_regen = 10

func _physics_process(delta: float) -> void:
	hp_bar.value = Global.player_health
	stamina_bar.value = stamina
	if Global.player_health <= 0:
		Global.player_health = 0
		animP.play("Death")
		await animP.animation_finished
		self.queue_free()
		Global.end = true
	if !can_move:
		return
	run(delta)
	if Input.is_action_just_pressed('attack') and can_attack == true:
		attack()
	elif Input.is_action_pressed("up"):
		up_move()
	elif Input.is_action_pressed("down"):
		down_move()
	elif Input.is_action_pressed("left"):
		left_move()
	elif Input.is_action_pressed("right"):
		right_move()
	else:
		idle()
	
	move_and_slide()

func up_move():
	anim.play("Up")
	velocity = Vector2(0, -speed)
	idle_dir = UP

func down_move():
	anim.play("Down")
	velocity = Vector2(0, speed)
	idle_dir = DOWN

func left_move():
	anim.flip_h = true
	anim.play("Front")
	velocity = Vector2(-speed, 0)
	idle_dir = LEFT

func right_move():
	anim.flip_h = false
	anim.play("Front")
	velocity = Vector2(speed, 0)
	idle_dir = RIGHT

func idle():
	velocity.x = 0
	velocity.y = 0
	if velocity.x == 0 and velocity.y == 0:
		match idle_dir:
			DOWN:
				anim.play("Idle_down")
			UP:
				anim.play("Idle_up")
			LEFT:
				anim.flip_h = true
				anim.play("Idle_front")
			RIGHT:
				anim.flip_h = false
				anim.play("Idle_front")
	
func run(delta):
	if Input.is_action_pressed("run") and stamina > 0:
		speed = 200
		stamina -= stamina_minus * delta
		if stamina <= 0:
			stamina = 0
			speed = 100
	else:
		speed = 100
		stamina += stamina_regen * delta
		if stamina >= max_stamina:
			stamina = max_stamina

func attack():
	can_move = false
	can_attack = false
	timer.start(attack_cooldown)
	velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		match idle_dir:
			DOWN:
				animP.play("Attack_down")
				await anim.animation_finished
				can_move = true
				animP.play("Idle_down")
			UP:
				animP.play("Attack_up")
				await anim.animation_finished
				can_move = true 
			LEFT:
				anim.flip_h = true
				animP.play("Attack_left")
				await anim.animation_finished
				can_move = true
			RIGHT:
				anim.flip_h = false
				animP.play("Attack_right")
				await anim.animation_finished
				can_move = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "enemy":
		var is_crit = randf() < Global.chance_crit
		var original_damage = Global.player_damage
		
		Global.player_damage *= 2 if is_crit else 1
		Global.enemy_health -= Global.player_damage
		Global.take_hit = true
		
		var damage_to_display = Global.player_damage
		await get_tree().process_frame
		Global.player_damage = original_damage
		Global.damage_to_display = damage_to_display

func _on_timer_timeout() -> void:
	can_attack = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "enemy":
		Global.take_hit = false
