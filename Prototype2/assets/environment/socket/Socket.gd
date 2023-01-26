extends Node2D

export var healthTransferAmount = 1.0
export(Array, NodePath) var triggerScenes = []

# TODO: use enum instead of bools? (empty, charging, full)
var isCharging = false
var isFullyCharged = false

var player
var robot


func _physics_process(delta):
	if isCharging:
		if robot.getHealth() <= 1:
			return
#		robot.takeDamage(healthTransferAmount)
		robot.transferHealth(healthTransferAmount)
		$HealthBar.subtractHealth(-healthTransferAmount)

func interact(area):
	# TODO: change implementation so player and robot are accessed differently
	player = area.owner
	robot = player.getRobotRef()
	if robot != null and robot.isFollowingPlayer and !isFullyCharged:
		# socket the robot
		robot.putRobotInSocket($Position2D.global_transform)
		
		# trigger everything that triggers on socket charging up that is connected
		isCharging = true
		triggerEachScene()

func getRobotDockPosition():
	return $Position2D.global_position

# TODO: think about a better name
func triggerEachScene():
	for nodePath in triggerScenes:
		var node = get_node(nodePath)
		if isCharging:
			if node.has_method("socketIsCharging"):
				node.socketIsCharging()
		if isFullyCharged:
			if node.has_method("socketFullyCharged"):
				node.socketFullyCharged()

func _on_HealthBar_healthReachedMax():
	isCharging = false
	isFullyCharged = true
	robot.isFollowingPlayer = true
	# disable socket interaction completely if fully charged
	$InteractionableBox/CollisionShape2D.disabled = true
	# trigger everything on socket being full that is connected
	triggerEachScene()
