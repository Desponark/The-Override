class_name InteractionableBox
extends Area2D

signal interacted(area)
var isReadyToInteract = false

func _init():
	# set the interactionable box to always exist on the interaction layer 5 (value 16, bit 4)
	set_collision_layer_bit(4, true)
	collision_mask = 0
	
func _ready():
	changePromptVisibility(false)

func interact(area):
	if !isReadyToInteract:
		return
	emit_signal("interacted", area)

func changePromptVisibility(isVisible):
	# let calls to make prompts invisible (isVisible = false) through regardless of readiness to interact.
	# Otherwise if a device that was ready to interact and has a visible prompt stops being ready to interact the prompt can't be hidden anymore
	if !isReadyToInteract and isVisible:
		return
	var prompt = get_node_or_null("Prompt")
	if prompt:
		prompt.visible = isVisible

func setInteractionReadiness(value):
	isReadyToInteract = value
