extends Node2D

export var startEnergy = 50.0
export var maxEnergy = 200.0
export var energyTransferAmount = 1.0
export(Array, NodePath) var triggerScenes = []

enum CHARGESTATE {EMPTY, CHARGING, PAUSED, FULLYCHARGED}
var chargeState = CHARGESTATE.EMPTY
var lastChargeState

# TODO: maybe change implementation so player and robot are accessed differently?
var player
var robot

# TODO: temporary solution for socket stopped charging being played on repeat
var isSocketStoppedCharging = false

signal socketIsCharging
signal socketFullyCharged

func _ready():
	$CanvasLayer/HealthBar.health = startEnergy
	$CanvasLayer/HealthBar.maxHealth = maxEnergy
	$CanvasLayer/HealthBar.setup()
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
		robot.loseHealth(energyTransferAmount)
		$CanvasLayer/HealthBar.subtractHealth(-energyTransferAmount)

func pauseChargeProcess(isPaused):
	if chargeState != CHARGESTATE.PAUSED:
		lastChargeState = chargeState
	if isPaused:
		chargeState = CHARGESTATE.PAUSED
	else:
		chargeState = lastChargeState
	triggerEachScene()

func getRobotDockPosition():
	return $Position2D.global_position

# TODO: think about a better name
# TODO: think about using signals instead?
func triggerEachScene():
	match chargeState:
		CHARGESTATE.CHARGING:
			emit_signal("socketIsCharging")
		CHARGESTATE.FULLYCHARGED:
			emit_signal("socketFullyCharged")
	
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
	return $CanvasLayer/HealthBar.health
	
func getMaxEnergy():
	return $CanvasLayer/HealthBar.maxHealth

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

func saveData():
	return {
		"nodePath" : get_path(),
		"chargeState" : chargeState,
		"health" : $HealthBar.getHealth()
	}
	
func loadData(data):
	chargeState = data["chargeState"]
	$HealthBar.health = data["health"]
	if chargeState == CHARGESTATE.FULLYCHARGED:
		$InteractionableBox/CollisionShape2D.disabled = true
		$InteractionableBox.setInteractionReadiness(false)
		triggerEachScene()
