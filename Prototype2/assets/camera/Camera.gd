extends KinematicBody2D


const upDirection = Vector2.UP

export(NodePath) var playerPath
onready var player = get_node(playerPath)
var velocity = Vector2.ZERO
export var cameraSpeedMultiplier = 100.0
var move
var snap = Vector2.DOWN

func _physics_process(delta):
	# follow player with move and slide
	var directionToPlayer = global_position.direction_to(player.global_position)
	var distanceToPlayer = global_position.distance_to(player.global_position)
	
	velocity = directionToPlayer * distanceToPlayer * cameraSpeedMultiplier
	print(distanceToPlayer * cameraSpeedMultiplier)
	
	velocity = move_and_slide(velocity, upDirection, false, 4, deg2rad(70))
#	var move = move_and_slide_with_snap(velocity, snap, upDirection, true, 4, deg2rad(60))
	
