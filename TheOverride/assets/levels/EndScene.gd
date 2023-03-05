extends Area2D

export(String, FILE, "*.tscn") var gamePath

func _ready():
	$CanvasLayer/Panel.hide()

func _on_EndScene_body_entered(body):
	if body.has_method("playSpeech"):
		$AnimationPlayer.play("endScreen")
		
func changeScene():
	get_tree().change_scene(gamePath)
