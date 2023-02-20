extends Area2D

export(VideoStream) var videoStream
export(String) var headline
export(Texture) var button
export(String) var explainationText
# TODO: change this to not work with strings
export(String, "dash", "reflect") var ability = "dash"

func _on_UpgradeTrigger_body_entered(body):
	if body.has_method("unlockAbility"):
		body.unlockAbility(ability, videoStream, headline, button, explainationText)
		queue_free()
