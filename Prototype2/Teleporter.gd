extends Node2D

# TODO: remove after milestone
# this is for showcasing things
onready var player =  $"../Alive/Player"
onready var camera = $"../Alive/CameraBody"
onready var robot = $"../Alive/Robot"

func _unhandled_input(event):
	# cheats TODO: remove after showcase
	if event.is_action_pressed("F1"):
		teleport($F1.global_position, false)
	if event.is_action_pressed("F2"):
		teleport($F2.global_position)
	if event.is_action_pressed("F3"):
		teleport($F3.global_position)
	if event.is_action_pressed("F4"):
		teleport($F4.global_position)
	if event.is_action_pressed("F5"):
		teleport($F5.global_position)
	if event.is_action_pressed("F6"):
		teleport($F6.global_position)


func teleport(pos, teleportRobot = true):
	player.global_position = pos
	camera.global_position = pos
	if teleportRobot:
		robot.global_position = pos
