extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if $Player.health <= 0:
		get_tree().reload_current_scene()
	pass
