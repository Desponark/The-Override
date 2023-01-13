extends Node2D

var player
var playerInRange = false

var crystal

var isSocketFullyCharged = false
var isSocketCharging = false
signal socketActivated
signal socketFullyCharged

export var maxCharge = 200
export var charge = 0
export var chargeAmount = .1

export(Array, NodePath) var socketActivators
export(Array, NodePath) var socketChargedActivators


func _ready():
	player = get_parent().get_node("Player")
	crystal = get_parent().get_node("Crystal")
	pass

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		activateSocket()
		
	chargeSocket()
			
	updateUI()

func updateUI():
	$HealthBar/Health.max_value = maxCharge
	$HealthBar/Health.value = charge
	pass
	
func chargeSocket():
	if isSocketCharging:
		charge = charge + chargeAmount
		crystal.health = crystal.health - chargeAmount
		if charge >= maxCharge:
			isSocketCharging = false
			isSocketFullyCharged = true
			player.isCrystalFollowing = true
			emit_signal("socketFullyCharged")

func activateSocket():
	if !isSocketFullyCharged:
		if !isSocketCharging:
			if player.isCrystalFollowing:
				if playerInRange:
					player.isCrystalFollowing = false
					crystal.global_transform = $CrystalPosition.global_transform
					# start charging
					isSocketCharging = true
					emit_signal("socketActivated")
	pass

func _on_Area2D_area_entered(area):
	playerInRange = true
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	playerInRange = false
	pass # Replace with function body.
