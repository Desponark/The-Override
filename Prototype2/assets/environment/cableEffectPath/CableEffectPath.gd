extends Path2D

export var effectSpeed = 0.4
export var spawnCooldown = 1.0
export(NodePath) var socketPath
onready var socket = get_node_or_null(socketPath)

func _ready():
	# TODO: think about how to connect to socket.
	socket.connect("socketIsCharging", self, "socketIsCharging")
	socket.connect("socketFullyCharged", self, "socketFullyCharged")
	$Timer.wait_time = spawnCooldown

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
