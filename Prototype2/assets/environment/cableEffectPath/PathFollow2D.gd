extends PathFollow2D


var effectSpeed = 0.1
var started = false

func setup(speed):
	effectSpeed = speed
	print("setup")
	show()

func start():
	started = true

func _process(delta):
	if started:
		unit_offset += effectSpeed * delta
		if unit_offset >= 1:
			queue_free()
