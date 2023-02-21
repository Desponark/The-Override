extends StaticBody2D

#export(Vector2) var targetPosition
export var targetHeight = -100.0
export var moveDuration = 4
export var moveOnlyOnce = false

var isDown = true
var isActive = false
#var startPosition
var startHeight

func _ready():
#	startPosition = global_position
	startHeight = global_position.y

func _on_Area2D_body_entered(body):
	# toogle elevator moving up or down
	if isActive:
		return
	
	if isDown:
		$Tween.interpolate_property(self, "global_position:y", startHeight, targetHeight, moveDuration, Tween.TRANS_QUAD)
	else:
		$Tween.interpolate_property(self, "global_position:y", targetHeight, startHeight, moveDuration, Tween.TRANS_QUAD)
	
	$Tween.start()
	isActive = true

func _on_Tween_tween_all_completed():
	isDown = !isDown
	$Timer.start()

# cooldown timer for elevator
func _on_Timer_timeout():
	if moveOnlyOnce:
		return
	isActive = false
