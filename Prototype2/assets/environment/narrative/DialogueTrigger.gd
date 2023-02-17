extends Area2D

export(AudioStream) var dialougeStream
export(String) var dialogueText
# TODO: replace dialogueText string type with text file for easier access and editing?
export var delay = 0
export(NodePath) var socketPath
onready var socket = get_node_or_null(socketPath)
export var socketTriggerPercent = 80.0

func _process(delta):
	# TODO: when there is more time change implementation
	if !socket:
		return
	var socketEnergyPercent = (socket.getEnergy() / socket.getMaxEnergy())
	if socketEnergyPercent >= (socketTriggerPercent / 100.0):
		enableDialogueTrigger()
		socket = null

func enableDialogueTrigger():
	collision_mask = 256 # robot mask layer

func socketFullyCharged():
	enableDialogueTrigger()

func _on_DialogueTrigger_body_entered(body):
	# TODO: replace with timer node?
	yield(get_tree().create_timer(delay), "timeout")
	
	if body.has_method("playSpeech"):
		body.playSpeech(dialougeStream, dialogueText, delay)
		collision_mask = 0
