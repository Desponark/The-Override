extends StaticBody2D


export var isOpen = false
var currentlyOpen = false
export var isLocked = false


func _process(delta):
	if isLocked:
		$Sprite.self_modulate = Color(1,0,0)
		return
	else:
		$Sprite.self_modulate = Color(1,1,1)
	
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() > 0:
		isOpen = true
	else:
		isOpen = false
		
	if !currentlyOpen and isOpen:
		$AnimationPlayer.play("open")
		$DoorOpeningSound.play()
		currentlyOpen = true
	elif currentlyOpen and !isOpen:
		$AnimationPlayer.play_backwards("open")
		$DoorClosingSound.play()
		currentlyOpen = false


func _on_introduction_startedPlaying():
	isLocked = false
