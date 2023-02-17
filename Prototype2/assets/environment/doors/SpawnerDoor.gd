extends StaticBody2D


export var isOpen = false
var currentlyOpen = false


func _process(delta):
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
