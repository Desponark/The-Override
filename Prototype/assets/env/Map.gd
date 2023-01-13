extends Node2D


func _process(delta):
	if $Player.health <= 0:
		get_tree().reload_current_scene()
	
	$Player.setup($Projectiles)
	pass
