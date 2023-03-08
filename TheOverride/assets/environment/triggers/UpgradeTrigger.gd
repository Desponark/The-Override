extends Area2D

export(VideoStream) var videoStream
export(String) var headline
export(Texture) var button
export(String) var explainationText
# TODO: change this to not work with strings
export(String, "dash", "reflect") var ability = "dash"

var wasUsed = false

func _on_UpgradeTrigger_body_entered(body):
	if wasUsed:
		return
	if body.has_method("unlockAbility"):
		body.unlockAbility(ability, videoStream, headline, button, explainationText)
	wasUsed = true
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func saveData():
	return {
		"nodePath" : get_path(),
		"wasUsed" : wasUsed
	}
	
func loadData(data):
	wasUsed = data["wasUsed"]
	if wasUsed:
		queue_free()
