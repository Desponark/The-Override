extends Node2D

export var freezeSlow = 0.07
export var freezeTime = 0.3
export(PackedScene) var startScreen

const saveGamePath = "user://savegame.save"

func _ready():
	# warning-ignore-all:RETURN_VALUE_DISCARDED
	EventBus.connect("enemyWasHit", self, "freezeEngine")
	EventBus.connect("spawnProjectile", self, "spawnProjectile")
	EventBus.connect("spawnEnemy", self, "spawnEnemy")
	EventBus.connect("spawnLoot", self, "spawnLoot")
	EventBus.connect("playerAbilityUnlocked", self, "showAbilityPopup")
	EventBus.connect("loseEvent", self, "showLoseScreen")
	EventBus.connect("saveGame", self, "saveGame")
	loadGame()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$MenuElements/pauseMenu.setup(startScreen)
		$MenuElements/pauseMenu.start()
		
	if event.is_action_pressed("quickSave"):
		saveGame()
	if event.is_action_pressed("quickLoad"):
		loadGame()

func freezeEngine(): # this is for creating a nice hit stop / freeze effect for making melee hit feel more impactful
	Engine.time_scale = freezeSlow
	# TODO: check if should be implemented differently
	# TODO: BUG: -> in rare cases the timer can get deleted if the scene gets restarted
	# 				which leads to permanent game slow down
	#				(atleast I suspect that is the case, I was not able to reliably recreate the bug)
	# LARS: make object that changes timescale on creation and resets it on destruction
	yield(get_tree().create_timer(freezeTime * freezeSlow), "timeout")
	Engine.time_scale = 1

func saveGame():
	print("save game")
	var file = File.new()
	file.open(saveGamePath, File.WRITE)
	var saveNodes = get_tree().get_nodes_in_group("persist")
	for node in saveNodes:
		if node.has_method("saveData"):
			var data = node.saveData()
			file.store_var(data)
	file.close()
	
func loadGame():
	# always load the savegame if it is found
	var file = File.new()
	if file.file_exists(saveGamePath):
		file.open(saveGamePath, File.READ)
		while file.get_position() < file.get_len():
			var data = file.get_var()
			var node = get_node_or_null(data["nodePath"])
			if node:
				if node.has_method("loadData"):
					node.loadData(data)
		file.close()

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
