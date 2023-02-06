extends KinematicBody2D


const upDirection = Vector2.UP

export(NodePath) var playerPath
onready var player = get_node(playerPath)
var velocity = Vector2.ZERO
export var cameraSpeedMultiplier = 2.0

func _ready():
#	set_as_toplevel(true)
	pass

func _physics_process(delta):
	# follow player with move and slide
	var directionToPlayer = global_position.direction_to(player.global_position)
	var distanceToPlayer = global_position.distance_to(player.global_position)
	
	velocity = directionToPlayer * distanceToPlayer * cameraSpeedMultiplier
	
	move_and_slide(velocity, upDirection)
