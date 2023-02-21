class_name InteractionableBox
extends Area2D

signal interacted(area)

func _init():
	# set the interactionable box to always exist on the interaction layer 5 (value 16, bit 4)
	set_collision_layer_bit(4, true)
	collision_mask = 0
	
func _ready():
	changePromptVisibility(false)

func interact(area):
	emit_signal("interacted", area)

func changePromptVisibility(isVisible):
	var prompt = get_node_or_null("Prompt")
	if prompt:
		prompt.visible = isVisible
