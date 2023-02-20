extends Control

func _on_Continue_pressed():
	get_tree().paused = false
	hide()


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Main_Menu_pressed():
	get_tree().change_scene("res://assets/ui/menus/startMenu/StartScreen.tscn")


func _on_Quit_Game_pressed():
	get_tree().quit()
