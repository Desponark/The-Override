extends Node2D

func _on_NewGame_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_QuitGame_pressed():
	get_tree().quit()
