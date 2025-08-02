extends Camera2D
var zoom_speed = 0.1
var min_zoom = 1.3
var max_zoom = 2.8
var can_zome = true
var shake_power := 0.0
var shake_until := 0.0
var shake_next := 0.0
var shake_offset := Vector2.ZERO
func _process(delta):
	if Global.damage:
		shake(0.1)
	
	if shake_until < Time.get_ticks_msec():
		offset = lerp(offset, Vector2.ZERO, delta * 10)
		return
		
	if shake_next < Time.get_ticks_msec():
		shake_offset = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * shake_power
		shake_next = Time.get_ticks_msec() + 25
	offset = lerp(offset, shake_offset, delta)
func shake(s, p = 100):
	shake_until = Time.get_ticks_msec() + s * 1000
	shake_power = p
	
	


func _input(event: InputEvent) -> void:
	if can_zome and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom =(zoom - Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom =(zoom + Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))


func _on_player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
