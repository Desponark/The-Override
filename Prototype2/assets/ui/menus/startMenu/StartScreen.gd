extends Node2D

export(String, FILE, "*.tscn") var gamePath

const saveGamePath = "user://savegame.save"

func _ready():
	var dir = Directory.new()
	if !dir.file_exists(saveGamePath):
		$Buttons/Continue.hide()
		$Buttons/Continue/Label.hide()

func _on_Continue_pressed():
	$ButtonPressSound.play()
	get_tree().change_scene(gamePath)

func _on_NewGame_pressed():
	$ButtonPressSound.play()
	var dir = Directory.new()
	if dir.file_exists(saveGamePath):
		dir.remove(saveGamePath)
	get_tree().change_scene(gamePath)

func _on_Options_pressed():
	$ButtonPressSound.play()
	$OptionsMenu.show()
	$Buttons.hide()
	
func _on_QuitGame_pressed():
	$ButtonPressSound.play()
	get_tree().quit()

func _on_Button_mouse_entered():
	$ButtonHoverSound.play()

func _on_OptionsMenu_optionsClosed():
	$Buttons.show()
