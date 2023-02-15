extends Area2D

export(AudioStream) var dialougeStream

func _on_DialogueTrigger_body_entered(body):
	if body.has_method("playVoice"):
		body.playVoice(dialougeStream)
	
	# disable collisions so voice cant be triggered again
	collision_mask = 0
