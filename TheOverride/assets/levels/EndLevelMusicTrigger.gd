extends Area2D

func _on_EndLevelMusicTrigger_body_entered(body):
	if body.has_method("transferHealth"):
		$AnimationPlayer.play("startEndLevelMusic")
		print("hi")
