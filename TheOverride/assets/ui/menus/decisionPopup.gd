extends Control

export(String, FILE, "*.tscn") var GoodEndingPath
export(String, FILE, "*.tscn") var BadEndingPath

func _ready():
	$CanvasLayer/Panel.hide()
	$CanvasLayer/ColorRect.hide()
	
func changeSceneToGoodEnding():
	get_tree().change_scene(GoodEndingPath)
	
func changeSceneToBadEnding():
	get_tree().change_scene(BadEndingPath)

func _on_SaveHumanity_pressed():
	$AnimationPlayer.play("goodEnding")


func _on_SaveYourself_pressed():
	$AnimationPlayer.play("badEnding")
