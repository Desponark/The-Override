extends Area2D

var interactable = null

func _init():
	# set the interactionable box to always exist on the interaction layer (5)
	collision_layer = 0
	collision_mask = 5

func _unhandled_input(event):
	if event.is_action_pressed("interact") and interactable != null:
		if interactable.has_method("interact"):
			interactable.interact(self)

func _on_InteractionBox_area_entered(area):
	interactable = area
	# TODO: bug -> if multiple interaction boxes are too close to each other
	# they overwrite the interaction making it very hard to interact
	# with the thing one wants to interact with
	# solution -> keep all possible interactions in mind and choose the one that is closest
	# TODO: show ui prompt -> press e to interact

func _on_InteractionBox_area_exited(area):
	interactable = null
