extends Node2D

export(NodePath) var socketPath
onready var socket = get_node(socketPath)
export var minRandomPause = 2
export var maxRandomPause = 5
var wasPaused = false
var active = false

func _ready():
	randomize()

func togglePause():
	if !wasPaused:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(true)
			$SwitchOffSound.play()
			$Light2D.color = Color(0.81, 0.38, 0.34)
		$Sprite.self_modulate = Color(1,0,0)
		wasPaused = true
		$InteractionableBox.setInteractionReadiness(true)
		$InteractionableBox.changePromptVisibility(false)
	else:
		if socket.has_method("pauseChargeProcess"):
			socket.pauseChargeProcess(false)
			$SwitchOnSound.play()
			$Light2D.color = Color(0.49, 0.81, 0.34)
		$Sprite.self_modulate = Color(1,1,1)
		wasPaused = false
		$InteractionableBox.setInteractionReadiness(false)

func socketIsCharging():
	active = true
	$RandomPause.start(rand_range(minRandomPause, maxRandomPause))

func socketFullyCharged():
	active = false
	$InteractionableBox.setInteractionReadiness(false)
	$RandomPause.stop()

func _on_RandomPause_timeout():
	wasPaused = false
	togglePause()

func _on_InteractionableBox_interacted(area):
	if !socket:
		return
	if active:
		togglePause()
