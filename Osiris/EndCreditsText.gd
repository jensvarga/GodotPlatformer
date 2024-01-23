extends Label

onready var text_2 := $"../Text2"

func _process(delta: float) -> void:

	var deaths = str(Events.death_counter)
	
	if Events.death_counter < 1:
		text = "You died zero times, you are a truly a true gamer!"
	elif Events.death_counter == 1:
		text = "You´re a true gamer, you only died once!"
	else:
		text = "You´re a true gamer, you only died " + deaths + " times!"


func _on_Timer_timeout():
	text_2.text = "Press X to return"
