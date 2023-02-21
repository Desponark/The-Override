extends Area2D

export(AudioStream) var dialougeStream
export(String) var dialogueText
# TODO: replace dialogueText string type with text file for easier access and editing?
export var delay = 0
export(NodePath) var socketPath
onready var socket = get_node_or_null(socketPath)
export var socketTriggerPercent = 80.0

export(NodePath) var doorPath
onready var door = get_node_or_null(doorPath)

func _process(delta):
	# TODO: when there is more time change implementation
	if !socket:
		return
	var socketEnergyPercent = (socket.getEnergy() / socket.getMaxEnergy())
	if socketEnergyPercent >= (socketTriggerPercent / 100.0):
		enableDialogueTrigger()
		socket = null

func enableDialogueTrigger():
	set_collision_mask_bit(8, true)

func socketFullyCharged():
	enableDialogueTrigger()

func _on_DialogueTrigger_body_entered(body):
	# TODO: replace with timer node?
	yield(get_tree().create_timer(delay), "timeout")
	
	if body.has_method("playSpeech"):
		body.playSpeech(dialougeStream, dialogueText, delay)
		set_collision_mask_bit(8, false)
		
	if door and door.has_method("lock"):
		door.lock(dialougeStream.get_length())
