class_name InteractionableBox
extends Area2D

func _init():
	# set the interactionable box to always exist on the interaction layer (5)
	collision_layer = 5
	collision_mask = 0

func interact(area):
	if owner.has_method("interact"):
		owner.interact(area)
