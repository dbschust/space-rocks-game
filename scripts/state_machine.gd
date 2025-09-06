extends Node


@export var starting_state:State
@export var current_state:State


func init(parent: Player):
	for child in get_children():
		child.parent = parent
	change_state(starting_state)


func process_physics(delta: float):
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)


func process_frame(delta: float):
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)


func process_input():
	var new_state = current_state.process_input()
	if new_state:
		change_state(new_state)


func change_state(new_state: State):
	if new_state == null:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

