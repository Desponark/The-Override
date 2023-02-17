extends RichTextLabel

export var duration = 100
export var scrollAfterXLines = 2
export var scrollAmount = 2

func _ready():
	hide()

func setup(dialogueText, duration):
	text = dialogueText
	$Tween.interpolate_property(self, "percent_visible", 0, 1, duration)

func start():
	$Tween.start()

func _process(delta):
	if $Tween.is_active() and get_visible_line_count() > scrollAfterXLines:
		get_v_scroll().value += scrollAmount

func _on_Tween_tween_all_completed():
	$Timer.start()

func _on_Timer_timeout():
	# once percent_visible is at 1 get_visible_line_count() will return all existing lines regardless of true visibility 
	# therefore another way of scrolling down was needed
	# by enabling scroll_following and adding newline() the text will look like its scrolling "down" like before.
	scroll_following = true
	if scrollAfterXLines > 0:
		newline()
		scrollAfterXLines -= 1
		$Timer.start()
	else:
		hide()

func _on_Tween_tween_started(object, key):
	# when starting the speech bubble via a timer the text can only be made visible
	# AFTER the tween is started otherwise there is a bug in which the whole text is shortly fully visible
	show()
