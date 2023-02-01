extends Node2D

export(NodePath) var socketPath
onready var socket = get_node(socketPath)
export var minRandomPause = 2
export var maxrandomPause = 5
var isPaused = false


func _ready():
	randomize()

func interact(area):
	if !socket:
		return
	togglePause()

func togglePause():
	if !isPaused:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(true)
		$Sprite.self_modulate = Color(1,0,0)
		isPaused = true
	else:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(false)
		$Sprite.self_modulate = Color(1,1,1)
		isPaused = false

func socketIsCharging():
	# start random deactivation process
	$RandomPause.start(rand_range(minRandomPause, maxrandomPause))

func socketFullyCharged():
	$RandomPause.stop()

func _on_RandomPause_timeout():
	isPaused = false
	togglePause()
