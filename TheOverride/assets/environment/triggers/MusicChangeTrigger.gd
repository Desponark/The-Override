extends Area2D

export(AudioStream) var music

func _on_MusicChangeTrigger_body_entered(body):
	EventBus.emit_signal("changeMusicTo", music)
