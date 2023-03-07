extends KinematicBody2D

var isFollowingPlayer = false
var player = null
export var followSpeedMultiplier = 3
export var lightScaleMultiplier = 0.5
export var minimumLightScaleMultiplier = 0.3

signal voiceLineFinished

func _ready():
	$InteractionableBox.setInteractionReadiness(true)
	$CanvasLayer.hide()

# TODO: think about a better way to change light scale
func _process(_delta):
	changeLightScale()
	
func _physics_process(_delta):
	if player != null:
		if isFollowingPlayer:
			$AnimationPlayer.play("idle")
			move_and_slide((player.getRobotFollowPosition() - global_position) * followSpeedMultiplier)

func changeLightScale():
	var lightScale = lightScaleMultiplier * (getHealth() / getMaxHealth())
	# stop lightscale from getting too small
	if lightScale <= minimumLightScaleMultiplier:
		lightScale = minimumLightScaleMultiplier
	$Light2D.set_texture_scale(lightScale)
	
func putRobotInSocket(position):
	$AnimationPlayer.play("RESET")
	isFollowingPlayer = false
	var tween = create_tween()
	tween.tween_property(self, "global_position", position, 0.5)

func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)
		$DamagedSound.play()
		$CanvasLayer/HealthBar/AnimationPlayer.play("healthLose")
		
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
func loseHealth(damage):
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)
		$CanvasLayer/HealthBar/AnimationPlayer.play("healthLose")
		
func gainHealth(healAmount):
	if $CanvasLayer/HealthBar.has_method("addHealth"):
		$CanvasLayer/HealthBar.addHealth(healAmount)
		$CanvasLayer/HealthBar/AnimationPlayer.play("healthGain")
		
		
func getHealth():
	return $CanvasLayer/HealthBar.getHealth()
	
func getMaxHealth():
	return $CanvasLayer/HealthBar.getMaxHealth()

func getPriority():
	return 2
	
func playSpeech(dialougeStream, dialogueText, delay):
	if !dialougeStream:
		$VoicePlayer.stop()
		$SpeechBubble.setup("", 2)
		return
	$VoicePlayer.stream = dialougeStream
	$VoicePlayer.play()
	$SpeechBubble.setup(dialogueText, dialougeStream.get_length())
	$SpeechBubble.start()

func _on_HealthBar_healthReachedZero():
	EventBus.emit_signal("loseEvent", "Your Robot died!")
	$DeathSound.play()

func _on_InteractionableBox_interacted(area):
	if player == null:
		player = area.owner
		if player.has_method("setRobotRef"):
			player.setRobotRef(self)
			isFollowingPlayer = true
			disableInteractions()

func disableInteractions():
	$InteractionableBox/CollisionShape2D.disabled = true
	$InteractionableBox.setInteractionReadiness(false)
	$CanvasLayer/HealthBar/AnimationPlayer.play("initialize")

func saveData():
	return {
		"nodePath" : get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"health" : $CanvasLayer/HealthBar.getHealth(),
		"playerPath" : player.get_path() if player else "",
		"isFollowingPlayer" : isFollowingPlayer
	}
	
func loadData(data):
	position.x = data["posX"]
	position.y = data["posY"]
	$CanvasLayer/HealthBar.health = data["health"]
	player = get_node_or_null(data["playerPath"])
	isFollowingPlayer = data["isFollowingPlayer"]
	disableInteractions() if player else null


func _on_VoicePlayer_finished():
	emit_signal("voiceLineFinished")
