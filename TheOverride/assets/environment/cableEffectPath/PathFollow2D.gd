extends PathFollow2D


var effectSpeed = 500
var started = false

func setup(speed):
	effectSpeed = speed
	show()

func start():
	started = true

func _process(delta):
	if started:
		offset += effectSpeed * delta
		if unit_offset >= 1:
			queue_free()
