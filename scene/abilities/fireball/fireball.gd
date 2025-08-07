extends Node2D

@export var speed : float = 200.0 # Скорость полета фаерболла
var direction : Vector2 = Vector2.ZERO # Направление полета (нормализованный вектор)
@export var damage : int = 10 # Урон, наносимый фаерболлом
var lifetime : float = 3.0 # Время жизни фаерболла в секундах
var timer : float = 0.0

func _ready():
	# Задаем направление полета при создании экземпляра (в Main, к примеру)
	pass

func _process(delta):
	# Перемещаем фаерболл в соответствии с направлением и скоростью
	position += direction * speed * delta

 # Увеличиваем таймер времени жизни
	timer += delta

	# Уничтожаем фаерболл, если время жизни истекло
	if timer >= lifetime:
		queue_free() # Уничтожает текущий узел

func set_direction(dir : Vector2):
	# Получаем направление и нормализуем его
	direction = dir.normalized()

func _on_area_2d_body_entered(body):
	# Обработка столкновения с другими телами (врагами, стенами и т.д.)
	if body is CharacterBody2D:
		# Наносим урон, если столкнулись с врагом (зависит от вашей реализации здоровья)
		body.take_damage(damage) # Предполагается, что у врага есть метод take_damage
		# Можно добавить визуальный эффект попадания
		queue_free() # Уничтожаем фаерболл после столкновения
	else:
		queue_free() # Уничтожаем фаерболл после столкновения
