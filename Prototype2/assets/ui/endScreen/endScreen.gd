extends Node2D

export(String, FILE, "*.tscn") var gamePath

func _on_NewGame_pressed():
	get_tree().change_scene(gamePath)