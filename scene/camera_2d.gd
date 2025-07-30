extends Camera2D
var zoom_speed = 0.1
var min_zoom = 1.3
var max_zoom = 2.8
var can_zome = true
var original_pos

func _ready() -> void:
	original_pos = position
	
func _process(delta: float) -> void:
	if Global.damage:
		shake_camera()

func _input(event: InputEvent) -> void:
	if can_zome and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom =(zoom - Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom =(zoom + Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func shake_camera():
	if !can_zome:
		return
	
	can_zome = false
	
	var tween = create_tween()
	var shake_str = 10.0
	var shake_time = 0.01
	
	
	tween.tween_property(self, "position", original_pos + Vector2(shake_str, shake_str), shake_time)
	tween.tween_property(self, "position", original_pos - Vector2(shake_str, shake_str), shake_time)
	tween.tween_property(self, "position", original_pos, shake_time)
	await  get_tree().create_timer(0,05).timeout
	can_zome = true
