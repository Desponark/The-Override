extends Area2D

export(AudioStream) var dialougeStream
export(String) var dialogueText
# TODO: replace dialoguText string type with text file for easier access and editing?

func _on_DialogueTrigger_body_entered(body):
	if body.has_method("playSpeech"):
		body.playSpeech(dialougeStream, dialogueText)
		queue_free()
