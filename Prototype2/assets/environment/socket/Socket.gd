extends Node2D

export var startEnergy = 50.0
export var maxEnergy = 200.0
export var energyTransferAmount = 1.0
export(Array, NodePath) var triggerScenes = []

enum CHARGESTATE {EMPTY, CHARGING, PAUSED, FULLYCHARGED}
var chargeState = CHARGESTATE.EMPTY
var currentChargeState

# TODO: maybe change implementation so player and robot are accessed differently?
var player
var robot

func _ready():
	$HealthBar.health = startEnergy
	$HealthBar.maxHealth = maxEnergy
	$HealthBar.setup()

func _physics_process(_delta):
	if chargeState == CHARGESTATE.CHARGING:
		if robot.getHealth() <= 1:
			$ChargingSound.stop()
			return
		$ChargingSound.play()
		robot.transferHealth(energyTransferAmount)
		$HealthBar.subtractHealth(-energyTransferAmount)

func pauseChargeProcess(isPaused):
	if chargeState != CHARGESTATE.PAUSED:
		currentChargeState = chargeState
	if isPaused:
		chargeState = CHARGESTATE.PAUSED
	else:
		chargeState = currentChargeState
	triggerEachScene()

func getRobotDockPosition():
	return $Position2D.global_position

# TODO: think about a better name
func triggerEachScene():
	for nodePath in triggerScenes:
		var node = get_node(nodePath)
		match chargeState:
			CHARGESTATE.CHARGING:
				if node.has_method("socketIsCharging"):
					node.socketIsCharging()
			CHARGESTATE.FULLYCHARGED:
				if node.has_method("socketFullyCharged"):
					node.socketFullyCharged()

func _on_HealthBar_healthReachedMax():
	chargeState = CHARGESTATE.FULLYCHARGED
	$ChargingSound.stop()
	robot.isFollowingPlayer = true
	$InteractionableBox/CollisionShape2D.disabled = true # disable socket interaction completely if fully charged
	triggerEachScene() # trigger everything on socket being full that is connected
	# Play ChargingFinished sound
	$ChargingFinishedSound.play()

func _on_InteractionableBox_interacted(area):
	player = area.owner
	robot = player.getRobotRef()
	if robot != null and robot.isFollowingPlayer and chargeState != CHARGESTATE.FULLYCHARGED:
		# socket the robot
		robot.putRobotInSocket($Position2D.global_position)
		$InsertSound.play()
		
		# trigger everything that triggers on socket charging up that is connected
		chargeState = CHARGESTATE.CHARGING
		triggerEachScene()
