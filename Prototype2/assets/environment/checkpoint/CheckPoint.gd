extends Area2D

func _on_CheckPoint_body_entered(body):
	print("set checkpoint: ", global_position)
	if body.has_method("setCheckPoint"):
		body.setCheckPoint(global_position)
