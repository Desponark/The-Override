extends Node2D

# TODO: remove after milestone
# this is for showcasing things
onready var player =  $"../Alive/Player"
onready var camera = $"../Alive/CameraBody"
onready var robot = $"../Alive/Robot"

var lastPosition

func _unhandled_input(event):
	# cheats TODO: remove after showcase
	if event.is_action_pressed("F1"):
		teleport($F1.global_position, false)
	if event.is_action_pressed("F2"):
		teleport($F2.global_position)
		$"../Alive/Robot".playSpeech(null, "", 2)
	if event.is_action_pressed("F3"):
		teleport($F3.global_position)
		$"../Alive/Robot".playSpeech(null, "", 2)
	if event.is_action_pressed("F4"):
		teleport($F4.global_position)
		$"../Alive/Robot".playSpeech(null, "", 2)
	if event.is_action_pressed("F5"):
		teleport($F5.global_position)
		$"../Alive/Robot".playSpeech(null, "", 2)
	if event.is_action_pressed("F6"):
		teleport($F6.global_position)
		$"../Alive/Robot".playSpeech(null, "", 2)


func teleport(pos, teleportRobot = true):
	player.global_position = pos
	camera.global_position = pos
	if teleportRobot:
		robot.global_position = pos
		
func teleportToLastPos():
	player.gainHealth(100)
	teleport(lastPosition)

func _on_Checkpoint1_body_entered(body):
	lastPosition = $"../Checkpoint1".global_position

func _on_Checkpoint2_body_entered(body):
	lastPosition = $"../Checkpoint2".global_position

func _on_Checkpoint3_body_entered(body):
	lastPosition = $"../Checkpoint3".global_position

func _on_Checkpoint7_body_entered(body):
	lastPosition = $"../Checkpoint7".global_position

func _on_Checkpoint4_body_entered(body):
	lastPosition = $"../Checkpoint4".global_position

func _on_Checkpoint5_body_entered(body):
	lastPosition = $"../Checkpoint5".global_position

func _on_Checkpoint6_body_entered(body):
	lastPosition = $"../Checkpoint6".global_position
