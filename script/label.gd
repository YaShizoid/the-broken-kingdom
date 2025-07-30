extends Label


func _physics_process(delta: float) -> void:
	visible = Global.end == true
