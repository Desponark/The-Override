extends StaticBody2D

export var isLocked = false
export var isOpen = false
var currentlyOpen = false

# TODO: think about using a trigger instead of process
func _process(_delta):
	# change the color of the door to red to symbolize it being locked
	if isLocked:
		modulate = Color( 1, 0, 0 ) # red; note that self_modulate doesn't seem to work for some reason
		return
	else:
		modulate = Color( 1, 1, 1 ) # standard color
	
	if !currentlyOpen and isOpen:
		$AnimationPlayer.play("open")
		$DoorOpeningSound.play()
		currentlyOpen = true
	elif currentlyOpen and !isOpen:
		$AnimationPlayer.play_backwards("open")
		$DoorClosingSound.play()
		currentlyOpen = false
	
func toggleDoorOpen(isTrue):
	if isLocked:
		return
	isOpen = isTrue

func setLock(lock):
	isLocked = lock

# socket functions
func socketIsCharging():
#	setLock(true)
	pass

func socketFullyCharged():
	setLock(false)
	toggleDoorOpen(!isOpen)

func _on_InteractionableBox_interacted(area):
	toggleDoorOpen(!isOpen)
