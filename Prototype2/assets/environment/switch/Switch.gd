extends Node2D

export(NodePath) var socketPath
onready var socket = get_node(socketPath)
export var minRandomPause = 2
export var maxRandomPause = 5
var isPaused = false
var active = false

func _ready():
	randomize()

func togglePause():
	if !isPaused:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(true)
			$SwitchOffSound.play()
		$Sprite.self_modulate = Color(1,0,0)
		isPaused = true
	else:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(false)
			$SwitchOnSound.play()
		$Sprite.self_modulate = Color(1,1,1)
		isPaused = false

func socketIsCharging():
	active = true
	$RandomPause.start(rand_range(minRandomPause, maxRandomPause))

func socketFullyCharged():
	active = false
	$RandomPause.stop()

func _on_RandomPause_timeout():
	isPaused = false
	togglePause()

func _on_InteractionableBox_interacted(area):
	if !socket:
		return
	if active:
		togglePause()
