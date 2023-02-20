extends Node2D

export var freezeSlow = 0.07
export var freezeTime = 0.3
export(PackedScene) var startScreen

func _ready():
	# warning-ignore-all:RETURN_VALUE_DISCARDED
	EventBus.connect("enemyWasHit", self, "freezeEngine")
	EventBus.connect("spawnProjectile", self, "spawnProjectile")
	EventBus.connect("spawnEnemy", self, "spawnEnemy")
	EventBus.connect("spawnLoot", self, "spawnLoot")
	EventBus.connect("playerAbilityUnlocked", self, "showAbilityPopup")
	EventBus.connect("loseEvent", self, "showLoseScreen")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$MenuElements/pauseMenu.show()

func freezeEngine(): # this is for creating a nice hit stop / freeze effect for making melee hit feel more impactful
	Engine.time_scale = freezeSlow
	# TODO: check if should be implemented differently
	# TODO: BUG: -> in rare cases the timer can get deleted if the scene gets restarted
	# 				which leads to permanent game slow down
	#				(atleast I suspect that is the case, I was not able to reliably recreate the bug)
	# LARS: make object that changes timescale on creation and resets it on destruction
	yield(get_tree().create_timer(freezeTime * freezeSlow), "timeout")
	Engine.time_scale = 1

func spawnProjectile(newProjectile):
	$Projectiles.call_deferred("add_child", newProjectile)
	
func spawnEnemy(newEnemy):
	$Enemies.add_child(newEnemy)

func spawnLoot(newLoot):
	$Loot.call_deferred("add_child", newLoot)

func showAbilityPopup(videoStream, headline, button, explainationText):
	$MenuElements/AbilityPopUp.setup(videoStream, headline, button, explainationText)
	$MenuElements/AbilityPopUp.start()

func showLoseScreen(message):
	$MenuElements/LoseScreen.setup(message)
	$MenuElements/LoseScreen.start()


func _on_Area2D_body_entered(body):
	showLoseScreen("To be continued.")
