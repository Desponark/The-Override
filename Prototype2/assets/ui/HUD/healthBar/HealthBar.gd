extends Control

export var maxHealth = 100.0
export var health = 100.0
signal healthReachedZero
signal healthReachedMax
# potentially add signal for health being damaged...

func _ready():
	setup()

func setup():
	$Health.max_value = maxHealth
	$Health.value = health
	$progressbar.scale.x = 1

func _process(_delta):
	$Health.value = health
	$progressbar.scale.x = getHealthPercent()

func getHealth():
	return health
	
func getMaxHealth():
	return maxHealth

func getHealthPercent():
	return health / maxHealth

func subtractHealth(damage):
	health -= damage
	if health <= 0:
		health = 0
		emit_signal("healthReachedZero")
	if health >= maxHealth:
		health = maxHealth
		emit_signal("healthReachedMax")
		
func addHealth(healAmount):
	health += healAmount
	if health <= 0:
		health = 0
		emit_signal("healthReachedZero")
	if health >= maxHealth:
		health = maxHealth
		emit_signal("healthReachedMax")
