extends Node2D

export(PackedScene) var game

func _on_NewGame_pressed():
	get_tree().change_scene_to(game)

func _on_QuitGame_pressed():
	get_tree().quit()
