extends CanvasLayer


signal start_game


@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var lives_counter = $MarginContainer/HBoxContainer/LivesCounter.get_children()
@onready var message = $VBoxContainer/Message
@onready var start_button = $VBoxContainer/StartButton
@onready var shield_bar = $MarginContainer/HBoxContainer/ShieldBar
@onready var shield_icon = $MarginContainer/HBoxContainer/ShieldIcon


var green_bar = preload("res://assets/bar_green_200.png")
var yellow_bar = preload("res://assets/bar_yellow_200.png")
var red_bar = preload("res://assets/bar_red_200.png")


var score = 0
var lives = 3
var shield = 0


func update_score(new_score: int):
	score_label.text = str(new_score)


func hide_top_bar():
	$MarginContainer.hide()


func show_top_bar():
	$MarginContainer.show()


func game_over():
	message.text = "Game Over"
	message.show()
	shield_bar.hide()
	shield_icon.hide()
	start_button.show()
	$GameMusic.stop()


func update_shield(value: int):
	if shield_bar == null:
		return
	if value > 70:
		shield_bar.texture_progress = green_bar
	elif value > 40:
		shield_bar.texture_progress = yellow_bar
	else:
		shield_bar.texture_progress = red_bar
	shield_bar.value = value


func update_lives(value: int):
	lives = value
	for i in 3:
		lives_counter[i].visible = lives > i
		

func new_level(level: int):
	$StartTimer.start()
	message.text = "Wave " + str(level)
	message.show()
	await $StartTimer.timeout
	message.hide()
	

func _on_start_button_pressed():
	start_button.hide()
	show_top_bar()
	shield_bar.show()
	shield_icon.show()
	update_lives(3)
	message.text = "Get Ready!"
	$GameMusic.play()
	$StartTimer.start()
	await $StartTimer.timeout
	
	var count = 3
	while count > 0:
		message.text = str(count)
		await $StartTimer.timeout
		count -= 1
		
	message.text = ""
	message.hide()
	start_game.emit()
	
