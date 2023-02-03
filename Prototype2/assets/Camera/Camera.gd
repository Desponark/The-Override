extends KinematicBody2D


const upDirection = Vector2.UP

export(NodePath) var playerPath = "res://assets/player/"
onready var player = get_node(playerPath)
var velocity = Vector2.ZERO


func _physics_process(delta):
	# follow player with move and slide	
	var directionToPlayer = global_position.direction_to(player.global_position)
	
	velocity = directionToPlayer * 2000.0
	
	move_and_slide(velocity, upDirection)
