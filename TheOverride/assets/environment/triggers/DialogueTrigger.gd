extends Area2D

export(AudioStream) var dialougeStream
export(String) var dialogueText
# TODO: replace dialogueText string type with text file for easier access and editing?
export var delay = 0

export(NodePath) var socketPath
onready var socket = get_node_or_null(socketPath)
export var socketTriggerPercent = 80.0

var wasUsed = false
var robot

signal startedPlaying
signal finishedPlaying

func _process(delta):
	# TODO: when there is more time change implementation
	if socket:
		var socketEnergyPercent = (socket.getEnergy() / socket.getMaxEnergy())
		if socketEnergyPercent >= (socketTriggerPercent / 100.0):
			enableDialogueTrigger()
			socket = null

func enableDialogueTrigger():
	set_collision_mask_bit(8, true)

func socketFullyCharged():
	enableDialogueTrigger()
	
func socketIsCharging():
	pass

func _on_DialogueTrigger_body_entered(body):
	if wasUsed:
		return
	robot = body
	robot.connect("voiceLineFinished", self, "voiceLineFinished")
	$Timer.start(delay)

func _on_Timer_timeout():
	if robot.has_method("playSpeech"):
		robot.playSpeech(dialougeStream, dialogueText, delay)
	set_collision_mask_bit(8, false)
	wasUsed = true
	emit_signal("startedPlaying")
	
func voiceLineFinished():
	emit_signal("finishedPlaying")

func saveData():
	return {
		"nodePath" : get_path(),
		"wasUsed" : wasUsed
	}
	
func loadData(data):
	wasUsed = data["wasUsed"]
	if wasUsed:
		queue_free()
