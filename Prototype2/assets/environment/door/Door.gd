extends StaticBody2D

export var isLocked = false
export var isOpen = false
var currentlyOpen = false

# TODO: think about using a trigger instead of process
func _process(_delta):
	if isLocked:
		modulate = Color( 1, 0, 0 ) # red; note that self_modulate doesn't seem to work for some reason
		return
	else:
		modulate = Color( 1, 1, 1 ) # standard color
	
	if !currentlyOpen and isOpen:
		$AnimationPlayer.play("open")
		currentlyOpen = true
	elif currentlyOpen and !isOpen:
		$AnimationPlayer.play_backwards("open")
		currentlyOpen = false
	
func toggleDoorOpen(isTrue):
	if isLocked:
		return
	isOpen = isTrue

# player interacts with door
func interact(area):
	toggleDoorOpen(!isOpen)

# socket functions
func socketFullyCharged():
	toggleDoorOpen(!isOpen)
