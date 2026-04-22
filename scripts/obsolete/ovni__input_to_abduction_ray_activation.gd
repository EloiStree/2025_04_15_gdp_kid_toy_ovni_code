extends MeshInstance3D


func _input(event: InputEvent) -> void:
	if InputMap.has_action("set_on_abduction") and event.is_action_pressed("set_on_abduction"):
		self.visible = true
	else :
		self.visible = false
