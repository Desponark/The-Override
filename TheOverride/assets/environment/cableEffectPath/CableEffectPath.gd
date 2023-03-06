extends Path2D

export var ChargingEffectSpeed = 500
export var ChargingEffectFrequency = 1.0
export var FullyChargedEffectSpeed = 250
export var FullyChargedEffectFrequency = 2.0

func _ready():
	$ChargingTimer.wait_time = ChargingEffectFrequency
	$FullyChargedTimer.wait_time = FullyChargedEffectFrequency

func socketIsCharging():
	$ChargingTimer.start()
	
func socketFullyCharged():
	$ChargingTimer.stop()
	$FullyChargedTimer.start()

func createNewPathFollowInstance(parentPathFollow, effectSpeed):
	var pathFollow2d = parentPathFollow.duplicate()
	pathFollow2d.setup(effectSpeed)
	pathFollow2d.start()
	add_child(pathFollow2d)

func _on_ChargingTimer_timeout():
	createNewPathFollowInstance($ChargingPathFollow, ChargingEffectSpeed)

func _on_FullyChargedTimer_timeout():
	createNewPathFollowInstance($FullyChargedPathFollow, FullyChargedEffectSpeed)
