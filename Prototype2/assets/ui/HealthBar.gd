extends Control

export var maxHealth = 100
export var health = 100
signal healthReachedZero
signal healthReachedMax
# potentially add signals for health reaching max or health being damaged etc...

func _ready():
	$Health.max_value = maxHealth
	$Health.value = health

func _process(_delta):
	$Health.value = health

func subtractHealth(damage):
	health -= damage
	if health <= 0:
		health = 0
		emit_signal("healthReachedZero")
	if health >= maxHealth:
		health = maxHealth
		emit_signal("healthReachedMax")
