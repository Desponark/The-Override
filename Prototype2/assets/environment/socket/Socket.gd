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

# TODO: temporary solution for socket stopped charging being played on repeat
var isSocketStoppedCharging = false

func _ready():
	$HealthBar.health = startEnergy
	$HealthBar.maxHealth = maxEnergy
	$HealthBar.setup()
	$InteractionableBox.setInteractionReadiness(true)

# TODO: cleanup this mess; make sure things happen only when they need to happen and not all the time
func _process(_delta):
	if chargeState == CHARGESTATE.CHARGING:
		if robot.getHealth() <= 1:
			if !isSocketStoppedCharging:
				$ChargingSound.stop()
				$ChargingStoppedSound.play()
				if robot.has_method("playSocketStoppedCharging"):
					robot.playSocketStoppedCharging()
				$Light2D.color = Color(0.81, 0.38, 0.34)
				isSocketStoppedCharging = true
			return
		isSocketStoppedCharging = false
		$ChargingSound.play()
		$ChargingStoppedSound.stop()
		$Light2D.color = Color(0.49, 0.81, 0.34)
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
# TODO: think about using signals instead?
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

func getEnergy():
	return $HealthBar.health
	
func getMaxEnergy():
	return $HealthBar.maxHealth

func _on_HealthBar_healthReachedMax():
	chargeState = CHARGESTATE.FULLYCHARGED
	$ChargingSound.stop()
	robot.isFollowingPlayer = true
	$InteractionableBox/CollisionShape2D.disabled = true # disable socket interaction completely if fully charged
	$InteractionableBox.setInteractionReadiness(false)
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
		$InteractionableBox.setInteractionReadiness(false)
		$InteractionableBox.changePromptVisibility(false)
		# trigger everything that triggers on socket charging up that is connected
		chargeState = CHARGESTATE.CHARGING
		triggerEachScene()
