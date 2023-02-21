extends Node2D

export(String, FILE, "*.tscn") var gamePath

func _on_NewGame_pressed():
	$ButtonPressSound.play()
	get_tree().change_scene(gamePath)

func _on_QuitGame_pressed():
	$ButtonPressSound.play()
	get_tree().quit()


func _on_Options_pressed():
	$ButtonPressSound.play()


func _on_NewGame_mouse_entered():
	$ButtonHoverSound.play()


func _on_Options_mouse_entered():
	$ButtonHoverSound.play()


func _on_QuitGame_mouse_entered():
	$ButtonHoverSound.play()
