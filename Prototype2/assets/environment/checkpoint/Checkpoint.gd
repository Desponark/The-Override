extends Area2D
	
export var oneShot = true
	
func _on_Checkpoint_body_entered(body):
	EventBus.emit_signal("saveGame")
	if oneShot:
		collision_layer = 0
		collision_mask = 0
