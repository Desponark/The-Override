extends Node2D

export (float) var maxHealth = 1000.0
export (float) var health = 200.0

func _ready():
#	health = maxHealth
	pass

func _process(delta):
	$HealthBar/Health.max_value = maxHealth
	$HealthBar/Health.value = health
	
	# set light radius
	
	var lightScale = 3 * (health / maxHealth)
#	print(lightScale)
	$Light2D.set_texture_scale(lightScale)
	pass
