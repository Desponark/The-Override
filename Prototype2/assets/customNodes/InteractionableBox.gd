class_name InteractionableBox
extends Area2D

func _init():
	# set the interactionable box to always exist on the interaction layer (5)
	collision_layer = 5
	collision_mask = 0

func interact(area):
	# LARS: use signal or give parent node and access its interact function here 
	if owner.has_method("interact"):
		owner.interact(area)

func _on_InteractionableBox_area_entered(area):
	$Sprite.show()

func _on_InteractionableBox_area_exited(area):
	$Sprite.hide()
