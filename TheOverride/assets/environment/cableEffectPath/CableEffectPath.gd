extends Path2D

export var effectSpeed = 500
export var effectFrequency = 1.0

func _ready():
	$Timer.wait_time = effectFrequency

func socketIsCharging():
	$Timer.start()
	
func socketFullyCharged():
	$Timer.stop()
	# TODO: add effect for when the socket is fully charged

func createNewPathFollowInstance():
	var pathFollow2d = $PathFollow2D.duplicate()
	pathFollow2d.setup(effectSpeed)
	pathFollow2d.start()
	add_child(pathFollow2d)

func _on_Timer_timeout():
	createNewPathFollowInstance()
