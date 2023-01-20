extends Control

export var maxHealth = 100
export var health = 100


func _ready():
	$Health.max_value = maxHealth
	$Health.value = health

func _process(_delta):
	$Health.value = health
	if health <= 0:
		health = 0
		# owner dead
		owner.queue_free()

func getDamaged(damage):
	health -= damage
