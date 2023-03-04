extends StaticBody2D


export var isOpen = false
var currentlyOpen = false
var isLocked = false

func _ready():
#	isLocked = true
	$Sprite.self_modulate = Color(1,0,0)

func _process(delta):
	if isLocked:
		return
	
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

func lock(seconds):
	isLocked = true
	$Sprite.self_modulate = Color(1,0,0)
	
	yield(get_tree().create_timer(seconds), "timeout")
	isLocked = false
	$Sprite.self_modulate = Color(1,1,1)
