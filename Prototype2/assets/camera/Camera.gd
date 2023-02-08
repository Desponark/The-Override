extends KinematicBody2D


const upDirection = Vector2.UP
export(NodePath) var playerPath
onready var player = get_node(playerPath)
var velocity = Vector2.ZERO
export var cameraSpeedMultiplier = 100.0



func _physics_process(delta):
	var toPlayer = player.global_position - global_position
	velocity = toPlayer * cameraSpeedMultiplier
	velocity = move_and_slide(velocity, upDirection, false, 2)
