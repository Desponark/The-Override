extends KinematicBody2D


const upDirection = Vector2.UP
export(NodePath) var playerPath
onready var player = get_node(playerPath)
var velocity = Vector2.ZERO
export var cameraSpeedMultiplier = 100.0



func _physics_process(delta):
	# TODO: think about improving this... ask lars about improvements
	
	# follow player with move and slide
#	var directionToPlayer = global_position.direction_to(player.global_position)
#	var distanceToPlayer = global_position.distance_to(player.global_position)
#
#	velocity = directionToPlayer * distanceToPlayer * cameraSpeedMultiplier
#	velocity = move_and_slide(velocity, upDirection)
#	print("on floor: ", is_on_floor(), "; on wall: ", is_on_wall(), "; on ceilling: ", is_on_ceiling())
#	print("on ceilling: ", is_on_ceiling())
#	print("on wall: ", is_on_wall())
	
#  move and slide with snap
#	snap = transform.y * 128 if is_on_floor() else Vector2.ZERO
#	velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, false, 4, PI/3)
#	velocity = velocity.rotated(-rotation)
#	if is_on_floor():
#		rotation = get_floor_normal().angle() + PI/2
#
# Solution with fixed x position works smooth for ramps but has trouble with stopping at walls
#	global_position.x = player.global_position.x
# this solution seems to work mostly... only disadvantage is that the camera follows up and down movement relatively slowly
	velocity.x = (player.global_position.x - global_position.x) * cameraSpeedMultiplier
	velocity.y = (player.global_position.y - global_position.y)
	velocity = move_and_slide(velocity, upDirection)
	
