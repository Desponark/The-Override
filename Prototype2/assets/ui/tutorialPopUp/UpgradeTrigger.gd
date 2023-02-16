extends Area2D

export(VideoStream) var videoStream
export(String) var headline
export(Texture) var button
export(String) var explainationText

func _on_UpgradeTrigger_body_entered(body):
	if body.has_method("showPopUp"):
		body.showPopUp(videoStream, headline, button, explainationText)
		queue_free()
