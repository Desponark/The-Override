extends Control

var startScreen

func setup(givenStartScreen):
	startScreen = givenStartScreen

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		hide()

func start():
	get_tree().paused = true
	show()

func _on_Continue_pressed():
	get_tree().paused = false
	hide()

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Main_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(startScreen)

func _on_Quit_Game_pressed():
	get_tree().quit()
